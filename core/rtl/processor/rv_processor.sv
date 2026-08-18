/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "execution_interface.svh"
`include "decode_output.svh"
`include "register.svh"
`include "../gpio_interface.svh"
`include "../bootloader/bootloader_interface.svh"
`include "../graphics_unit/graphics_interface.svh"

module rv_processor #(
    parameter HISTORY_SIZE = 10,
    I_CACHE_SIZE = 1024,
    D_CACHE_SIZE = 1 << 10,
    BTB_SIZE = 128
) (
    input logic clk,
    input logic reset,
    bootloader_if.processor bootloader_if,
    graphics_if.processor graphics_if,
    gpio_if.processor gpio_if,
    output logic [15:0] o_reg16_f8,
    output logic [15:0] o_reg16_fc
);

    localparam ADDRESS_WIDTH = $clog2(I_CACHE_SIZE / 4);
    // Fetch signals
    logic fetch_en;
    logic fetch_reset;
    logic fetch_output_bubble;
    logic fetch_instruction_valid;
    logic [ADDRESS_WIDTH-1:0] fetch_instruction_addr;
    logic [31:0] fetch_instruction_raw;
    logic fetch_btb_hit;
    logic fetch_btb_hit_was_jump;

    // Prediction signals
    logic prediction_reset;
    logic prediction_enable;
    logic prediction_output_bubble;
    logic prediction_prediction;
    logic prediction_predict;
    logic prediction_btb_hit;
    logic prediction_redirect;
    logic prediction_instruction_valid;
    logic [HISTORY_SIZE -1:0] prediction_pht_index;
    logic [ADDRESS_WIDTH-1:0] prediction_redirect_target;
    logic [31:0] prediction_instruction_raw;
    logic [ADDRESS_WIDTH-1:0] prediction_instruction_addr;

    // Decode signals
    logic decode_enable;
    logic decode_output_bubble;
    decode_output_t decode_out_;

    // Register file signals
    register_write_data_t register_write_;
    register_read_output_t register_read_;
    logic register_read_enable;
    logic register_read_output_bubble;
    logic register_file_reset;

    // Execution signals
    execution_if #(.HISTORY_SIZE(HISTORY_SIZE)) execution_if ();
    logic execution_output_bubble;
    logic execution_enable;
    logic execution_reset; // resets the internal state of multiplier and divider units


    // Stage control signals
    logic [0:4] stage_controller_flush_vector;
    logic [0:5] stage_controller_stall_vector;

    logic memory_graphics_write;
    logic memory_en;
    logic memory_gpio_stall;


    stage_controller stage_controller (
        .clk(clk),
        .i_misprediction(execution_if.redirect),
        .i_load_stall_type0(execution_if.stall_pipeline_type0),
        .i_load_stall_type1(execution_if.stall_pipeline_type1),
        .i_load_stall_type2(execution_if.stall_pipeline_type2),
        .i_graphics_instruction_write_fail((graphics_if.graphics_buffer_full && memory_graphics_write) || memory_gpio_stall),
        .flush_vector(stage_controller_flush_vector),
        .stall_vector(stage_controller_stall_vector)
    );

    fetch #(
        .I_CACHE_SIZE(I_CACHE_SIZE),
        .BTB_SIZE(BTB_SIZE)
    ) fetch (
        .clk                        (clk),
        .i_en                       (fetch_en),
        .i_reset                    (fetch_reset),
        .i_output_bubble            (fetch_output_bubble),
        .i_predictor_redirect_target(prediction_redirect_target),
        .i_predictor_redirect       (prediction_redirect),
        .i_graphics_init_done       (graphics_if.graphics_init_done),
        .bootloaderi                (bootloader_if),
        .exi                        (execution_if),
        .o_instruction_valid        (fetch_instruction_valid),
        .o_instruction_addr         (fetch_instruction_addr),
        .o_instruction_raw          (fetch_instruction_raw),
        .o_btb_hit                  (fetch_btb_hit),
        .o_btb_hit_was_jump         (fetch_btb_hit_was_jump)
    );
    prediction #(
        .HISTORY_SIZE (HISTORY_SIZE),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) prediction (
        .clk                      (clk),
        .i_reset                  (prediction_reset),
        .i_en                     (prediction_enable),
        .i_output_bubble          (prediction_output_bubble),
        .i_btb_hit_was_jump       (fetch_btb_hit_was_jump),
        .i_predict                (prediction_predict),
        .i_btb_hit                (fetch_btb_hit),
        .i_instruction_raw        (fetch_instruction_raw),
        .i_instruction_addr       (fetch_instruction_addr),
        .i_instruction_valid      (fetch_instruction_valid),
        .exi                      (execution_if),
        .o_prediction             (prediction_prediction),
        .o_pht_index              (prediction_pht_index),
        .o_btb_hit                (prediction_btb_hit),
        .o_predictor_redirect     (prediction_redirect),
        .o_predictor_redirect_addr(prediction_redirect_target),
        .o_instruction_raw        (prediction_instruction_raw),
        .o_instruction_addr       (prediction_instruction_addr),
        .o_instruction_valid      (prediction_instruction_valid)
    );

    decode #(
        .HISTORY_SIZE (HISTORY_SIZE  /* default 10 */),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) decode (
        .clk                   (clk),
        .i_enable              (decode_enable),
        .i_output_bubble       (decode_output_bubble),
        .i_instruction_valid   (prediction_instruction_valid),
        .i_btb_hit             (prediction_btb_hit),
        .i_predictor_prediction(prediction_prediction),
        .i_predictor_pht_index (prediction_pht_index),
        .i_instruction_raw     (prediction_instruction_raw),
        .i_instruction_addr    (prediction_instruction_addr),
        .o_decode              (decode_out_)
    );


    register_file register_file (
        .clk             (clk),
        .i_en            (register_read_enable),
        .i_output_bubble (register_read_output_bubble),
        .i_reset         (register_file_reset),
        .i_register_write(register_write_),
        .i_decode_out    (decode_out_),
        .exi             (execution_if),
        .o_register_read (register_read_)
    );

    execute execute (
        .clk                (clk),
        .i_en               (execution_enable),
        .i_reset            (execution_reset),
        .i_output_bubble    (execution_output_bubble),
        .i_decode_out       (decode_out_),
        .i_register_read_out(register_read_),
        .exi                (execution_if)
    );


    memory #(
        .SIZE(D_CACHE_SIZE)
    ) memory (
        .clk             (clk),
        .i_reset         (reset),
        .ei              (execution_if),
        .i_en            (memory_en),
        .graphicsi       (graphics_if),
        .gpioi           (gpio_if),
        .bootloaderi     (bootloader_if),
        .o_register_write(register_write_),
        .o_graphics_write(memory_graphics_write),
        .o_gpio_stall    (memory_gpio_stall),
        .o_reg16_f8      (o_reg16_f8),
        .o_reg16_fc      (o_reg16_fc)
    );

    always_comb begin
        fetch_en = ~stage_controller_stall_vector[0];
        fetch_reset = reset;
        fetch_output_bubble = stage_controller_flush_vector[0];

        prediction_reset = reset;
        prediction_enable = ~stage_controller_stall_vector[1];
        prediction_output_bubble = stage_controller_flush_vector[1] | reset;
        prediction_predict       = fetch_btb_hit & fetch_instruction_valid & ~fetch_btb_hit_was_jump; // We are not going to use pht tables for our indirect jumps since they require no prediction

        decode_enable = ~stage_controller_stall_vector[2];
        decode_output_bubble = stage_controller_flush_vector[2];


        register_file_reset = reset;
        register_read_enable = ~stage_controller_stall_vector[4];
        register_read_output_bubble = stage_controller_flush_vector[4];

        execution_output_bubble = stage_controller_flush_vector[3];
        execution_enable = ~stage_controller_stall_vector[3];
        execution_reset = reset;

        memory_en = ~stage_controller_stall_vector[5];
    end
endmodule

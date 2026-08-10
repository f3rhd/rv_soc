/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "execution_interface.svh"
`include "register.svh"
`include "decode_output.svh"
module execute #(
    parameter HISTORY_SIZE = 10
) (
    input logic clk,
    input logic i_en,
    input logic i_reset,
    input logic i_output_bubble,
    input decode_output_t i_decode_out, // has the signals needed for triggering type1 stall
    input register_read_output_t i_register_read_out,
    execution_if.producer exi
);

    logic src1_match, src2_match, src3_match;
    logic [31:0] src1_data, src2_data, src3_data;
    logic alu_stall;


    logic [HISTORY_SIZE - 1 : 0] pht_index;
    logic btb_write;
    logic [31:0] instruction_addr;
    logic [31:0] btb_branch_target_addr;
    logic [31:0] memory_write_data;
    logic [2:0] memory_operation;
    logic [31:0] alu_out;
    logic predictor_update;
    logic [31:0] redirection_address;
    logic btb_write_jump;
    logic redirect;
    logic branch_result;
    logic [31:0] fpu_result;
    logic fpu_inv_op;
    logic fpu_done;
    logic fpu_begin;

    decoded_instruction_t instruction_data;
    register_read_data_t read_data;
    prediction_data_t prediction_data;

    assign prediction_data = i_register_read_out.decode_data.prediction_data;
    assign instruction_data = i_register_read_out.decode_data.instruction_data;
    assign read_data = i_register_read_out.read_data;

    assign src1_match = (~exi.mem_read && ((exi.int_reg_write && instruction_data.read_rs1 && exi.dest != 5'd0) || (exi.float_reg_write && instruction_data.read_fs1)) && (instruction_data.src1 == exi.dest));
    assign src2_match = (~exi.mem_read && ((exi.int_reg_write && instruction_data.read_rs2 && exi.dest != 5'd0) || (exi.float_reg_write && instruction_data.read_fs2)) && (instruction_data.src2 == exi.dest));
    assign src3_match = (~exi.mem_read && exi.float_reg_write && instruction_data.src3 == exi.dest);
    assign src1_data = src1_match ? exi.exec_result : read_data.src1_data;
    assign src2_data = src2_match ? exi.exec_result : read_data.src2_data;
    assign src3_data = src3_match ? exi.exec_result : read_data.src3_data;

    assign pht_index = prediction_data.pht_index;
    assign btb_write =  instruction_data.btb_write & ~prediction_data.btb_was_hit & ~instruction_data.invalid;
    assign instruction_addr = instruction_data.instruction_addr;
    assign btb_branch_target_addr = instruction_data.instruction_addr + instruction_data.extended_imm_val;
    assign fpu_begin = instruction_data.operation[6:5] == 2'b11;

    alu #(
        .HISTORY_SIZE(HISTORY_SIZE)
    ) alu (
        .clk                  (clk),
        .i_reset              (i_reset),
        .i_en                 (i_en),
        .i_instruction_data   (instruction_data),
        .i_btb_was_hit        (prediction_data.btb_was_hit),
        .i_prediction         (prediction_data.prediction),
        .i_redirect           (exi.redirect),
        .i_src1_data          (src1_data),
        .i_src2_data          (src2_data),
        .o_memory_write_data  (memory_write_data),
        .o_memory_operation   (memory_operation),
        .o_alu_out            (alu_out),
        .o_predictor_update   (predictor_update),
        .o_redirection_address(redirection_address),
        .o_redirect           (redirect),
        .o_btb_write_jump     (btb_write_jump),
        .o_branch_result      (branch_result),
        .o_stall              (alu_stall)
    );
    fpu fpu (
        .clk          (clk),
        .i_reset      (i_reset),
        .i_begin      (fpu_begin),
        .i_op         (instruction_data.operation),
        .i_flush_units(exi.redirect),
        .i_rnd_mode   (instruction_data.round_mode),
        .i_src1_data  (src1_data),
        .i_src2_data  (src2_data),
        .i_src3_data  (src3_data),
        .i_fcsr       (read_data.fcsr),
        .o_fpu_result (fpu_result),
        .o_done       (fpu_done),
        .o_inv_op     (fpu_inv_op)
    );

    always_comb begin : stall_logic
        exi.stall_pipeline_type1 = 0;
        exi.stall_pipeline_type2 = alu_stall | (fpu_begin && ~fpu_done);

        if (!i_decode_out.instruction_data.invalid & exi.mem_read) begin
            if (exi.int_reg_write & exi.dest != 0) begin
                exi.stall_pipeline_type1 =   ((i_decode_out.instruction_data.src1 == exi.dest) && i_decode_out.instruction_data.read_rs1) 
                                             |
                                             ((i_decode_out.instruction_data.src2 == exi.dest) && i_decode_out.instruction_data.read_rs2);
            end else if (exi.float_reg_write) begin
                exi.stall_pipeline_type1 =   ((i_decode_out.instruction_data.src1 == exi.dest) && i_decode_out.instruction_data.read_fs1) 
                                             |
                                             ((i_decode_out.instruction_data.src2 == exi.dest) && i_decode_out.instruction_data.read_fs2)
                                             |
                                             ((i_decode_out.instruction_data.src3 == exi.dest) && i_decode_out.instruction_data.read_fs3 );
            end
        end
    end



    always_ff @(posedge clk) begin
        if (instruction_data.invalid | i_output_bubble | i_reset) begin
            exi.invalid                    <= 1;
            exi.memory_write_data          <= 0;
            exi.memory_operation           <= 0;
            exi.exec_result                <= 0;
            exi.dest                       <= 0;
            exi.mem_write                  <= 0;
            exi.int_reg_write              <= 0;
            exi.float_reg_write            <= 0;
            exi.mem_read                   <= 0;
            exi.predictor_update           <= 0;
            exi.redirection_address        <= 0;
            exi.redirect                   <= 0;
            exi.pht_index                  <= 0;
            exi.btb_write                  <= 0;
            exi.execution_instruction_addr <= 0;
            exi.btb_write_jump             <= 0;
            exi.actual_branch_result       <= 0;
            exi.btb_branch_target_addr     <= 0;
        end else if (i_en) begin
            exi.memory_write_data          <= memory_write_data;
            exi.memory_operation           <= memory_operation;
            exi.exec_result                <= fpu_begin ? fpu_result : alu_out;
            exi.dest                       <= instruction_data.dest;
            exi.invalid                    <= instruction_data.invalid;
            exi.mem_write                  <= instruction_data.mem_write;
            exi.mem_read                   <= instruction_data.mem_read;
            exi.int_reg_write              <= instruction_data.int_reg_write;
            exi.float_reg_write            <= instruction_data.float_reg_write;
            exi.predictor_update           <= predictor_update;
            exi.redirection_address        <= redirection_address;
            exi.redirect                   <= redirect;
            exi.pht_index                  <= pht_index;
            exi.btb_write                  <= btb_write;
            exi.execution_instruction_addr <= instruction_addr;
            exi.btb_write_jump             <= btb_write_jump;
            exi.actual_branch_result       <= branch_result;
            exi.btb_branch_target_addr     <= btb_branch_target_addr;
        end
    end
endmodule

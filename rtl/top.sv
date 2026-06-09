`include "../include/execution_interface.svh"
`include "../include/fetch_interface.svh"
`include "../include/pre_exec_interface.svh"
`include "../include/decode_output.svh"
module top (
    input logic clk,
    input logic reset
);
    localparam HISTORY_SIZE = 10;
    localparam MEMORY_CELLS = 1024;
    localparam BTB_SIZE = 128;

    execution_if #(.HISTORY_SIZE(HISTORY_SIZE)) execution_if ();
    fetch_if fetch_if ();
    pre_exec_interface #(.HISTORY_SIZE(HISTORY_SIZE)) pre_exec_interface ();

    decode_output_t decode_output;
    logic [0:2] flush_vector;
    logic [0:2] stall_vector;
    logic [31:0] o_btb_target_addr;
    logic [1:0] o_btb_way;
    logic o_btb_hit;
    logic o_predictor_prediction;
    logic o_predictor_btb_predict;
    logic [HISTORY_SIZE-1:0] o_predictor_pht_index;

    stage_controller stage_controller (
        .i_flush     (execution_if.misspeculation),
        .i_stall     (execution_if.mem_read),
        .flush_vector(flush_vector),
        .stall_vector(stall_vector)
    );

    fetch #(
        .SIZE(MEMORY_CELLS)
    ) fetch (
        .clk            (clk),
        .i_en           (~stall_vector[0]),
        .i_reset        (reset),
        .i_output_bubble(flush_vector[0]),
        .exi            (execution_if.fetch_consumer),
        .fi             (fetch_if.producer)
    );

    decode decode (
        .clk            (clk),
        .i_enable       (fetch_if.instruction_ready),
        .i_output_bubble(reset | flush_vector[1]),
        .fi             (fetch_if.decode_consumer),
        .o_decoded_mop  (decode_output)
    );


    btb #(
        .SIZE(BTB_SIZE)
    ) btb (
        .clk(clk),
        .i_read_enable     (decode_output.operation[6:5] == 2'b01 & decode_output.operation[3] ),
        .i_branch_addr_read(fetch_if.pc),
        .ei(execution_if.btb_consumer),
        .o_target_addr(o_btb_target_addr),
        .o_way(o_btb_way),
        .o_hit(o_btb_hit)
    );

    predictor #(
        .HISTORY_SIZE(HISTORY_SIZE)
    ) predictor (
        .clk          (clk),
        .i_reset      (reset),
        .i_btb_predict(o_btb_hit),
        .i_branch_addr(decode_output.instruction_addr),
        .exi          (execution_if.predictor_consumer),
        .o_prediction (o_predictor_prediction),
        .o_pht_index  (o_predictor_pht_index),
        .o_btb_predict(o_predictor_btb_predict)
    );
endmodule

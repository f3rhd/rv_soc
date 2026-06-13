`ifndef PRE_EXEC_INTERFACE_SVH
`define PRE_EXEC_INTERFACE_SVH
`include "decode_output.svh"
interface pre_exec_if #(parameter HISTORY_SIZE = 10);
    decode_output_t decode_data;
    logic [HISTORY_SIZE-1:0] pht_index;
    logic btb_was_hit;
    logic [1:0] btb_way_hit;
    logic prediction;
    logic [31:0] src1_data;
    logic [31:0] src2_data;

    modport decode_producer(
        output decode_data,
        output pht_index,
        output btb_was_hit,
        output btb_way_hit,
        output prediction
    );
    modport consumer(
        input decode_data,
        input pht_index,
        input btb_was_hit,
        input btb_way_hit,
        input prediction,
        input src1_data,
        input src2_data
    );
endinterface
`endif

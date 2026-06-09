`include "../include/execution_interface.svh"
module predictor #(
    parameter HISTORY_SIZE = 10
) (
    input logic clk,
    input logic i_reset,
    input logic i_btb_predict,
    input logic [31:0] i_branch_addr,
    execution_if.predictor_consumer exi,
    output logic o_prediction,
    output logic [HISTORY_SIZE-1:0] o_pht_index,
    output logic o_btb_predict
);


    logic [1:0] pht_table[0:2**HISTORY_SIZE-1];
    logic [HISTORY_SIZE-1:0] global_history = 0;
    logic [HISTORY_SIZE-1:0] pht_index;
    assign pht_index = i_branch_addr[HISTORY_SIZE-1:0] ^ global_history;
    always_ff @(posedge clk) begin
        if (i_reset) begin
            for (int i = 0; i < 2 ** HISTORY_SIZE; i++) begin
                pht_table[i] <= 0;
            end
        end else begin
            o_btb_predict <= i_btb_predict;
            if (i_btb_predict) begin
                o_prediction <= pht_table[pht_index][1];
                o_pht_index  <= pht_index;
            end else begin
                o_prediction <= 0;
            end
            if (exi.misspeculation) begin
                case (exi.actual_branch_result)
                    1'b0:
                    pht_table[exi.pht_index] <= pht_table[exi.pht_index] > 0 ? pht_table[exi.pht_index] - 1 : 0 ;
                    1'b1:
                    pht_table[exi.pht_index] <= pht_table[exi.pht_index] < 3 ? pht_table[exi.pht_index] + 1 : 3;
                    default:
                    pht_table[exi.pht_index] <= pht_table[exi.pht_index];
                endcase
                global_history <= {
                    global_history[HISTORY_SIZE-2:0], exi.actual_branch_result
                };
            end
        end
    end
endmodule

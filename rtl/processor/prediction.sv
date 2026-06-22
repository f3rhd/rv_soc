`include "../../include/execution_interface.svh"
module prediction #(
    parameter HISTORY_SIZE = 10
) (
    input logic clk,
    input logic i_reset,
    input logic i_en,
    input logic i_output_bubble,
    input logic i_predict,
    input logic i_btb_hit,
    input logic i_btb_hit_was_jump,
    input logic [1:0] i_btb_hit_way,
    input logic [31:0] i_instruction_raw,
    input logic [31:0] i_instruction_addr,
    input logic i_instruction_valid,
    execution_if.predictor_consumer exi,
    output logic o_prediction,
    output logic [HISTORY_SIZE-1:0] o_pht_index,
    output logic o_btb_hit,
    output logic [1:0] o_btb_hit_way,
    output logic o_predictor_redirect,
    output logic [31:0] o_predictor_redirect_addr,
    output logic [31:0] o_instruction_raw,
    output logic [31:0] o_instruction_addr,
    output logic o_instruction_valid
);


    (* ram_style = "distributed" *) logic [1:0] pht_table[0:2**HISTORY_SIZE-1];
    logic [HISTORY_SIZE-1:0] global_history = 0;
    logic [HISTORY_SIZE-1:0] pht_index;
    assign pht_index = i_instruction_addr[HISTORY_SIZE-1:0] ^ global_history;

    logic r_btb_hit_was_jump;
    always_ff @(posedge clk) begin
        if (i_reset) begin
            pht_table      <= '{default: 2'b00};
            global_history <= 0;
            o_prediction   <= 0;
            o_pht_index    <= 0;
        end else begin
            if (i_en) begin
                o_instruction_raw   <= i_instruction_raw;
                o_instruction_addr  <= i_instruction_addr;
                o_instruction_valid <= i_instruction_valid;
                o_btb_hit           <= i_btb_hit;
                o_btb_hit_way       <= i_btb_hit_way;
                r_btb_hit_was_jump  <= i_btb_hit_was_jump;

                if (i_predict & i_instruction_valid) begin
                    o_prediction <= pht_table[pht_index][1];
                    o_pht_index  <= pht_index;
                end else begin
                    o_prediction <= 0;
                end
            end
            if (exi.predictor_update) begin
                case (exi.actual_branch_result)
                    1'b0: begin
                        pht_table[exi.pht_index] <= pht_table[exi.pht_index] > 0 ? pht_table[exi.pht_index] - 1 : 0 ;
                    end
                    1'b1: begin
                        pht_table[exi.pht_index] <= pht_table[exi.pht_index] < 3 ? pht_table[exi.pht_index] + 1 : 3;
                    end
                    default:
                    pht_table[exi.pht_index] <= pht_table[exi.pht_index];
                endcase
                global_history <= {
                    global_history[HISTORY_SIZE-2:0], exi.actual_branch_result
                };
            end
            if (i_output_bubble) begin
                o_btb_hit           <= 0;
                o_btb_hit_way       <= 0;
                o_instruction_raw   <= 0;
                o_instruction_addr  <= 32'hFFFFFFFF;
                o_pht_index         <= 0;
                o_prediction        <= 0;
                o_instruction_valid <= 0;
                o_btb_hit           <= 0;
                o_btb_hit_way       <= 0;
                r_btb_hit_was_jump  <= 0;
            end
        end
    end
    always_comb begin
        o_predictor_redirect      = 0;
        o_predictor_redirect_addr = o_instruction_addr;
        if (o_btb_hit & i_instruction_valid & ~r_btb_hit_was_jump) begin
            if (o_prediction == 0) begin
                o_predictor_redirect      = 1;
                o_predictor_redirect_addr = o_instruction_addr + 4;
            end
        end
    end
endmodule

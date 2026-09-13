/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "graphics_decode_output.svh"
module graphics_decode (
    input logic clk,
    input logic i_output_bubble,
    input logic [31:0] i_instruction,
    input logic i_instruction_valid,
    output graphics_decode_output_t decode_output
);
    graphics_decode_output_t next_decode_output;
    always_comb begin
        next_decode_output.valid    = i_instruction_valid;
        next_decode_output.instr_id = instr_id_e'(i_instruction[27:24]);
        next_decode_output.instr    = i_instruction[23:0];
        next_decode_output.hollow   = i_instruction[28];
    end
    always_ff @(posedge clk) begin
        if (i_output_bubble) begin
            decode_output.valid <= 0;
        end else begin
            decode_output <= next_decode_output;
        end
    end
endmodule

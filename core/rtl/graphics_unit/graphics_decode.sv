/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "graphics_decode_output.svh"
module graphics_decode (
    input logic clk,
    input logic i_output_bubble,
    input logic [32:0] i_instruction,
    input logic i_instruction_valid,
    output graphics_decode_output_t decode_output
);
    graphics_decode_output_t next_decode_output;
    always_comb begin
        next_decode_output.valid        = i_instruction_valid;
        next_decode_output.instruction  = i_instruction[31:0];
        next_decode_output.is_command   = i_instruction[32];
        next_decode_output.command_type = INVALID;
        if (next_decode_output.is_command) begin
            case (i_instruction[31:24])
                8'h2A: begin
                    next_decode_output.command_type = CASET;
                end
                8'h2B: begin
                    next_decode_output.command_type = RASET;
                end
                8'h2C: begin
                    next_decode_output.command_type = RAMWR;
                end
                default: next_decode_output.command_type = INVALID;
            endcase
        end
    end
    always_ff @(posedge clk) begin
        if (i_output_bubble) begin
            decode_output <= '{default: 0, command_type : INVALID};
        end else begin
            decode_output <= next_decode_output;
        end
    end
endmodule

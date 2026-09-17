/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
`include "rasterizer_interface.svh"
typedef union packed {
    logic [27:0] color;
    struct packed {
        logic [13:0] x;
        logic [13:0] y;
    } point;
} graphics_union_t;
typedef enum logic [1:0] {
    P0,
    P1,
    P2,
    CLR
} instr_id_e;
typedef struct packed {
    graphics_union_t instr;
    instr_id_e instr_id;
    logic valid;
    logic hollow;
} graphics_decode_output_t;


module graphics_decode (
    input logic clk,
    input logic i_reset,
    input logic [31:0] i_instruction,
    input logic i_instruction_valid,
    rasterizer_if.graphics_decoder rasterizeri,
    output logic o_done
);
    enum logic {
        S_DECODE,
        S_WAIT_RASTERIZER
    } decode_state = S_DECODE;
    graphics_decode_output_t decoded_instr;
    always_comb begin
        decoded_instr.valid    = i_instruction_valid;
        decoded_instr.instr_id = instr_id_e'(i_instruction[30:29]);
        decoded_instr.instr    = i_instruction[27:0];
        decoded_instr.hollow   = i_instruction[31];
    end
    always_ff @(posedge clk) begin
        if (i_reset) begin
            decode_state <= S_DECODE;
        end else begin
            rasterizeri.rasterizer_begin <= 0;
            o_done                       <= 0 | rasterizeri.rasterizer_done;
            case (decode_state)
                S_DECODE: begin
                    if (decoded_instr.valid & !o_done) begin
                        case (decoded_instr.instr_id)
                            P0: begin
                                rasterizeri.triangle_data.points[0].x <= decoded_instr.instr.point.x;
                                rasterizeri.triangle_data.points[0].y <= decoded_instr.instr.point.y;
                                o_done                                <= 1;
                            end
                            P1: begin
                                rasterizeri.triangle_data.points[1].x <= decoded_instr.instr.point.x;
                                rasterizeri.triangle_data.points[1].y <= decoded_instr.instr.point.y;
                                o_done                                <= 1;
                            end
                            P2: begin
                                rasterizeri.triangle_data.points[2].x <= decoded_instr.instr.point.x;
                                rasterizeri.triangle_data.points[2].y <= decoded_instr.instr.point.y;
                                o_done                                <= 1;
                            end
                            CLR: begin
                                rasterizeri.triangle_data.color  <= decoded_instr.instr.color[15:0];
                                rasterizeri.triangle_data.hollow <= decoded_instr.hollow;
                                rasterizeri.rasterizer_begin     <= 1;
                                decode_state                     <= S_WAIT_RASTERIZER;
                            end
                            default: ;
                        endcase
                    end
                end
                S_WAIT_RASTERIZER: begin
                    if (rasterizeri.rasterizer_done) decode_state <= S_DECODE;
                end
            endcase
        end
    end
endmodule

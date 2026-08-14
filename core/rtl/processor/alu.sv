/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "decode_output.svh"
module alu #(
    parameter unsigned HISTORY_SIZE = 10
) (
    input logic clk,
    input logic i_reset,
    input logic i_en,
    input decoded_instruction_t i_instruction_data,
    input logic i_btb_was_hit,
    input logic i_prediction,
    input logic i_redirect,
    input logic [31:0] i_src1_data,
    input logic [31:0] i_src2_data,
    output logic [31:0] o_memory_write_data,
    output logic [2:0] o_memory_operation,
    output logic [31:0] o_alu_out,
    output logic o_predictor_update,
    output logic [31:0] o_redirection_address,
    output logic o_redirect,
    output logic o_btb_write_jump,
    output logic o_branch_result,
    output logic o_stall
);
    logic btb_write_jump;
    logic [31:0] mul_result;
    logic mul_begin;
    logic mul_done;
    logic [1:0] mul_type;
    logic [1:0] div_type;
    logic div_begin;
    logic [31:0] div_result;
    logic div_done;
    logic [31:0] alu_src2;
    logic [31:0] alu_out;
    logic branch_result;
    logic [2:0] memory_operation;
    logic [31:0] memory_write_data;
    logic predictor_update;
    logic [31:0] redirection_address;
    logic redirect;

    assign o_memory_write_data = memory_write_data;
    assign o_memory_operation = memory_operation;
    assign o_alu_out = alu_out;
    assign o_predictor_update = predictor_update;
    assign o_redirection_address = redirection_address;
    assign o_redirect = redirect;
    assign o_btb_write_jump = btb_write_jump;
    assign o_branch_result = branch_result;
    assign o_stall = (mul_begin & ~mul_done) | (div_begin & ~div_done);
    multiplier #(
        .IN_WIDTH(32)
    ) multiplier (
        .clk(clk),
        .i_multiplicand(alu_src2),
        .i_multiplier(i_src1_data),
        .i_mul_type(mul_type),
        .i_begin(mul_begin & i_en & ~i_instruction_data.invalid),
        .i_reset(i_reset | i_redirect),
        .o_result(mul_result),
        .o_done(mul_done),
        .o_full_product()  // Left open intentionally; Not used by alu  in this case
    );
    divider divider (
        .clk       (clk),
        .i_dividend(i_src1_data),
        .i_divisor (alu_src2),
        .i_div_type(div_type),
        .i_begin   (div_begin & i_en & ~i_instruction_data.invalid),
        .i_reset   (i_reset | i_redirect),
        .o_result  (div_result),
        .o_done    (div_done)
    );
    always_comb begin : integer_operations
        memory_operation    = '0;
        alu_out             = 0;
        branch_result       = '0;
        memory_write_data   = 0;
        predictor_update    = '0;
        redirection_address = '0;
        redirect            = '0;
        btb_write_jump      = '0;
        mul_begin           = 0;
        mul_type            = 0;
        div_begin           = 0;
        div_type            = 0;
        alu_src2            = i_src2_data;


        case (i_instruction_data.operation[6:5])
            2'b00: begin
                alu_src2 = i_instruction_data.uses_imm ? i_instruction_data.extended_imm_val : i_src2_data;
                case (i_instruction_data.operation[4:0])
                    5'b00001: alu_out = i_src1_data + alu_src2;
                    5'b00010: alu_out = i_src1_data - alu_src2;
                    5'b00011: alu_out = i_src1_data << alu_src2[4:0];
                    5'b00100:
                    alu_out = {
                        {31{1'b0}}, $signed(i_src1_data) < $signed(alu_src2)
                    };
                    5'b00101:
                    alu_out = {
                        {31{1'b0}}, $unsigned(i_src1_data) < $unsigned(alu_src2)
                    };
                    5'b00110: alu_out = i_src1_data ^ alu_src2;
                    5'b00111: alu_out = i_src1_data >> alu_src2[4:0];
                    5'b01000: alu_out = $signed(i_src1_data) >>> alu_src2[4:0];
                    5'b01001: alu_out = i_src1_data | alu_src2;
                    5'b01010: alu_out = i_src1_data & alu_src2;
                    // AUIPC
                    5'b01011:
                    alu_out = i_instruction_data.instruction_addr + alu_src2;
                    // LUI
                    5'b01100: alu_out = alu_src2;
                    //MUL
                    5'b01110: begin
                        alu_out   = mul_result;
                        mul_type  = 2'b00;
                        mul_begin = 1;
                    end
                    // MULH (Signed * Signed)
                    5'b01111: begin
                        alu_out   = mul_result;
                        mul_type  = 2'b01;
                        mul_begin = 1;
                    end

                    // MULHSU (Signed * Unsigned)
                    5'b10000: begin
                        alu_out   = mul_result;
                        mul_type  = 2'b10;
                        mul_begin = 1;
                    end

                    // MULHU (Unsigned * Unsigned)
                    5'b10001: begin
                        alu_out   = mul_result;
                        mul_type  = 2'b11;
                        mul_begin = 1;
                    end
                    // DIV 
                    5'b10010: begin
                        alu_out   = div_result;
                        div_type  = 2'b00;
                        div_begin = 1;
                    end

                    // DIVU (Unsigned)
                    5'b10011: begin
                        alu_out   = div_result;
                        div_type  = 2'b01;
                        div_begin = 1;

                    end
                    // REM
                    5'b10100: begin
                        alu_out   = div_result;
                        div_type  = 2'b10;
                        div_begin = 1;
                    end

                    // REMU
                    5'b10101: begin
                        alu_out   = div_result;
                        div_type  = 2'b11;
                        div_begin = 1;
                    end
                    default: alu_out = 0;
                endcase
            end
            2'b01: begin
                case (i_instruction_data.operation[3])
                    1'b1: begin
                        alu_out = i_instruction_data.instruction_addr + 1;
                        case (i_instruction_data.operation[0])
                            1'b0: begin
                                redirect = 1'b1 & ~i_instruction_data.invalid;
                                redirection_address = i_src1_data + i_instruction_data.extended_imm_val;
                            end
                            1'b1: begin
                                redirect = ~i_instruction_data.invalid & ~i_btb_was_hit;
                                redirection_address = i_instruction_data.instruction_addr + i_instruction_data.extended_imm_val ;
                                btb_write_jump = 1;
                            end
                        endcase
                    end
                    1'b0: begin

                        case (i_instruction_data.operation[2:0])
                            3'b001:
                            branch_result = $signed(i_src1_data) ==
                                $signed(i_src2_data);
                            3'b010:
                            branch_result = $signed(i_src1_data) !=
                                $signed(i_src2_data);
                            3'b011:
                            branch_result = $signed(i_src1_data) <
                                $signed(i_src2_data);
                            3'b100:
                            branch_result = $signed(i_src1_data) >=
                                $signed(i_src2_data);
                            3'b101:
                            branch_result = $unsigned(i_src1_data) <
                                $unsigned(i_src2_data);
                            3'b110:
                            branch_result = $unsigned(i_src1_data) >=
                                $unsigned(i_src2_data);
                            default: begin
                            end
                        endcase
                        redirect = (i_prediction ^ branch_result) & ~i_instruction_data.invalid ;
                        predictor_update = 1'b1 & ~i_instruction_data.invalid;
                        if (branch_result == 1) begin
                            redirection_address = i_instruction_data.instruction_addr + i_instruction_data.extended_imm_val;
                        end else begin
                            redirection_address = i_instruction_data.instruction_addr + 1;
                        end
                    end
                    default: begin

                    end
                endcase
            end
            2'b10: begin
                alu_out = i_src1_data + i_instruction_data.extended_imm_val;
                memory_operation = i_instruction_data.operation[2:0];
                memory_write_data = i_src2_data;
            end
            default: begin
            end
        endcase
    end
endmodule

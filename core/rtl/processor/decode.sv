/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "decode_output.svh"
module decode #(
    parameter HISTORY_SIZE  = 10,
    parameter ADDRESS_WIDTH = 20
) (
    input logic clk,
    input logic i_enable,
    input logic i_output_bubble,
    input logic i_instruction_valid,
    input logic i_btb_hit,
    input logic i_predictor_prediction,
    input logic [HISTORY_SIZE-1:0] i_predictor_pht_index,
    input logic [31:0] i_instruction_raw,
    input logic [ADDRESS_WIDTH-1:0] i_instruction_addr,
    output decode_output_t o_decode
);
    decode_output_t decoded_mop_next;
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [6:0] op;
    logic [6:0] alu_base_op;
    logic is_alu_instruction;
    assign is_alu_instruction = (op == 7'b0010011) || (op == 7'b0110011);
    always_comb begin
        alu_base_op = 0;
        decoded_mop_next.instruction_data = '0;
        decoded_mop_next.prediction_data.btb_was_hit = i_btb_hit;
        decoded_mop_next.prediction_data.prediction = i_predictor_prediction;
        decoded_mop_next.prediction_data.pht_index = i_predictor_pht_index;
        decoded_mop_next.instruction_data.instruction_addr = {
            {(32 - ADDRESS_WIDTH) {1'b0}}, i_instruction_addr
        };
        decoded_mop_next.instruction_data.src1 = i_instruction_raw[19:15];
        decoded_mop_next.instruction_data.src2 = i_instruction_raw[24:20];
        decoded_mop_next.instruction_data.dest = i_instruction_raw[11:7];
        decoded_mop_next.instruction_data.invalid = ~i_instruction_valid;
        decoded_mop_next.instruction_data.read_rs1 = 1'b0;
        decoded_mop_next.instruction_data.read_rs2 = 1'b0;
        op = i_instruction_raw[6:0];
        funct3 = i_instruction_raw[14:12];
        funct7 = i_instruction_raw[31:25];
        if (is_alu_instruction) begin
            if (funct7[0] & op == 7'b0110011) begin
                decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                decoded_mop_next.instruction_data.read_rs2 = 1'b1;
                case (funct3)
                    3'b000: alu_base_op = 7'b00_01110;  // mul (multiply low) 
                    3'b001:
                    alu_base_op = 7'b00_01111;  // mulh (multiply high signed signed)
                    3'b010:
                    alu_base_op = 7'b00_10000;  // mulhsu (multiply high signed unsigned)
                    3'b011:
                    alu_base_op = 7'b00_10001;  // mulhu (multiply high unsigned unsigned)
                    3'b100: alu_base_op = 7'b00_10010;  // div (divide signed)
                    3'b101:
                    alu_base_op = 7'b00_10011;  // divu (divide unsigned)
                    3'b110:
                    alu_base_op = 7'b00_10100;  // rem (remainder signed)
                    3'b111:
                    alu_base_op = 7'b00_10101;  // remu (remainder unsigned)
                    default: decoded_mop_next.instruction_data.invalid = 1'b1;
                endcase
            end else begin
                case (funct3)
                    3'b000:
                    alu_base_op = funct7[5] & op == 7'b0110011 ? 7'b00_00010 : 7'b00_00001;  // sub or add
                    3'b001: alu_base_op = 7'b00_00011;  // sll
                    3'b010: alu_base_op = 7'b00_00100;  // slt
                    3'b011: alu_base_op = 7'b00_00101;  // sltu
                    3'b100: alu_base_op = 7'b00_00110;  // xor 
                    3'b101:
                    alu_base_op = funct7[5] ? 7'b00_01000 : 7'b00_00111; // srl or sra
                    3'b110: alu_base_op = 7'b00_01001;  // or
                    3'b111: alu_base_op = 7'b00_01010;  // and
                    default: decoded_mop_next.instruction_data.invalid = 1'b1;
                endcase
            end
        end
        case (op)
            // register to register immediate instructions
            7'b0010011: begin
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                decoded_mop_next.instruction_data.read_rs2 = 1'b0;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    {20{i_instruction_raw[31]}}, i_instruction_raw[31:20]
                };
                decoded_mop_next.instruction_data.operation = alu_base_op;
            end
            // default register to register instructions
            7'b0110011: begin
                decoded_mop_next.instruction_data.read_rs1      = 1'b1;
                decoded_mop_next.instruction_data.read_rs2      = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.operation     = alu_base_op;
            end
            // upper immedite instructions
            7'b0110111: begin : lui
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    i_instruction_raw[31:12], 12'b0
                };
                decoded_mop_next.instruction_data.operation = 7'b00_01100;
            end
            7'b0010111: begin : auipc
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    i_instruction_raw[31:12], 12'b0
                };
                decoded_mop_next.instruction_data.operation = 7'b00_01011;

            end
            // branch instructions
            7'b1100011: begin : conditional
                decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                decoded_mop_next.instruction_data.read_rs2 = 1'b1;
                decoded_mop_next.instruction_data.btb_write = 1'b1;
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    {21{i_instruction_raw[31]}},
                    {
                        i_instruction_raw[31],
                        i_instruction_raw[7],
                        i_instruction_raw[30:25],
                        i_instruction_raw[11:9]
                    }
                };
                case (funct3)
                    3'b000:
                    decoded_mop_next.instruction_data.operation = 7'b01_00_001;
                    3'b001:
                    decoded_mop_next.instruction_data.operation = 7'b01_00_010;
                    3'b100:
                    decoded_mop_next.instruction_data.operation = 7'b01_00_011;
                    3'b101:
                    decoded_mop_next.instruction_data.operation = 7'b01_00_100;
                    3'b110:
                    decoded_mop_next.instruction_data.operation = 7'b01_00_101;
                    3'b111:
                    decoded_mop_next.instruction_data.operation = 7'b01_00_110;
                    default: decoded_mop_next.instruction_data.invalid = 1'b1;
                endcase
            end
            7'b1101111: begin : jal
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.btb_write = 1'b1;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    {13{i_instruction_raw[31]}},
                    i_instruction_raw[31],
                    i_instruction_raw[19:12],
                    i_instruction_raw[20],
                    i_instruction_raw[30:22]
                };
                decoded_mop_next.instruction_data.operation = 7'b01_01_001;
            end
            7'b1100111: begin : jalr
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                decoded_mop_next.instruction_data.read_rs2 = 1'b0;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    {22{i_instruction_raw[31]}}, i_instruction_raw[31:22]
                };
                decoded_mop_next.instruction_data.operation = 7'b01_01_000;
            end
            // memory operations
            7'b0000011: begin : loads
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                decoded_mop_next.instruction_data.mem_read = 1'b1;
                decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                decoded_mop_next.instruction_data.read_rs2 = 1'b0;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    {20{i_instruction_raw[31]}}, i_instruction_raw[31:20]
                };
                case (funct3)
                    3'b000:
                    decoded_mop_next.instruction_data.operation = 7'b10_01_000;
                    3'b001:
                    decoded_mop_next.instruction_data.operation = 7'b10_01_001;
                    3'b010:
                    decoded_mop_next.instruction_data.operation = 7'b10_01_010;
                    3'b100:
                    decoded_mop_next.instruction_data.operation = 7'b10_01_011;
                    3'b101:
                    decoded_mop_next.instruction_data.operation = 7'b10_01_100;
                    default: decoded_mop_next.instruction_data.invalid = 1;
                endcase
            end
            7'b0100011: begin : stores
                decoded_mop_next.instruction_data.uses_imm = 1'b1;
                decoded_mop_next.instruction_data.mem_write = 1'b1;
                decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                decoded_mop_next.instruction_data.read_rs2 = 1'b1;
                decoded_mop_next.instruction_data.extended_imm_val = {
                    {20{i_instruction_raw[31]}},
                    i_instruction_raw[31:25],
                    i_instruction_raw[11:7]
                };
                case (funct3)
                    3'b000:
                    decoded_mop_next.instruction_data.operation = 7'b10_00_000;
                    3'b001:
                    decoded_mop_next.instruction_data.operation = 7'b10_00_001;
                    3'b010:
                    decoded_mop_next.instruction_data.operation = 7'b10_00_010;
                    default: decoded_mop_next.instruction_data.invalid = 1;
                endcase
            end
            default: decoded_mop_next.instruction_data.invalid = 1'b1;
        endcase
    end

    always_ff @(posedge clk) begin
        if (i_output_bubble) begin
            o_decode.instruction_data <= '{default: 0, invalid : 1};
            o_decode.prediction_data  <= '{default: 0};
        end else if (i_enable) begin
            o_decode <= decoded_mop_next;
        end
    end

endmodule

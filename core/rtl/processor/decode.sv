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
    opcode_e alu_base_op;
    logic is_alu_instruction;
    assign is_alu_instruction = (op == 7'b0010011) || (op == 7'b0110011);
    always_comb begin
        alu_base_op = OP_INVALID;
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
                    3'b000:  alu_base_op = ALU_MUL;
                    3'b001:  alu_base_op = ALU_MULH;
                    3'b010:  alu_base_op = ALU_MULHSU;
                    3'b011:  alu_base_op = ALU_MULHU;
                    3'b100:  alu_base_op = ALU_DIV;
                    3'b101:  alu_base_op = ALU_DIVU;
                    3'b110:  alu_base_op = ALU_REM;
                    3'b111:  alu_base_op = ALU_REMU;
                    default: decoded_mop_next.instruction_data.invalid = 1'b1;
                endcase
            end else begin
                case (funct3)
                    3'b000:
                    alu_base_op = funct7[5] & op == 7'b0110011 ? ALU_SUB : ALU_ADD;
                    3'b001: alu_base_op = ALU_SLL;
                    3'b010: alu_base_op = ALU_SLT;
                    3'b011: alu_base_op = ALU_SLTU;
                    3'b100: alu_base_op = ALU_XOR;
                    3'b101: alu_base_op = funct7[5] ? ALU_SRA : ALU_SRL;
                    3'b110: alu_base_op = ALU_OR;
                    3'b111: alu_base_op = ALU_AND;
                    default: decoded_mop_next.instruction_data.invalid = 1'b1;
                endcase
            end
        end
        case (op[6:5])
            2'b00: begin
                case (op[4])
                    1'b0: begin : load_instructions
                        decoded_mop_next.instruction_data.uses_imm = 1'b1;
                        decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                        decoded_mop_next.instruction_data.mem_read = 1'b1;
                        decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                        decoded_mop_next.instruction_data.read_rs2 = 1'b0;
                        decoded_mop_next.instruction_data.extended_imm_val = {
                            {20{i_instruction_raw[31]}},
                            i_instruction_raw[31:20]
                        };
                        if (op[2]) begin : flw
                            decoded_mop_next.instruction_data.operation = MEM_FLW;
                            decoded_mop_next.instruction_data.int_reg_write = 1'b0;
                            decoded_mop_next.instruction_data.float_reg_write = 1'b1;
                        end else begin
                            case (funct3[2])
                                1'b0: begin
                                    if (funct3[1])  // lw
                                        decoded_mop_next.instruction_data.operation = MEM_LW;
                                    else begin
                                        if (funct3[0])  // lh
                                            decoded_mop_next.instruction_data.operation = MEM_LH;
                                        else  // lb
                                            decoded_mop_next.instruction_data.operation = MEM_LB;
                                    end

                                end
                                1'b1: begin
                                    if (funct3[0])  // lhu
                                        decoded_mop_next.instruction_data.operation = MEM_LHU;
                                    else  // lbu
                                        decoded_mop_next.instruction_data.operation = MEM_LBU;
                                end
                            endcase
                        end

                    end
                    1'b1: begin
                        if (op[2]) begin : auipc
                            decoded_mop_next.instruction_data.uses_imm = 1'b1;
                            decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                            decoded_mop_next.instruction_data.extended_imm_val = {
                                i_instruction_raw[31:12], 12'b0
                            };
                            decoded_mop_next.instruction_data.operation = ALU_AUIPC;
                        end else begin : register_to_register_imm
                            decoded_mop_next.instruction_data.uses_imm = 1'b1;
                            decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                            decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                            decoded_mop_next.instruction_data.read_rs2 = 1'b0;
                            decoded_mop_next.instruction_data.extended_imm_val = {
                                {20{i_instruction_raw[31]}},
                                i_instruction_raw[31:20]
                            };
                            decoded_mop_next.instruction_data.operation = alu_base_op;

                        end
                    end
                endcase
            end
            2'b01: begin
                if (op[4]) begin
                    if (op[2]) begin : lui
                        decoded_mop_next.instruction_data.uses_imm = 1'b1;
                        decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                        decoded_mop_next.instruction_data.extended_imm_val = {
                            i_instruction_raw[31:12], 12'b0
                        };
                        decoded_mop_next.instruction_data.operation = ALU_LUI;
                    end else begin : register_to_register
                        decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                        decoded_mop_next.instruction_data.read_rs2 = 1'b1;
                        decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                        decoded_mop_next.instruction_data.operation     = alu_base_op;
                    end
                end else begin : store_instructions
                    decoded_mop_next.instruction_data.uses_imm = 1'b1;
                    decoded_mop_next.instruction_data.mem_write = 1'b1;
                    decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                    decoded_mop_next.instruction_data.read_rs2 = 1'b1;
                    decoded_mop_next.instruction_data.extended_imm_val = {
                        {20{i_instruction_raw[31]}},
                        i_instruction_raw[31:25],
                        i_instruction_raw[11:7]
                    };
                    if (op[2]) begin : fsw
                        decoded_mop_next.instruction_data.operation = MEM_FSW;
                        decoded_mop_next.instruction_data.read_rs2  = 1'b0;
                        decoded_mop_next.instruction_data.read_fs2  = 1'b1;
                    end else begin
                        if (funct3[1]) begin : sw
                            decoded_mop_next.instruction_data.operation = MEM_SW;
                        end else begin
                            if (funct3[0]) begin : sh
                                decoded_mop_next.instruction_data.operation = MEM_SH;
                            end else begin : sb
                                decoded_mop_next.instruction_data.operation = MEM_SB;
                            end
                        end
                    end
                end
            end
            2'b11: begin
                if (op[3]) begin : jal
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
                    decoded_mop_next.instruction_data.operation = BR_JAL;

                end else begin
                    if (op[2]) begin : jalr
                        decoded_mop_next.instruction_data.uses_imm = 1'b1;
                        decoded_mop_next.instruction_data.int_reg_write = 1'b1;
                        decoded_mop_next.instruction_data.read_rs1 = 1'b1;
                        decoded_mop_next.instruction_data.read_rs2 = 1'b0;
                        decoded_mop_next.instruction_data.extended_imm_val = {
                            {22{i_instruction_raw[31]}},
                            i_instruction_raw[31:22]
                        };
                        decoded_mop_next.instruction_data.operation = BR_JALR;

                    end else begin : branch
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
                        if (funct3[2]) begin
                            case (funct3[1:0])
                                2'b00:
                                decoded_mop_next.instruction_data.operation = BR_BLT;
                                2'b01:
                                decoded_mop_next.instruction_data.operation = BR_BGE;
                                2'b10:
                                decoded_mop_next.instruction_data.operation = BR_BLTU;
                                2'b11:
                                decoded_mop_next.instruction_data.operation = BR_BGEU;
                            endcase
                        end else begin
                            if (funct3[0]) begin
                                decoded_mop_next.instruction_data.operation = BR_BNE;
                            end else begin
                                decoded_mop_next.instruction_data.operation = BR_BEQ;
                            end
                        end
                    end
                end
            end
        endcase
    end
    always_ff @(posedge clk) begin
        if (i_output_bubble) begin
            o_decode.instruction_data <= '{default: OP_INVALID, invalid : 1};
            o_decode.prediction_data  <= '{default: 0};
        end else if (i_enable) begin
            o_decode <= decoded_mop_next;
        end
    end

endmodule

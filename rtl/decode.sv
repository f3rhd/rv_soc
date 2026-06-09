`include "../include/decode_output.svh"
`include "../include/fetch_interface.svh"
module decode (
    input logic clk,
    input logic i_enable,
    input logic i_output_bubble,
    fetch_if.decode_consumer fi,
    output decode_output_t o_decoded_mop
);
    decode_output_t decoded_mop_next;
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [6:0] op;
    logic [6:0] alu_base_op;
    assign is_alu_instruction = (op == 7'b0010011) || (op == 7'b0110011);
    always_comb begin
        decoded_mop_next                  = '0;
        decoded_mop_next.instruction_addr = fi.pc;
        decoded_mop_next.src1             = fi.instruction_raw[19:15];
        decoded_mop_next.src2             = fi.instruction_raw[24:20];
        decoded_mop_next.dest             = fi.instruction_raw[11:7];
        op                                = fi.instruction_raw[6:0];
        funct3                            = fi.instruction_raw[14:12];
        funct7                            = fi.instruction_raw[31:25];
        if (is_alu_instruction) begin
            if (funct7[0]) begin
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
                    default: decoded_mop_next.invalid = 1'b1;
                endcase
            end else begin
                case (funct3)
                    3'b000:
                    alu_base_op = funct7[5] ? 7'b00_00010 : 7'b00_00001;  // add or sub 
                    3'b001: alu_base_op = 7'b00_00111;  // sll
                    3'b010: alu_base_op = 7'b00_00100;  // slt
                    3'b011: alu_base_op = 7'b00_00101;  // sltu
                    3'b100: alu_base_op = 7'b00_00110;  // xor 
                    3'b101:
                    alu_base_op = funct7[5] ? 7'b00_01000 : 7'b00_00111; // srl or sra
                    3'b110: alu_base_op = 7'b00_01001;  // or
                    3'b111: alu_base_op = 7'b00_01010;  // and
                    default: decoded_mop_next.invalid = 1'b1;
                endcase
            end
        end
        case (op)
            // register to register immediate instructions
            7'b0010011: begin
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{fi.instruction_raw[31]}}, fi.instruction_raw[31:20]
                };
                decoded_mop_next.operation = alu_base_op;
            end
            // default register to register instructions
            7'b0110011: begin
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.operation = alu_base_op;
            end
            // upper immedite instructions
            7'b0110111: begin : lui
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    fi.instruction_raw[31:12], 12'b0
                };
                decoded_mop_next.operation = 7'b00_01100;
            end
            7'b0010111: begin : auipc
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    fi.instruction_raw[31:12], 12'b0
                };
                decoded_mop_next.operation = 7'b00_01011;

            end
            // branch instructions
            7'b1100011: begin : conditional
                decoded_mop_next.btb_write = 1'b1;
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{fi.instruction_raw[31]}},
                    {
                        fi.instruction_raw[31],
                        fi.instruction_raw[7],
                        fi.instruction_raw[30:25],
                        fi.instruction_raw[11:8]
                    }
                };
                case (funct3)
                    3'b000:  decoded_mop_next.operation = 7'b01_00_001;
                    3'b001:  decoded_mop_next.operation = 7'b01_00_010;
                    3'b100:  decoded_mop_next.operation = 7'b01_00_011;
                    3'b101:  decoded_mop_next.operation = 7'b01_00_100;
                    3'b110:  decoded_mop_next.operation = 7'b01_00_101;
                    3'b111:  decoded_mop_next.operation = 7'b01_00_110;
                    default: decoded_mop_next.invalid = 1'b1;
                endcase
            end
            7'b1101111: begin : jal
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {12{fi.instruction_raw[31]}},
                    fi.pc[31],
                    fi.instruction_raw[19:12],
                    fi.pc[20],
                    fi.pc[30:21]
                };
                decoded_mop_next.operation = 7'b01_01_001;
            end
            7'b1100111: begin : jalr
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{fi.instruction_raw[31]}}, fi.instruction_raw[31:20]
                };
                decoded_mop_next.operation = 7'b01_01_000;
            end
            // memory operations
            7'b0000011: begin : loads
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.mem_read = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {12{fi.instruction_raw[31]}}, fi.instruction_raw[31:12]
                };
                case (funct3)
                    3'b000:  decoded_mop_next.operation = 7'b10_01_000;
                    3'b001:  decoded_mop_next.operation = 7'b10_01_001;
                    3'b010:  decoded_mop_next.operation = 7'b10_01_010;
                    3'b100:  decoded_mop_next.operation = 7'b10_01_011;
                    3'b101:  decoded_mop_next.operation = 7'b10_01_100;
                    default: decoded_mop_next.invalid = 1;
                endcase
            end
            7'b0100011: begin : stores
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.mem_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{fi.instruction_raw[31]}},
                    fi.instruction_raw[31:25],
                    fi.instruction_raw[11:7]
                };
                case (funct3)
                    3'b000:  decoded_mop_next.operation = 7'b10_00_000;
                    3'b010:  decoded_mop_next.operation = 7'b10_00_001;
                    3'b110:  decoded_mop_next.operation = 7'b10_00_010;
                    default: decoded_mop_next.invalid = 1;
                endcase
            end
            default: decoded_mop_next.invalid = 1'b1;
        endcase
    end

    always_ff @(posedge clk) begin
        if (i_output_bubble) begin
            o_decoded_mop         <= '0;
            o_decoded_mop.invalid <= 1'b1;
        end else if (i_enable) begin
            o_decoded_mop <= decoded_mop_next;
        end
    end

endmodule

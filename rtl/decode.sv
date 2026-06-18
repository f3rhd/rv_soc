`include "../include/pre_exec_interface.svh"
module decode #(
    parameter HISTORY_SIZE = 10
) (
    input logic clk,
    input logic i_enable,
    input logic i_output_bubble,
    input logic i_instruction_valid,
    input logic i_btb_hit,
    input logic i_predictor_prediction,
    input logic [HISTORY_SIZE-1:0] i_predictor_pht_index,
    input logic [1:0] i_btb_way_hit,
    input logic [31:0] i_instruction_raw,
    input logic [31:0] i_instruction_addr,
    pre_exec_if.decode_producer pre_exec_if
);
    decode_output_t decoded_mop_next;
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [6:0] op;
    logic [6:0] alu_base_op;
    assign is_alu_instruction = (op == 7'b0010011) || (op == 7'b0110011);
    always_comb begin
        decoded_mop_next                  = '0;
        decoded_mop_next.instruction_addr = i_instruction_addr;
        decoded_mop_next.src1             = i_instruction_raw[19:15];
        decoded_mop_next.src2             = i_instruction_raw[24:20];
        decoded_mop_next.dest             = i_instruction_raw[11:7];
        decoded_mop_next.invalid          = ~i_instruction_valid;
        op                                = i_instruction_raw[6:0];
        funct3                            = i_instruction_raw[14:12];
        funct7                            = i_instruction_raw[31:25];
        if (is_alu_instruction) begin
            if (funct7[0] & op == 7'b0110011) begin
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
                    alu_base_op = funct7[5] & op == 7'b0110011 ? 7'b00_00010 : 7'b00_00001;  // sub or add
                    3'b001: alu_base_op = 7'b00_00011;  // sll
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
                decoded_mop_next.is_reg_to_reg_imm = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{i_instruction_raw[31]}}, i_instruction_raw[31:20]
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
                    i_instruction_raw[31:12], 12'b0
                };
                decoded_mop_next.operation = 7'b00_01100;
            end
            7'b0010111: begin : auipc
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    i_instruction_raw[31:12], 12'b0
                };
                decoded_mop_next.operation = 7'b00_01011;

            end
            // branch instructions
            7'b1100011: begin : conditional
                decoded_mop_next.btb_write = 1'b1;
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {19{i_instruction_raw[31]}},
                    {
                        i_instruction_raw[31],
                        i_instruction_raw[7],
                        i_instruction_raw[30:25],
                        i_instruction_raw[11:8],
                        {1'b0}
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
                decoded_mop_next.btb_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {11{i_instruction_raw[31]}},
                    i_instruction_raw[31],
                    i_instruction_raw[19:12],
                    i_instruction_raw[20],
                    i_instruction_raw[30:21],
                    {1'b0}
                };
                decoded_mop_next.operation = 7'b01_01_001;
            end
            7'b1100111: begin : jalr
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{i_instruction_raw[31]}}, i_instruction_raw[31:20]
                };
                decoded_mop_next.operation = 7'b01_01_000;
            end
            // memory operations
            7'b0000011: begin : loads
                decoded_mop_next.uses_imm = 1'b1;
                decoded_mop_next.reg_write = 1'b1;
                decoded_mop_next.mem_read = 1'b1;
                decoded_mop_next.extended_imm_val = {
                    {20{i_instruction_raw[31]}}, i_instruction_raw[31:20]
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
                    {20{i_instruction_raw[31]}},
                    i_instruction_raw[31:25],
                    i_instruction_raw[11:7]
                };
                case (funct3)
                    3'b000:  decoded_mop_next.operation = 7'b10_00_000;
                    3'b001:  decoded_mop_next.operation = 7'b10_00_001;
                    3'b010:  decoded_mop_next.operation = 7'b10_00_010;
                    default: decoded_mop_next.invalid = 1;
                endcase
            end
            default: decoded_mop_next.invalid = 1'b1;
        endcase
    end

    always_ff @(posedge clk) begin
        if (i_output_bubble) begin
            pre_exec_if.decode_data         <= '0;
            pre_exec_if.decode_data.invalid <= 1'b1;
            pre_exec_if.btb_was_hit         <= 0;
            pre_exec_if.btb_way_hit         <= 0;
            pre_exec_if.prediction          <= 0;
            pre_exec_if.pht_index           <= 0;
        end else if (i_enable) begin
            pre_exec_if.decode_data <= decoded_mop_next;
            pre_exec_if.btb_was_hit <= i_btb_hit;
            pre_exec_if.btb_way_hit <= i_btb_way_hit;
            pre_exec_if.prediction  <= i_predictor_prediction;
            pre_exec_if.pht_index   <= i_predictor_pht_index;
        end
    end

endmodule

`include "../include/pre_exec_interface.svh"
`include "../include/execution_interface.svh"
module execute (
    input logic clk,
    input logic i_output_bubble,
    pre_exec_if.consumer pre_exi,
    execution_if.producer exi
);
    logic [31:0] alu_out;
    logic branch_result;
    logic [2:0] memory_operation;
    logic [31:0] memory_write_data;
    logic should_bubble;
    logic src1_match, src2_match;
    logic [31:0] src1_data, src2_data;

    assign src1_match = (exi.reg_write && ~exi.mem_read && (pre_exi.decode_data.src1 == exi.dest) && (exi.dest != 5'd0));
    assign src2_match = (exi.reg_write && ~exi.mem_read && (pre_exi.decode_data.src2 == exi.dest) && (exi.dest != 5'd0) && ~pre_exi.decode_data.uses_imm);


    always_comb begin
        memory_operation = '0;
        alu_out = 0;
        branch_result = '0;
        memory_write_data = src2_data;
        should_bubble = 0;

        exi.predictor_update = '0;
        exi.actual_branch_result = branch_result;
        exi.pht_index = pre_exi.pht_index;
        exi.branch_addr_way = pre_exi.btb_way_hit;
        exi.btb_write = pre_exi.decode_data.btb_write & ~pre_exi.btb_was_hit & ~pre_exi.decode_data.invalid;
        exi.redirection_address = '0;
        exi.redirect = '0;
        exi.branch_instruction_addr = pre_exi.decode_data.instruction_addr;

        exi.stall_pipeline = ~pre_exi.decode_data.invalid & (exi.mem_read && (pre_exi.decode_data.src1 == exi.dest) && (exi.dest != 5'd0)) &
            (exi.mem_read && (pre_exi.decode_data.src2 == exi.dest) && (exi.dest != 5'd0) && ~pre_exi.decode_data.uses_imm);

        src1_data = src1_match ? exi.alu_out : pre_exi.src1_data;
        src2_data = src2_match ? exi.alu_out : pre_exi.src2_data;
        case (pre_exi.decode_data.operation[6:5])
            2'b00: begin
                src2_data = pre_exi.decode_data.uses_imm ? pre_exi.decode_data.extended_imm_val : src2_data;
                case (pre_exi.decode_data.operation[4:0])
                    5'b00001: alu_out = src1_data + src2_data;
                    5'b00010: alu_out = src1_data - src2_data;
                    5'b00011: alu_out = src1_data << src2_data[4:0];
                    5'b00100:
                    alu_out = {
                        {31{1'b0}}, $signed(src1_data) < $signed(src2_data)
                    };
                    5'b00101:
                    alu_out = {
                        {31{1'b0}}, $unsigned(src1_data) < $unsigned(src2_data)
                    };
                    5'b00110: alu_out = src1_data ^ src2_data;
                    5'b00111: alu_out = src1_data >> src2_data[4:0];
                    5'b01000: alu_out = $signed(src1_data) >>> src2_data[4:0];
                    5'b01001: alu_out = src1_data | src2_data;
                    5'b01010: alu_out = src1_data & src2_data;
                    // AUIPC
                    5'b01011:
                    alu_out = pre_exi.decode_data.instruction_addr + src2_data;
                    // LUI
                    5'b01100: alu_out = src2_data;
                    //MUL
                    5'b01110: alu_out = src1_data * src2_data;
                    // MULH (Signed * Signed)
                    5'b01111:
                    alu_out = 64'($signed(src1_data) * $signed(src2_data)) >>
                        32;

                    // MULHSU (Signed * Unsigned)
                    5'b10000:
                    alu_out = (65'($signed({{32{src1_data[31]}}, src1_data}) *
                                   $signed({33'b0, src2_data}))) >> 32;

                    // MULHU (Unsigned * Unsigned)
                    5'b10001: alu_out = (64'(src1_data) * 64'(src2_data)) >> 32;

                    5'b10010:
                    alu_out = (src2_data == 32'h0) ? 32'hFFFF_FFFF :
                                (src1_data == 32'h8000_0000 &&
                                src2_data == 32'hFFFF_FFFF)  ? 32'h8000_0000 :
                                $signed(src1_data) / $signed(src2_data);

                    // DIVU (Unsigned)
                    5'b10011:
                    alu_out = (src2_data == 32'h0) ? 32'hFFFF_FFFF :
                                src1_data / src2_data;

                    5'b10100:
                    alu_out = (src2_data == 32'h0) ? src1_data :
                                (src1_data == 32'h8000_0000 &&
                                src2_data == 32'hFFFF_FFFF)  ? 32'h0 :
                                $signed(src1_data) % $signed(src2_data);

                    5'b10101:
                    alu_out = (src2_data == 32'h0) ? src1_data :
                                src1_data % src2_data;
                    default: alu_out = 0;
                endcase
            end
            2'b01: begin
                should_bubble = 1;
                case (pre_exi.decode_data.operation[3])
                    1'b1: begin
                        exi.redirect = 1'b1 & pre_exi.decode_data.invalid;
                        alu_out      = pre_exi.decode_data.instruction_addr + 4;
                        case (pre_exi.decode_data.operation[0])
                            1'b0: begin
                                exi.redirection_address = src1_data + pre_exi.decode_data.extended_imm_val;
                            end
                            1'b1: begin
                                exi.redirection_address = pre_exi.decode_data.instruction_addr + pre_exi.decode_data.extended_imm_val;
                            end
                            default: exi.redirection_address = 32'hFFFFFFFF;
                        endcase
                    end
                    1'b0: begin
                        case (pre_exi.decode_data.operation[2:0])
                            3'b001:
                            branch_result = $signed(src1_data) ==
                                $signed(src2_data);
                            3'b010:
                            branch_result = $signed(src1_data) !=
                                $signed(src2_data);
                            3'b011:
                            branch_result = $signed(src1_data) <
                                $signed(src2_data);
                            3'b100:
                            branch_result = $signed(src1_data) >=
                                $signed(src2_data);
                            3'b101:
                            branch_result = $unsigned(src2_data) <
                                $unsigned(src2_data);
                            3'b110:
                            branch_result = $unsigned(src2_data) >=
                                $unsigned(src2_data);
                        endcase
                        exi.redirect = (pre_exi.prediction ^ branch_result) & pre_exi.decode_data.invalid;
                        exi.predictor_update = 1'b1 & ~pre_exi.decode_data.invalid;
                        if (branch_result == 1) begin
                            exi.redirection_address = pre_exi.decode_data.instruction_addr + pre_exi.decode_data.extended_imm_val;
                        end else begin
                            exi.redirection_address = pre_exi.decode_data.instruction_addr + 4;
                        end
                    end
                endcase
            end
            2'b10: begin
                alu_out          = src1_data + src2_data;
                memory_operation = pre_exi.decode_data.operation[2:0];
            end
            default: should_bubble = 1;
        endcase
    end
    always_ff @(posedge clk) begin
        if ((should_bubble & pre_exi.decode_data.invalid) | i_output_bubble) begin
            exi.invalid           <= 1;
            exi.memory_write_data <= 0;
            exi.memory_operation  <= 0;
            exi.alu_out           <= 0;
            exi.dest              <= 0;
            exi.mem_write         <= 0;
            exi.reg_write         <= 0;
            exi.mem_read          <= 0;
        end else begin
            exi.memory_write_data <= memory_write_data;
            exi.memory_operation  <= memory_operation;
            exi.alu_out           <= alu_out;
            exi.dest              <= pre_exi.decode_data.dest;
            exi.invalid           <= pre_exi.decode_data.invalid;
            exi.mem_write         <= pre_exi.decode_data.mem_write;
            exi.mem_read          <= pre_exi.decode_data.mem_read;
            exi.reg_write         <= pre_exi.decode_data.reg_write;
        end
    end
endmodule

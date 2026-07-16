`include "../../include/execution_interface.svh"
`include "../../include/register.svh"
`include "../../include/decode_output.svh"
module execute #(
    parameter HISTORY_SIZE = 10
) (
    input logic clk,
    /*unlike stall behavior of other stages execution's is rather different
    when there is a dependency between a load and following branch/jump instruction
    we have to disable redirection for one cycle as operand that is going to be use for comparison is not ready yet*/
    input logic i_en,
    input logic i_output_bubble,
    input decode_output_t i_decode_out, // has the signals needed for triggering type1 stall
    input register_read_output_t i_register_read_out,
    execution_if.producer exi
);
    logic [31:0] alu_out;
    logic branch_result;
    logic [2:0] memory_operation;
    logic [31:0] memory_write_data;
    //logic should_bubble;
    logic src1_match, src2_match;
    logic [31:0] src1_data, src2_data;


    logic predictor_update;
    logic [31:0] redirection_address;
    logic redirect;
    logic [HISTORY_SIZE - 1 : 0] pht_index;
    logic [1:0] branch_addr_way;
    logic btb_write;
    logic [31:0] branch_instruction_addr;
    logic btb_write_jump;

    decoded_instruction_t instruction_data;
    register_read_data_t read_data;
    prediction_data_t prediction_data;

    assign prediction_data = i_register_read_out.decode_data.prediction_data;
    assign instruction_data = i_register_read_out.decode_data.instruction_data;
    assign read_data = i_register_read_out.read_data;

    assign src1_match = (exi.reg_write && ~exi.mem_read  && (instruction_data.src1 == exi.dest) && (exi.dest != 5'd0));
    assign src2_match = (exi.reg_write && ~exi.mem_read  && (instruction_data.src2 == exi.dest) && (exi.dest != 5'd0));

    assign exi.stall_pipeline_type1 = ~i_decode_out.instruction_data.invalid & exi.mem_read & (
        ((i_decode_out.instruction_data.src1 == exi.dest) && (exi.dest != 5'd0)) 
        |
        ((i_decode_out.instruction_data.src2 == exi.dest) && (exi.dest != 5'd0) && ~i_decode_out.instruction_data.is_reg_to_reg_imm )
    );
    always_comb begin
        memory_operation = '0;
        alu_out = 0;
        branch_result = '0;
        //should_bubble = 0;
        memory_write_data = 0;
        predictor_update = '0;
        redirection_address = '0;
        redirect = '0;
        pht_index = prediction_data.pht_index;
        branch_addr_way = prediction_data.btb_way_hit;
        btb_write = instruction_data.btb_write & ~prediction_data.btb_was_hit & ~instruction_data.invalid;
        branch_instruction_addr = instruction_data.instruction_addr;
        btb_write_jump = '0;


        src1_data = src1_match ? exi.alu_out : read_data.src1_data;
        src2_data = src2_match ? exi.alu_out : read_data.src2_data;
        case (instruction_data.operation[6:5])
            2'b00: begin
                src2_data = instruction_data.uses_imm ? instruction_data.extended_imm_val : src2_data;
                case (instruction_data.operation[4:0])
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
                    alu_out = instruction_data.instruction_addr + src2_data;
                    // LUI
                    5'b01100: alu_out = src2_data;
                    //MUL
                    //5'b01110: alu_out = src1_data * src2_data;
                    //// MULH (Signed * Signed)
                    //5'b01111:
                    //alu_out = 64'($signed(src1_data) * $signed(src2_data)) >>
                    //    32;

                    //// MULHSU (Signed * Unsigned)
                    //5'b10000:
                    //alu_out = (65'($signed({{32{src1_data[31]}}, src1_data}) *
                    //               $signed({33'b0, src2_data}))) >> 32;

                    //// MULHU (Unsigned * Unsigned)
                    //5'b10001: alu_out = (64'(src1_data) * 64'(src2_data)) >> 32;

                    //5'b10010:
                    //alu_out = (src2_data == 32'h0) ? 32'hFFFF_FFFF :
                    //            (src1_data == 32'h8000_0000 &&
                    //            src2_data == 32'hFFFF_FFFF)  ? 32'h8000_0000 :
                    //            $signed(src1_data) / $signed(src2_data);

                    //// DIVU (Unsigned)
                    //5'b10011:
                    //alu_out = (src2_data == 32'h0) ? 32'hFFFF_FFFF :
                    //            src1_data / src2_data;

                    //5'b10100:
                    //alu_out = (src2_data == 32'h0) ? src1_data :
                    //            (src1_data == 32'h8000_0000 &&
                    //            src2_data == 32'hFFFF_FFFF)  ? 32'h0 :
                    //            $signed(src1_data) % $signed(src2_data);

                    //5'b10101:
                    //alu_out = (src2_data == 32'h0) ? src1_data :
                    //           src1_data % src2_data;
                    default: alu_out = 0;
                endcase
            end
            2'b01: begin
                case (instruction_data.operation[3])
                    1'b1: begin
                        alu_out = instruction_data.instruction_addr + 1;
                        case (instruction_data.operation[0])
                            1'b0: begin
                                redirect = 1'b1 & ~instruction_data.invalid & i_en;
                                redirection_address = src1_data + instruction_data.extended_imm_val;
                            end
                            1'b1: begin
                                redirect = ~instruction_data.invalid & ~prediction_data.btb_was_hit;
                                redirection_address = instruction_data.instruction_addr + instruction_data.extended_imm_val ;
                                btb_write_jump = 1;
                            end
                            default: exi.redirection_address = 32'hFFFFFFFF;
                        endcase
                    end
                    1'b0: begin

                        case (instruction_data.operation[2:0])
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
                            branch_result = $unsigned(src1_data) <
                                $unsigned(src2_data);
                            3'b110:
                            branch_result = $unsigned(src1_data) >=
                                $unsigned(src2_data);
                            default: begin
                            end
                        endcase
                        redirect = (prediction_data.prediction ^ branch_result) & ~instruction_data.invalid & i_en;
                        predictor_update = 1'b1 & ~instruction_data.invalid & i_en;
                        if (branch_result == 1) begin
                            redirection_address = instruction_data.instruction_addr + instruction_data.extended_imm_val;
                        end else begin
                            redirection_address = instruction_data.instruction_addr + 1;
                        end
                    end
                    default: begin

                    end
                endcase
            end
            2'b10: begin
                alu_out = src1_data + instruction_data.extended_imm_val;
                memory_operation = instruction_data.operation[2:0];
                memory_write_data = src2_data;
            end
            default: begin
            end
        endcase
    end
    always_ff @(posedge clk) begin
        if (instruction_data.invalid | i_output_bubble) begin
            exi.invalid                 <= 1;
            exi.memory_write_data       <= 0;
            exi.memory_operation        <= 0;
            exi.alu_out                 <= 0;
            exi.dest                    <= 0;
            exi.mem_write               <= 0;
            exi.reg_write               <= 0;
            exi.mem_read                <= 0;
            exi.predictor_update        <= 0;
            exi.redirection_address     <= 0;
            exi.redirect                <= 0;
            exi.pht_index               <= 0;
            exi.branch_addr_way         <= 0;
            exi.btb_write               <= 0;
            exi.branch_instruction_addr <= 0;
            exi.btb_write_jump          <= 0;
            exi.actual_branch_result    <= 0;
        end else if (i_en) begin
            exi.memory_write_data       <= memory_write_data;
            exi.memory_operation        <= memory_operation;
            exi.alu_out                 <= alu_out;
            exi.dest                    <= instruction_data.dest;
            exi.invalid                 <= instruction_data.invalid;
            exi.mem_write               <= instruction_data.mem_write;
            exi.mem_read                <= instruction_data.mem_read;
            exi.reg_write               <= instruction_data.reg_write;
            exi.predictor_update        <= predictor_update;
            exi.redirection_address     <= redirection_address;
            exi.redirect                <= redirect;
            exi.pht_index               <= pht_index;
            exi.branch_addr_way         <= branch_addr_way;
            exi.btb_write               <= btb_write;
            exi.branch_instruction_addr <= branch_instruction_addr;
            exi.btb_write_jump          <= btb_write_jump;
            exi.actual_branch_result    <= branch_result;
        end
    end
endmodule

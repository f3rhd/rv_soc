/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "../../include/register.svh"
`include "../../include/decode_output.svh"
`include "../../include/execution_interface.svh"
module register_file (
    input logic clk,
    input logic i_en,
    input logic i_output_bubble,
    input logic i_reset,
    input register_write_data_t i_register_write,
    input decode_output_t i_decode_out,
    execution_if.register_read exi,
    output register_read_output_t o_register_read
);
    logic [31:0] file[0:31];

    decoded_instruction_t instruction_data_in;
    decoded_instruction_t instruction_data_out;
    assign instruction_data_in = i_decode_out.instruction_data;
    assign instruction_data_out = o_register_read.decode_data.instruction_data;
    assign exi.stall_pipeline_type0 = ~instruction_data_in.invalid & instruction_data_out.mem_read & (
        ((instruction_data_in.src1 == instruction_data_out.dest) && (instruction_data_out.dest != 5'd0)) 
        |
        ((instruction_data_in.src2 == instruction_data_out.dest) && (instruction_data_out.dest != 5'd0) && ~instruction_data_in.is_reg_to_reg_imm )
    );

    always_ff @(posedge clk) begin
        if (i_reset) begin
            for (int i = 0; i < 32; i++) begin
                file[i] <= 0;
            end
            o_register_read.decode_data.instruction_data <= '{
                default: 0,
                invalid : 1
            };
            o_register_read.decode_data.prediction_data <= '{default: 0};
            o_register_read.read_data <= '{default: 0};
        end else if (i_register_write.write_enable) begin
            if (i_register_write.write_addr != 0) begin
                file[i_register_write.write_addr] <= i_register_write.write_data;
            end
        end
        if (i_en) begin
            o_register_read.decode_data <= i_decode_out;
            // Forward from execute
            if (exi.reg_write & ~exi.mem_read & exi.dest == instruction_data_in.src1 && instruction_data_in.src1 != 0) begin
                o_register_read.read_data.src1_data <= exi.alu_out;
                // Forward from write back stage
            end else if (i_register_write.write_enable & i_register_write.write_addr == instruction_data_in.src1 && instruction_data_in.src1 != 0) begin
                o_register_read.read_data.src1_data <= i_register_write.write_data;
            end else begin
                o_register_read.read_data.src1_data <= file[instruction_data_in.src1];
            end

            if (exi.reg_write & ~exi.mem_read & exi.dest == instruction_data_in.src2 && instruction_data_in.src2 != 0) begin
                o_register_read.read_data.src2_data <= exi.alu_out;
            end  // Forward from write back stage
            else if (i_register_write.write_enable & i_register_write.write_addr == instruction_data_in.src2 && instruction_data_in.src2 != 0) begin
                o_register_read.read_data.src2_data <= i_register_write.write_data;
            end else begin
                o_register_read.read_data.src2_data <= file[instruction_data_in.src2];
            end
        end
        if (i_output_bubble) begin
            o_register_read.decode_data.instruction_data <= '{
                default: 0,
                invalid : 1
            };
            o_register_read.decode_data.prediction_data <= '{default: 0};
            o_register_read.read_data <= '{default: 0};
        end
    end
endmodule

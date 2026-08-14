/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "register.svh"
`include "decode_output.svh"
`include "execution_interface.svh"
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
    logic [31:0] integer_register_file[0:31];
    logic [31:0] float_register_file[0:31];

    decoded_instruction_t instruction_data_in;
    decoded_instruction_t instruction_data_out;
    assign instruction_data_in  = i_decode_out.instruction_data;
    assign instruction_data_out = o_register_read.decode_data.instruction_data;

    always_comb begin
        exi.stall_pipeline_type0 = 0;
        if (~instruction_data_in.invalid & instruction_data_out.mem_read) begin
            // Load stall logic for integer related dependency
            if(instruction_data_out.int_reg_write & instruction_data_out.dest != 0) begin
                exi.stall_pipeline_type0 = 
                        ((instruction_data_in.src1 == instruction_data_out.dest) && instruction_data_in.read_rs1) 
                        |
                        ((instruction_data_in.src2 == instruction_data_out.dest) && instruction_data_in.read_rs2);
            end else if (instruction_data_out.float_reg_write) begin
                exi.stall_pipeline_type0 = 
                        ((instruction_data_in.src1 == instruction_data_out.dest) && instruction_data_in.read_fs1) 
                        |
                        ((instruction_data_in.src2 == instruction_data_out.dest) && instruction_data_in.read_fs2)
                        |
                        ((instruction_data_in.src3 == instruction_data_out.dest) && instruction_data_in.read_fs3);
            end
        end
    end
    always_ff @(posedge clk) begin : integer_register
        if (i_reset) begin
            for (int i = 0; i < 32; i++) begin
                integer_register_file[i] <= 0;
                float_register_file[i]   <= 0;
            end
            o_register_read.decode_data.instruction_data <= '{
                default: OP_INVALID,
                invalid : 1
            };
            o_register_read.decode_data.prediction_data <= '{default: 0};
            o_register_read.read_data <= '{default: 0};
        end else if (i_register_write.int_write_enable & i_register_write.write_addr != 0) begin
            integer_register_file[i_register_write.write_addr] <= i_register_write.write_data;
        end else if (i_register_write.float_write_enable) begin
            float_register_file[i_register_write.write_addr] <= i_register_write.write_data;
        end
        if (i_en) begin
            o_register_read.decode_data <= i_decode_out;
            begin : src1_data
                o_register_read.read_data.src1_data <= '0;

                // Integer registers
                if (instruction_data_in.read_rs1) begin
                    // Priority 1: Forward from EX stage
                    if (exi.int_reg_write & ~exi.mem_read & (exi.dest == instruction_data_in.src1) && instruction_data_in.src1 != 0) begin
                        o_register_read.read_data.src1_data <= exi.exec_result;
                    end  // Priority 2: Forward from WB stage
                    else if (i_register_write.int_write_enable & (i_register_write.write_addr == instruction_data_in.src1) && instruction_data_in.src1 != 0) begin
                        o_register_read.read_data.src1_data <= i_register_write.write_data;
                    end  // Priority 3: Read directly from Integer Regfile
                    else begin
                        o_register_read.read_data.src1_data <= integer_register_file[instruction_data_in.src1];
                    end
                end  // Floating point registers
                else if (instruction_data_in.read_fs1) begin
                    // Priority 1: Forward from EX stage
                    if (exi.float_reg_write & ~exi.mem_read & (exi.dest == instruction_data_in.src1)) begin
                        o_register_read.read_data.src1_data <= exi.exec_result;
                    end  // Priority 2: Forward from WB stage
                    else if (i_register_write.float_write_enable & (i_register_write.write_addr == instruction_data_in.src1)) begin
                        o_register_read.read_data.src1_data <= i_register_write.write_data;
                    end  // Priority 3: Read directly from Float Regfile
                    else begin
                        o_register_read.read_data.src1_data <= float_register_file[instruction_data_in.src1];
                    end
                end
            end
            begin : src2_data
                o_register_read.read_data.src2_data <= '0;

                // Integer registers
                if (instruction_data_in.read_rs2) begin
                    // Priority 1: Forward from EX stage
                    if (exi.int_reg_write & ~exi.mem_read & (exi.dest == instruction_data_in.src2) && instruction_data_in.src2 != 0) begin
                        o_register_read.read_data.src2_data <= exi.exec_result;
                    end  // Priority 2: Forward from WB stage
                    else if (i_register_write.int_write_enable & (i_register_write.write_addr == instruction_data_in.src2) && instruction_data_in.src2 != 0) begin
                        o_register_read.read_data.src2_data <= i_register_write.write_data;
                    end  // Priority 3: Read directly from Integer Regfile
                    else begin
                        o_register_read.read_data.src2_data <= integer_register_file[instruction_data_in.src2];
                    end
                end  // Floating point registers
                else if (instruction_data_in.read_fs2) begin
                    // Priority 1: Forward from EX stage
                    if (exi.float_reg_write & ~exi.mem_read & (exi.dest == instruction_data_in.src2)) begin
                        o_register_read.read_data.src2_data <= exi.exec_result;
                    end  // Priority 2: Forward from WB stage
                    else if (i_register_write.float_write_enable & (i_register_write.write_addr == instruction_data_in.src2)) begin
                        o_register_read.read_data.src2_data <= i_register_write.write_data;
                    end  // Priority 3: Read directly from Float Regfile
                    else begin
                        o_register_read.read_data.src2_data <= float_register_file[instruction_data_in.src2];
                    end
                end
            end
            begin : src3_data
                o_register_read.read_data.src3_data <= '0;

                // src3_data data holds only float values
                // Priority 1: Forward from EX stage
                if (exi.float_reg_write & ~exi.mem_read & (exi.dest == instruction_data_in.src3)) begin
                    o_register_read.read_data.src3_data <= exi.exec_result;
                end  // Priority 2: Forward from WB stage
                else if (i_register_write.float_write_enable & (i_register_write.write_addr == instruction_data_in.src3)) begin
                    o_register_read.read_data.src3_data <= i_register_write.write_data;
                end  // Priority 3: Read directly from Float Regfile
                else begin
                    o_register_read.read_data.src3_data <= float_register_file[instruction_data_in.src3];
                end
            end
        end
        begin : fcsr
            o_register_read.read_data.fcsr <= 0;
            if (exi.float_reg_write & ~exi.mem_read & (exi.dest == 3)) begin
                o_register_read.read_data.fcsr <= exi.exec_result;
            end  // Priority 2: Forward from WB stage
                else if (i_register_write.float_write_enable & (i_register_write.write_addr == 3)) begin
                o_register_read.read_data.fcsr <= i_register_write.write_data;
            end  // Priority 3: Read directly from Float Regfile
                else begin
                o_register_read.read_data.fcsr <= float_register_file[3];
            end
        end
        if (i_output_bubble) begin
            o_register_read.decode_data.instruction_data <= '{
                default: OP_INVALID,
                invalid : 1
            };
            o_register_read.decode_data.prediction_data <= '{default: 0};
            o_register_read.read_data <= '{default: 0};
        end
    end
endmodule

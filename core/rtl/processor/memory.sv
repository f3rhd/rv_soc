/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "execution_interface.svh"
`include "../graphics_unit/common/graphics_interface.svh"
`include "register.svh"
`include "../gpio_interface.svh"
`include "../bootloader/bootloader_interface.svh"
module memory #(
    parameter SIZE = 2048
) (
    input logic clk,
    input logic i_reset,
    input logic i_en,
    input logic [63:0] i_system_counter,
    execution_if.mem_consumer ei,
    graphics_if.processor graphicsi,
    gpio_if.processor gpioi,
    bootloader_if.processor bootloaderi,
    output register_write_data_t o_register_write,
    output logic o_graphics_write,
    output logic o_gpio_stall,
    output logic [15:0] o_reg16_f4,
    output logic [15:0] o_reg16_f8
);
    localparam logic [31:0] GRAPHICS_ADDR = 32'hF0000001;
    localparam logic [31:0] REG16_1_ADDR = 32'hF0000004;
    localparam logic [31:0] REG16_2_ADDR = 32'hF0000008;
    localparam logic [31:0] PIN_MODE_ADDR = 32'hF0000010;
    localparam logic [31:0] PIN_DRIVE_ADDR = 32'hF0000020;
    localparam logic [31:0] PIN_READ_ADDR = 32'hF0000040;
    localparam logic [31:0] SYSTEM_CNTR_READ_LOW = 32'hF0000080;
    localparam logic [31:0] SYSTEM_CNTR_READ_HIGH = 32'hF0000100;

`ifdef VIVADO
    (* ram_style = "block" *)
`elsif QUARTUS
    (* ramstyle = "block" *)
`endif
    logic [0:31] ram[0:SIZE/4-1];
    logic [31:0] static_data_counter;

    wire [31:0] address = bootloaderi.static_data_ready ? static_data_counter : ei.exec_result >> 2;

    logic [1:0] r_byte_offset;
    logic [31:0] reg_exec_result;
    logic [31:0] reg_raw_word;
    logic [2:0] reg_memory_op;
    logic reg_mem_read;
    logic sent_gpio_read;

    wire [7:0] selected_byte = (r_byte_offset == 2'b00) ? reg_raw_word[31:24]   :
        (r_byte_offset == 2'b01) ? reg_raw_word[23:16]  :
        (r_byte_offset == 2'b10) ? reg_raw_word[15:8] :
                                   reg_raw_word[7:0];
    wire [15:0] selected_half = r_byte_offset[1] ? reg_raw_word[15:0] : reg_raw_word[31:16];

    logic [3:0] byte_en;
    logic [7:0] byte0_write;
    logic [7:0] byte1_write;
    logic [7:0] byte2_write;
    logic [7:0] byte3_write;
    logic is_mmio;
    logic [31:0] reg_system_counter_read_val;
    logic reg_system_counter_read;



    assign is_mmio          = ei.exec_result[31] == 1'b1;
    assign o_graphics_write = graphicsi.graphics_instruction_write;
    assign o_gpio_stall     = sent_gpio_read && !gpioi.pin_read_done;


    always_comb begin
        byte_en = 4'b0000;
        if (ei.mem_write && !ei.invalid) begin
            case (ei.memory_operation)
                3'b000: byte_en[ei.exec_result[1:0]] = 1'b1;  // SB
                3'b001: begin  // SH
                    if (ei.exec_result[1]) byte_en = 4'b1100;
                    else byte_en = 4'b0011;
                end
                3'b100,  // store float
                3'b010:
                byte_en = 4'b1111;  // SW
                default: byte_en = 4'b0000;
            endcase
        end
    end
    always_comb begin
        byte0_write = ei.memory_write_data[7:0];
        byte1_write = byte_en[0] ? ei.memory_write_data[15:8] : ei.memory_write_data[7:0];
        byte2_write = byte_en[3] & byte_en[1] & byte_en[0] ? ei.memory_write_data[23:16] : ei.memory_write_data[7:0];
        byte3_write = byte_en[2] & byte_en[1] & byte_en[0] ? ei.memory_write_data[31:24] : 
                                                byte_en[2] ? ei.memory_write_data[15:8] :
                                                ei.memory_write_data[7:0];
    end
    always_ff @(posedge clk) begin
        if (i_reset) begin
            o_register_write.write_addr          <= 0;
            o_register_write.int_write_enable    <= 0;
            o_register_write.float_write_enable  <= 0;
            reg_mem_read                         <= 0;
            graphicsi.graphics_instruction       <= 0;
            graphicsi.graphics_instruction_write <= 0;
            o_reg16_f4                           <= 0;
            o_reg16_f8                           <= 0;
            gpioi.pin_drive_enable               <= 0;
            gpioi.pin_set_enable                 <= 0;
            gpioi.pin_read_enable                <= 0;
            sent_gpio_read                       <= 0;
            static_data_counter                  <= 0;
        end else if (i_en) begin
            o_register_write.int_write_enable    <= ei.int_reg_write;
            o_register_write.float_write_enable  <= ei.float_reg_write;
            o_register_write.write_addr          <= ei.dest;
            reg_mem_read                         <= 0;
            graphicsi.graphics_instruction       <= 0;
            graphicsi.graphics_instruction_write <= 0;
            gpioi.pin_drive_enable               <= 0;
            gpioi.pin_set_enable                 <= 0;
            gpioi.pin_read_enable                <= 0;
            reg_system_counter_read              <= 0;
            reg_exec_result                      <= ei.exec_result;
            if (sent_gpio_read && gpioi.pin_read_done) begin
                sent_gpio_read <= 0;
            end
            if (bootloaderi.static_data_ready) begin
                ram[address]        <= bootloaderi.static_data;
                static_data_counter <= static_data_counter + 1;
            end else begin
                if (ei.mem_write) begin
                    if (is_mmio) begin
                        if (ei.exec_result[0]) begin
                            graphicsi.graphics_instruction <= ei.memory_write_data;
                            graphicsi.graphics_instruction_write <= 1;
                        end else if (ei.exec_result[2]) begin
                            o_reg16_f8 <= ei.memory_write_data[15:0];
                        end else if (ei.exec_result[3]) begin
                            o_reg16_f4 <= ei.memory_write_data[15:0];
                        end else if (ei.exec_result[4]) begin
                            gpioi.pin_set_enable <= 1;
                            gpioi.pin_id         <= ei.memory_write_data[5:1];
                            gpioi.pin_mode       <= ei.memory_write_data[0];
                        end else if (ei.exec_result[5]) begin
                            gpioi.pin_drive_enable <= 1;
                            gpioi.pin_drive_val    <= ei.memory_write_data[0];
                            gpioi.pin_id           <= ei.memory_write_data[5:1];
                        end
                    end else begin
                        if (byte_en[0]) begin
                            ram[address][0:7] <= byte0_write;
                        end
                        if (byte_en[1]) begin
                            ram[address][8:15] <= byte1_write;
                        end
                        if (byte_en[2]) begin
                            ram[address][16:23] <= byte2_write;
                        end
                        if (byte_en[3]) begin
                            ram[address][24:31] <= byte3_write;
                        end
                    end
                end else if (ei.mem_read) begin
                    reg_memory_op <= ei.memory_operation;
                    reg_mem_read  <= 1;
                    r_byte_offset <= ei.exec_result[1:0];
                    if (ei.exec_result[6] && !sent_gpio_read && is_mmio) begin
                        gpioi.pin_read_enable <= 1;
                        gpioi.pin_id          <= ei.exec_result[12:8];
                        sent_gpio_read        <= 1;
                    end else if (ei.exec_result[7] && is_mmio) begin
                        reg_system_counter_read_val <= i_system_counter[31:0];
                        reg_system_counter_read     <= 1;
                    end else if (ei.exec_result[8] && is_mmio) begin
                        reg_system_counter_read_val <= i_system_counter[63:32];
                        reg_system_counter_read     <= 1;
                    end
                    reg_raw_word <= ram[address];
                end
            end
        end
    end
    always_comb begin
        if (reg_mem_read) begin
            case (reg_memory_op)
                // load byte (signed)
                3'b000:
                o_register_write.write_data = {
                    {24{selected_byte[7]}}, selected_byte
                };
                // load half (signed)
                3'b001:
                o_register_write.write_data = {
                    {16{selected_half[7]}},
                    selected_half[7:0],
                    selected_half[15:8]
                };
                // load word integer 
                3'b010: begin
                    if (sent_gpio_read && gpioi.pin_read_done) begin
                        o_register_write.write_data = {
                            {31{1'b0}}, gpioi.pin_read_val
                        };
                    end else if (sent_gpio_read) begin
                        o_register_write.write_data = 0;
                    end else if (reg_system_counter_read) begin
                        o_register_write.write_data = reg_system_counter_read_val;
                    end else begin
                        o_register_write.write_data = {
                            reg_raw_word[7:0],
                            reg_raw_word[15:8],
                            reg_raw_word[23:16],
                            reg_raw_word[31:24]
                        };
                    end
                end
                // load word float 
                3'b101: begin
                    o_register_write.write_data = {
                        reg_raw_word[7:0],
                        reg_raw_word[15:8],
                        reg_raw_word[23:16],
                        reg_raw_word[31:24]
                    };
                end
                // load byte unsigned
                3'b011: o_register_write.write_data = {24'b0, selected_byte};
                // load half unsigned
                3'b100:
                o_register_write.write_data = {
                    16'b0, selected_half[7:0], selected_half[15:8]
                };
                default: o_register_write.write_data = 33'b0;
            endcase
        end else begin
            o_register_write.write_data = reg_exec_result;
        end
    end
endmodule

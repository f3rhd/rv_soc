`include "../../include/execution_interface.svh"
`include "../../include/execution_interface.svh"
`include "../../include/graphics_interface.svh"
`include "../../include/register.svh"
module memory #(
    parameter SIZE = 2048
) (
    input logic clk,
    execution_if.mem_consumer ei,
    graphics_if.processor graphicsi,
    output register_write_data_t o_register_write
);
    localparam unsigned GRAPHICS_PIXEL_DATA_ADDRESS = 32'hFFFFFFFF; // @Temporary : May change it later 
    localparam unsigned GRAPHICS_COMMAND_DATA_ADDRESS = 32'hFFFFFFF0; // @Temporary : May change it later

    (* ram_style = "block" *) logic [0:31] ram[0:SIZE-1];
    wire [31:0] translated_address = ei.alu_out >> 2;

    logic [1:0] r_byte_offset;
    logic alu_is_reg_write;
    logic [31:0] reg_alu_out;
    logic [31:0] reg_raw_word;
    logic [2:0] reg_memory_op;
    logic reg_mem_read;

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
    always_comb begin
        byte_en = 4'b0000;
        if (ei.mem_write && !ei.invalid) begin
            case (ei.memory_operation)
                3'b000:  byte_en[ei.alu_out[1:0]] = 1'b1;  // SB
                3'b001: begin  // SH
                    if (ei.alu_out[1]) byte_en = 4'b1100;
                    else byte_en = 4'b0011;
                end
                3'b010:  byte_en = 4'b1111;  // SW
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
        if (ei.invalid) begin
            o_register_write.write_addr   <= 0;
            o_register_write.write_enable <= 0;
            alu_is_reg_write              <= 0;
            reg_mem_read                  <= 0;
        end else begin
            o_register_write.write_enable <= ei.reg_write;
            o_register_write.write_addr   <= ei.dest;
            alu_is_reg_write              <= 0;
            reg_mem_read                  <= 0;
            if (ei.reg_write & ~ei.mem_read & ~ei.mem_write) begin
                alu_is_reg_write <= 1;
                reg_alu_out      <= ei.alu_out;
            end else begin
                if (ei.mem_write) begin
                    graphicsi.graphics_instruction       <= 0;
                    graphicsi.graphics_instruction_write <= 1'b0;
                    if (ei.alu_out == GRAPHICS_COMMAND_DATA_ADDRESS || ei.alu_out == GRAPHICS_PIXEL_DATA_ADDRESS) begin
                        graphicsi.graphics_instruction <= {
                            ei.alu_out == GRAPHICS_COMMAND_DATA_ADDRESS ? 1'b1 : 1'b0,
                            ei.memory_write_data
                        };
                        graphicsi.graphics_instruction_write <= 1'b1;
                    end else begin
                        if (byte_en[0]) begin
                            ram[translated_address][0:7] <= byte0_write;
                        end
                        if (byte_en[1]) begin
                            ram[translated_address][8:15] <= byte1_write;
                        end
                        if (byte_en[2]) begin
                            ram[translated_address][16:23] <= byte2_write;
                        end
                        if (byte_en[3]) begin
                            ram[translated_address][24:31] <= byte3_write;
                        end
                    end
                end else if (ei.mem_read) begin
                    reg_raw_word  <= ram[translated_address];
                    reg_memory_op <= ei.memory_operation;
                    reg_mem_read  <= 1;
                    r_byte_offset <= ei.alu_out[1:0];
                end
            end
        end
    end
    always_comb begin
        if (alu_is_reg_write) begin
            o_register_write.write_data = reg_alu_out;
        end else if (reg_mem_read) begin
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
                // load word
                3'b010:
                o_register_write.write_data = {
                    reg_raw_word[7:0],
                    reg_raw_word[15:8],
                    reg_raw_word[23:16],
                    reg_raw_word[31:24]
                };
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
            o_register_write.write_data = 33'b0;
        end
    end
endmodule


`include "../include/execution_interface.svh"
`include "../include/execution_interface.svh"
module memory #(
    parameter SIZE = 2048
) (
    input logic clk,
    execution_if.mem_consumer ei,
    output logic [4:0] o_register_write_index,
    output logic [31:0] o_register_write_data,
    output logic o_register_write
);
    (* ram_style = "distributed" *) logic [31:0] ram[0:SIZE-1];
    wire [31:0] translated_address = ei.alu_out >> 2;

    logic [1:0] r_byte_offset;
    logic alu_is_reg_write;
    logic [31:0] reg_alu_out;
    logic [31:0] reg_raw_word;
    logic [2:0] reg_memory_op;
    logic reg_mem_read;

    wire [7:0] selected_byte =         (r_byte_offset == 2'b00) ? reg_raw_word[7:0]   :
        (r_byte_offset == 2'b01) ? reg_raw_word[15:8]  :
        (r_byte_offset == 2'b10) ? reg_raw_word[23:16] :
                                   reg_raw_word[31:24];
    wire [15:0] selected_half = r_byte_offset[1] ? reg_raw_word[31:16] : reg_raw_word[15:0];

    logic [3:0] byte_en;
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
    always_ff @(posedge clk) begin
        if (ei.invalid) begin
            o_register_write_index <= 0;
            o_register_write       <= 0;
            alu_is_reg_write       <= 0;
            reg_mem_read           <= 0;
        end else begin
            o_register_write       <= ei.reg_write;
            o_register_write_index <= ei.dest;
            alu_is_reg_write       <= 0;
            reg_mem_read           <= 0;
            if (ei.reg_write & ~ei.mem_read & ~ei.mem_write) begin
                alu_is_reg_write <= 1;
                reg_alu_out      <= ei.alu_out;
            end else begin
                if (ei.mem_write) begin
                    for (int i = 0; i < 4; i++) begin
                        if (byte_en[i]) begin
                            ram[translated_address][i*8 +: 8] <= ei.memory_write_data[i*8 +: 8];
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
            o_register_write_data = reg_alu_out;
        end else if (reg_mem_read) begin
            case (reg_memory_op)
                // load byte (signed)
                3'b000:
                o_register_write_data = {{24{selected_byte[7]}}, selected_byte};
                // load half (signed)
                3'b001:
                o_register_write_data = {
                    {16{selected_half[15]}}, selected_half
                };
                // load word
                3'b010: o_register_write_data = reg_raw_word;
                // load byte unsigned
                3'b011: o_register_write_data = {24'b0, selected_byte};
                // load half unsigned
                3'b100: o_register_write_data = {16'b0, selected_half};
                default: o_register_write_data = 32'b0;
            endcase
        end else begin
            o_register_write_data = 32'b0;
        end
    end
endmodule

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
    logic [31:0] translated_address;
    wire [1:0] byte_offset = ei.alu_out[1:0];
    assign translated_address = ei.alu_out >> 2;
    wire [31:0] raw_word = ram[translated_address];
    wire [7:0] selected_byte =
    (byte_offset == 2'b00) ? raw_word[7:0]   :
    (byte_offset == 2'b01) ? raw_word[15:8]  :
    (byte_offset == 2'b10) ? raw_word[23:16] :
                             raw_word[31:24];

    wire [15:0] selected_half = byte_offset[1] ? raw_word[31:16] : raw_word[15:0];
    always_ff @(posedge clk) begin
        if (ei.invalid) begin
            o_register_write_index <= 0;
            o_register_write_data  <= 0;
            o_register_write       <= 0;
        end else begin
            o_register_write       <= ei.reg_write;
            o_register_write_index <= ei.dest;
            if (ei.reg_write & ~ei.mem_read & ~ei.mem_write)
                o_register_write_data <= ei.alu_out;
            else begin
                if (ei.mem_write) begin
                    case (ei.memory_operation)
                        // write byte
                        3'b000:
                        ram[translated_address] <= {
                            (byte_offset[1:0] == 2'b11) ? ei.memory_write_data[7:0] : ram[translated_address][31:24],
                            (byte_offset[1:0] == 2'b10) ? ei.memory_write_data[7:0] : ram[translated_address][23:16],
                            (byte_offset[1:0] == 2'b01) ? ei.memory_write_data[7:0] : ram[translated_address][15:8],
                            (byte_offset[1:0] == 2'b00) ? ei.memory_write_data[7:0] : ram[translated_address][7:0]
                        };

                        // write half
                        3'b001:
                        ram[translated_address] <= {
                            byte_offset[1] ? ei.memory_write_data[15:8]  : ram[translated_address][31:24],
                            byte_offset[1] ? ei.memory_write_data[7:0]   : ram[translated_address][23:16],
                            byte_offset[1] ? ram[translated_address][15:8] : ei.memory_write_data[15:8],
                            byte_offset[1] ? ram[translated_address][7:0]  : ei.memory_write_data[7:0]
                        };
                        // write word
                        3'b010: ram[translated_address] <= ei.memory_write_data;
                    endcase
                end else if (ei.mem_read) begin
                    case (ei.memory_operation)
                        // load byte (signed)
                        3'b000:
                        o_register_write_data <= {
                            {24{selected_byte[7]}}, selected_byte
                        };

                        // load half (signed)
                        3'b001:
                        o_register_write_data <= {
                            {16{selected_half[15]}}, selected_half
                        };

                        // load word
                        3'b010: o_register_write_data <= raw_word;

                        // load byte unsigned
                        3'b011: o_register_write_data <= {24'b0, selected_byte};

                        // load half unsigned 
                        3'b100: o_register_write_data <= {16'b0, selected_half};

                        default: o_register_write_data <= 32'b0;

                    endcase
                end
            end
        end
    end
endmodule

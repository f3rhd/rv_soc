`include "../include/execution_interface.svh"
`include "../include/execution_interface.svh"
/*module memory #(
    parameter SIZE = 2048
) (
    input  logic                            clk,
           execution_if.mem_consumer        ei,
    output logic                     [ 4:0] o_register_write_index,
    output logic                     [31:0] o_register_write_data,
    output logic                            o_register_write
);
    logic [7:0] cells[0:SIZE-1];
    localparam int ADDR_WIDTH = $clog2(SIZE);

    initial begin
        for (int i = 0; i < SIZE; i++) cells[i] = 8'b0;
    end

    // byte address
    wire [ADDR_WIDTH-1:0] addr = ei.alu_out[ADDR_WIDTH-1:0];

    // ── write ────────────────────────────────────────────────────────────────
    always_ff @(posedge clk) begin
        if (!ei.invalid && ei.mem_write) begin
            case (ei.memory_operation)
                3'b000: begin  // SB
                    if (addr < SIZE) cells[addr] <= ei.memory_write_data[7:0];
                end
                3'b001: begin  // SH
                    if (addr < SIZE) cells[addr] <= ei.memory_write_data[7:0];
                    if (addr + 1 < SIZE)
                        cells[addr+1] <= ei.memory_write_data[15:8];
                end
                3'b010: begin  // SW
                    if (addr < SIZE) cells[addr] <= ei.memory_write_data[7:0];
                    if (addr + 1 < SIZE)
                        cells[addr+1] <= ei.memory_write_data[15:8];
                    if (addr + 2 < SIZE)
                        cells[addr+2] <= ei.memory_write_data[23:16];
                    if (addr + 3 < SIZE)
                        cells[addr+3] <= ei.memory_write_data[31:24];
                end
                default: ;
            endcase
        end
    end

    // ── pipeline registers ───────────────────────────────────────────────────
    logic                  reg_mem_read;
    logic                  reg_alu_write;
    logic [           2:0] reg_memory_op;
    logic [ADDR_WIDTH-1:0] reg_addr;
    logic [          31:0] reg_alu_out;

    always_ff @(posedge clk) begin
        o_register_write       <= 0;
        o_register_write_index <= 0;
        reg_mem_read           <= 0;
        reg_alu_write          <= 0;

        if (!ei.invalid) begin
            o_register_write       <= ei.reg_write;
            o_register_write_index <= ei.dest;

            if (ei.mem_read) begin
                reg_mem_read  <= 1;
                reg_memory_op <= ei.memory_operation;
                reg_addr      <= addr;
            end else if (ei.reg_write && !ei.mem_write) begin
                reg_alu_write <= 1;
                reg_alu_out   <= ei.alu_out;
            end
        end
    end

    // ── read (combinational off latched addr) ────────────────────────────────
    logic [31:0] mem_read_data;
    always_comb begin
        case (reg_memory_op)
            3'b000: begin  // LB
                automatic logic [7:0] b = cells[reg_addr];
                mem_read_data = {{24{b[7]}}, b};
            end
            3'b001: begin  // LH
                automatic logic [15:0] h = {cells[reg_addr+1], cells[reg_addr]};
                mem_read_data = {{16{h[15]}}, h};
            end
            3'b010:  // LW
            mem_read_data = {
                cells[reg_addr+3],
                cells[reg_addr+2],
                cells[reg_addr+1],
                cells[reg_addr]
            };
            3'b011:  // LBU
            mem_read_data = {24'b0, cells[reg_addr]};
            3'b100: begin  // LHU
                automatic logic [15:0] h = {cells[reg_addr+1], cells[reg_addr]};
                mem_read_data = {16'b0, h};
            end
            default: mem_read_data = 32'b0;
        endcase
    end

    // ── output mux ───────────────────────────────────────────────────────────
    always_comb begin
        if (reg_alu_write) o_register_write_data = reg_alu_out;
        else if (reg_mem_read) o_register_write_data = mem_read_data;
        else o_register_write_data = 32'b0;
    end

endmodule
*/
module memory #(
    parameter SIZE = 2048
) (
    input logic clk,
    execution_if.mem_consumer ei,
    output logic [4:0] o_register_write_index,
    output logic [31:0] o_register_write_data,
    output logic o_register_write
);
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
                    {16{selected_half[7]}},
                    selected_half[7:0],
                    selected_half[15:8]
                };
                // load word
                3'b010:
                o_register_write_data = {
                    reg_raw_word[7:0],
                    reg_raw_word[15:8],
                    reg_raw_word[23:16],
                    reg_raw_word[31:24]
                };
                // load byte unsigned
                3'b011: o_register_write_data = {24'b0, selected_byte};
                // load half unsigned
                3'b100:
                o_register_write_data = {
                    16'b0, selected_half[7:0], selected_half[15:8]
                };
                default: o_register_write_data = 32'b0;
            endcase
        end else begin
            o_register_write_data = 32'b0;
        end
    end
endmodule

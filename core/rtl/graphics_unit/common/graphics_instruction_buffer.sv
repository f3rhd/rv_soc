/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

module graphics_instruction_buffer #(
    parameter unsigned BUFFER_SIZE = 256 * 4
) (
    input logic clk,
    input logic i_reset,
    input logic [31:0] i_instruction,
    input logic i_instruction_write,
    input logic i_advance_head,
    output logic [31:0] o_instruction,
    output logic o_instruction_is_valid,
    output logic o_buffer_is_full
);
    localparam unsigned INSTRUCTION_BUFFER_BOTTOM_INDEX = BUFFER_SIZE / 4 - 1;


`ifdef VIVADO
    (* ram_style = "block" *)
`elsif QUARTUS
    (* ramstyle = "block" *)
`endif
    logic [31:0] instruction_buffer[0 : INSTRUCTION_BUFFER_BOTTOM_INDEX];

    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] head;
    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] tail;

    logic [31:0] read_entry;
    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX):0] fill_count;

    assign o_instruction = read_entry;
    assign o_buffer_is_full = (fill_count == INSTRUCTION_BUFFER_BOTTOM_INDEX + 1);
    always_ff @(posedge clk) begin
        if (i_reset) begin
            fill_count <= 0;
        end else begin
            case ({
                i_instruction_write & !o_buffer_is_full,
                i_advance_head & (fill_count != 0)
            })
                2'b10:   fill_count <= fill_count + 1;
                2'b01:   fill_count <= fill_count - 1;
                default: fill_count <= fill_count;
            endcase
        end
    end
    always_ff @(posedge clk) begin
        if (i_reset) begin
            head <= 0;
            tail <= 0;
        end else begin
            o_instruction_is_valid <= (fill_count != 0);
            read_entry             <= instruction_buffer[head];
            if (i_advance_head) begin
                head                   <= head + 1;
                o_instruction_is_valid <= 0;
            end
            if (i_instruction_write & !o_buffer_is_full) begin : write
                instruction_buffer[tail] <= i_instruction;
                tail                     <= tail + 1'b1;
            end
        end
    end

endmodule

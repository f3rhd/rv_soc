module graphics_instruction_buffer #(
    parameter unsigned BUFFER_SIZE = 256 * 4
) (
    input logic clk,
    input logic i_reset,
    input logic [32:0] i_instruction,
    input logic i_instruction_write,
    input logic i_advance_head,
    output logic [32:0] o_instruction,
    output logic o_instruction_is_valid,
    output logic o_buffer_is_full
);
    localparam unsigned INSTRUCTION_BUFFER_BOTTOM_INDEX = BUFFER_SIZE / 4 - 1;


    (* ram_style = "block" *)
    logic [32:0] instruction_buffer[0 : INSTRUCTION_BUFFER_BOTTOM_INDEX];

    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] head;
    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] tail;
    logic [INSTRUCTION_BUFFER_BOTTOM_INDEX:0] entry_valid_vector;
    logic [32:0] read_entry;
    logic instruction_is_valid;

    assign o_instruction          = read_entry;
    assign o_instruction_is_valid = instruction_is_valid;
    //  THIS WORKS WHEN BUFFER SIZE IS POWER OF 2
    assign o_buffer_is_full       = tail + 1'b1 == head & !i_advance_head;

    always_ff @(posedge clk) begin
        if (i_reset) begin
            head                 <= 0;
            tail                 <= 0;
            read_entry           <= 0;
            entry_valid_vector   <= 0;
            instruction_is_valid <= 0;
        end else begin

            read_entry           <= instruction_buffer[head];

            instruction_is_valid <= entry_valid_vector[head];

            if (i_advance_head) begin
                entry_valid_vector[head] <= 0;
                head                     <= head + 1;
                instruction_is_valid     <= 0;
                read_entry               <= '0;
            end

            if (i_instruction_write) begin : write
                if (o_buffer_is_full) begin
                end else begin
                    instruction_buffer[tail] <= i_instruction;
                    entry_valid_vector[tail] <= 1'b1;
                    tail                     <= tail + 1'b1;
                end
            end
        end
    end

endmodule

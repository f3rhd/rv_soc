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
    output logic o_write_fail
);
    localparam unsigned INSTRUCTION_BUFFER_BOTTOM_INDEX = BUFFER_SIZE / 4 - 1;


    (* ram_style = "block" *)
    logic [32:0] instruction_buffer[0 : INSTRUCTION_BUFFER_BOTTOM_INDEX];

    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] head;
    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] fetch_index;
    logic [$clog2(INSTRUCTION_BUFFER_BOTTOM_INDEX + 1) - 1:0] tail;
    logic [INSTRUCTION_BUFFER_BOTTOM_INDEX:0] next_valid_vector;
    logic [INSTRUCTION_BUFFER_BOTTOM_INDEX:0] entry_valid_vector;
    logic [32:0] read_entry;
    logic instruction_is_valid;

    //  THIS WORKS WHEN BUFFER SIZE IS POWER OF 2
    assign buffer_is_full = {tail + 1'b1} == head;
    assign fetch_index    = i_advance_head ? head + 1 : head;

    always_comb begin
        next_valid_vector = entry_valid_vector;
        if (i_advance_head) begin
            next_valid_vector = next_valid_vector & ~({{INSTRUCTION_BUFFER_BOTTOM_INDEX{1'b0}},1'b1} << head);
        end
        if (i_instruction_write & !(buffer_is_full && !i_advance_head)) begin
            next_valid_vector = next_valid_vector | {{INSTRUCTION_BUFFER_BOTTOM_INDEX{1'b0}},1'b1} << tail;
        end
    end
    always_ff @(posedge clk) begin
        if (i_reset) begin
            head                 <= 0;
            tail                 <= 0;
            read_entry           <= 0;
            entry_valid_vector   <= 0;
            instruction_is_valid <= 0;
            o_write_fail         <= 0;
        end else begin

            read_entry <= instruction_buffer[fetch_index];

            instruction_is_valid <= |{
                entry_valid_vector & ({{INSTRUCTION_BUFFER_BOTTOM_INDEX{1'b0}},1'b1} << ((i_advance_head) ? head + 1 :  head))
            };

            // in a cycle where i_advance_head is 1 we are going to fetch from head + 1 anyways so for the next cycle we are setting head to head + 2 
            if (i_advance_head) begin
                head <= head + 2;
            end

            if (i_instruction_write) begin : write
                if (buffer_is_full && !i_advance_head) begin
                end else begin
                    instruction_buffer[tail] <= i_instruction;
                    tail                     <= tail + 1'b1;
                end
            end
            entry_valid_vector <= next_valid_vector;
            o_write_fail       <= buffer_is_full & !i_advance_head;
        end
    end
    assign o_instruction          = read_entry;
    assign o_instruction_is_valid = instruction_is_valid;

endmodule

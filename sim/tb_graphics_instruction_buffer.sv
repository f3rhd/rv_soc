`timescale 1ns / 1ps
module tb_graphics_instruction_buffer;

    logic clk = 0;
    logic i_reset = 1;
    logic [32:0] i_instruction;
    logic i_instruction_write = 0;
    logic i_advance_head = 0;
    logic [32:0] o_instruction;
    logic o_instruction_is_valid;
    logic o_write_fail;
    logic [1:0] head;
    logic [1:0] tail;

    always #5 clk = ~clk;

    graphics_instruction_buffer #(
        .BUFFER_SIZE(4 * 4)
    ) graphics_instruction_buffer (
        .clk                   (clk),
        .i_reset               (i_reset),
        .i_instruction         (i_instruction),
        .i_instruction_write   (i_instruction_write),
        .i_advance_head        (i_advance_head),
        .o_instruction         (o_instruction),
        .o_instruction_is_valid(o_instruction_is_valid),
        .o_write_fail          (o_write_fail)
    );
    assign head = graphics_instruction_buffer.head;
    assign tail = graphics_instruction_buffer.tail;
    initial begin
        repeat (2) @(posedge clk);
        #1 i_reset = 0;

        i_instruction_write = 1;
        i_instruction       = {1'b1, 32'h316942};
        @(posedge clk);

        #1
        assert(graphics_instruction_buffer.instruction_buffer[0] == i_instruction);
        i_instruction = {1'b0, 32'h693142};
        @(posedge clk);


        #1
        assert(graphics_instruction_buffer.instruction_buffer[1] == i_instruction);
        i_instruction = {1'b1, 32'h426931};
        @(posedge clk);

        #1
        assert(graphics_instruction_buffer.instruction_buffer[2] == i_instruction);
        i_instruction  = {1'b1, 32'h313131};
        i_advance_head = 1'b1;
        $stop;
    end
endmodule

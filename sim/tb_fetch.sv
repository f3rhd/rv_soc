`timescale 1ns / 1ps
module tb_fetch;

    logic clk = 0;
    logic i_en = 1;
    logic i_pc_reset = 0;
    logic i_reset = 1;
    logic i_redirect = 0;
    logic [31:0] i_redirect_target = 0;
    logic [31:0] o_instruction_addr;

    logic [31:0] o_instruction_raw;
    logic o_instruction_ready;
    fetch #(
        .SIZE(1024)
    ) uut (
        .clk(clk),
        .i_en(i_en),
        .i_reset(i_pc_reset),
        .i_output_bubble(i_reset),
        .i_redirect(i_redirect),
        .i_redirect_target(i_redirect_target),
        .o_instruction_raw(o_instruction_raw),
        .o_instruction_ready(o_instruction_ready),
        .o_pc(o_instruction_addr)
    );

    always #5 clk = ~clk;

    initial begin
        for (integer i = 0; i < 16; i = i + 1) begin
            uut.memory[i] = i + 1;
        end

        #20 i_reset = 0;
        i_pc_reset = 1;
        #10 i_pc_reset = 0;

        #100;

        i_redirect        = 1;
        i_redirect_target = 32'h0000000a;
        #10 i_redirect = 0;

        #100 $finish;
    end

    always @(posedge clk) begin
        if (o_instruction_ready) begin
            $display(
                "Time %t: Instruction Received: %h, Instruction Address: %h",
                $time, o_instruction_raw, o_instruction_addr);
        end
    end
endmodule

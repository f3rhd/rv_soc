`timescale 1ns / 1ps

module btb_tb;
    parameter SIZE = 128;

    logic clk;
    logic i_reset;
    logic i_write_enable;
    logic i_read_enable;
    logic [1:0] i_write_way;
    logic [31:0] i_branch_addr_write;
    logic [31:0] i_branch_target_write;
    logic [31:0] i_branch_addr_read;
    logic [31:0] o_target_addr;
    logic [1:0] o_way;
    logic o_hit;

    btb #(.SIZE(SIZE)) uut (.*);

    always #5 clk = ~clk;

    task automatic write_entry(logic [1:0] way, logic [31:0] addr,
                               logic [31:0] target);
        i_write_enable        <= 1;
        i_write_way           <= way;
        i_branch_addr_write   <= addr;
        i_branch_target_write <= target;
        @(posedge clk);
        i_write_enable <= 0;
    endtask

    task automatic check_entry(logic [31:0] addr, logic exp_hit,
                               logic [1:0] exp_way, logic [31:0] exp_target);
        i_read_enable      <= 1;
        i_branch_addr_read <= addr;
        @(posedge clk);
        i_read_enable <= 0;
        #1;  // Allow BRAM output and always_comb to settle

        if (o_hit !== exp_hit)
            $error(
                "MISMATCH: Hit expected %b, got %b at addr %h",
                exp_hit,
                o_hit,
                addr
            );

        if (exp_hit) begin
            if (o_way !== exp_way)
                $error("MISMATCH: Way expected %d, got %d", exp_way, o_way);
            if (o_target_addr !== exp_target)
                $error(
                    "MISMATCH: Target expected %h, got %h",
                    exp_target,
                    o_target_addr
                );
        end
    endtask

    initial begin
        clk                   = 0;
        i_reset               = 1;
        i_write_enable        = 0;
        i_read_enable         = 0;
        i_write_way           = 0;
        i_branch_addr_write   = 0;
        i_branch_target_write = 0;
        i_branch_addr_read    = 0;

        repeat (2) @(posedge clk);
        i_reset = 0;
        @(posedge clk);

        // Test set associativity by writing to different ways in the same set (0x1004)
        write_entry(2'b00, 32'h0000_1004, 32'h0000_2000);
        write_entry(2'b01, 32'h0000_1004, 32'h0000_3000);
        write_entry(2'b11, 32'h0000_1004, 32'h0000_4000);

        // Write to a completely different set
        write_entry(2'b00, 32'h0000_2008, 32'h0000_5000);

        repeat (2) @(posedge clk);

        // Verify the aliased ways (Note: your hardware design returns the last matching way found in the loop)
        check_entry(32'h0000_1004, 1'b1, 2'b11, 32'h0000_4000);
        check_entry(32'h0000_2008, 1'b1, 2'b00, 32'h0000_5000);

        // Verify a miss
        check_entry(32'h0000_9999, 1'b0, 2'b00, 32'h0000_0000);

        $display("Simulation completely finished successfully!");
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module tb_predictor;

    parameter HISTORY_SIZE = 10;
    parameter CLK_PERIOD = 10;

    logic                    clk;
    logic [            31:0] i_branch_addr;
    logic                    i_branch_result;
    logic [HISTORY_SIZE-1:0] i_pht_index;
    logic                    i_predict;
    logic                    i_update;
    logic                    o_prediction;
    logic [HISTORY_SIZE-1:0] o_pht_index;

    predictor #(
        .HISTORY_SIZE(HISTORY_SIZE)
    ) dut (
        .clk(clk),
        .i_branch_addr(i_branch_addr),
        .i_branch_result(i_branch_result),
        .i_pht_index(i_pht_index),
        .i_predict(i_predict),
        .i_update(i_update),
        .o_prediction(o_prediction),
        .o_pht_index(o_pht_index)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    logic [HISTORY_SIZE-1:0] index_pipeline[$];

    initial begin
        i_branch_addr   = 0;
        i_branch_result = 0;
        i_pht_index     = 0;
        i_predict       = 0;
        i_update        = 0;

        @(posedge clk);
        #(1);

        $display("==================================================");
        $display("Starting Gshare Branch Predictor Testbench");
        $display("==================================================");

        $display("\n[Test 1] Training Branch at 0x0040_00AC to be TAKEN...");

        repeat (4) begin
            i_branch_addr = 32'h0040_00AC;
            i_predict     = 1'b1;
            i_update      = 1'b0;

            @(posedge clk);
            #1;

            $display("Fetch: Addr=0x%h | Pred=%b | Saved Index=%d",
                     i_branch_addr, o_prediction, o_pht_index);

            index_pipeline.push_back(o_pht_index);

            i_predict       = 1'b0;
            i_update        = 1'b1;
            i_pht_index     = index_pipeline.pop_front();
            i_branch_result = 1'b1;

            @(posedge clk);
            #1;
            i_update = 1'b0;
        end

        $display("\n[Test 2] Verifying prediction for 0x0040_00AC...");
        i_branch_addr = 32'h0040_00AC;
        i_predict     = 1'b1;

        @(posedge clk);
        #(1);
        $display("Result: Addr=0x%h | Pred=%b (Expected: 1)", i_branch_addr,
                 o_prediction);
        i_predict = 1'b0;

        $display(
            "\n[Test 3] Testing a different branch address 0x0040_1234...");
        i_branch_addr = 32'h0040_1234;
        i_predict     = 1'b1;

        @(posedge clk);
        #(1);
        $display("Result: Addr=0x%h | Pred=%b | Index Generated=%d",
                 i_branch_addr, o_prediction, o_pht_index);
        i_predict = 1'b0;

        $display("\n[Test 4] Alternating outcomes for Addr 0x0040_FFFF...");
        i_branch_addr = 32'h0040_FFFF;

        for (int i = 0; i < 3; i++) begin
            i_predict = 1'b1;
            @(posedge clk);
            #(1);
            index_pipeline.push_back(o_pht_index);
            i_predict       = 1'b0;

            i_update        = 1'b1;
            i_pht_index     = index_pipeline.pop_front();
            i_branch_result = (i % 2 == 0) ? 1'b0 : 1'b1;

            @(posedge clk);
            #(1);
            $display(
                "Cycle %0d: Actual Outcome=%b | Next Global History Shifted",
                i, i_branch_result);
            i_update = 1'b0;
        end

        $display("\n==================================================");
        $display("Simulation Finished Successfully!");
        $display("==================================================");
        $finish;
    end

endmodule

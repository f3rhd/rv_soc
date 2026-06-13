`timescale 1ns / 1ps
`include "../include/execution_interface.svh"
module tb_frontend;

    execution_if #(.HISTORY_SIZE(10)) exi ();
    // fetch signals
    logic clk = 0;
    logic fetch_reset;
    logic [31:0] predictor_redirect_target;
    logic predictor_redirect;
    logic [1:0] btb_hit_way;
    logic btb_hit;
    logic [31:0] fetch_instruction_raw;
    logic [31:0] fetch_instruction_addr;
    logic fetch_instruction_valid;

    // predictor signals
    logic predictor_reset;
    logic predictor_prediction;
    logic [9:0] predictor_pht_index;
    logic [31:0] prediction_stage_instruction_addr;
    logic [31:0] prediction_stage_instruction_raw;
    logic [1:0] predictor_btb_hit_way;
    logic predictor_btb_hit;
    logic [31:0] prediction_instruction_raw;
    logic [31:0] prediction_instruction_addr;

    fetch #(
        .I_CACHE_SIZE(1024),
        .BTB_SIZE(128)
    ) fetch (
        .clk                        (clk),
        .i_en                       (1),
        .i_reset                    (fetch_reset),
        .i_output_bubble            (0),
        .i_predictor_redirect_target(predictor_redirect_target),
        .i_predictor_redirect       (predictor_redirect),
        .exi                        (exi),
        .o_instruction_raw          (fetch_instruction_raw),
        .o_instruction_addr         (fetch_instruction_addr),
        .o_instruction_valid        (fetch_instruction_valid),
        .o_btb_hit_way              (btb_hit_way),
        .o_btb_hit                  (btb_hit)
    );

    prediction #(
        .HISTORY_SIZE(10)
    ) prediction (
        .clk                      (clk),
        .i_reset                  (predictor_reset),
        .i_en                     (1),
        .i_output_bubble          (0),
        .i_predict                (btb_hit & fetch_instruction_valid),
        .i_btb_hit                (btb_hit),
        .i_btb_hit_way            (btb_hit_way),
        .i_instruction_raw        (fetch_instruction_raw),
        .i_instruction_addr       (fetch_instruction_addr),
        .exi                      (exi),
        .o_prediction             (predictor_prediction),
        .o_pht_index              (predictor_pht_index),
        .o_btb_hit                (predictor_btb_hit),
        .o_btb_hit_way            (predictor_btb_hit_way),
        .o_predictor_redirect     (predictor_redirect),
        .o_predictor_redirect_addr(predictor_redirect_target),
        .o_instruction_raw        (prediction_instruction_raw),
        .o_instruction_addr       (prediction_instruction_addr)
    );


    always_comb begin
        if (predictor_redirect) begin
            $display("Predictor disagreed with btb. Redirecting Pc to addr:%h",
                     predictor_redirect_target);
        end
    end
    always #5 clk = ~clk;
    initial begin
        // Initialize memory with NOPs
        for (int i = 0; i < (fetch.I_CACHE_SIZE / 4); i++) begin
            fetch.memory[i] = 32'h0000_0013;  // ADDI x0, x0, 0  (canonical NOP)
        end

        fetch.memory[0] = 32'h06400113;  // addi x2,x0,100
        fetch.memory[1] = 32'h00108093;  // addi x1,x1,1
        fetch.memory[2] = 32'hfe208ee3;  // bne x1,x2,-4

        fetch_reset     = 1'b1;
        predictor_reset = 1'b1;
        repeat (2) @(posedge clk);
        #1;
        fetch_reset     = 1'b0;
        predictor_reset = 1'b0;

        $monitor("Fetch.Instruction Addr : %h", fetch_instruction_addr);
        $monitor("Fetch.BTB hit: %b", btb_hit);
        $monitor("Fetch.Valid: %b", fetch_instruction_valid);

        exi.btb_write               = 0;
        exi.branch_instruction_addr = 0;
        exi.branch_addr_way         = 0;
        exi.predictor_update        = 0;
        exi.redirect                = 0;
        exi.redirection_address     = 0;
        exi.actual_branch_result    = 0;

        repeat (5) @(posedge clk);

        @(posedge clk);
        #1 exi.btb_write = 1'b1;
        exi.branch_instruction_addr = 8;
        exi.branch_addr_way         = 0;
        exi.predictor_update        = 1'b1;
        exi.redirect                = 1;
        exi.redirection_address     = 0;
        exi.actual_branch_result    = 1;
        exi.pht_index               = 8 ^ 0;

        @(posedge clk);
        #1 exi.btb_write = 1'b0;
        exi.predictor_update = 1'b0;
        exi.redirect         = 0;


        repeat (10) @(posedge clk);

        $finish;
    end

endmodule


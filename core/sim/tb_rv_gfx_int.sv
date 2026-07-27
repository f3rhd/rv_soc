/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "../include/graphics_interface.svh"
`include "../include/bootloader_interface.svh"


`define LOG_ENABLED 

module tb_rv_gfx_int;

    logic clk = 0;
    logic reset = 0;
    logic print = 1;


    int   soc_log_file;
    int   graphics_dispatch_log_file;
    int   graphics_instr_complete_file;

    bootloader_if bootloader_if ();
    graphics_if graphics_if ();

    rv_processor #(
        .HISTORY_SIZE(8  /* default 10 */),
        .I_CACHE_SIZE(1024 * 32  /* default 1024 */),
        .D_CACHE_SIZE(1024 * 32  /* default 1 << 10 */),
        .BTB_SIZE    (32  /* default 128 */)
    ) rv_processor (
        .clk          (clk),
        .reset        (reset),
        .bootloader_if(bootloader_if),
        .graphics_if  (graphics_if)
    );

    graphics_unit #(
        .GRAPHICS_INSTRUCTION_BUFFER_SIZE(8192 / 8 * 4  /* default 256 * 4 */),
        .SYSTEM_CLK_HZ(100_000_000  /* default 100_000_000 */),
        .SPI_CLK_HZ(25_000_000  /* default 25_000_000 */)
    ) graphics_unit (
        .clk        (clk),
        .i_reset    (reset),
        .graphics_if(graphics_if)
    );

    always #5 clk = ~clk;

    always_ff @(posedge clk) begin
`ifdef LOG_ENABLED
        if (soc_log_file) begin

            if (rv_processor.register_write_.write_enable && rv_processor.register_write_.write_addr != 0) begin
                $fdisplay(soc_log_file,
                          "[Time: \%0t] Register File[\%d] <- 0x\%h", $time,
                          rv_processor.register_write_.write_addr,
                          rv_processor.register_write_.write_data);
            end


            if (rv_processor.memory.ei.mem_write) begin
                $fdisplay(soc_log_file, "[Time: \%0t] DCache[0x\%h] <- \%h",
                          $time, rv_processor.memory.ei.alu_out,
                          rv_processor.memory.ei.memory_write_data);
            end


            if (rv_processor.memory.ei.mem_read) begin
                $fdisplay(soc_log_file, "[Time: \%0t] Reading DCache[0x\%h]",
                          $time, rv_processor.memory.ei.alu_out);
            end


            if (rv_processor.stage_controller_stall_vector != 0) begin
                $fdisplay(soc_log_file, "[Time: \%0t] Stall vector : \%b",
                          $time, rv_processor.stage_controller_stall_vector);
            end


            if (rv_processor.memory_graphics_write) begin
                if (graphics_if.graphics_buffer_full) begin
                    $fdisplay(soc_log_file,
                              "[Time: %0t] GFX instruction write failed",
                              $time);
                end else begin
                    $fdisplay(soc_log_file,
                              "[Time: %0t] GFX instruction write success",
                              $time);
                    $fdisplay(
                        graphics_dispatch_log_file, "DCache[0x\%h] <- \%h",
                        graphics_if.graphics_instruction[32] ? 'hf0000004 : 'hf0000000,
                        graphics_if.graphics_instruction[31:0]);
                end
            end


            if (rv_processor.stage_controller_flush_vector != 0) begin
                $fdisplay(soc_log_file, "[Time: \%0t] Flush vector : \%b",
                          $time, rv_processor.stage_controller_flush_vector);
            end


            if (rv_processor.prediction_redirect & rv_processor.prediction_enable) begin
                $fdisplay(
                    soc_log_file,
                    "[Time: %0t] Predictor redirected pc due to disagreement with fetch unit 0x%h",
                    $time, rv_processor.prediction_redirect_target);
            end


            if (rv_processor.execution_if.predictor_update) begin
                $fdisplay(soc_log_file, "[Time: \%0t] PHT[\%d] <~ \%d", $time,
                          rv_processor.execution_if.pht_index,
                          rv_processor.execution_if.actual_branch_result);
            end


            if (rv_processor.execution_if.btb_write) begin
                $fdisplay(
                    soc_log_file,
                    "[Time: %0t] BranchTableBank[0x%h][0x%h] <- instruction_addr : 0x%h | target_addr : 0x%h | is_jump : 0x%h",
                    $time, rv_processor.fetch.btb.write_set_id,
                    rv_processor.fetch.btb.set_allocation_counter[rv_processor.fetch.btb.write_set_id],
                    rv_processor.execution_if.branch_instruction_addr * 4,
                    rv_processor.execution_if.btb_branch_target_addr * 4,
                    rv_processor.execution_if.btb_write_jump);
            end


            if (rv_processor.execution_if.redirect) begin
                $fdisplay(
                    soc_log_file,
                    "[Time: %0t] Execution stage redirected pc to the address 0x%h",
                    $time, rv_processor.execution_if.redirection_address * 4);
            end


            if (rv_processor.fetch_btb_hit & rv_processor.fetch_instruction_valid) begin
                if (print) begin
                    $fdisplay(
                        soc_log_file,
                        "[Time: %0t] Instruction[0x%h] hit btb. | Redirected to : 0x%h",
                        $time, rv_processor.fetch_instruction_addr * 4,
                        rv_processor.fetch.btb_target_addr * 4);
                end
                if (rv_processor.fetch_instruction_addr == 2) begin
                    print <= 0;
                end
            end


            if (graphics_unit.execute_complete) begin
                $fdisplay(soc_log_file,
                          "[Time: \%0t] Graphics Instruction : 0x\%h complete",
                          $time,
                          graphics_unit.graphics_execute.r_decode.instruction);

                $fdisplay(graphics_instr_complete_file,
                          "Graphics Instruction : 0x\%h complete",
                          graphics_unit.graphics_execute.r_decode.instruction);

            end
        end
`endif
    end

    initial begin

        soc_log_file = $fopen("simulate.log", "w");
        graphics_dispatch_log_file = $fopen("graphics_only.log", "w");
        graphics_instr_complete_file =
            $fopen("graphics_instr_success.log", "w");

        if (!soc_log_file) begin
            $display("ERROR: Could not open simulate.log for writing!");
            $finish;
        end
        if (!graphics_dispatch_log_file) begin
            $display("ERROR: Could not open graphics_only.log for writing!");
            $finish;
        end

        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/program_tests/c/circle.hex",
            rv_processor.fetch.instructions);

        reset = 1;

        repeat (2) @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #2;
        graphics_unit.graphics_execute.graphics_state = graphics_unit.graphics_execute.EXECUTE;
        graphics_unit.graphics_execute.exec_state = graphics_unit.graphics_execute.EXEC_KIND_DO_NOTHING;
        rv_processor.fetch.state = rv_processor.fetch.FETCH;
        rv_processor.fetch.instruction_count = 32'hFFFFFFFF;
        #1;


        //$fclose(soc_log_file);
        $stop;
    end
endmodule

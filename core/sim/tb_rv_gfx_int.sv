/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "../include/graphics_interface.svh"
`include "../include/bootloader_interface.svh"
module tb_rv_gfx_int;


    logic clk = 0;
    logic reset = 0;
    logic print = 1;
    bootloader_if bootloader_if ();
    graphics_if graphics_if ();
    rv_processor #(
        .HISTORY_SIZE(10  /* default 10 */),
        .I_CACHE_SIZE(1024 * 16  /* default 1024 */),
        .D_CACHE_SIZE(1024 * 32  /* default 1 << 10 */),
        .BTB_SIZE    (64  /* default 128 */)
    ) rv_processor (
        .clk          (clk),
        .reset        (reset),
        .bootloader_if(bootloader_if),
        .graphics_if  (graphics_if)
    );
    graphics_unit #(
        .GRAPHICS_INSTRUCTION_BUFFER_SIZE(10240 * 100 * 4  /* default 256 * 4 */),
        .SYSTEM_CLK_HZ(100_000_000  /* default 100_000_000 */),
        .SPI_CLK_HZ(50_000_000  /* default 25_000_000 */)
    ) graphics_unit (
        .clk        (clk),
        .i_reset    (reset),
        .graphics_if(graphics_if)
    );

    always #5 clk = ~clk;
    always_ff @(posedge clk) begin
        if (rv_processor.register_write_.write_enable && rv_processor.register_write_.write_addr != 0)begin
            $display("[Time: %0t] Register File[%d] <- 0x%h", $time,
                     rv_processor.register_write_.write_addr,
                     rv_processor.register_write_.write_data);
            $fflush();
        end
        if (rv_processor.memory.ei.mem_write) begin
            $display("[Time: %0t] DCache[0x%h] <- %h", $time,
                     rv_processor.memory.ei.alu_out,
                     rv_processor.memory.ei.memory_write_data);
            $fflush();
        end
        if (rv_processor.memory.ei.mem_read) begin
            $display("[Time: %0t] Reading DCache[0x%h]", $time,
                     rv_processor.memory.ei.alu_out);
            $fflush();
        end
        if (rv_processor.stage_controller_stall_vector != 0) begin
            $display("[Time: %0t] Stall vector : %b", $time,
                     rv_processor.stage_controller_stall_vector);
            $fflush();
        end
        if(rv_processor.memory.ei.mem_write & (rv_processor.memory.ei.alu_out == 32'hFFFFFFFF || rv_processor.memory.ei.alu_out == 32'hFFFFFFF0)) begin
            if (graphics_if.graphics_buffer_full) begin
                $display("[Time: %0t] GFX instruction write failed", $time);
            end else begin
                $display("[Time: %0t] GFX instruction write success", $time);
            end
            $fflush();
        end
        if (rv_processor.stage_controller_flush_vector != 0) begin
            $display("[Time: %0t] Flush vector : %b", $time,
                     rv_processor.stage_controller_flush_vector);
            $fflush();
        end
        if (rv_processor.prediction_redirect & rv_processor.prediction_enable) begin
            $display(
                "[Time: %0t] Predictor redirected pc to due to dissagrement with fetch unit 0x%h",
                $time, rv_processor.prediction_redirect_target);
            $fflush();
        end
        if (rv_processor.execution_if.predictor_update) begin
            $display("[Time: %0t] PHT[%d] <~ %d", $time,
                     rv_processor.execution_if.pht_index,
                     rv_processor.execution_if.actual_branch_result);
            $fflush();
        end
        if (rv_processor.execution_if.btb_write) begin
            $display(
                "[Time: %0t] BranchTableBank[0x%h][0x%h] <- instruction_addr : 0x%h | target_addr : 0x%h | is_jump : 0x%h",
                $time, rv_processor.fetch.btb.write_set_id,
                rv_processor.fetch.btb.set_allocation_counter[rv_processor.fetch.btb.write_set_id],
                rv_processor.execution_if.branch_instruction_addr * 4,
                rv_processor.execution_if.btb_branch_target_addr * 4,
                rv_processor.execution_if.btb_write_jump);
            $fflush();
        end
        if (rv_processor.execution_if.redirect) begin
            $display(
                "[Time: %0t] Execution stage redirected pc to the address 0x%h",
                $time, rv_processor.execution_if.redirection_address * 4);
            $fflush();
        end
        if (rv_processor.fetch_btb_hit & rv_processor.fetch_instruction_valid) begin
            if (print) begin
                $display(
                    "[Time: %0t] Instruction[0x%h] hit btb. | Redirected to : 0x%h",
                    $time, rv_processor.fetch_instruction_addr * 4,
                    rv_processor.fetch.btb_target_addr * 4);
                if (rv_processor.fetch_instruction_addr == 'd191) begin
                    $display("oybla");
                end
                $fflush();
            end
            if (rv_processor.fetch_instruction_addr == 2) begin
                print <= 0;
            end
        end
        if (graphics_unit.execute_complete) begin
            $display("Graphics Instruction : 0x%h complete",
                     graphics_unit.graphics_execute.r_decode.instruction);
        end
        if (rv_processor.execution_if.branch_instruction_addr == 'd188) begin
            $display("oyblaaaaa");
        end

    end
    initial begin
        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/program_tests/c/dvd.hex",
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
        $stop;
    end
endmodule

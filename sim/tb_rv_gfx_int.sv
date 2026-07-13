`include "../include/graphics_interface.svh"
`include "../include/bootloader_interface.svh"
module tb_rv_gfx_int;


    logic clk = 0;
    logic reset = 0;
    bootloader_if bootloader_if ();
    graphics_if graphics_if ();
    rv_processor #(
        .HISTORY_SIZE(10  /* default 10 */),
        .I_CACHE_SIZE(1024  /* default 1024 */),
        .D_CACHE_SIZE(1 << 10  /* default 1 << 10 */),
        .BTB_SIZE    (16  /* default 128 */)
    ) rv_processor (
        .clk          (clk),
        .reset        (reset),
        .bootloader_if(bootloader_if),
        .graphics_if  (graphics_if)
    );
    graphics_unit #(
        .GRAPHICS_INSTRUCTION_BUFFER_SIZE(64 * 4  /* default 256 * 4 */),
        .SYSTEM_CLK_HZ(100_000_000  /* default 100_000_000 */),
        .SPI_CLK_HZ(50_000_000  /* default 25_000_000 */)
    ) graphics_unit (
        .clk        (clk),
        .i_reset    (reset),
        .graphics_if(graphics_if)
    );

    always #5 clk = ~clk;
    always_ff @(posedge clk) begin
        if (rv_processor.register_write_.write_enable && rv_processor.register_write_.write_addr != 0)
            $display(
                "[Time: %0t] Register File[%d] <- 0x%h",
                $time,
                rv_processor.register_write_.write_addr,
                rv_processor.register_write_.write_data
            );
        if (rv_processor.memory.ei.mem_write) begin
            $display("[Time: %0t] DCache[0x%h] <- %h", $time,
                     rv_processor.memory.ei.alu_out,
                     rv_processor.memory.ei.memory_write_data);
        end
        if (rv_processor.memory.ei.mem_read) begin
            $display("[Time: %0t] Reading DCache[%d]", $time,
                     rv_processor.memory.ei.alu_out);
        end
        if (rv_processor.stage_controller_stall_vector != 0) begin
            $display("[Time: %0t] Stall vector : %b", $time,
                     rv_processor.stage_controller_stall_vector);
        end
        if(graphics_if.graphics_buffer_full & rv_processor.memory.ei.mem_write) begin
            $display("[Time: %0t] GFX instruction write failed", $time);
        end
        if (rv_processor.stage_controller_flush_vector != 0) begin
            $display("[Time: %0t] Flush vector : %b", $time,
                     rv_processor.stage_controller_flush_vector);
        end
        if (rv_processor.prediction_redirect & rv_processor.prediction_enable) begin
            $display(
                "[Time: %0t] Predictor redirected pc to due to dissagrement with fetch unit 0x%h",
                $time, rv_processor.prediction_redirect_target);
        end
        if (rv_processor.execution_if.predictor_update) begin
            $display("[Time: %0t] PHT[%d] <~ %d", $time,
                     rv_processor.execution_if.pht_index,
                     rv_processor.execution_if.actual_branch_result);
        end
        if (rv_processor.execution_if.btb_write) begin
            $display(
                "[Time: %0t] BranchTableBank[%d] <- instruction_addr : 0x%h | target_addr : 0x%h | is_jump : 0x%h",
                $time, rv_processor.execution_if.branch_addr_way,
                rv_processor.execution_if.branch_instruction_addr,
                rv_processor.execution_if.redirection_address,
                rv_processor.execution_if.btb_write_jump);
        end
        if (rv_processor.execution_if.redirect) begin
            $display(
                "[Time: %0t] Execution stage redirected pc to the address 0x%h",
                $time, rv_processor.execution_if.redirection_address);
        end
        if (rv_processor.fetch_btb_hit & rv_processor.fetch_instruction_valid) begin
            $display("[Time: %0t] Instruction[0x%h] hit btb.", $time,
                     rv_processor.fetch_instruction_addr);
        end
        if (rv_processor.register_write_.write_data == 32'hF800F800) begin
            $display("[Time: %0t] AND I SAID OOP", $time);
        end
    end
    initial begin
        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/program_tests/graphics_test.hex",
            rv_processor.fetch.instructions);

        graphics_if.graphics_init_done = 1;
        graphics_unit.graphics_execute.graphics_state = graphics_unit.graphics_execute.EXECUTE;
        reset = 1;
        bootloader_if.program_load_done = 0;
        bootloader_if.instruction = 0;
        bootloader_if.instruction_ready = 0;

        repeat (2) @(posedge clk);
        reset                           = 0;

        bootloader_if.program_load_done = 1;
        bootloader_if.instruction       = 0;
        bootloader_if.instruction_ready = 0;

        @(posedge clk);
        #2;
        bootloader_if.program_load_done = 0;
        $stop;
    end
endmodule

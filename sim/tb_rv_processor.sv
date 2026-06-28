`timescale 1ns / 1ps
`include "../include/bootloader_interface.svh"
`include "../include/graphics_interface.svh"
module tb_rv_processor;
    logic clk = 0;
    logic reset = 0;
    always #5 clk = ~clk;


    localparam HISTORY_SIZE = 10;
    localparam I_CACHE_SIZE = 1024;
    localparam D_CACHE_SIZE = 1 << 10;
    localparam BTB_SIZE = 128;
    bootloader_if bootloader_if ();
    graphics_if graphics_if ();
    rv_processor #(
        .HISTORY_SIZE(HISTORY_SIZE  /* default 10 */),
        .I_CACHE_SIZE(I_CACHE_SIZE  /* default 1024 */),
        .D_CACHE_SIZE(D_CACHE_SIZE  /* default 1 << 16 */),
        .BTB_SIZE    (BTB_SIZE  /* default 128 */)
    ) rv_processor (
        .clk(clk),
        .reset(reset),
        .bootloader_if(bootloader_if),
        .graphics_if(graphics_if)
    );

    always_ff @(posedge clk) begin
        if (rv_processor.register_write_.write_enable && rv_processor.register_write_.write_addr != 0)
            $display(
                "Register File[%d] <- %d",
                rv_processor.register_write_.write_addr,
                rv_processor.register_write_.write_data
            );
        if (rv_processor.memory.ei.mem_write) begin
            $display("DCache[%d] <- %d", rv_processor.memory.ei.alu_out,
                     rv_processor.memory.ei.memory_write_data);
        end
        if (rv_processor.memory.ei.mem_read) begin
            $display("Reading DCache[%d]", rv_processor.memory.ei.alu_out);
        end
        if (rv_processor.stage_controller_stall_vector != 0) begin
            $display("Stall vector : %b",
                     rv_processor.stage_controller_stall_vector);
        end
        if (rv_processor.stage_controller_flush_vector != 0) begin
            $display("Flush vector : %b",
                     rv_processor.stage_controller_flush_vector);
        end
        if (rv_processor.prediction_redirect) begin
            $display(
                "Predictor is redirecting pc to due to dissagrement with fetch unit%d",
                rv_processor.prediction_redirect_target);
        end
        if (rv_processor.execution_if.predictor_update) begin
            $display("PHT[%d] <~ %d", rv_processor.execution_if.pht_index,
                     rv_processor.execution_if.actual_branch_result);
        end
        if (rv_processor.execution_if.btb_write) begin
            $display(
                "BranchTableBank[%d] <- instruction_addr : %h | target_addr : %h | is_jump : %h",
                rv_processor.execution_if.branch_addr_way,
                rv_processor.execution_if.branch_instruction_addr,
                rv_processor.execution_if.redirection_address,
                rv_processor.execution_if.btb_write_jump);
        end
        if (rv_processor.execution_if.redirect) begin
            $display("Execution stage is redirecting pc to address %d",
                     rv_processor.execution_if.redirection_address);
        end
        if (rv_processor.fetch_btb_hit & rv_processor.fetch_instruction_valid) begin
            $display("Instruction[%d] was hit in btb.",
                     rv_processor.fetch_instruction_addr);
        end
    end

    initial begin

        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/program_tests/load_stall_test.hex",
            rv_processor.fetch.instructions);

        graphics_if.graphics_init_done  = 1;
        reset                           = 1;
        bootloader_if.program_load_done = 0;
        bootloader_if.instruction       = 0;
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
/*
add_wave {{/tb_rv_processor/rv_processor/execute/exi/stall_pipeline}} {{/tb_rv_processor/rv_processor/execute/exi/reg_write}} {{/tb_rv_processor/rv_processor/execute/exi/redirection_address}} {{/tb_rv_processor/rv_processor/execute/exi/redirect}} {{/tb_rv_processor/rv_processor/execute/exi/predictor_update}} {{/tb_rv_processor/rv_processor/execute/exi/pht_index}} {{/tb_rv_processor/rv_processor/execute/exi/memory_write_data}} {{/tb_rv_processor/rv_processor/execute/exi/memory_operation}} {{/tb_rv_processor/rv_processor/execute/exi/mem_write}} {{/tb_rv_processor/rv_processor/execute/exi/mem_read}} {{/tb_rv_processor/rv_processor/execute/exi/invalid}} {{/tb_rv_processor/rv_processor/execute/exi/dest}} {{/tb_rv_processor/rv_processor/execute/exi/btb_write}} {{/tb_rv_processor/rv_processor/execute/exi/branch_instruction_addr}} {{/tb_rv_processor/rv_processor/execute/exi/branch_addr_way}} {{/tb_rv_processor/rv_processor/execute/exi/alu_out}} {{/tb_rv_processor/rv_processor/execute/exi/actual_branch_result}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/src2_data}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/src1_data}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/prediction}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/pht_index}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/decode_data}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/btb_way_hit}} {{/tb_rv_processor/rv_processor/decode/pre_exec_if/btb_was_hit}} rv_processor
*/

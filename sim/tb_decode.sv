`timescale 1ns / 1ps
`include "../include/decode_result.svh"
module tb_decode;

    logic clk;
    logic i_enable;
    logic i_output_bubble;
    logic [31:0] i_instruction_addr;
    logic [31:0] i_instruction_raw;
    decode_result_t o_decoded_mop;

    decode uut (
        .clk(clk),
        .i_enable(i_enable),
        .i_output_bubble(i_output_bubble),
        .i_instruction_addr(i_instruction_addr),
        .i_instruction_raw(i_instruction_raw),
        .o_decoded_mop(o_decoded_mop)
    );

    always #10 clk = ~clk;

    task automatic check_decode(
        input logic [31:0] addr, input logic [31:0] raw_inst,
        input logic [6:0] expected_op, input logic expected_reg_write,
        input logic expected_mem_read, input logic expected_mem_write,
        input string test_name);
        begin
            i_instruction_addr = addr;
            i_instruction_raw  = raw_inst;

            @(posedge clk);
            #1;

            assert (o_decoded_mop.operation == expected_op)
            else
                $error(
                    "%s FAILED: Expected OP %b, got %b",
                    test_name,
                    expected_op,
                    o_decoded_mop.operation
                );

            assert (o_decoded_mop.reg_write == expected_reg_write)
            else
                $error(
                    "%s FAILED: Expected reg_write %b, got %b",
                    test_name,
                    expected_reg_write,
                    o_decoded_mop.reg_write
                );

            assert (o_decoded_mop.mem_read == expected_mem_read)
            else
                $error(
                    "%s FAILED: Expected mem_read %b, got %b",
                    test_name,
                    expected_mem_read,
                    o_decoded_mop.mem_read
                );

            assert (o_decoded_mop.mem_write == expected_mem_write)
            else
                $error(
                    "%s FAILED: Expected mem_write %b, got %b",
                    test_name,
                    expected_mem_write,
                    o_decoded_mop.mem_write
                );
        end
    endtask

    initial begin
        clk                = 0;
        i_enable           = 0;
        i_output_bubble    = 0;
        i_instruction_addr = 32'h0;
        i_instruction_raw  = 32'h0;

        #20;
        i_enable = 1'b1;

        $display("--- Starting Decode Module Testbench --- ");

        // ADD Instruction (R-type) 
        // add x10, x11, x12 -> rs1=11, rs2=12, rd=10, funct3=0, funct7=0
        // Raw: 32'b0000000_01100_01011_000_01010_0110011 -> 32'h00C58533
        check_decode(.addr(32'h1000), .raw_inst(32'h00C58533),
                     .expected_op(7'b00_00001),  // add
                     .expected_reg_write(1'b1), .expected_mem_read(1'b0),
                     .expected_mem_write(1'b0), .test_name("ADD_R_TYPE"));

        // ADDI Instruction (I-type) 
        // addi x5, x6, 10 -> rs1=6, rd=5, imm=10, funct3=0
        // Raw: 32'b000000001010_00110_000_00101_0010011 -> 32'h00A30293
        check_decode(.addr(32'h1004), .raw_inst(32'h00A30293),
                     .expected_op(7'b00_00001),  // addi (uses base add op)
                     .expected_reg_write(1'b1), .expected_mem_read(1'b0),
                     .expected_mem_write(1'b0), .test_name("ADDI_I_TYPE"));

        // BEQ Instruction (B-type) 
        // beq x1, x2, offset -> rs1=1, rs2=2, funct3=0
        // Raw: 32'h00208463
        check_decode(.addr(32'h1008), .raw_inst(32'h00208463),
                     .expected_op(7'b01_00_001),  // branch if equal
                     .expected_reg_write(1'b0), .expected_mem_read(1'b0),
                     .expected_mem_write(1'b0), .test_name("BEQ_BRANCH"));

        // LW Instruction (Load Word) 
        // lw x15, 8(x16) -> rs1=16, rd=15, funct3=2, opcode=7'b0000011
        // Raw: 32'h00882783
        check_decode(.addr(32'h100C), .raw_inst(32'h00882783),
                     .expected_op(7'b10_01_010),  // load word
                     .expected_reg_write(1'b1), .expected_mem_read(1'b1),
                     .expected_mem_write(1'b0), .test_name("LW_LOAD"));

        // SW Instruction (Store word)
        // sw x14, 4(x13) -> rs1=13, rs2=14, funct3=2, opcode=7'b0100011
        check_decode(.addr(32'h1010), .raw_inst(32'h00E6E223),
                     .expected_op(7'b10_00_010),  // store word
                     .expected_reg_write(1'b0), .expected_mem_read(1'b0),
                     .expected_mem_write(1'b1), .test_name("SW_STORE"));

        //  Pipeline Bubble Behavior 
        $display("Testing Pipeline Bubble Behavior...");
        i_output_bubble = 1'b1;
        @(posedge clk);
        #1;
        assert (o_decoded_mop.invalid == 1'b1)
        else
            $error(
                "BUBBLE_TEST FAILED: Output should be marked invalid during bubble."
            );

        i_output_bubble = 1'b0;

        //  Pipeline Disable Behavior 
        $display("Testing Stage Enable Disable...");
        i_enable          = 1'b0;
        i_instruction_raw = 32'h00C58533;
        @(posedge clk);
        #1;
        // Output shouldn't have updated because i_enable was low
        assert (o_decoded_mop.operation != 7'b00_00001)
        else
            $error(
                "ENABLE_TEST FAILED: Decoder updated values even when i_enable was low!"
            );

        $display("--- Testbench Execution Completed ---");
        $finish;
    end

endmodule

/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`ifndef EXECUTION_INTERFACE_SVH
`define EXECUTION_INTERFACE_SVH
interface execution_if #(parameter HISTORY_SIZE = 10);

    /*
    as the name suggests
    */
    logic [31:0] memory_write_data;
    /*
    read/write mode
    */
    logic [2:0] memory_operation;
    /*
    this field may have values of calculated addresses for memory access/write or  
    calculated values of the destination resgister
    */
    logic [31:0] alu_out;
    /*
    index of the destination register
    */
    logic [4:0] dest;

    logic redirect;
    logic actual_branch_result;
    logic predictor_update;
    logic [31:0] redirection_address;
    logic [31:0] branch_instruction_addr;
    logic [31:0] btb_branch_target_addr;
    logic [HISTORY_SIZE-1:0] pht_index;
    logic btb_write_jump;

    /*
    control bits
    */
    logic invalid;
    logic stall_pipeline_type0;
    logic stall_pipeline_type1;
    logic stall_pipeline_type2;
    logic mem_write;
    logic mem_read;
    logic reg_write;
    logic btb_write;


    modport producer(
        output redirect,
        output memory_write_data,
        output memory_operation,
        output alu_out,
        output dest,
        output actual_branch_result,
        output predictor_update,
        output redirection_address,
        output branch_instruction_addr,
        output pht_index,
        output invalid,
        output mem_write,
        output mem_read,
        output reg_write,
        output btb_write,
        output stall_pipeline_type1,
        output btb_write_jump,
        output btb_branch_target_addr,
        output stall_pipeline_type2
    );
    modport register_read (
        input dest,
        input alu_out,
        input reg_write,
        input mem_read,
        output stall_pipeline_type0
    );
    modport predictor_consumer (
        input pht_index,
        input actual_branch_result,
        input predictor_update
    );
    modport fetch_consumer (
        input redirect,
        input btb_write,
        input btb_write_jump,
        input branch_instruction_addr,
        input redirection_address,
        input btb_branch_target_addr
    );

    modport mem_consumer (
        input alu_out,
        input memory_operation,
        input memory_write_data,
        input dest,
        input invalid,
        input mem_write,
        input mem_read,
        input reg_write
    );
endinterface
`endif // EXECUTION_INTERFACE_SVH

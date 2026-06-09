`ifndef EXECUTION_INTERFACE_SVH
`define EXECUTION_INTERFACE_SVH
interface execution_if #(parameter HISTORY_SIZE = 10);
    logic redirect;
    logic [31:0] redirect_target;

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

    logic actual_branch_result;
    logic misspeculation;
    logic [31:0] redirection_address;
    logic [31:0] branch_instruction_addr;
    logic [1:0] branch_addr_way;
    logic [HISTORY_SIZE-1:0] pht_index;

    /*
    control bits
    */
    logic invalid;
    logic mem_write;
    logic mem_read;
    logic reg_write;
    logic btb_write;

    modport producer(
        output redirect,
        output redirect_target,
        output memory_write_data,
        output memory_operation,
        output alu_out,
        output dest,
        output actual_branch_result,
        output misspeculation,
        output redirection_address,
        output branch_instruction_addr,
        output branch_addr_way,
        output pht_index,
        output invalid,
        output mem_write,
        output mem_read,
        output reg_write,
        output btb_write
    );
    modport predictor_consumer (
        input pht_index,
        input misspeculation,
        input actual_branch_result,
        input branch_instruction_addr
    );
    modport btb_consumer (
        input btb_write,
        input branch_instruction_addr,
        input branch_addr_way,
        input redirection_address
    );
    modport fetch_consumer (
        input redirect,
        input redirect_target
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
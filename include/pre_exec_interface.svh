`ifndef PRE_EXEC_INTERFACE_SVH
`define PRE_EXEC_INTERFACE_SVH
interface pre_exec_interface #(parameter HISTORY_SIZE = 10);
    execution_input_t data;
    logic [HISTORY_SIZE-1:0] pht_index;
    modport producer(output data,output pht_index);
    modport consumer(input data,input pht_index);
endinterface
typedef struct packed {
    /*
    needed for target address calculation
    */
    logic [31:0] instruction_addr;
    /*
    represent rs1 and rs2 values  
    src2_data may be an immediate value in instructions such as addi,xori,andi and etc.
    */
    logic [31:0] src1_data; 
    logic [31:0] src2_data;
    /*
    immediate value used by store,load,branch instructions
    */
    logic [31:0] imm_val; 
    /*
    destination register index for destination writers
    */
    logic [4:0] dest;
    logic [6:0] operation;
    /*
    way identifier for branch instruction
    */
    logic [1:0] branch_addr_way;
    /*
    prediction of a branch instruction
    */
    logic prediction;
    logic invalid;
    logic reg_write;
    logic mem_write;
    logic btb_write;
    logic mem_read;
} execution_input_t;

`endif

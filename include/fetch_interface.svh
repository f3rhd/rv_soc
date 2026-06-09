`ifndef FETCH_INTERFACE_SVH
`define FETCH_INTERFACE_SVH
interface fetch_if;
    logic [31:0] instruction_raw;
    logic [31:0] pc;
    logic instruction_ready;

    logic [31:0] btb_redirection_addr;
    logic [31:0] predictor_redirection_addr;
    logic [31:0] execution_redirection_addr;

    logic btb_redirect;
    logic predictor_redirect;
    logic execution_redirect;

    modport execution_producer(output execution_redirect, execution_redirection_addr);
    modport predictor_producer(output predictor_redirect, predictor_redirection_addr);
    modport btb_producer(output btb_redirect,btb_redirection_addr);

    modport producer (
        output instruction_raw,
        output pc,
        output instruction_ready
    );
    modport decode_consumer (
        input instruction_raw, 
        input pc, 
        input instruction_ready
    );

endinterface
`endif 
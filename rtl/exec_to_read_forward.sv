module exec_to_read_forward (
    input  logic [ 4:0] i_src1_addr,
    input  logic [ 4:0] i_src2_addr,
    input  logic [31:0] i_src1_value,
    input  logic [31:0] i_src2_value,
    input  logic        i_src2_is_not_imm,
    input  logic        i_exec_writes_to_register_only,
    input  logic [ 4:0] i_exec_dest,
    input  logic [31:0] i_exec_alu_out,
    output logic [31:0] o_src1_data,
    output logic [31:0] o_src2_data
);

    logic src1_match, src2_match;

    assign src1_match = (i_exec_writes_to_register_only && (i_src1_addr == i_exec_dest) && (i_exec_dest != 5'd0));
    assign src2_match = (i_exec_writes_to_register_only && (i_src2_addr == i_exec_dest) && (i_exec_dest != 5'd0) && i_src2_is_not_imm);

    assign o_src1_data = src1_match ? i_exec_alu_out : i_src1_value;
    assign o_src2_data = src2_match ? i_exec_alu_out : i_src2_value;

endmodule

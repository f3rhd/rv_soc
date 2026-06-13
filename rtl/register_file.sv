module register_file (
    input logic clk,
    input logic i_reset,
    input logic i_write_enable,
    input logic [4:0] i_write_addr,
    input logic [31:0] i_write_data,
    input logic [4:0] i_read_addr0,
    input logic [4:0] i_read_addr1,
    output logic [31:0] o_read_result0,
    output logic [31:0] o_read_result1
);
    (* ram_style = "distributed" *) logic [31:0] file[0:31];

    always_comb begin : forwarding
        o_read_result0 = i_write_addr == i_read_addr0 ? i_write_data : file[i_read_addr0];
        o_read_result1 = i_write_addr == i_read_addr1 ? i_write_data : file[i_read_addr1];
    end
    always_ff @(posedge clk) begin
        if (i_reset) begin
            for (int i = 0; i < 32; i++) begin
                file[i] <= 0;
            end
        end else if (i_write_enable) begin
            if (i_write_addr != 0) begin
                $display("RegisterFile[%h] <- %h", i_write_addr, i_write_data);
                file[i_write_addr] <= i_write_data;
            end
        end
    end
endmodule

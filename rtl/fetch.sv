module fetch #(
    parameter I_CACHE_SIZE = 1024,  // Total size in bytes
    parameter BTB_SIZE = 128
) (
    input logic clk,
    input logic i_en,
    input logic i_reset,
    input logic i_output_bubble,
    input logic [31:0] i_predictor_redirect_target,
    input logic i_predictor_redirect,
    execution_if.fetch_consumer exi,
    output logic o_instruction_valid,
    output logic [31:0] o_instruction_addr,
    output logic [31:0] o_instruction_raw,
    output logic [1:0] o_btb_hit_way,
    output logic o_btb_hit
);

    (* ram_style = "block" *) logic [31:0] memory[0:(I_CACHE_SIZE/4)-1];

    logic [31:0] program_counter;
    logic [31:0] btb_target_addr;
    logic btb_hit;
    btb #(
        .SIZE(BTB_SIZE)
    ) btb (
        .clk(clk),
        .i_branch_addr_read(redirection ? 32'hFFFFFFFF : program_counter),
        .exi(exi),
        .o_target_addr(btb_target_addr),
        .o_way(o_btb_hit_way),
        .o_hit(btb_hit)
    );
    assign redirection = exi.redirect | (o_btb_hit) | i_predictor_redirect;
    always @(posedge clk) begin : pc_logic
        if (i_reset) begin
            program_counter <= 0;
        end else if (i_en) begin
            if (exi.redirect) begin
                program_counter <= exi.redirection_address;
            end else if (i_predictor_redirect) begin
                program_counter <= i_predictor_redirect_target;
            end else if (o_btb_hit) begin
                program_counter <= btb_target_addr;
            end else if (program_counter < I_CACHE_SIZE - 4) begin
                program_counter <= program_counter + 4;
            end
        end
    end
    assign o_btb_hit = btb_hit;
    always @(posedge clk) begin : out_logic
        if (i_reset) begin
            o_instruction_raw   <= 0;
            o_instruction_valid <= 0;
            o_instruction_addr  <= 32'hFFFFFFFF;
        end else if (i_output_bubble | program_counter == $unsigned(
                I_CACHE_SIZE
            ) - 1) begin
            o_instruction_raw   <= 0;
            o_instruction_valid <= 0;
            o_instruction_addr  <= 32'hFFFFFFFF;
        end else if (i_en) begin
            if (redirection) begin
                o_instruction_raw   <= 0;
                o_instruction_valid <= 0;
                o_instruction_addr  <= 32'hFFFFFFFF;
            end else begin
                o_instruction_raw   <= memory[program_counter[31:2]];
                o_instruction_valid <= 1'b1;
                o_instruction_addr  <= program_counter;
            end
        end
    end

endmodule

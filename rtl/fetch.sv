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
    output logic o_btb_hit,
    output logic o_btb_hit_was_jump
);

    (* ram_style = "block" *) logic [31:0] memory[0:(I_CACHE_SIZE/4)-1];

    logic [31:0] program_pointer;
    logic [31:0] program_counter;
    logic [31:0] btb_target_addr;
    btb #(
        .SIZE(BTB_SIZE)
    ) btb (
        .clk(clk),
        .i_branch_addr_read(program_pointer),
        .exi(exi),
        .o_target_addr(btb_target_addr),
        .o_way(o_btb_hit_way),
        .o_hit(o_btb_hit),
        .o_hit_was_jump(o_btb_hit_was_jump)
    );
    always_comb begin
        if (exi.redirect) begin
            program_pointer = exi.redirection_address;
        end else if (i_predictor_redirect) begin
            program_pointer = i_predictor_redirect_target;
        end else if (o_btb_hit) begin
            program_pointer = btb_target_addr;
        end else begin
            program_pointer = program_counter;
        end
    end
    always @(posedge clk) begin : pc_logic
        if (i_reset) begin
            program_counter <= 0;
        end else if (i_en) begin
            if (exi.redirect) begin
                program_counter <= exi.redirection_address + 4;
            end else if (i_predictor_redirect) begin
                program_counter <= i_predictor_redirect_target + 4;
            end else if (o_btb_hit) begin
                program_counter <= btb_target_addr + 4;
            end else if (program_counter < I_CACHE_SIZE - 4) begin
                program_counter <= program_counter + 4;
            end
        end
    end
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
            o_instruction_raw   <= memory[program_pointer[31:2]];
            o_instruction_valid <= 1'b1;
            o_instruction_addr  <= program_counter;
        end
    end

endmodule

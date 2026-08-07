/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
// Overflow is not checked
// Doesn't handle the denormals
module fmultiplier (
    input logic clk,
    input logic i_reset,
    input logic [31:0] i_f1,
    input logic [31:0] i_f2,
    input logic [31:0] i_fcsr,
    input logic [2:0] i_round_mode,
    input logic i_begin,
    output logic [31:0] o_result,
    output logic o_done,
    output logic o_inv_op
);
    typedef enum logic [2:0] {
        S_IDLE,
        S_ZERO_CHECK,
        S_MULTIPLY,
        S_NORMALIZE,
        S_ROUND
    } fmul_state_e;

    fmul_state_e state;

    logic [7:0] exp_result_r;


    logic [47:0] mul_full_product;
    logic [47:0] normalized;
    logic r, s;
    logic mul_begin_r;
    logic mul_done;
    logic [23:0] final_p;
    logic rnd;

    wire [31:0] f1 = i_f1;
    wire [31:0] f2 = i_f2;
    wire [31:0] fcsr = i_fcsr;
    wire [2:0] round_mode = i_round_mode;

    wire [23:0] f1_significand = {1'b1, f1[22:0]};
    wire [7:0] f1_exp = f1[30:23];
    wire f1_sign = f1[31];

    wire [23:0] f2_significand = {1'b1, f2[22:0]};
    wire [7:0] f2_exp = f2[30:23];
    wire f2_sign = f2[31];

    wire final_sign = f1_sign ^ f2_sign;

    wire [2:0] effective_rnd = round_mode == 3'd7 ? fcsr[7:5] : round_mode;
    wire [23:0] P = normalized[47:24];

    wire is_nan1 = (f1_exp == 8'hFF) && (f1_significand[22:0] != 0);
    wire is_nan2 = (f2_exp == 8'hFF) && (f2_significand[22:0] != 0);
    wire is_inf1 = (f1_exp == 8'hFF) && (f1_significand[22:0] == 0);
    wire is_inf2 = (f2_exp == 8'hFF) && (f2_significand[22:0] == 0);
    wire is_zero1 = (f1_exp == 8'h00) && (f1_significand[22:0] == 0);
    wire is_zero2 = (f2_exp == 8'h00) && (f2_significand[22:0] == 0);

    multiplier #(
        .IN_WIDTH(24)
    ) multiplier (
        .clk(clk),
        .i_multiplicand(f1_significand),
        .i_multiplier(f2_significand),
        .i_mul_type(2'b00),
        .i_begin(mul_begin_r),
        .i_reset(i_reset | o_done),
        .o_result(),  // Left open intentionally; we dont need it here
        .o_done(mul_done),
        .o_full_product(mul_full_product)
    );
    always_comb begin
        rnd = 0;
        case (effective_rnd)
            3'd0: begin
                if ((r && P[0]) || (r && s)) rnd = 1;
            end
            3'd1: begin
                rnd = 0;
            end
            3'd2: begin
                if (final_sign && (r || s)) rnd = 1;
            end
            3'd3: begin
                if (~final_sign && (r || s)) rnd = 1;
            end
            3'd4: begin
                rnd = 1;
            end
        endcase
        if (rnd) final_p = P + 1;
        else final_p = P;
    end
    always_ff @(posedge clk) begin
        o_done      <= 0;
        mul_begin_r <= 0;
        if (i_reset) begin
            o_result <= 0;
            o_inv_op <= 0;
            state    <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (o_done) begin
                    end else if (i_begin) begin
                        state <= S_ZERO_CHECK;
                    end
                end
                S_ZERO_CHECK: begin
                    if (is_nan1 || is_nan2) begin
                        o_done   <= 1;
                        o_result <= 32'h7FC00000;
                        state    <= S_IDLE;
                    end
                    else if ((is_zero1 && is_inf2) || (is_inf1 && is_zero2)) begin
                        o_done   <= 1;
                        o_result <= 32'h7FC00000;
                        o_inv_op <= 1'b1;
                        state    <= S_IDLE;
                    end else if (is_zero1 || is_zero2) begin
                        o_done   <= 1;
                        o_result <= {final_sign, 31'b0};
                        state    <= S_IDLE;
                    end else if (is_inf1 || is_inf2) begin
                        o_done   <= 1;
                        o_result <= {final_sign, 8'hFF, 23'b0};
                        state    <= S_IDLE;
                    end else begin
                        mul_begin_r <= 1'b1;
                        state       <= S_MULTIPLY;
                    end
                end
                S_MULTIPLY: begin
                    if (mul_done) begin
                        state        <= S_NORMALIZE;
                        exp_result_r <= f1_exp + f2_exp - 127;
                    end
                end
                S_NORMALIZE: begin
                    if (mul_full_product[47]) begin
                        normalized   <= mul_full_product;
                        exp_result_r <= exp_result_r + 1;
                        r            <= mul_full_product[23];
                        s            <= |mul_full_product[22:0];
                    end else begin
                        normalized[47:24] <= mul_full_product[46:23];
                        normalized[23:0]  <= mul_full_product[23:0];
                        r                 <= mul_full_product[22];
                        s                 <= |mul_full_product[21:0];
                    end
                    state <= S_ROUND;
                end
                S_ROUND: begin
                    o_done          <= 1;
                    o_result[31]    <= final_sign;
                    o_result[30:23] <= exp_result_r;
                    o_result[22:0]  <= final_p[22:0];
                    state           <= S_IDLE;
                end
            endcase
        end
    end
endmodule

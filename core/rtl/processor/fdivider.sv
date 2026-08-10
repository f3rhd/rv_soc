/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
module fdivider (
    input  logic        clk,
    input  logic        i_reset,
    input  logic [31:0] i_f1,
    input  logic [31:0] i_f2,
    input  logic [31:0] i_fcsr,
    input  logic [ 2:0] i_round_mode,
    input  logic        i_begin,
    output logic [31:0] o_result,
    output logic        o_done,
    output logic        o_inv_op
);

    enum logic [3:0] {
        S_IDLE,
        S_SPECIAL_CHECK,
        S_SETUP,
        S_DIV_ITER,
        S_ROUND_PREP,
        S_ROUND,
        S_HANDLE_CARRY,
        S_DONE
    } state;


    logic f1_sign;
    logic [23:0] f1_sig;
    logic [7:0] f1_exp;
    logic f2_sign;
    logic [23:0] f2_sig;
    logic [7:0] f2_exp;

    wire f1_is_zero = (f1_exp == 8'h00) && (f1_sig[22:0] == 23'd0);
    wire f2_is_zero = (f2_exp == 8'h00) && (f2_sig[22:0] == 23'd0);
    wire f1_is_nan = (f1_exp == 8'hFF) && (f1_sig[22:0] != 23'd0);
    wire f2_is_nan = (f2_exp == 8'hFF) && (f2_sig[22:0] != 23'd0);
    wire f1_is_inf = (f1_exp == 8'hFF) && (f1_sig[22:0] == 23'd0);
    wire f2_is_inf = (f2_exp == 8'hFF) && (f2_sig[22:0] == 23'd0);

    logic [24:0] R;
    logic [26:0] Q;

    logic [4:0] iter_count;

    logic [24:0] d_ext;
    assign d_ext = {1'b0, f2_sig};

    logic [23:0] preliminary_sig;
    logic [ 7:0] exp_result;
    logic        result_sign;
    logic        carry_out;
    logic g, r, s;

    wire [2:0] effective_rnd = i_round_mode == 3'd7 ? i_fcsr[7:5] : i_round_mode;
    logic rnd;

    always_comb begin
        rnd = 0;
        case (effective_rnd)
            3'd0: if (g && (r || s || preliminary_sig[0])) rnd = 1;  // RNE
            3'd1: rnd = 0;  // RTZ
            3'd2: if (result_sign && (g || r || s)) rnd = 1;  // RDN
            3'd3: if (~result_sign && (g || r || s)) rnd = 1;  // RUP
            3'd4: if (g) rnd = 1;  // RMM
        endcase
    end

    always_ff @(posedge clk) begin
        o_done <= 0;
        if (i_reset) begin
            state           <= S_IDLE;
            f1_sign         <= 0;
            f1_sig          <= 0;
            f1_exp          <= 0;
            f2_sign         <= 0;
            f2_sig          <= 0;
            f2_exp          <= 0;
            o_inv_op        <= 0;
            R               <= 0;
            Q               <= 0;
            iter_count      <= 0;
            preliminary_sig <= 0;
            exp_result      <= 0;
            result_sign     <= 0;
            carry_out       <= 0;
            g               <= 0;
            r               <= 0;
            s               <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    f1_sign         <= 0;
                    f1_sig          <= 0;
                    f1_exp          <= 0;
                    f2_sign         <= 0;
                    f2_sig          <= 0;
                    f2_exp          <= 0;
                    o_inv_op        <= 0;
                    R               <= 0;
                    Q               <= 0;
                    iter_count      <= 0;
                    preliminary_sig <= 0;
                    exp_result      <= 0;
                    result_sign     <= 0;
                    carry_out       <= 0;
                    g               <= 0;
                    r               <= 0;
                    s               <= 0;
                    if (o_done) begin
                    end else if (i_begin) begin
                        f1_sign <= i_f1[31];
                        f1_sig  <= {1'b1, i_f1[22:0]};
                        f1_exp  <= i_f1[30:23];

                        f2_sign <= i_f2[31];
                        f2_sig  <= {1'b1, i_f2[22:0]};
                        f2_exp  <= i_f2[30:23];

                        state   <= S_SPECIAL_CHECK;
                    end
                end

                S_SPECIAL_CHECK: begin
                    if (f1_is_nan || f2_is_nan) begin

                        result_sign     <= 1'b0;
                        exp_result      <= 8'hFF;
                        preliminary_sig <= {1'b1, 23'h400000};
                        state           <= S_DONE;
                    end else if ((f1_is_inf && f2_is_inf) || (f1_is_zero && f2_is_zero)) begin

                        result_sign     <= 1'b0;
                        exp_result      <= 8'hFF;
                        preliminary_sig <= {1'b1, 23'h400000};
                        o_inv_op        <= 1'b1;
                        state           <= S_DONE;
                    end else if (f1_is_inf) begin

                        result_sign     <= f1_sign ^ f2_sign;
                        exp_result      <= 8'hFF;
                        preliminary_sig <= 24'd0;
                        state           <= S_DONE;
                    end else if (f2_is_zero) begin
                        result_sign     <= f1_sign ^ f2_sign;
                        exp_result      <= 8'hFF;
                        preliminary_sig <= 24'd0;
                        state           <= S_DONE;
                    end else if (f1_is_zero || f2_is_inf) begin

                        result_sign     <= f1_sign ^ f2_sign;
                        exp_result      <= 8'd0;
                        preliminary_sig <= 24'd0;
                        state           <= S_DONE;
                    end else begin
                        state <= S_SETUP;
                    end
                end

                S_SETUP: begin
                    exp_result  <= f1_exp - f2_exp + 8'd127;
                    result_sign <= f1_sign ^ f2_sign;
                    R           <= {1'b0, f1_sig};
                    Q           <= 0;
                    iter_count  <= 0;
                    state       <= S_DIV_ITER;
                end

                S_DIV_ITER: begin
                    if (R >= d_ext) begin
                        Q <= {Q[25:0], 1'b1};
                        R <= (R - d_ext) << 1;
                    end else begin
                        Q <= {Q[25:0], 1'b0};
                        R <= R << 1;
                    end
                    iter_count <= iter_count + 1'b1;
                    if (iter_count == 5'd26) state <= S_ROUND_PREP;
                end

                S_ROUND_PREP: begin


                    if (Q[26]) begin

                        preliminary_sig <= Q[26:3];
                        g               <= Q[2];
                        r               <= Q[1];
                        s               <= |R | Q[0];
                    end else begin

                        preliminary_sig <= Q[25:2];
                        g               <= Q[1];
                        r               <= Q[0];
                        s               <= |R;
                        exp_result      <= exp_result - 1;
                    end
                    state <= S_ROUND;
                end

                S_ROUND: begin
                    state <= S_HANDLE_CARRY;
                    if (rnd) begin
                        {carry_out, preliminary_sig} <= preliminary_sig + 1;
                    end else begin
                        carry_out <= 1'b0;
                    end
                end

                S_HANDLE_CARRY: begin
                    state <= S_DONE;
                    if (carry_out) begin
                        preliminary_sig <= {1'b0, preliminary_sig[23:1]};
                        exp_result      <= exp_result + 1;
                    end
                end

                S_DONE: begin
                    state           <= S_IDLE;
                    o_done          <= 1;
                    o_result[31]    <= result_sign;
                    o_result[30:23] <= exp_result;
                    o_result[22:0]  <= preliminary_sig[22:0];
                end
            endcase
        end
    end
endmodule

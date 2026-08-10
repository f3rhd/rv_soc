/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
module fsqrt (
    input  logic        clk,
    input  logic        i_reset,
    input  logic [31:0] i_f,
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
        S_SQRT_ITER,
        S_ROUND_PREP,
        S_ROUND,
        S_HANDLE_CARRY,
        S_DONE
    } state;


    logic f_sign;
    logic [23:0] f_sig;
    logic [7:0] f_exp;


    logic presc;
    assign presc = ~f_exp[0];

    logic [8:0] exp_sum;
    assign exp_sum = {1'b0, f_exp} + 9'd127 - {8'b0, presc};

    logic [24:0] sig25;
    assign sig25 = presc ? {f_sig, 1'b0} : {1'b0, f_sig};


    logic [51:0] rad_buf;
    logic [29:0] R;
    logic [25:0] Q;
    logic [ 4:0] iter_count;

    logic [29:0] r_shifted;
    logic [29:0] t_val;
    assign r_shifted = {R[27:0], rad_buf[51:50]};
    assign t_val     = {2'b00, Q, 2'b01};


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
            3'd0: if ((r && preliminary_sig[0]) || (r && s)) rnd = 1;
            3'd1: rnd = 0;
            3'd2: if (result_sign && (r || s)) rnd = 1;
            3'd3: if (~result_sign && (r || s)) rnd = 1;
            3'd4: rnd = 1;
        endcase
    end

    always_ff @(posedge clk) begin
        o_done <= 0;
        if (i_reset) begin
            state           <= S_IDLE;
            f_sign          <= 0;
            f_sig           <= 0;
            f_exp           <= 0;
            o_inv_op        <= 0;
            rad_buf         <= 0;
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
                    f_sign          <= 0;
                    f_sig           <= 0;
                    f_exp           <= 0;
                    o_inv_op        <= 0;
                    rad_buf         <= 0;
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
                        f_sign <= i_f[31];
                        f_sig  <= {1'b1, i_f[22:0]};
                        f_exp  <= i_f[30:23];
                        state  <= S_SPECIAL_CHECK;
                    end
                end

                S_SPECIAL_CHECK: begin
                    if (f_exp == 8'h00 && f_sig[22:0] == 23'd0) begin

                        result_sign     <= f_sign;
                        exp_result      <= 8'd0;
                        preliminary_sig <= 24'd0;
                        state           <= S_DONE;
                    end else if (f_exp == 8'hFF) begin
                        if (f_sig[22:0] != 0) begin

                            result_sign     <= 1'b0;
                            exp_result      <= 8'hFF;
                            preliminary_sig <= {1'b1, 23'h400000};
                            state           <= S_DONE;
                        end else if (f_sign) begin

                            result_sign     <= 1'b0;
                            exp_result      <= 8'hFF;
                            preliminary_sig <= {1'b1, 23'h400000};
                            o_inv_op        <= 1'b1;
                            state           <= S_DONE;
                        end else begin

                            result_sign     <= 1'b0;
                            exp_result      <= 8'hFF;
                            preliminary_sig <= 24'd0;
                            state           <= S_DONE;
                        end
                    end else if (f_sign) begin

                        result_sign     <= 1'b0;
                        exp_result      <= 8'hFF;
                        preliminary_sig <= {1'b1, 23'h400000};
                        o_inv_op        <= 1'b1;
                        state           <= S_DONE;
                    end else begin
                        state <= S_SETUP;
                    end
                end

                S_SETUP: begin
                    exp_result  <= exp_sum[8:1];
                    result_sign <= 1'b0;
                    rad_buf     <= {sig25, 27'b0};
                    R           <= 0;
                    Q           <= 0;
                    iter_count  <= 0;
                    state       <= S_SQRT_ITER;
                end

                S_SQRT_ITER: begin

                    if (r_shifted >= t_val) begin
                        R <= r_shifted - t_val;
                        Q <= {Q[24:0], 1'b1};
                    end else begin
                        R <= r_shifted;
                        Q <= {Q[24:0], 1'b0};
                    end
                    rad_buf    <= {rad_buf[49:0], 2'b00};
                    iter_count <= iter_count + 1'b1;
                    if (iter_count == 5'd25) state <= S_ROUND_PREP;
                end

                S_ROUND_PREP: begin

                    preliminary_sig <= Q[25:2];
                    g               <= Q[1];
                    r               <= Q[0];
                    s               <= |R;
                    state           <= S_ROUND;
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

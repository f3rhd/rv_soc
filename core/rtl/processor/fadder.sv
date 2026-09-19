/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
// Denormals are not handled
module fadder (
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

    enum logic [3:0] {
        S_IDLE,
        S_SPECIAL_VALUE_CHECK,
        S_SWAP_OPERAND,
        S_TWOS_COMPLEMENT,
        S_SHIFT_S2,
        S_COMPUTE_PRELIMINARY_SIGNIFICAND,
        S_NORMALIZE_PRELIMINARY,
        S_ADJUST_R_S,
        S_ROUND,
        S_HANDLE_CARRY,
        S_COMPUTE_SIGN,
        S_DONE
    } state;
    logic f1_sign;
    logic [23:0] f1_sig;
    logic [7:0] f1_exp;
    logic f2_sign;
    logic [23:0] f2_sig;
    logic [7:0] f2_exp;

    logic [7:0] shift_amount;
    logic [7:0] exp_diff;
    logic logical_shift;
    logic g, r, s;

    logic [23:0] preliminary_sig;
    logic [7:0] exp_result;
    logic result_sign;
    logic carry_out;
    logic normalization_left_shift;
    logic normalization_right_shift;
    logic [23:0] preliminary_before_normalization;
    logic normalizaiton_had_more_than_one_left_shift;
    logic swapped;
    logic twos_complement;


    wire [24:0] sum_raw = f1_sig + f2_sig;

    wire [2:0] effective_rnd = i_round_mode == 3'd7 ? i_fcsr[7:5] : i_round_mode;
    logic rnd;

    always_comb begin
        rnd = 0;
        case (effective_rnd)
            3'd0: begin
                if ((r && preliminary_sig[0]) || (r && s)) rnd = 1;
            end
            3'd1: begin
                rnd = 0;
            end
            3'd2: begin
                if (result_sign && (r || s)) rnd = 1;
            end
            3'd3: begin
                if (~result_sign && (r || s)) rnd = 1;
            end
            3'd4: begin
                rnd = 1;
            end
        endcase
    end
    always_ff @(posedge clk) begin
        o_done <= 0;
        if (i_reset) begin
            state                                      <= S_IDLE;
            f1_sign                                    <= 0;
            f1_sig                                     <= 0;
            f1_exp                                     <= 0;
            f2_sign                                    <= 0;
            f2_sig                                     <= 0;
            f2_exp                                     <= 0;
            o_inv_op                                   <= 0;
            shift_amount                               <= 0;
            result_sign                                <= 0;
            preliminary_sig                            <= 0;
            g                                          <= 0;
            r                                          <= 0;
            s                                          <= 0;
            exp_result                                 <= 0;
            exp_diff                                   <= 0;
            logical_shift                              <= 0;
            carry_out                                  <= 0;
            normalization_left_shift                   <= 0;
            normalization_right_shift                  <= 0;
            normalizaiton_had_more_than_one_left_shift <= 0;
            preliminary_before_normalization           <= 0;
            swapped                                    <= 0;
            twos_complement                            <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    f1_sign                                    <= 0;
                    f1_sig                                     <= 0;
                    f1_exp                                     <= 0;
                    f2_sign                                    <= 0;
                    f2_sig                                     <= 0;
                    f2_exp                                     <= 0;
                    shift_amount                               <= 0;
                    result_sign                                <= 0;
                    g                                          <= 0;
                    r                                          <= 0;
                    s                                          <= 0;
                    preliminary_sig                            <= 0;
                    exp_result                                 <= 0;
                    exp_diff                                   <= 0;
                    logical_shift                              <= 0;
                    carry_out                                  <= 0;
                    normalization_left_shift                   <= 0;
                    normalization_right_shift                  <= 0;
                    normalizaiton_had_more_than_one_left_shift <= 0;
                    preliminary_before_normalization           <= 0;
                    swapped                                    <= 0;
                    twos_complement                            <= 0;
                    if (o_done) begin
                    end else if (i_begin) begin
                        f1_sign <= i_f1[31];
                        f1_sig  <= {1'b1, i_f1[22:0]};
                        f1_exp  <= i_f1[30:23];

                        f2_sign <= i_f2[31];
                        f2_sig  <= {1'b1, i_f2[22:0]};
                        f2_exp  <= i_f2[30:23];

                        state   <= S_SPECIAL_VALUE_CHECK;
                    end
                end
                S_SPECIAL_VALUE_CHECK: begin
                    if (f1_exp == 8'h00 && f1_sig[22:0] == 23'd0) begin
                        // Operand 1 is Zero: Result is Operand 2
                        result_sign     <= f2_sign;
                        exp_result      <= f2_exp;
                        preliminary_sig <= f2_sig;
                        state           <= S_DONE;
                    end else if (f2_exp == 8'h00 && f2_sig[22:0] == 23'd0) begin
                        // Operand 2 is Zero: Result is Operand 1
                        result_sign     <= f1_sign;
                        exp_result      <= f1_exp;
                        preliminary_sig <= f1_sig;
                        state           <= S_DONE;
                    end else if ((f1_exp == 8'hFF && f1_sig[22:0] != 0) || (f2_exp == 8'hFF && f2_sig[22:0] != 0)) begin
                        result_sign     <= 1'b0;
                        exp_result      <= 8'hFF;
                        preliminary_sig <= {1'b1, 23'h400000};
                        state           <= S_DONE;
                    end else if (f1_exp == 8'hFF || f2_exp == 8'hFF) begin
                        if (f1_exp == 8'hFF && f2_exp == 8'hFF && (f1_sign != f2_sign)) begin
                            // (+Inf) + (-Inf) is Invalid -> NaN
                            result_sign     <= 1'b0;
                            exp_result      <= 8'hFF;
                            preliminary_sig <= {1'b1, 23'h400000};
                            o_inv_op        <= 1'b1;
                        end else if (f1_exp == 8'hFF) begin
                            // Result is Inf with f1's sign
                            result_sign     <= f1_sign;
                            exp_result      <= 8'hFF;
                            preliminary_sig <= 24'd0;
                        end else begin
                            // Result is Inf with f2's sign
                            result_sign     <= f2_sign;
                            exp_result      <= 8'hFF;
                            preliminary_sig <= 24'd0;
                        end
                        state <= S_DONE;
                    end else begin
                        state <= S_SWAP_OPERAND;
                    end
                end
                S_SWAP_OPERAND: begin
                    state <= S_TWOS_COMPLEMENT;
                    if (f1_exp < f2_exp) begin
                        exp_result <= f2_exp;
                        f1_sign    <= f2_sign;
                        f1_sig     <= f2_sig;
                        f1_exp     <= f2_exp;
                        f2_sign    <= f1_sign;
                        f2_sig     <= f1_sig;
                        f2_exp     <= f1_exp;
                        swapped    <= 1'b1;
                    end else exp_result <= f1_exp;
                end
                S_TWOS_COMPLEMENT: begin

                    state         <= S_SHIFT_S2;
                    shift_amount  <= f1_exp - f2_exp;
                    exp_diff      <= f1_exp - f2_exp;
                    logical_shift <= 1;
                    if (f1_sign ^ f2_sign) begin
                        f2_sig        <= -f2_sig;
                        logical_shift <= 0;
                    end
                end
                S_SHIFT_S2: begin
                    if (shift_amount == 0) begin
                        state <= S_COMPUTE_PRELIMINARY_SIGNIFICAND;
                    end else begin
                        shift_amount <= shift_amount - 1;
                        g            <= f2_sig[0];
                        r            <= g;
                        s            <= s | r;
                        if (logical_shift) f2_sig <= {1'b0, f2_sig[23:1]};
                        else f2_sig <= {1'b1, f2_sig[23:1]};
                    end
                end
                S_COMPUTE_PRELIMINARY_SIGNIFICAND: begin
                    state <= S_NORMALIZE_PRELIMINARY;
                    if (exp_diff == 0 && (f1_sign ^ f2_sign) && !sum_raw[24] && sum_raw[23]) begin
                        preliminary_sig <= -sum_raw[23:0];
                        //result_sign     <= f2_sign;
                        twos_complement <= 1;
                    end else begin
                        preliminary_sig <= sum_raw[23:0];
                        carry_out       <= sum_raw[24];
                    end
                end
                S_NORMALIZE_PRELIMINARY: begin
                    if (f1_sign == f2_sign && carry_out) begin
                        preliminary_sig                  <= {carry_out, preliminary_sig[23:1]};
                        preliminary_before_normalization <= preliminary_sig;
                        normalization_right_shift        <= 1;
                        exp_result                       <= exp_result + 1;
                        state                            <= S_ADJUST_R_S;
                    end else if (preliminary_sig == 0 && g == 0) begin
                        exp_result <= 8'd0;
                        state      <= S_COMPUTE_SIGN;
                    end else begin
                        if (preliminary_sig[23]) begin
                            // it is normalized
                            state <= S_ADJUST_R_S;
                        end else begin
                            if (!normalization_left_shift) begin
                                preliminary_sig          <= {preliminary_sig[22:0], g};
                                normalization_left_shift <= 1;
                            end else begin
                                normalizaiton_had_more_than_one_left_shift <= 1'b1;
                                preliminary_sig                            <= {preliminary_sig[22:0], 1'b0};
                            end
                            exp_result <= exp_result - 1;
                        end
                    end
                end
                S_ADJUST_R_S: begin
                    state <= S_ROUND;
                    if (!normalization_left_shift && !normalization_right_shift) begin
                        r <= g;
                        s <= r | s;
                    end else if (normalization_right_shift) begin
                        r <= preliminary_before_normalization[0];
                        s <= s | g | r;
                    end else if (normalization_left_shift) begin
                        if (normalizaiton_had_more_than_one_left_shift) begin
                            r <= 0;
                            s <= 0;
                        end
                    end
                end
                S_ROUND: begin
                    state <= S_HANDLE_CARRY;
                    if (rnd) begin
                        {carry_out, preliminary_sig} <= preliminary_sig + 1;
                    end else begin
                        carry_out <= 0;
                    end
                end
                S_HANDLE_CARRY: begin
                    state <= S_COMPUTE_SIGN;
                    if (carry_out) begin
                        preliminary_sig <= {1'b0, preliminary_sig[23:1]};
                        exp_result      <= exp_result + 1;
                    end
                end
                S_COMPUTE_SIGN: begin
                    state <= S_DONE;
                    if (f1_sign == f2_sign) begin
                        result_sign <= f1_sign;
                    end else begin
                        if (swapped) begin
                            result_sign <= i_f2[31];
                        end else begin
                            if (twos_complement) begin
                                result_sign <= i_f2[31];
                            end else result_sign <= i_f1[31];
                        end
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

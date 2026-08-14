/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

module float_to_int (
    input  logic        clk,
    input  logic        i_reset,
    input  logic        i_begin,
    input  logic        i_signed,
    input  logic [ 2:0] i_rnd_mode,
    input  logic [31:0] i_fs,
    input  logic [31:0] i_fcsr,
    output logic [31:0] o_result,
    output logic        o_done
);


    localparam logic [2:0] RNE = 3'b000;
    localparam logic [2:0] RTZ = 3'b001;
    localparam logic [2:0] RDN = 3'b010;
    localparam logic [2:0] RUP = 3'b011;
    localparam logic [2:0] RMM = 3'b100;
    localparam logic [2:0] DYN = 3'b111;

    localparam logic [31:0] S32_MAX = 32'h7FFF_FFFF;
    localparam logic [31:0] S32_MIN = 32'h8000_0000;
    localparam logic [31:0] U32_MAX = 32'hFFFF_FFFF;
    localparam logic [31:0] U32_MIN = 32'h0000_0000;

    typedef enum logic [1:0] {
        IDLE,
        CALC_PREP,
        CALC,
        DONE
    } state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge i_reset) begin
        if (i_reset) state <= IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        unique case (state)
            IDLE: next_state = i_begin ? CALC_PREP : IDLE;
            CALC_PREP: next_state = CALC;
            CALC: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end


    logic        signed_reg;
    logic [31:0] fs_reg;
    logic [ 2:0] rnd_reg;

    wire  [ 2:0] eff_rnd_mode = (i_rnd_mode == DYN) ? i_fcsr[7:5] : i_rnd_mode;

    always_ff @(posedge clk or posedge i_reset) begin
        if (i_reset) begin
            signed_reg <= 1'b0;
            fs_reg     <= 32'b0;
            rnd_reg    <= 3'b0;
        end else if (state == IDLE && i_begin) begin
            signed_reg <= i_signed;
            fs_reg     <= i_fs;
            rnd_reg    <= eff_rnd_mode;
        end
    end




    logic        fs_sign;
    logic [ 7:0] fs_exp;
    logic [22:0] fs_frac;

    assign fs_sign = fs_reg[31];
    assign fs_exp  = fs_reg[30:23];
    assign fs_frac = fs_reg[22:0];

    logic is_zero, is_nan, is_inf, is_special;
    logic               eff_sign;
    logic        [23:0] sig24;
    logic signed [ 8:0] e;

    always_comb begin
        is_zero    = (fs_exp == 8'h00) && (fs_frac == 23'b0);
        is_nan     = (fs_exp == 8'hFF) && (fs_frac != 23'b0);
        is_inf     = (fs_exp == 8'hFF) && (fs_frac == 23'b0);
        is_special = is_nan || is_inf;
        eff_sign   = is_nan ? 1'b0 : fs_sign;

        if (fs_exp == 8'h00) begin
            sig24 = {1'b0, fs_frac};
            e     = -9'sd126;
        end else begin
            sig24 = {1'b1, fs_frac};
            e     = $signed({1'b0, fs_exp}) - 9'sd127;
        end
    end


    logic signed [7:0] shift_amt;
    logic [63:0] wide0, wide_shifted;
    logic [31:0] int_part;
    logic guard, sticky, round_up;
    logic [32:0] mag_rounded;

    always_comb begin
        shift_amt = 8'sd23 - 8'(e);
        wide0     = {8'd0, sig24, 32'd0};


        int_part  = wide_shifted[63:32];
        guard     = wide_shifted[31];
        sticky    = |wide_shifted[30:0];

        unique case (rnd_reg)
            RNE:     round_up = guard & (sticky | int_part[0]);
            RTZ:     round_up = 1'b0;
            RDN:     round_up = eff_sign & (guard | sticky);
            RUP:     round_up = ~eff_sign & (guard | sticky);
            RMM:     round_up = guard;
            default: round_up = guard & (sticky | int_part[0]);
        endcase

        mag_rounded = {1'b0, int_part} + (round_up ? 33'd1 : 33'd0);
    end


    logic [32:0] mag_small;

    always_comb begin
        unique case (rnd_reg)
            RNE, RTZ, RMM: mag_small = 33'd0;
            RDN:           mag_small = eff_sign ? 33'd1 : 33'd0;
            RUP:           mag_small = ~eff_sign ? 33'd1 : 33'd0;
            default:       mag_small = 33'd0;
        endcase
    end


    logic [32:0] mag_final;

    always_comb begin
        if (is_zero) begin
            mag_final = 33'd0;
        end else if (e <= -9'sd2) begin
            mag_final = mag_small;
        end else if (e >= 9'sd31) begin

            if (!is_special && e == 9'sd31 && sig24 == 24'h80_0000 && eff_sign)
                mag_final = 33'h0_8000_0000;
            else mag_final = 33'h1_FFFF_FFFF;
        end else begin
            mag_final = mag_rounded;
        end
    end


    logic [31:0] result_comb;

    always_comb begin
        if (is_zero) begin
            result_comb = 32'b0;
        end else if (is_nan || is_inf) begin
            if (signed_reg) result_comb = eff_sign ? S32_MIN : S32_MAX;
            else result_comb = eff_sign ? U32_MIN : U32_MAX;
        end else if (signed_reg) begin
            if (eff_sign) begin

                if (mag_final > 33'h0000_0000_8000_0000) result_comb = S32_MIN;
                else result_comb = (~mag_final[31:0] + 32'd1);
            end else begin
                if (mag_final > 33'h0000_0000_7FFF_FFFF) result_comb = S32_MAX;
                else result_comb = mag_final[31:0];
            end
        end else begin
            if (eff_sign) begin

                result_comb = U32_MIN;
            end else begin
                if (mag_final > 33'h0_FFFF_FFFF) result_comb = U32_MAX;
                else result_comb = mag_final[31:0];
            end
        end
    end

    always_ff @(posedge clk) begin
        if (i_reset) begin
            o_result <= 32'b0;
            o_done   <= 1'b0;
        end else begin
            unique case (state)
                CALC_PREP: begin
                    if (shift_amt >= 0) wide_shifted <= wide0 >> shift_amt;
                    else wide_shifted <= wide0 << (-shift_amt);
                end
                CALC: begin
                    o_result <= result_comb;
                    o_done   <= 1'b1;
                end
                DONE: o_done <= 1'b0;
                default: ;
            endcase
        end
    end

endmodule

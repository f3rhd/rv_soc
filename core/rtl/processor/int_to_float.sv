/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
module int_to_float (
    input logic clk,
    input logic i_reset,
    input logic i_begin,
    input logic i_signed,
    input logic [2:0] i_rnd_mode,
    input logic [31:0] i_fs,
    input logic [31:0] i_fcsr,
    output logic [31:0] o_result,
    output logic o_done
);

    localparam logic [2:0] RNE = 3'b000;
    localparam logic [2:0] RTZ = 3'b001;
    localparam logic [2:0] RDN = 3'b010;
    localparam logic [2:0] RUP = 3'b011;
    localparam logic [2:0] RMM = 3'b100;
    localparam logic [2:0] DYN = 3'b111;

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
            IDLE:      next_state = i_begin ? CALC_PREP : IDLE;
            CALC_PREP: next_state = CALC;
            CALC:      next_state = DONE;
            DONE:      next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

    logic        sign_reg;
    logic [31:0] mag_reg;
    logic [ 2:0] rnd_reg;

    wire  [ 2:0] eff_rnd_mode = (i_rnd_mode == DYN) ? i_fcsr[7:5] : i_rnd_mode;

    always_ff @(posedge clk or posedge i_reset) begin
        if (i_reset) begin
            sign_reg <= 1'b0;
            mag_reg  <= 32'b0;
            rnd_reg  <= 3'b0;
        end else if (state == IDLE && i_begin) begin
            sign_reg <= i_signed & i_fs[31];
            mag_reg  <= (i_signed && i_fs[31]) ? (~i_fs + 32'b1) : i_fs;
            rnd_reg  <= eff_rnd_mode;
        end
    end

    function automatic [5:0] clz32(input logic [31:0] val);
        int i;
        begin
            clz32 = 6'd32;
            for (i = 31; i >= 0; i--)
            if (val[i] && clz32 == 6'd32) clz32 = 6'(31 - i);
        end
    endfunction

    logic [ 5:0] lzc;
    logic [22:0] mant;
    logic guard, rnd_bit, sticky, round_up;
    logic [ 7:0] exp_raw;
    logic [23:0] mant_ext;
    logic [ 8:0] exp_ext;
    logic [31:0] result_comb;

    logic [31:0] shifted_wire;
    assign lzc          = clz32(mag_reg);
    assign shifted_wire = mag_reg << lzc;

    always_comb begin
        unique case (rnd_reg)
            RNE: round_up = guard & (rnd_bit | sticky | mant[0]);
            RTZ: round_up = 1'b0;
            RDN: round_up = sign_reg & (guard | rnd_bit | sticky);
            RUP: round_up = ~sign_reg & (guard | rnd_bit | sticky);
            RMM: round_up = guard;
            default: round_up = guard & (rnd_bit | sticky | mant[0]);
        endcase

        mant_ext = {1'b0, mant} + (round_up ? 24'd1 : 24'd0);
        exp_ext  = {1'b0, exp_raw};

        if (mant_ext[23]) begin
            exp_ext = {1'b0, exp_raw} + 9'd1;
        end

        if (mag_reg == 32'b0) result_comb = 32'b0;  // +0.0
        else result_comb = {sign_reg, exp_ext[7:0], mant_ext[22:0]};
    end

    always_ff @(posedge clk) begin
        if (i_reset) begin
            o_result <= 32'b0;
            o_done   <= 1'b0;
            exp_raw  <= 8'b0;
            mant     <= 23'b0;
            guard    <= 1'b0;
            rnd_bit  <= 1'b0;
            sticky   <= 1'b0;
        end else begin
            unique case (state)
                CALC_PREP: begin
                    if (mag_reg != 32'b0) begin
                        mant    <= shifted_wire[30:8];
                        guard   <= shifted_wire[7];
                        rnd_bit <= shifted_wire[6];
                        sticky  <= |shifted_wire[5:0];
                        exp_raw <= 8'(127 + 31 - lzc);
                    end else begin
                        exp_raw <= 8'b0;
                        mant    <= 23'b0;
                        guard   <= 1'b0;
                        rnd_bit <= 1'b0;
                        sticky  <= 1'b0;
                    end
                end
                CALC: begin
                    o_result <= result_comb;
                    o_done   <= 1'b1;
                end
                DONE:    o_done <= 1'b0;
                default: ;
            endcase
        end
    end

endmodule

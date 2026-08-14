/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
module divider #(
    parameter unsigned WIDTH = 32
) (
    input logic clk,
    input logic [WIDTH-1:0] i_dividend,
    input logic [WIDTH-1:0] i_divisor,
    input logic [1:0] i_div_type,
    input logic i_begin,
    input logic i_reset,
    output logic [WIDTH-1:0] o_result,
    output logic o_done
);
    typedef enum logic [2:0] {
        DIV       = 3'b000,
        DIVU      = 3'b010,
        REM       = 3'b001,
        REMU      = 3'b011,
        UNDEFINED = 3'b100
    } _div_kind;

    typedef enum logic [1:0] {
        S_IDLE,
        S_PREPARE,
        S_EXECUTE,
        S_DONE
    } _div_state;

    _div_kind                    div_type;
    _div_kind                    div_kind;
    _div_state                   div_state;

    logic      [$clog2(WIDTH):0] iterator;

    logic      [      WIDTH-1:0] divisor;
    logic      [      WIDTH-1:0] quotient;
    logic      [      WIDTH-1:0] remainder;

    logic      [      WIDTH-1:0] dividend_abs;
    logic      [      WIDTH-1:0] divisor_abs;

    logic                        dividend_sign;
    logic                        divisor_sign;

    logic                        div_by_zero;
    logic                        signed_overflow;

    logic      [      WIDTH-1:0] shifted_remainder;
    logic      [        WIDTH:0] trial;

    logic      [      WIDTH-1:0] signed_quotient;
    logic      [      WIDTH-1:0] signed_remainder;
    logic      [      WIDTH-1:0] final_quotient;
    logic      [      WIDTH-1:0] final_remainder;

    logic      [      WIDTH-1:0] latched_dividend;
    logic      [      WIDTH-1:0] latched_divisor;
    always_comb begin
        case (i_div_type)
            2'b00:   div_type = DIV;
            2'b01:   div_type = DIVU;
            2'b10:   div_type = REM;
            2'b11:   div_type = REMU;
            default: div_type = UNDEFINED;
        endcase

        dividend_sign = latched_dividend[WIDTH-1] & ~div_kind[1];
        divisor_sign = latched_divisor[WIDTH-1] & ~div_kind[1];

        dividend_abs = dividend_sign ? (~latched_dividend + 1'b1) : latched_dividend;
        divisor_abs = divisor_sign ? (~latched_divisor + 1'b1) : latched_divisor;

        shifted_remainder = {remainder[WIDTH-2:0], quotient[WIDTH-1]};
        trial = {1'b0, shifted_remainder} - {1'b0, divisor};

        signed_quotient  = (dividend_sign ^ divisor_sign) ? (~quotient + 1'b1) : quotient;
        signed_remainder = dividend_sign ? (~remainder + 1'b1) : remainder;

        if (div_by_zero) begin
            final_quotient  = {WIDTH{1'b1}};
            final_remainder = latched_dividend;
        end else if (signed_overflow) begin
            final_quotient  = {1'b1, {(WIDTH - 1) {1'b0}}};
            final_remainder = {WIDTH{1'b0}};
        end else begin
            final_quotient  = div_kind[1] ? quotient : signed_quotient;
            final_remainder = div_kind[1] ? remainder : signed_remainder;
        end
    end

    always_ff @(posedge clk) begin
        if (i_reset) begin
            div_kind         <= UNDEFINED;
            div_state        <= S_IDLE;
            o_done           <= 0;
            iterator         <= 0;
            divisor          <= 0;
            quotient         <= 0;
            remainder        <= 0;
            div_by_zero      <= 0;
            signed_overflow  <= 0;
            o_result         <= 0;
            latched_dividend <= 0;
            latched_divisor  <= 0;
        end else begin
            case (div_state)
                S_IDLE: begin
                    iterator         <= 0;
                    o_done           <= 0;
                    divisor          <= 0;
                    quotient         <= 0;
                    remainder        <= 0;
                    div_by_zero      <= 0;
                    signed_overflow  <= 0;
                    o_result         <= 0;
                    latched_dividend <= 0;
                    latched_divisor  <= 0;

                    if (o_done) begin
                    end else if (i_begin) begin
                        latched_divisor  <= i_divisor;
                        latched_dividend <= i_dividend;
                        div_kind         <= div_type;
                        div_state        <= S_PREPARE;
                    end
                end

                S_PREPARE: begin
                    div_state <= S_EXECUTE;

                    divisor <= divisor_abs;
                    quotient <= dividend_abs;
                    remainder <= 0;

                    div_by_zero <= (latched_divisor == 32'b0);
                    signed_overflow   <= ~div_kind[1] &
                                             (latched_dividend == 32'h8000_0000) &
                                             (latched_divisor  == 32'hFFFF_FFFF);
                end
                S_EXECUTE: begin
                    iterator <= iterator + 1;

                    if (!trial[32]) begin
                        remainder <= trial[WIDTH-1:0];
                        quotient  <= {quotient[WIDTH-2:0], 1'b1};
                    end else begin
                        remainder <= shifted_remainder;
                        quotient  <= {quotient[WIDTH-2:0], 1'b0};
                    end

                    if (iterator == WIDTH - 1) begin
                        iterator  <= 0;
                        div_state <= S_DONE;
                    end
                end

                S_DONE: begin
                    o_done    <= 1;
                    o_result  <= div_kind[0] ? final_remainder : final_quotient;
                    div_state <= S_IDLE;
                end
                default: div_state <= S_IDLE;
            endcase
        end
    end
endmodule

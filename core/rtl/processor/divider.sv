/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
module divider (
    input logic clk,
    input logic [31:0] i_dividend,
    input logic [31:0] i_divisor,
    input logic [1:0] i_div_type,
    input logic i_begin,
    input logic i_reset,
    output logic [31:0] o_result,
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
        S_EXECUTE,
        S_DONE
    } _div_state;

    _div_kind         div_type;
    _div_kind         div_kind;
    _div_state        div_state;

    logic      [ 5:0] iterator;

    logic      [31:0] divisor;
    logic      [31:0] quotient;
    logic      [31:0] remainder;

    logic      [31:0] dividend_abs;
    logic      [31:0] divisor_abs;

    logic             dividend_sign;
    logic             divisor_sign;

    logic      [31:0] saved_dividend;
    logic             div_by_zero;
    logic             signed_overflow;

    logic      [31:0] shifted_remainder;
    logic      [32:0] trial;

    logic      [31:0] signed_quotient;
    logic      [31:0] signed_remainder;
    logic      [31:0] final_quotient;
    logic      [31:0] final_remainder;

    always_comb begin
        case (i_div_type)
            2'b00:   div_type = DIV;
            2'b01:   div_type = DIVU;
            2'b10:   div_type = REM;
            2'b11:   div_type = REMU;
            default: div_type = UNDEFINED;
        endcase

        dividend_sign = i_dividend[31] & ~div_type[1];
        divisor_sign = i_divisor[31] & ~div_type[1];

        dividend_abs = dividend_sign ? (~i_dividend + 1'b1) : i_dividend;
        divisor_abs = divisor_sign ? (~i_divisor + 1'b1) : i_divisor;

        shifted_remainder = {remainder[30:0], quotient[31]};
        trial = {1'b0, shifted_remainder} - {1'b0, divisor};

        signed_quotient  = (dividend_sign ^ divisor_sign) ? (~quotient + 1'b1) : quotient;
        signed_remainder = dividend_sign ? (~remainder + 1'b1) : remainder;

        if (div_by_zero) begin
            final_quotient  = 32'hFFFF_FFFF;
            final_remainder = saved_dividend;
        end else if (signed_overflow) begin
            final_quotient  = 32'h8000_0000;
            final_remainder = 32'h0000_0000;
        end else begin
            final_quotient  = div_kind[1] ? quotient : signed_quotient;
            final_remainder = div_kind[1] ? remainder : signed_remainder;
        end
    end

    always_ff @(posedge clk) begin
        if (i_reset) begin
            div_kind        <= UNDEFINED;
            div_state       <= S_IDLE;
            o_done          <= 0;
            iterator        <= 0;
            divisor         <= 0;
            quotient        <= 0;
            remainder       <= 0;
            saved_dividend  <= 0;
            div_by_zero     <= 0;
            signed_overflow <= 0;
            o_result        <= 0;
        end else begin
            case (div_state)
                S_IDLE: begin
                    o_done   <= 0;
                    iterator <= 0;

                    if (o_done) begin
                    end else if (i_begin) begin
                        div_kind <= div_type;
                        div_state <= S_EXECUTE;

                        divisor <= divisor_abs;
                        quotient <= dividend_abs;
                        remainder <= 0;

                        saved_dividend <= i_dividend;
                        div_by_zero <= (i_divisor == 32'b0);
                        signed_overflow   <= ~div_type[1] &
                                             (i_dividend == 32'h8000_0000) &
                                             (i_divisor  == 32'hFFFF_FFFF);
                    end
                end

                S_EXECUTE: begin
                    iterator <= iterator + 1;

                    if (!trial[32]) begin
                        remainder <= trial[31:0];
                        quotient  <= {quotient[30:0], 1'b1};
                    end else begin
                        remainder <= shifted_remainder;
                        quotient  <= {quotient[30:0], 1'b0};
                    end

                    if (iterator == 31) begin
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

/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

module multiplier #(
    parameter unsigned IN_WIDTH = 32
) (
    input logic clk,
    input logic [IN_WIDTH-1:0] i_multiplicand,
    input logic [IN_WIDTH-1:0] i_multiplier,
    input logic [1:0] i_mul_type,
    input logic i_begin,
    input logic i_reset,
    output logic [IN_WIDTH*2-1:0] o_full_product,
    output logic [IN_WIDTH-1:0] o_result,
    output logic o_done
);
    typedef enum logic [2:0] {
        MULH      = 3'b000,
        MULHSU    = 3'b001,
        MUL       = 3'b100,
        MULHU     = 3'b101,
        UNDEFINED = 3'b010
    } _mul_kind;

    typedef enum logic [1:0] {
        S_IDLE,
        S_EXECUTE,
        S_DONE
    } _mul_state;

    _mul_kind                       mul_type;
    _mul_kind                       mul_kind;
    _mul_state                      mul_state;

    logic      [$clog2(IN_WIDTH):0] iterator;
    logic      [      IN_WIDTH-1:0] multiplicand;
    logic      [    2*IN_WIDTH-1:0] product;
    logic                           booth_bit;

    logic      [        IN_WIDTH:0] sum_sub;
    logic      [        IN_WIDTH:0] unsigned_sum;
    logic      [        IN_WIDTH:0] hsu_sum;

    always_comb begin
        case (i_mul_type)
            2'b00:   mul_type = MUL;
            2'b01:   mul_type = MULH;
            2'b10:   mul_type = MULHSU;
            2'b11:   mul_type = MULHU;
            default: mul_type = UNDEFINED;
        endcase

        case ({
            product[0], booth_bit
        })
            2'b10:
            sum_sub = {product[2*IN_WIDTH-1], product[2*IN_WIDTH-1:IN_WIDTH]} - {multiplicand[IN_WIDTH-1], multiplicand};
            2'b01:
            sum_sub = {product[2*IN_WIDTH-1], product[2*IN_WIDTH-1:IN_WIDTH]} + {multiplicand[IN_WIDTH-1], multiplicand};
            default:
            sum_sub = {product[2*IN_WIDTH-1], product[2*IN_WIDTH-1:IN_WIDTH]};
        endcase


        unsigned_sum = product[2*IN_WIDTH-1:IN_WIDTH] + multiplicand;


        hsu_sum = {product[2*IN_WIDTH-1], product[2*IN_WIDTH-1:IN_WIDTH]} + {multiplicand[IN_WIDTH-1], multiplicand};
    end

    always_ff @(posedge clk) begin
        if (i_reset) begin
            mul_kind     <= UNDEFINED;
            mul_state    <= S_IDLE;
            o_done       <= 0;
            iterator     <= 0;
            multiplicand <= 0;
            booth_bit    <= 0;
            product      <= 0;
            o_done       <= 0;
            o_result     <= 0;
        end else begin
            case (mul_state)
                S_IDLE: begin
                    o_done   <= 0;
                    iterator <= 0;
                    product  <= 0;

                    if (o_done) begin
                    end else if (i_begin) begin
                        multiplicand <= i_multiplicand;
                        mul_kind     <= mul_type;
                        mul_state    <= S_EXECUTE;
                        product      <= {{IN_WIDTH{1'b0}}, i_multiplier};
                        booth_bit    <= 1'b0;
                    end
                end

                S_EXECUTE: begin
                    iterator <= iterator + 1;

                    if (mul_kind[2]) begin

                        if (product[0]) begin
                            product <= {unsigned_sum, product[IN_WIDTH-1:1]};
                        end else begin
                            product <= {1'b0, product[2*IN_WIDTH-1:1]};
                        end
                    end else begin
                        // mulh
                        if (~mul_kind[0]) begin
                            product   <= {sum_sub, product[IN_WIDTH-1:1]};
                            booth_bit <= product[0];
                        end else begin

                            if (product[0]) begin
                                product <= {hsu_sum, product[IN_WIDTH-1:1]};
                            end else begin
                                product <= {
                                    product[2*IN_WIDTH-1],
                                    product[2*IN_WIDTH-1:1]
                                };
                            end
                        end
                    end

                    if (iterator == IN_WIDTH - 1) begin
                        iterator  <= 0;
                        mul_state <= S_DONE;
                    end
                end

                S_DONE: begin
                    o_done         <= 1;
                    o_full_product <= product;
                    if (mul_kind[2] & ~mul_kind[0]) begin
                        o_result <= product[IN_WIDTH-1:0];
                    end else begin
                        o_result <= product[2*IN_WIDTH-1:IN_WIDTH];
                    end
                    mul_state <= S_IDLE;
                end
                default: mul_state <= S_IDLE;
            endcase
        end
    end
endmodule

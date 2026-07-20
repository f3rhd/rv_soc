/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
module seven_seg_display (
    input  logic       clk,
    input  logic       reset,
    input  logic       in,
    output logic [6:0] o_seg,
    output logic [3:0] o_an
);


    logic [16:0] refresh_counter;
    always_ff @(posedge clk) begin
        if (reset) refresh_counter <= '0;
        else refresh_counter <= refresh_counter + 1'b1;
    end

    logic [1:0] active_digit;
    assign active_digit = refresh_counter[16:15];
    localparam logic [6:0] CHAR_BLANK = 7'b1111111;
    localparam logic [6:0] CHAR_L = 7'b1000111;
    localparam logic [6:0] CHAR_O = 7'b1000000;
    localparam logic [6:0] CHAR_A = 7'b0001000;
    localparam logic [6:0] CHAR_D = 7'b0100001;
    localparam logic [6:0] CHAR_N = 7'b1101010;
    localparam logic [6:0] CHAR_E = 7'b0000110;

    always_comb begin
        o_an  = 4'b1111;
        o_seg = 7'b1111111;

        if (!in) begin
            case (active_digit)
                2'b00: begin
                    o_an  = 4'b0111;
                    o_seg = CHAR_L;
                end
                2'b01: begin
                    o_an  = 4'b1011;
                    o_seg = CHAR_O;
                end
                2'b10: begin
                    o_an  = 4'b1101;
                    o_seg = CHAR_A;
                end
                2'b11: begin
                    o_an  = 4'b1110;
                    o_seg = CHAR_D;
                end
                default: begin
                    o_seg = CHAR_BLANK;
                end
            endcase
        end else begin
            case (active_digit)
                2'b00: begin
                    o_an  = 4'b0111;
                    o_seg = CHAR_D;
                end
                2'b01: begin
                    o_an  = 4'b1011;
                    o_seg = CHAR_O;
                end
                2'b10: begin
                    o_an  = 4'b1101;
                    o_seg = CHAR_N;
                end
                2'b11: begin
                    o_an  = 4'b1110;
                    o_seg = CHAR_E;
                end
                default: begin
                    o_seg = CHAR_BLANK;
                end
            endcase
        end
    end

endmodule

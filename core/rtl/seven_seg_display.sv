/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */
module seven_seg_display (
    input logic clk,
    input logic reset,
    input logic [15:0] i_display_val,
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

    logic [3:0] current_nibble;
    always_comb begin
        case (active_digit)
            2'b00:   current_nibble = i_display_val[3:0];
            2'b01:   current_nibble = i_display_val[7:4];
            2'b10:   current_nibble = i_display_val[11:8];
            2'b11:   current_nibble = i_display_val[15:12];
            default: current_nibble = 4'h0;
        endcase
    end

    always_comb begin
        case (active_digit)
            2'b00:   o_an = 4'b1110;
            2'b01:   o_an = 4'b1101;
            2'b10:   o_an = 4'b1011;
            2'b11:   o_an = 4'b0111;
            default: o_an = 4'b1111;
        endcase
    end

    always_comb begin
        case (current_nibble)
            4'h0: o_seg = 7'b1000000;  // 0
            4'h1: o_seg = 7'b1111001;  // 1
            4'h2: o_seg = 7'b0100100;  // 2
            4'h3: o_seg = 7'b0110000;  // 3
            4'h4: o_seg = 7'b0011001;  // 4
            4'h5: o_seg = 7'b0100101;  // 5
            4'h6: o_seg = 7'b0100000;  // 6
            4'h7: o_seg = 7'b1111000;  // 7
            4'h8: o_seg = 7'b0000000;  // 8
            4'h9: o_seg = 7'b0000100;  // 9
            4'hA: o_seg = 7'b0001000;  // A
            4'hB: o_seg = 7'b0000011;  // b
            4'hC: o_seg = 7'b1000110;  // C
            4'hD: o_seg = 7'b0100001;  // d
            4'hE: o_seg = 7'b0000110;  // E
            4'hF: o_seg = 7'b0001110;  // F
            default: o_seg = 7'b1111111;  // Blank
        endcase
    end

endmodule

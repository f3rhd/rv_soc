/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
module seven_seg_display_controller (
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

    logic [3:0] raw_anode;
    logic [6:0] raw_seg;

    always_comb begin
        case (active_digit)
            2'b00:   raw_anode = 4'b0001;
            2'b01:   raw_anode = 4'b0010;
            2'b10:   raw_anode = 4'b0100;
            2'b11:   raw_anode = 4'b1000;
            default: raw_anode = 4'b0000;
        endcase
    end

    always_comb begin
        case (current_nibble)
            4'h0: raw_seg = 7'b0111111;  // 0
            4'h1: raw_seg = 7'b0000110;  // 1
            4'h2: raw_seg = 7'b1011011;  // 2
            4'h3: raw_seg = 7'b1001111;  // 3
            4'h4: raw_seg = 7'b1100110;  // 4
            4'h5: raw_seg = 7'b1101101;  // 5
            4'h6: raw_seg = 7'b1111101;  // 6
            4'h7: raw_seg = 7'b0000111;  // 7
            4'h8: raw_seg = 7'b1111111;  // 8
            4'h9: raw_seg = 7'b1101111;  // 9
            4'hA: raw_seg = 7'b1110111;  // A
            4'hB: raw_seg = 7'b1111100;  // b
            4'hC: raw_seg = 7'b0111001;  // C
            4'hD: raw_seg = 7'b1011110;  // d
            4'hE: raw_seg = 7'b1111001;  // E
            4'hF: raw_seg = 7'b1110001;  // F
            default: raw_seg = 7'b0000000;  // Blank
        endcase
    end

`ifdef ACTIVE_LOW
    assign o_an  = ~raw_anode;
    assign o_seg = ~raw_seg;
`else
    assign o_an  = raw_anode;
    assign o_seg = raw_seg;
`endif
endmodule

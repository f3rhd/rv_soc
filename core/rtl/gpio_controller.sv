/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "gpio_interface.svh"
module gpio_controller #(
    parameter unsigned PIN_AMOUNT = 27
) (
    input logic clk,
    input logic i_reset,
    gpio_if.controller gpioi,
    inout wire [0 : PIN_AMOUNT-1] pins_io
);

    localparam logic PIN_INPUT = 1'b0;
    localparam logic PIN_OUTPUT = 1'b1;

    logic [0:PIN_AMOUNT-1] pins_out_reg;
    logic [0:PIN_AMOUNT-1] pins_dir_reg;

    genvar i;
    generate
        for (i = 0; i < PIN_AMOUNT; i++) begin : g_pin_drivers
            assign pins_io[i] = (pins_dir_reg[i] == PIN_OUTPUT) ? pins_out_reg[i] : 1'bz;
        end
    endgenerate

    always_ff @(posedge clk) begin
        if (i_reset) begin
            pins_out_reg        <= '0;
            pins_dir_reg        <= {PIN_AMOUNT{PIN_INPUT}};
            gpioi.pin_read_done <= 1'b0;
            gpioi.pin_read_val  <= 1'b0;
        end else begin
            gpioi.pin_read_done <= 1'b0;

            if (gpioi.pin_set_enable) begin
                pins_dir_reg[gpioi.pin_id] <= gpioi.pin_mode;
            end else if (gpioi.pin_drive_enable) begin
                if (pins_dir_reg[gpioi.pin_id] == PIN_OUTPUT) begin
                    pins_out_reg[gpioi.pin_id] <= gpioi.pin_drive_val;
                end
            end else if (gpioi.pin_read_enable) begin
                gpioi.pin_read_done <= 1'b1;
                gpioi.pin_read_val  <= pins_io[gpioi.pin_id];
            end
        end
    end
endmodule

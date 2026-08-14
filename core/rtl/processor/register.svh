/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`ifndef REGISTER_READ_OUTPUT_SVH
`define REGISTER_READ_OUTPUT_SVH
`include "decode_output.svh"
typedef struct packed {
    logic [31:0] src1_data;
    logic [31:0] src2_data;
    logic [31:0] src3_data;
    logic [31:0] fcsr;
} register_read_data_t;
typedef struct packed {
    decode_output_t decode_data;
    register_read_data_t read_data;
} register_read_output_t;
typedef struct packed {
    logic int_write_enable;
    logic float_write_enable;
    logic [4:0] write_addr;
    logic [31:0] write_data;
} register_write_data_t;
`endif

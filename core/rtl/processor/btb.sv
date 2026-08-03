/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "../../include/execution_interface.svh"
module btb #(
    parameter SIZE = 32,
    parameter ADDRESS_WIDTH = 12
) (
    input logic clk,
    input logic i_reset,
    input logic i_enable,
    input logic [ADDRESS_WIDTH-1:0] i_branch_addr_read,
    execution_if.fetch_consumer exi,
    output logic [ADDRESS_WIDTH-1:0] o_target_addr,
    output logic o_hit,
    output logic o_hit_was_jump
);
    localparam NUM_WAYS = 4;
    localparam NUM_SETS = SIZE / NUM_WAYS;
    localparam NUM_BITS_FOR_SET_ID = $clog2(NUM_SETS);
    localparam NUM_BITS_FOR_WAY_ID = $clog2(NUM_WAYS);
    localparam TAG_WIDTH = ADDRESS_WIDTH - NUM_BITS_FOR_SET_ID;
    typedef struct packed {
        logic [TAG_WIDTH-1:0]     tag;
        logic [ADDRESS_WIDTH-1:0] target_addr;
        logic                     valid;
        logic                     is_jump;
    } btb_entry_t;

    logic [NUM_BITS_FOR_WAY_ID-1:0] set_allocation_counter[0:NUM_SETS-1];
    btb_entry_t branch_table[0:NUM_SETS-1][0:NUM_WAYS-1];

    btb_entry_t accessed_line[0:NUM_WAYS-1];

    logic [NUM_BITS_FOR_SET_ID-1:0] read_set_id;
    logic [NUM_BITS_FOR_SET_ID-1:0] write_set_id;

    logic [TAG_WIDTH - 1 : 0] read_tag;
    logic [TAG_WIDTH - 1 : 0] r_read_tag;

    logic [TAG_WIDTH - 1 : 0] write_tag;

    assign write_tag    = exi.execution_instruction_addr[(ADDRESS_WIDTH-1) -: TAG_WIDTH];
    assign read_tag = i_branch_addr_read[(ADDRESS_WIDTH-1)-:TAG_WIDTH];

    assign write_set_id = exi.execution_instruction_addr[0+:NUM_BITS_FOR_SET_ID];
    assign read_set_id = i_branch_addr_read[0+:NUM_BITS_FOR_SET_ID];

    always_ff @(posedge clk) begin
        if (i_reset) begin
            for (int i = 0; i < NUM_SETS; i++) begin
                for (int j = 0; j < NUM_WAYS; j++) begin
                    branch_table[i][j] <= '0;
                end
                set_allocation_counter[i] <= 0;
            end
        end else if (i_enable) begin
            if (exi.btb_write) begin
                branch_table[write_set_id][set_allocation_counter[write_set_id]] <= '{
                    is_jump : exi.btb_write_jump,
                    valid : 1'b1,
                    tag : write_tag,
                    target_addr : exi.btb_branch_target_addr[ADDRESS_WIDTH-1:0]
                };
                set_allocation_counter[write_set_id] <= set_allocation_counter[write_set_id] + 1;
            end
            accessed_line <= branch_table[read_set_id];
            r_read_tag    <= read_tag;
        end
    end


    always_comb begin
        o_hit          = 1'b0;
        o_target_addr  = '0;
        o_hit_was_jump = 1'b0;
        for (int w = 0; w < NUM_WAYS; w++) begin
            if (accessed_line[w].valid && (accessed_line[w].tag == r_read_tag)) begin
                o_hit          = 1'b1;
                o_target_addr  = accessed_line[w].target_addr;
                o_hit_was_jump = accessed_line[w].is_jump;
                break;
            end
        end
    end


endmodule

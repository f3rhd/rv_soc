`include "../../include/execution_interface.svh"
module btb #(
    parameter SIZE = 128,
    parameter ADDRESS_WIDTH = 20
) (
    input logic clk,
    input logic i_reset,
    input logic [ADDRESS_WIDTH-1:0] i_branch_addr_read,
    execution_if.fetch_consumer exi,
    output logic [ADDRESS_WIDTH-1:0] o_target_addr,
    output logic o_hit,
    output logic o_hit_was_jump
);
    localparam NUM_WAYS = 4;
    localparam NUM_SETS = SIZE / 4;
    localparam NUM_BITS_FOR_SET_ID = $clog2(SIZE / 4);
    localparam NUM_BITS_FOR_WAY_ID = $clog2(NUM_WAYS);
    localparam TAG_WIDTH = ADDRESS_WIDTH - NUM_BITS_FOR_SET_ID - NUM_BITS_FOR_SET_ID;
    typedef struct packed {
        logic                     is_jump;
        logic                     valid;
        logic [TAG_WIDTH-1:0]     tag;
        logic [ADDRESS_WIDTH-1:0] target_addr;
    } btb_entry_t;

    btb_entry_t branch_table[0:NUM_SETS-1][0:NUM_WAYS-1];

    btb_entry_t accessed_entry;

    logic [NUM_BITS_FOR_SET_ID-1:0] read_set_id;
    logic [NUM_BITS_FOR_SET_ID-1:0] write_set_id;

    logic [TAG_WIDTH - 1 : 0] read_tag;
    logic [TAG_WIDTH - 1 : 0] r_read_tag;
    logic [NUM_BITS_FOR_WAY_ID-1:0] read_way;

    logic [TAG_WIDTH - 1 : 0] write_tag;
    logic [NUM_BITS_FOR_WAY_ID-1:0] write_way;

    assign write_tag = exi.branch_instruction_addr[(ADDRESS_WIDTH-1)-:TAG_WIDTH];
    assign write_set_id = exi.branch_instruction_addr[NUM_BITS_FOR_WAY_ID+:NUM_BITS_FOR_SET_ID];
    assign write_way = exi.branch_instruction_addr[0+:NUM_BITS_FOR_WAY_ID];

    assign read_tag = i_branch_addr_read[(ADDRESS_WIDTH-1)-:TAG_WIDTH];
    assign read_set_id = i_branch_addr_read[NUM_BITS_FOR_WAY_ID+:NUM_BITS_FOR_SET_ID];
    assign read_way = i_branch_addr_read[0+:NUM_BITS_FOR_WAY_ID];

    always_ff @(posedge clk) begin
        if (i_reset) begin
            for (int i = 0; i < NUM_SETS; i++) begin
                for (int j = 0; j < NUM_WAYS; j++) begin
                    branch_table[i][j] <= '0;
                end
            end
        end else begin
            if (exi.btb_write) begin
                branch_table[write_set_id][write_way] <= '{
                    is_jump : exi.btb_write_jump,
                    valid : 1'b1,
                    tag : write_tag,
                    target_addr : exi.redirection_address[ADDRESS_WIDTH-1:0]
                };
            end
            accessed_entry <= branch_table[read_set_id][read_way];
            r_read_tag     <= read_tag;
        end
    end

    always_comb begin
        o_hit          = 1'b0;
        o_target_addr  = '0;
        o_hit_was_jump = 0;
        if (accessed_entry.valid && (accessed_entry.tag == r_read_tag)) begin
            o_hit          = 1'b1;
            o_target_addr  = accessed_entry.target_addr;
            o_hit_was_jump = accessed_entry.is_jump;
        end
    end


endmodule

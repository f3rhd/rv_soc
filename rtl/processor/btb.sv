`include "../../include/execution_interface.svh"
module btb #(
    parameter SIZE = 128
) (
    input logic clk,
    input logic [31:0] i_branch_addr_read,
    execution_if.fetch_consumer exi,
    output logic [31:0] o_target_addr,
    output logic [1:0] o_way,
    output logic o_hit,
    output logic o_hit_was_jump
);
    localparam NUM_WAYS = 4;
    localparam NUM_SETS = SIZE / 4;
    localparam NUM_BITS_FOR_SET_ID = $clog2(SIZE / 4);
    localparam TAG_WIDTH = 32 - (2 + NUM_BITS_FOR_SET_ID);
    typedef struct packed {
        logic                 is_jump;
        logic                 valid;
        logic [TAG_WIDTH-1:0] tag;
        logic [31:0]          target_addr;
    } btb_entry_t;

    (* ram_style = "block" *)
    btb_entry_t branch_table_banks[0:NUM_WAYS-1][0:NUM_SETS-1];
    btb_entry_t read_data_ways[0:NUM_WAYS-1];

    logic [NUM_BITS_FOR_SET_ID-1:0] read_set_id;
    logic [31 - (2+NUM_BITS_FOR_SET_ID) : 0] read_tag;
    logic [31 - (2+NUM_BITS_FOR_SET_ID) : 0] read_tag_q;
    logic [NUM_BITS_FOR_SET_ID-1:0] write_set_id;
    logic [31 - (2+NUM_BITS_FOR_SET_ID) : 0] write_tag;
    logic [1:0] counter = 0;

    assign write_tag = exi.branch_instruction_addr[31 : 2+NUM_BITS_FOR_SET_ID];
    assign write_set_id = exi.branch_instruction_addr[2+NUM_BITS_FOR_SET_ID-1 : 2];

    assign read_tag = i_branch_addr_read[31:2+NUM_BITS_FOR_SET_ID];
    assign read_set_id = i_branch_addr_read[2+NUM_BITS_FOR_SET_ID-1 : 2];

    always_ff @(posedge clk) begin
        counter    <= counter + 1;
        read_tag_q <= read_tag;
        for (int i = 0; i < NUM_WAYS; i++) begin
            read_data_ways[i] <= branch_table_banks[i][read_set_id];
        end
        if (exi.btb_write) begin
            branch_table_banks[exi.branch_addr_way][write_set_id].tag <= write_tag;
            branch_table_banks[exi.branch_addr_way][write_set_id].target_addr <= exi.redirection_address;
            branch_table_banks[exi.branch_addr_way][write_set_id].valid <= 1'b1;
            branch_table_banks[exi.branch_addr_way][write_set_id].is_jump <= exi.btb_write_jump;
        end
    end


    always_comb begin
        o_hit          = 1'b0;
        o_target_addr  = '0;
        o_way          = counter[1:0];
        o_hit_was_jump = 0;

        // If there was a hit output the way address of the hit branch.
        for (int i = 0; i < NUM_WAYS; i++) begin
            if (read_data_ways[i].valid && (read_data_ways[i].tag == read_tag_q)) begin
                o_hit          = 1'b1;
                o_target_addr  = read_data_ways[i].target_addr;
                o_way          = i[1:0];
                o_hit_was_jump = read_data_ways[i].is_jump;
            end
        end
        // Else our way is going to be picked pseudo-randomly. This may create problems in branch heavy applications.
        // Since it introduces the possibility of overwriting existing entry even tho there were some empty entries.
    end


endmodule

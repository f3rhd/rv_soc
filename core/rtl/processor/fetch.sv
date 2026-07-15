`include "../../include/bootloader_interface.svh"
module fetch #(
    parameter unsigned I_CACHE_SIZE = 1024,  // Total size in bytes
    parameter unsigned BTB_SIZE = 128
) (
    input logic clk,
    input logic i_en,
    input logic i_reset,
    input logic i_output_bubble,
    input logic [31:0] i_predictor_redirect_target,
    input logic i_predictor_redirect,
    input logic i_graphics_init_done,
    execution_if.fetch_consumer exi,
    bootloader_if.processor bootloaderi,
    output logic o_instruction_valid,
    output logic [31:0] o_instruction_addr,
    output logic [31:0] o_instruction_raw,
    output logic [1:0] o_btb_hit_way,
    output logic o_btb_hit,
    output logic o_btb_hit_was_jump
);


`ifdef VIVADO
    (* ram_style = "block" *)
`elsif QUARTUS
    (* ramstyle = "block" *)
`endif
    logic [31:0] instructions[0:(I_CACHE_SIZE/4)-1];

    logic [31:0] program_pointer;
    logic [31:0] program_counter;
    logic [31:0] btb_target_addr;
    logic [31:0] program_size;
    logic end_of_program;
    typedef enum logic {
        LOAD,
        FETCH
    } fetch_state;
    fetch_state state = LOAD;

    btb #(
        .SIZE(BTB_SIZE)
    ) btb (
        .clk(clk),
        .i_branch_addr_read(program_pointer),
        .i_reset(i_reset),
        .exi(exi),
        .o_target_addr(btb_target_addr),
        .o_way(o_btb_hit_way),
        .o_hit(o_btb_hit),
        .o_hit_was_jump(o_btb_hit_was_jump)
    );
    always_comb begin
        if (exi.redirect) begin
            program_pointer = exi.redirection_address;
        end else if (i_predictor_redirect) begin
            program_pointer = i_predictor_redirect_target;
        end else if (o_btb_hit) begin
            program_pointer = btb_target_addr;
        end else begin
            program_pointer = program_counter;
        end
    end
    assign end_of_program = program_pointer > program_size - 4;

    always_ff @(posedge clk) begin

        if (i_reset) begin
            program_counter     <= 0;
            o_instruction_raw   <= 0;
            o_instruction_valid <= 0;
            o_instruction_addr  <= 32'h0;
            program_size        <= 0;
            state               <= LOAD;
        end else begin
            case (state)
                LOAD: begin
                    if (bootloaderi.instruction_ready) begin
                        instructions[program_counter] <= bootloaderi.instruction;
                        program_counter <= program_counter + 1;
                        program_size <= program_size + 4;
                    end
                    if (bootloaderi.program_load_done & i_graphics_init_done) begin
                        program_counter <= 0;
                        state           <= FETCH;
                    end
                end
                FETCH: begin
                    if (i_en & !end_of_program) begin
                        program_counter <= program_pointer + 4;
                        o_instruction_raw <= instructions[program_pointer[31:2]];
                        o_instruction_valid <= 1'b1;
                        o_instruction_addr <= program_pointer;
                    end else if (i_output_bubble | end_of_program) begin
                        o_instruction_raw   <= 0;
                        o_instruction_valid <= 0;
                        o_instruction_addr  <= 32'h0;
                    end
                end
                default: begin
                    o_instruction_raw   <= 0;
                    o_instruction_valid <= 0;
                    o_instruction_addr  <= 32'h0;
                end
            endcase
        end
    end

endmodule

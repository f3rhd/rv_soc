`include "../include/fetch_interface.svh"
`include "../include/execution_interface.svh"
module fetch #(
    parameter SIZE = 1024
) (
    input logic clk,
    input logic i_en,
    input logic i_reset,
    input logic i_output_bubble,
    execution_if.fetch_consumer exi,
    fetch_if.producer fi
);
    (* ram_style = "block" *) logic [7:0] memory[0:SIZE-1];

    logic [31:0] program_counter = 0;
    logic [2:0] byte_counter = 0;
    logic [23:0] shift_reg = 0;

    always @(posedge clk) begin : pc_logic
        if (i_reset) begin
            program_counter <= 0;
            byte_counter    <= 0;
            shift_reg       <= 0;
        end else if (exi.redirect & i_en) begin
            program_counter <= exi.redirect_target;
        end else begin
            if (program_counter < SIZE / 4 & i_en & byte_counter == 3) begin
                program_counter <= program_counter + 4;
            end
        end
    end

    always @(posedge clk) begin : out_logic
        if (i_output_bubble) begin
            fi.instruction_raw   <= 0;
            fi.instruction_ready <= 0;
            fi.pc                <= 32'hFFFFFFFF;
        end else if (i_en) begin
            fi.instruction_ready <= 0;
            fi.pc                <= 32'hFFFFFFFF;
            case (byte_counter)
                2'b00: shift_reg[7:0] <= memory[program_counter];
                2'b01: shift_reg[15:8] <= memory[program_counter+1];
                2'b10: shift_reg[23:16] <= memory[program_counter+2];
                2'b11: begin
                    fi.instruction_raw <= {
                        memory[program_counter+3], shift_reg[23:0]
                    };
                end
            endcase
            if (exi.redirect) begin
                byte_counter       <= 0;
                shift_reg          <= 0;
                fi.instruction_raw <= 0;
                fi.pc              <= 32'hFFFFFFFF;
            end else if (byte_counter == 3) begin
                byte_counter         <= 0;
                fi.instruction_ready <= 1;
                fi.pc                <= program_counter;
            end else begin
                byte_counter <= byte_counter + 1;
            end
        end
    end
endmodule

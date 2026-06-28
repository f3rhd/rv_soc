module stage_controller (
    input logic i_misprediction,
    input logic i_load_stall,
    input logic i_graphics_instruction_write_fail,
    output logic [0:3] flush_vector,
    output logic [0:3] stall_vector
);
    always_comb begin
        flush_vector = 4'b0000;
        stall_vector = 4'b0000;
        if (i_misprediction) begin
            /*
            flush everything except fetch stage
            we are not flushing fetch stage since in a clock cycle where redirection is detected the next instruction
            is going to be fetched from calculated target address
            */
            flush_vector = 4'b0111;
            stall_vector = 3'b0000;
        end else if (i_load_stall) begin
            flush_vector = 4'b0001;  // flush execute stage
            stall_vector = 4'b1110;  // stall all
        end else if (i_graphics_instruction_write_fail) begin
            flush_vector = 4'b0000;
            stall_vector = 4'b1111;
        end
    end
endmodule

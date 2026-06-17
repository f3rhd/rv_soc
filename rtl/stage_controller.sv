module stage_controller (
    input logic i_misprediction,
    input logic i_load_stall,
    output logic [0:3] flush_vector,
    output logic [0:3] stall_vector
);
    always_comb begin
        flush_vector = 4'b0000;
        stall_vector = 4'b0000;
        if (i_misprediction) begin
            /*
            flush everything except execution and fetch stage
            jump instructions also trigger flushing, we cant flush them as they write to registers
            we are not flushing fetch stage since in a clock cycle where redirection is detected the next fetched instruction
            is going to be from the calculated address
            */
            flush_vector = 4'b0110;
            stall_vector = 3'b0000;
        end else if (i_load_stall) begin
            flush_vector = 4'b0001;  // flush execute stage
            stall_vector = 4'b1110;  // stall fetch,prediciton and decode stages
        end
    end
endmodule

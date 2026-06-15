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
            flush everything except execution stage
            upon misprediction execution flushes itself already (so does the fetch by using signal exi.redirect)
            jump instructions also trigger flushing, we cant flush them as they write to registers
            */
            flush_vector = 4'b1110;
            stall_vector = 3'b0000;
        end else if (i_load_stall) begin
            flush_vector = 4'b0001;  // flush execute stage
            stall_vector = 4'b1110;  // stall fetch,prediciton and decode stages
        end
    end
endmodule

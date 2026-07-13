module stage_controller (
    input logic clk,
    input logic i_misprediction,
    input logic i_load_stall_type0,
    input logic i_load_stall_type1,
    input logic i_graphics_instruction_write_fail,
    output logic [0:4] flush_vector,
    output logic [0:4] stall_vector
);
    /*
        [0]       [1]        [2]      [4]     [3]
        fetch -> predict -> decode -> read -> execute -> memory -> write
    */
    /*
        i1,i2,i3 -- i3 is load instruction
        load stall type0 is triggered in read stage when a load instruction is followed by dependent instrucion (dependency exists between i3 & i2) 
        meanwhile load stall type1 is triggered in execution stage when dependency exists between i3 & i1
    */
    logic r_stall;
    always_comb begin
        flush_vector = 5'b0000;
        stall_vector = 5'b0000;
        if (i_misprediction) begin
            /*
            flush everything except fetch stage
            we are not flushing fetch stage since in a clock cycle where redirection is detected the next instruction
            is going to be fetched from calculated target address
            */
            flush_vector = 5'b01111;
            stall_vector = 5'b00000;
        end else if (i_load_stall_type0 | r_stall) begin  // stall fetch pred dec, flush read
            flush_vector = 5'b00001;
            stall_vector = 5'b11100;
        end else if (i_load_stall_type1) begin
            stall_vector = 5'b11101;
            flush_vector = 5'b00010;
        end else if (i_graphics_instruction_write_fail) begin
            flush_vector = 5'b00000;
            stall_vector = 5'b11111;
        end
    end
    always_ff @(posedge clk) begin
        r_stall <= 0;
        if (i_load_stall_type0) begin
            r_stall <= 1;
        end
    end
endmodule

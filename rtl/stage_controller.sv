module stage_controller (
    input logic i_flush,
    input logic i_stall,
    output logic [0:2] flush_vector,
    output logic [0:2] stall_vector
);
    always_comb begin
        flush_vector = 3'b000;
        stall_vector = 3'b000;
        if (i_flush) begin
            flush_vector = 3'b011;  // flush decode and execute stages
            stall_vector = 3'b000;
        end else if (i_stall) begin
            flush_vector = 3'b001;  // flush execute stage
            stall_vector = 3'b110;  // stall decode and fetch
        end
    end
endmodule

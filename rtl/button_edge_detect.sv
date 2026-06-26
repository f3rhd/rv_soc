module button_edge_detect (
    input clk,
    input logic i_btn,
    output logic o_edge
);
    logic sync_0, sync_1;
    logic btn_clean;
    logic btn_prev;
    always @(posedge clk) begin
        sync_0 <= i_btn;
        sync_1 <= sync_0;
    end

    reg [20:0] counter = 0;

    always @(posedge clk) begin : debouncer
        if (sync_1 != btn_clean) begin
            counter <= counter + 1;

            if (counter >= 2000000) begin
                btn_clean <= sync_1;
                counter   <= 0;
            end
        end else begin
            counter <= 0;
        end
    end
    always @(posedge clk) begin
        btn_prev <= btn_clean;
    end
    assign o_edge = btn_clean & ~btn_prev;
endmodule

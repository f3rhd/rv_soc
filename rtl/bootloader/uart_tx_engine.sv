module uart_tx_engine #(
    parameter unsigned DATA_WIDTH = 8,
    parameter unsigned BAUD_RATE = 115200,
    parameter unsigned SYSTEM_CLK_HZ = 100_000_000
) (
    input logic clk,
    input logic i_reset,
    input logic i_begin,
    input logic [DATA_WIDTH-1:0] i_data,
    output logic tx
);
    localparam unsigned CLKS_PER_BIT = SYSTEM_CLK_HZ / BAUD_RATE;
    typedef enum logic {
        IDLE,
        SEND
    } ux_state;
    ux_state state = IDLE;
    logic [DATA_WIDTH-1:0] data;
    logic [$clog2(DATA_WIDTH + 1)-1:0] sent_bit_counter = 0;
    logic [$clog2(CLKS_PER_BIT)-1:0] baud_counter = 0;

    always_ff @(posedge clk) begin
        if (i_reset) begin
            state            <= IDLE;
            tx               <= 1'b1;
            baud_counter     <= '0;
            sent_bit_counter <= '0;
            data             <= '0;
        end else begin
            case (state)
                IDLE: begin
                    data             <= 0;
                    tx               <= 1;
                    baud_counter     <= 0;
                    sent_bit_counter <= 0;
                    if (i_begin) begin
                        state <= SEND;
                        data  <= i_data;
                        tx    <= 0;
                    end
                end
                SEND: begin
                    if (baud_counter <= CLKS_PER_BIT - 1) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 0;
                        if (sent_bit_counter < DATA_WIDTH) begin
                            tx               <= data[0];
                            data             <= data >> 1;
                            sent_bit_counter <= sent_bit_counter + 1;
                        end else if (sent_bit_counter == DATA_WIDTH) begin
                            tx               <= 1'b1;
                            sent_bit_counter <= sent_bit_counter + 1;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule

`include "../include/bootloader_interface.svh"
module tx_engine #(
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
                    if (baud_counter <= CLKS_PER_BIT) begin
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
            endcase
        end
    end
endmodule
module rx_engine #(
    parameter SYSTEM_CLK_HZ = 100_000_000,
    parameter BAUD_RATE = 115200
) (
    input logic clk,
    input logic i_reset,
    input logic i_rx,
    output logic [7:0] o_byte_out,
    output logic o_byte_ready
);
    localparam unsigned CLKS_PER_BIT = SYSTEM_CLK_HZ / (BAUD_RATE);
    localparam unsigned PHASE1_WAIT = CLKS_PER_BIT * 2 - CLKS_PER_BIT / 2;
    typedef enum logic [1:0] {
        IDLE,
        READING_PHASE_1,
        READING_PHASE_2
    } rtx_state;
    logic [4:0] received_bit_counter = 0;
    logic [$clog2(PHASE1_WAIT)-1:0] phase1_counter = 0;
    logic [$clog2(CLKS_PER_BIT)-1:0] baud_counter = 0;
    rtx_state state = IDLE;

    always_ff @(posedge clk) begin
        if (i_reset) begin
            received_bit_counter <= 0;
            baud_counter         <= 0;
            o_byte_out           <= 0;
            o_byte_ready         <= 0;
            phase1_counter       <= 0;
            state                <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    received_bit_counter <= 0;
                    baud_counter         <= 0;
                    o_byte_out           <= 0;
                    o_byte_ready         <= 0;
                    if (i_rx == 0) begin
                        state <= READING_PHASE_1;
                    end
                end
                READING_PHASE_1: begin
                    if (phase1_counter < PHASE1_WAIT - 1) begin
                        phase1_counter <= phase1_counter + 1;
                    end else begin
                        o_byte_out           <= o_byte_out >> 1;
                        o_byte_out[7]        <= i_rx;
                        phase1_counter       <= 0;
                        received_bit_counter <= received_bit_counter + 1;
                        state                <= READING_PHASE_2;
                    end
                end
                READING_PHASE_2: begin
                    if (baud_counter < CLKS_PER_BIT - 1) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        if (received_bit_counter < 8) begin
                            baud_counter         <= 0;
                            received_bit_counter <= received_bit_counter + 1;
                            o_byte_out           <= o_byte_out >> 1;
                            o_byte_out[7]        <= i_rx;
                        end else if (received_bit_counter == 8) begin
                            baud_counter         <= 0;
                            received_bit_counter <= received_bit_counter + 1;
                        end else begin
                            o_byte_ready <= 1;
                            state        <= IDLE;
                        end
                    end
                end
            endcase
        end
    end
endmodule
module bootloader #(
    parameter SYSTEM_CLK_HZ = 100_000_000,
    parameter BAUD_RATE = 115200
) (
    input logic clk,
    input logic i_reset,
    bootloader_if.bootloader bootloader_if
);
    typedef enum logic [1:0] {
        IDLE,
        GET_PROGRAM_SIZE,
        INSTRUCTION_BUILD
    } bootloader_state;
    bootloader_state state = IDLE;

    localparam unsigned BOOT_SIGNAL = 'h69;
    logic [7:0] rx_byte_out;
    logic rx_byte_ready;
    logic tx_begin;
    logic [2:0] instruction_byte_counter;

    logic [31:0] program_size;
    logic [2:0] program_size_byte_counter;

    logic [31:0] sent_instruction_counter;

    logic [7:0] tx_data;
    rx_engine #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */),
        .BAUD_RATE    (BAUD_RATE  /* default 115200 */)
    ) rx_engine (
        .clk         (clk),
        .i_reset     (i_reset),
        .i_rx        (bootloader_if.rx),
        .o_byte_out  (rx_byte_out),
        .o_byte_ready(rx_byte_ready)
    );
    tx_engine #(
        .DATA_WIDTH   (8  /* default 8 */),
        .BAUD_RATE    (BAUD_RATE  /* default 115200 */),
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */)
    ) tx_engine (
        .clk    (clk),
        .i_reset(i_reset),
        .i_begin(tx_begin),
        .i_data (tx_data),
        .tx     (bootloader_if.tx)
    );
    always_ff @(posedge clk) begin
        if (i_reset) begin
            bootloader_if.instruction       <= 0;
            bootloader_if.instruction_ready <= 0;
            bootloader_if.execute           <= 0;
            program_size                    <= 0;
            program_size_byte_counter       <= 0;
            sent_instruction_counter        <= 0;
            state                           <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    tx_begin                        <= 0;
                    instruction_byte_counter        <= 0;
                    program_size                    <= 0;
                    program_size_byte_counter       <= 0;
                    sent_instruction_counter        <= 0;
                    bootloader_if.instruction       <= 0;
                    bootloader_if.instruction_ready <= 0;
                    bootloader_if.execute           <= 0;
                    if (bootloader_if.bootloader_begin) begin
                        tx_begin <= 1;
                        tx_data  <= BOOT_SIGNAL;
                        state    <= GET_PROGRAM_SIZE;
                    end
                end
                GET_PROGRAM_SIZE: begin
                    tx_begin <= 0;
                    if (rx_byte_ready) begin
                        program_size[(3-program_size_byte_counter)*8 +: 8] <= rx_byte_out;
                        if (program_size_byte_counter == 3) begin
                            program_size_byte_counter <= 0;
                            state                     <= INSTRUCTION_BUILD;
                        end else begin
                            program_size_byte_counter <= program_size_byte_counter + 1;
                        end
                    end
                end
                INSTRUCTION_BUILD: begin
                    tx_begin                        <= 0;
                    bootloader_if.instruction_ready <= 0;

                    if (sent_instruction_counter >= program_size) begin
                        bootloader_if.execute <= 1;
                        state                 <= IDLE;
                    end else if (rx_byte_ready) begin
                        bootloader_if.instruction[(3-instruction_byte_counter)*8 +: 8] <= rx_byte_out;
                        if (instruction_byte_counter == 3) begin
                            instruction_byte_counter <= 0;
                            bootloader_if.instruction_ready <= 1;
                            sent_instruction_counter <= sent_instruction_counter + 4;
                        end else begin
                            instruction_byte_counter <= instruction_byte_counter + 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule

/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "bootloader_interface.svh"
module uart_controller #(
  parameter SYSTEM_CLK_HZ = 100_000_000,
  parameter BAUD_RATE     = 115200
) (
  input logic                    clk,
  input logic                    i_reset,
        bootloader_if.bootloader bootloader_if,
        uart_if.uart             uart_if
);
  typedef enum logic [2:0] {
    IDLE,
    CORE_RESET,
    SEND_BOOT_SIGNAL,
    GET_STREAM_SIZE,
    STREAM_BUILD,
    STATIC_DATA_SIGNAL_SEND,
    FREE
  } uart_state;
  uart_state state = IDLE;

  localparam unsigned BEGIN_SIGNAL = 'h72;
  localparam unsigned BOOT_SIGNAL = 'h69;
  localparam unsigned MEMORY_SIGNAL = 'h31;
  logic [ 7:0] rx_byte_out;
  logic        rx_byte_ready;
  logic        tx_begin;
  logic [ 2:0] stream_byte_counter;

  logic [31:0] stream_size;
  logic [ 2:0] stream_size_byte_counter;

  logic [31:0] sent_instruction_bytes_counter;

  logic [ 7:0] tx_data;
  logic        static_data_phase;
  uart_rx_engine #(
    .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */),
    .BAUD_RATE    (BAUD_RATE  /* default 115200 */)
  ) rx_engine (
    .clk         (clk),
    .i_reset     (i_reset),
    .i_rx        (uart_if.rx),
    .o_byte_out  (rx_byte_out),
    .o_byte_ready(rx_byte_ready)
  );
  logic tx_ready;
  logic tx_ready_prev;
  always_ff @(posedge clk) begin
    tx_ready_prev <= tx_ready;
  end
  uart_tx_engine #(
    .DATA_WIDTH   (8  /* default 8 */),
    .BAUD_RATE    (BAUD_RATE  /* default 115200 */),
    .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */)
  ) tx_engine (
    .clk    (clk),
    .i_reset(i_reset),
    .i_begin(tx_begin),
    .i_data (tx_data),
    .tx     (uart_if.tx),
    .o_ready(tx_ready)
  );
  logic                                        write_buffer_advance_head;
  logic                                  [7:0] write_buffer_out;
  logic                                        write_buffer_out_valid;
  enum logic [1:0] {SEND_WRITE, WAIT_TX}       write_state;
  assign write_buffer_advance_head = !tx_ready_prev && tx_ready && state == FREE && write_state == WAIT_TX && write_buffer_out_valid;
  wire fifo_reset = i_reset | state == IDLE;
  fifo #(
    .BUFFER_SIZE(1024),
    .DATA_WIDTH (8)
  ) uart_write_buffer (
    .clk                (clk),
    .i_reset            (fifo_reset),
    .i_data             (uart_if.write_byte_data),
    .i_instruction_write(uart_if.write_byte_enable),
    .i_advance_head     (write_buffer_advance_head),
    .o_data             (write_buffer_out),
    .o_data_is_valid    (write_buffer_out_valid),
    .o_buffer_is_full   (uart_if.uart_write_buffer_full),
    .o_empty            ()                                 // ignored intentionally
  );
  logic                                       read_buffer_empty;
  logic                                 [7:0] read_buffer_out;
  logic                                       read_buffer_advance_head;
  logic                                       read_buffer_out_valid;

  enum logic {READ_IDLE, READ_REGISTER}       read_state;
  assign read_buffer_advance_head = read_state == READ_REGISTER;
  fifo #(
    .BUFFER_SIZE(1024  /* default 256 * 4 */),
    .DATA_WIDTH (8  /* default 32 */)
  ) uart_read_buffer (
    .clk                (clk),
    .i_reset            (fifo_reset),
    .i_data             (rx_byte_out),
    .i_instruction_write(rx_byte_ready && state == FREE),
    .i_advance_head     (read_buffer_advance_head),
    .o_data             (read_buffer_out),
    .o_data_is_valid    (read_buffer_out_valid),
    .o_buffer_is_full   (),                                // ignored intentionally
    .o_empty            (read_buffer_empty)
  );
  always_ff @(posedge clk) begin
    if (i_reset) begin
      bootloader_if.data              <= 0;
      bootloader_if.instruction_ready <= 0;
      bootloader_if.load_done         <= 0;
      stream_size                     <= 0;
      stream_size_byte_counter        <= 0;
      sent_instruction_bytes_counter  <= 0;
      bootloader_if.core_reset        <= 0;
      static_data_phase               <= 0;
      state                           <= IDLE;
      write_state                     <= SEND_WRITE;
      read_state                      <= READ_IDLE;
    end
    else begin
      tx_begin                        <= 0;
      bootloader_if.instruction_ready <= 0;
      bootloader_if.static_data_ready <= 0;
      bootloader_if.core_reset        <= 0;
      uart_if.read_result_ready       <= 0;
      case (state)
        IDLE: begin
          if (rx_byte_ready && rx_byte_out == BEGIN_SIGNAL) begin
            // Each time we load a new program we should set this flag to 0
            // So fetch unit in the processor can write the program to its data memory
            bootloader_if.load_done <= 0;
            state                   <= CORE_RESET;
          end
        end
        CORE_RESET: begin
          stream_byte_counter            <= 0;
          stream_size                    <= 0;
          stream_size_byte_counter       <= 0;
          sent_instruction_bytes_counter <= 0;
          bootloader_if.data             <= 0;
          static_data_phase              <= 0;
          bootloader_if.core_reset       <= 1;
          read_state                     <= READ_IDLE;
          write_state                    <= SEND_WRITE;
          state                          <= SEND_BOOT_SIGNAL;
        end
        SEND_BOOT_SIGNAL: begin
          tx_begin <= 1;
          tx_data  <= BOOT_SIGNAL;
          state    <= GET_STREAM_SIZE;
        end
        GET_STREAM_SIZE: begin
          if (rx_byte_ready) begin
            stream_size[(3-stream_size_byte_counter)*8+:8] <= rx_byte_out;
            if (stream_size_byte_counter == 3) begin
              stream_size_byte_counter <= 0;
              state                    <= STREAM_BUILD;
            end
            else begin
              stream_size_byte_counter <= stream_size_byte_counter + 1;
            end
          end
        end
        STREAM_BUILD: begin
          if (sent_instruction_bytes_counter >= stream_size) begin
            state <= static_data_phase ? FREE : STATIC_DATA_SIGNAL_SEND;
            if (static_data_phase) begin
              bootloader_if.load_done <= 1;
            end
            sent_instruction_bytes_counter <= 0;
            stream_byte_counter            <= 0;
          end
          else if (rx_byte_ready) begin
            bootloader_if.data[(3-stream_byte_counter)*8+:8] <= rx_byte_out;
            if (stream_byte_counter == 3) begin
              stream_byte_counter <= 0;
              if (!static_data_phase) begin
                bootloader_if.instruction_ready <= 1;
              end
              else begin
                bootloader_if.static_data_ready <= 1;
              end

              sent_instruction_bytes_counter <= sent_instruction_bytes_counter + 4;
            end
            else begin
              stream_byte_counter <= stream_byte_counter + 1;
            end
          end
        end
        STATIC_DATA_SIGNAL_SEND: begin
          tx_begin          <= 1;
          tx_data           <= MEMORY_SIGNAL;
          state             <= GET_STREAM_SIZE;
          static_data_phase <= 1;
        end
        FREE: begin
          case (write_state)
            SEND_WRITE: begin
              if (write_buffer_out_valid && tx_ready) begin
                tx_begin    <= 1;
                tx_data     <= write_buffer_out;
                write_state <= WAIT_TX;
              end
            end
            WAIT_TX: begin
              if (!tx_ready_prev && tx_ready) begin
                write_state <= SEND_WRITE;
              end
            end
            default: ;
          endcase
          case (read_state)
            READ_IDLE: begin
              if (uart_if.read_request) begin
                uart_if.serial_avail <= !read_buffer_empty;
                if (read_buffer_empty) begin
                  uart_if.read_result_ready <= 1;
                  uart_if.read_result       <= 8'hFF;
                end
                else begin
                  read_state <= READ_REGISTER;
                end
              end
            end
            READ_REGISTER: begin
              uart_if.read_result_ready <= 1;
              uart_if.read_result       <= read_buffer_out;
              read_state                <= READ_IDLE;
            end
            default: ;
          endcase
        end
        default: state <= IDLE;
      endcase
    end
  end
endmodule

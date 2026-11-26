`ifndef UART_INTERFACE_SVH
`define UART_INTERFACE_SVH 
interface uart_if;
  logic [7:0] write_byte_data;
  logic       write_byte_enable;
  logic       uart_write_buffer_full;
  logic       serial_avail;
  logic       read_request;
  logic [7:0] read_result;
  logic       read_result_ready;
  logic       rx;
  logic       tx;
  modport processor(
    output write_byte_data, write_byte_enable, read_request,
    input uart_write_buffer_full, serial_avail, read_result, read_result_ready
  );
  modport uart(
    input write_byte_data, write_byte_enable, read_request, rx,
    output uart_write_buffer_full, tx, serial_avail, read_result, read_result_ready
  );
endinterface
`endif

`ifndef GRAPHICS_DECODE_OUTPUT_SVH
`define GRAPHICS_DECODE_OUTPUT_SVH
typedef enum logic [1:0] {
    INVALID,
    CASET,
    RASET,
    RAMWR
} command_type;
typedef struct packed {
    logic [31:0] instruction;
    logic is_command; // if it is not command it is raw pixel data
    logic valid;
    command_type command_type;
} graphics_decode_output_t;
`endif

`ifndef GPIO_INTERFACE_SVH
`define GPIO_INTERFACE_SVH
interface gpio_if;
    logic [4:0] pin_id;
    logic pin_mode;
    logic pin_drive_val;
    logic pin_read_val;
    logic pin_drive_enable;
    logic pin_set_enable;
    logic pin_read_enable;
    logic pin_read_done;
    modport processor (
        output pin_mode,
        output pin_drive_val,
        output pin_id,
        output pin_set_enable,
        output pin_drive_enable,
        output pin_read_enable,
        input  pin_read_val,
        input pin_read_done
    );
    modport controller (
        input pin_mode,
        input pin_drive_val,
        input pin_read_enable,
        input pin_id,
        input pin_set_enable,
        input pin_drive_enable,
        output pin_read_val,
        output pin_read_done
    );
endinterface
`endif

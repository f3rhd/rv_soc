import serial
import time
import sys

SERIAL_PORT = 'COM3'
BAUD_RATE   =  115200     

BEGIN_SIGNAL = b'\x72'
BOOT_SIGNAL = b'\x69'
STATIC_DATA_SIGNAL = b'\x31'

def wait_and_send_data(ser, signal_byte, signal_name, file_path):
    while True:
        print(f"Waiting for a {signal_name} signal...")
        byte = ser.read(1)
        if not byte:
            continue
        if byte == signal_byte:          
            print(f"{signal_name.capitalize()} signal received.\nSending data...")
            break
        else:
            print(f"  (unexpected byte: {byte.hex()} — still waiting)")

    with open(file_path, 'r') as f:  
        hex_content = f.read()
    
    cleaned_hex = ''.join(hex_content.split())
    data = bytes.fromhex(cleaned_hex)

    total = len(data)
    print(f"Sending {total} byte(s) from '{file_path}'...")

    for i in total.to_bytes(4, 'big'):
        ser.write(bytes([i]))
        time.sleep(0.00001)

    for i, b in enumerate(data):
        ser.write(bytes([b]))
        time.sleep(0.00001)
        print(f"  [{i+1:>4}/{total}] sent 0x{b:02X}")


def send_program():
    if len(sys.argv) < 3:
        print("Error: Please provide both hex file paths.")
        print("Usage: python3 sender.py <program.hex> <memory.hex>")
        return

    program_hex_path = sys.argv[1]  
    memory_hex_path = sys.argv[2]

    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=5)
        print(f"Connected to {SERIAL_PORT} @ {BAUD_RATE} baud")
        time.sleep(2)

        ser.write(BEGIN_SIGNAL)
        print("Sent begin signal to the core.")
        wait_and_send_data(ser, BOOT_SIGNAL, "boot", program_hex_path)
        wait_and_send_data(ser, STATIC_DATA_SIGNAL, "static data", memory_hex_path)

        ser.close()
        print("Success")

    except FileNotFoundError as e:
        print(f"Error: File not found. Check your file name or path. ({e})")
    except ValueError:
        print("Error: One of your files contains invalid non-hex characters.")
    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")


if __name__ == "__main__":
    send_program()
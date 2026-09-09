import serial
import time
import sys
import os

SERIAL_PORT = 'COM3'
BAUD_RATE   =  115200

BEGIN_SIGNAL = b'\x72'
BOOT_SIGNAL = b'\x69'
STATIC_DATA_SIGNAL = b'\x31'


def validate_hex_file(file_path):
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"'{file_path}' does not exist.")

    if not os.path.isfile(file_path):
        raise ValueError(f"'{file_path}' is not a regular file.")

    try:
        with open(file_path, 'r') as f:
            hex_content = f.read()
    except UnicodeDecodeError:
        raise ValueError(f"'{file_path}' is not a valid text/hex file (binary content detected).")

    cleaned_hex = ''.join(hex_content.split())

    if len(cleaned_hex) % 2 != 0:
        raise ValueError(f"'{file_path}' has an odd number of hex digits ({len(cleaned_hex)}); "
                          f"each byte needs two hex characters.")

    if not all(c in '0123456789abcdefABCDEF' for c in cleaned_hex):
        bad_chars = sorted(set(c for c in cleaned_hex if c not in '0123456789abcdefABCDEF'))
        raise ValueError(f"'{file_path}' contains non-hex characters: {bad_chars}")

    try:
        data = bytes.fromhex(cleaned_hex)
    except ValueError as e:
        raise ValueError(f"'{file_path}' could not be parsed as hex: {e}")

    return data


def wait_and_send_data(ser, signal_byte, signal_name, data, file_path):
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
        print(f"Validating '{program_hex_path}'...")
        program_data = validate_hex_file(program_hex_path)
        print(f"  OK — {len(program_data)} byte(s) of valid hex data.")

        print(f"Validating '{memory_hex_path}'...")
        memory_data = validate_hex_file(memory_hex_path)
        print(f"  OK — {len(memory_data)} byte(s) of valid hex data.")
    except FileNotFoundError as e:
        print(f"Error: File not found. Check your file name or path. ({e})")
        return
    except ValueError as e:
        print(f"Error: Invalid hex file. ({e})")
        return

    print("Both files validated successfully. Proceeding to connect and handshake...\n")

    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=5)
        print(f"Connected to {SERIAL_PORT} @ {BAUD_RATE} baud")

        ser.write(BEGIN_SIGNAL)
        print("Sent begin signal to the core.")
        wait_and_send_data(ser, BOOT_SIGNAL, "boot", program_data, program_hex_path)
        wait_and_send_data(ser, STATIC_DATA_SIGNAL, "static data", memory_data, memory_hex_path)

        ser.close()
        print("Success")

    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")


if __name__ == "__main__":
    send_program()
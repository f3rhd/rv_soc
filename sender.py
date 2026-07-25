import serial
import time
import sys  

SERIAL_PORT = 'COM3'
BAUD_RATE   =  115200     

BOOT_SIGNAL = b'\x69'

def send_program():
    if len(sys.argv) < 2:
        print("Error: Please provide the hex file path.")
        print("Usage: python3 sender.py <program.hex>")
        return

    file_path = sys.argv[1]  

    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=5)
        print(f"Connected to {SERIAL_PORT} @ {BAUD_RATE} baud")

        time.sleep(2)

        
        while True:
            print("Waiting for a boot signal...")
            byte = ser.read(1)
            if not byte:
                continue;
            if byte == BOOT_SIGNAL:          
                print("Boot signal received.\nSending program...")
                break
            else:
                print(f"  (unexpected byte: {byte.hex()} — still waiting)")

        with open(file_path, 'r') as f:  
            hex_content = f.read()
        
        cleaned_hex = ''.join(hex_content.split())
        data = bytes.fromhex(cleaned_hex)

        total = len(data)
        print(f"Sending {total} byte(s) from '{file_path}'...")

        for i in total.to_bytes(4,'big'):
            ser.write(bytes([i]))
            time.sleep(0.00001)

        for i, b in enumerate(data):
            ser.write(bytes([b]))
            time.sleep(0.00001)
            print(f"  [{i+1:>4}/{total}] sent 0x{b:02X}")

        ser.close()

    except FileNotFoundError:
        print(f"Error: '{file_path}' not found. Check your file name or path.")
    except ValueError:
        print(f"Error: '{file_path}' contains invalid non-hex characters.")
    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    send_program()

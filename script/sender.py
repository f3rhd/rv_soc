import serial
import time

SERIAL_PORT = 'COM3'  
BAUD_RATE = 115200
FILE_PATH = 'program.bin'

def send_program():
    try:
        # Open the serial connection
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
        print(f"Connected to {SERIAL_PORT}")
        
        # Give the FPGA a moment to reset/initialize
        time.sleep(2) 

        # 2. Wait for a "Ready" signal from your FPGA
        # Your FPGA should send something like 'R' when it's ready
        print("Waiting for FPGA ready signal...")
        while True:
            if ser.in_waiting > 0:
                signal = ser.read().decode('ascii')
                if signal == 'R':
                    print("FPGA is ready! Sending program...")
                    break

        # 3. Send the file byte by byte
        with open(FILE_PATH, 'rb') as f:
            data = f.read()
            ser.write(data)
            print(f"Sent {len(data)} bytes.")

        # 4. Optional: Wait for an "OK" from FPGA
        print("Done! Closing connection.")
        ser.close()

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    send_program()
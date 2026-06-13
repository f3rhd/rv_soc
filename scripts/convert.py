# Little script to change the endiannes of the hex files
import sys

def convert_hex_file(input_filename, output_filename):
    try:
        with open(input_filename, 'r') as infile, open(output_filename, 'w') as outfile:
            for line_num, line in enumerate(infile, 1):
                bytes_list = line.strip().split()
                
                if not bytes_list:
                    continue
                
                if len(bytes_list) != 4:
                    print(f"Warning: Line {line_num} does not have exactly 4 bytes. Skipping: '{line.strip()}'")
                    continue
                
                reversed_bytes = bytes_list[::-1]
                fixed_line = "".join(reversed_bytes)
                
                outfile.write(fixed_line + '\n')
                
        print(f"Success! Converted file saved as '{output_filename}'")
    except FileNotFoundError:
        print(f"Error: The file '{input_filename}' could not be found. Double check your spelling, babe!")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python convert.py <input_file> <output_file>")
        print("Example: python convert.py raw_data.txt mem_init.hex")
        sys.exit(1)
        
    # Grab the filenames from the terminal command
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    convert_hex_file(input_file, output_file)
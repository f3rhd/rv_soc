#!/usr/bin/env bash
# ============================================================
#  build.sh - RV32IM freestanding C build (multi-TU, Harvard)
#  Usage: build.sh [options] <src1.c> [src2.c ...] [O0|O1|O2|O3|Os|Ofast]
#  Options:
#    -o <name>    Specify custom base name for output files
#
#  Produces TWO separate hex images (instruction memory and
#  data memory are physically separate on this core):
#     <base>_imem.hex   -> .text                (code only)
#     <base>_dmem.hex   -> .rodata/.data/.sdata/.bss (globals)
# ============================================================

set -u

SOURCES=()
CUSTOM_BASENAME=""
OPTLEVEL=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        -o)
            if [ -n "${2:-}" ]; then
                CUSTOM_BASENAME="$2"
                shift 2
            else
                echo "ERROR: -o requires a filename argument."
                exit 1
            fi
            ;;
        *)
            LOWER_ARG="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
            case "$LOWER_ARG" in
                o0|o1|o2|o3|os|ofast)
                    OPTLEVEL="$1"
                    shift
                    ;;
                *)
                    SOURCES+=("$1")
                    shift
                    ;;
            esac
            ;;
    esac
done

# Set defaults if not provided
if [ -z "$OPTLEVEL" ]; then
    OPTLEVEL="O0"
fi

SRCCOUNT=${#SOURCES[@]}

if [ "$SRCCOUNT" -eq 0 ]; then
    echo "Usage: build.sh [-o custom_name] <src1.c> [src2.c ...] [O0|O1|O2|O3|Os|Ofast]"
    exit 1
fi

# Validate sources exist
for SRC in "${SOURCES[@]}"; do
    if [ ! -e "$SRC" ]; then
        echo "ERROR: source file \"$SRC\" not found."
        exit 1
    fi
done

OPTFLAG="-$OPTLEVEL"

# ============================================================
#  Memory geometry - EDIT THESE ONLY. Everything else derives
#  from these values, so re-synthesizing with a different
#  depth/width just means changing a number here once.
# ============================================================

# Instruction memory: IMEM_SIZE = IMEM_DEPTH * IMEM_UNIT bytes
IMEM_DEPTH=1024
IMEM_UNIT=32
IMEM_BASE=0x00000000

# Data memory: DMEM_SIZE = DMEM_DEPTH * DMEM_UNIT * DMEM_MULT bytes
DMEM_DEPTH=1024
DMEM_UNIT=32
DMEM_MULT=4
DMEM_BASE=0x00000000

# KB of DMEM carved out at the bottom for globals/statics
# (.rodata + .data + .sdata + .bss + .sbss). The rest of DMEM,
# from the top down, is stack.
STATIC_RESERVE_KB=4

IMEM_SIZE=$((IMEM_DEPTH * IMEM_UNIT))
DMEM_SIZE=$((DMEM_DEPTH * IMEM_UNIT * DMEM_MULT))
STATIC_RESERVE=$((STATIC_RESERVE_KB * 1024))

if [ "$STATIC_RESERVE" -ge "$DMEM_SIZE" ]; then
    echo "ERROR: STATIC_RESERVE ($STATIC_RESERVE bytes) >= DMEM_SIZE ($DMEM_SIZE bytes)."
    echo "       Leave room for a stack."
    exit 1
fi

GCC="riscv64-unknown-elf-gcc"
OBJCOPY="riscv64-unknown-elf-objcopy"
OBJDUMP="riscv64-unknown-elf-objdump"
NM="riscv64-unknown-elf-nm"

command -v "$GCC" >/dev/null 2>&1 || { echo "ERROR: $GCC not found in PATH."; exit 1; }
command -v "$OBJCOPY" >/dev/null 2>&1 || { echo "ERROR: $OBJCOPY not found in PATH."; exit 1; }
command -v "$OBJDUMP" >/dev/null 2>&1 || { echo "ERROR: $OBJDUMP not found in PATH."; exit 1; }

# Determine output base name (custom or derived from first source)
if [ -n "$CUSTOM_BASENAME" ]; then
    BASENAME="$CUSTOM_BASENAME"
else
    FIRST_SRC="${SOURCES[0]}"
    BASE_NOEXT="$(basename "$FIRST_SRC")"
    BASENAME="${BASE_NOEXT%.*}"
fi

OUT_ASM="${BASENAME}.s"
OUT_IMEM_HEX="${BASENAME}_imem.hex"
OUT_DMEM_HEX="${BASENAME}_dmem.hex"

STARTUP_S="__startup_tmp.s"
STARTUP_O="__startup_tmp.o"
LDSCRIPT="__link_tmp.ld"
ELF="__out_tmp.elf"
IMEM_BIN="__out_tmp_imem.bin"
DMEM_BIN="__out_tmp_dmem.bin"
BIN2HEX_PY_HIGH_ENDIAN="__bin2hex_tmp_high_endian.py"
BIN2HEX_PY_LITTLE_ENDIAN="__bin2hex_tmp_little_endian.py"
SENDER="__sender.py"

CFLAGS="-march=rv32imf -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables"

OBJLIST=()
TMPFILELIST=()

cleanup() {
    for F in "$STARTUP_S" "$STARTUP_O" "$LDSCRIPT" "$ELF" "$IMEM_BIN" "$DMEM_BIN" "$BIN2HEX_PY_LITTLE_ENDIAN" "$BIN2HEX_PY_HIGH_ENDIAN"; do
        [ -e "$F" ] && rm -f "$F"
    done
    for F in "${TMPFILELIST[@]:-}"; do
        [ -n "$F" ] && [ -e "$F" ] && rm -f "$F"
    done
    for F in __tu*_tmp.o; do
        [ -e "$F" ] && rm -f "$F"
    done
}

build_error() {
    echo
    echo "BUILD FAILED."
    cleanup
    exit 1
}

cleanup

# ------------------------------------------------------------
# Startup code: sets gp (for gp-relative small-data access),
# then sp (top of DMEM), then jumps into main.
# ------------------------------------------------------------
cat > "$STARTUP_S" <<'EOF'
    .section .text.start,"ax"
    .globl _start
_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    la sp, __stack_top

    call main
halt_loop:
    j halt_loop
EOF

# shellcheck disable=SC2086
"$GCC" $CFLAGS $OPTFLAG -c "$STARTUP_S" -o "$STARTUP_O" || build_error

OBJLIST+=("$STARTUP_O")

for ((I=0; I<SRCCOUNT; I++)); do
    THISSRC="${SOURCES[$I]}"
    OBJ="__tu$((I+1))_tmp.o"

    # shellcheck disable=SC2086
    "$GCC" $CFLAGS $OPTFLAG -c "$THISSRC" -o "$OBJ" || build_error

    OBJLIST+=("$OBJ")
    TMPFILELIST+=("$OBJ")
done

# ------------------------------------------------------------
# Linker script: two distinct memory regions (Harvard).
# ------------------------------------------------------------
cat > "$LDSCRIPT" <<EOF
ENTRY(_start)

MEMORY
{
    IMEM (rx) : ORIGIN = $IMEM_BASE, LENGTH = $IMEM_SIZE
    DMEM (rw) : ORIGIN = $DMEM_BASE, LENGTH = $DMEM_SIZE
}

__static_reserve = $STATIC_RESERVE;
__stack_top      = ALIGN(ORIGIN(DMEM) + LENGTH(DMEM), 32);

SECTIONS
{
    . = ORIGIN(IMEM);
    .text : { KEEP(*(.text.start)) *(.text*) } > IMEM

    . = ORIGIN(DMEM);
    .rodata : { *(.rodata .rodata.*) } > DMEM
    .data   : { *(.data .data.*) } > DMEM

    .sdata : {
        . = ALIGN(32);
        PROVIDE(__global_pointer\$ = . + 0x800);
        *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
        *(.sdata .sdata.*) *(.gnu.linkonce.s.*)
    } > DMEM

    .bss : {
        *(.sbss .sbss.*) *(.gnu.linkonce.sb.*)
        *(.bss .bss.*)
        *(COMMON)
    } > DMEM

    __static_end  = .;
    __static_used = __static_end - ORIGIN(DMEM);
}

ASSERT(__static_used <= __static_reserve, "ERROR: global/static data footprint exceeds STATIC_RESERVE_KB budget - shrink your globals or raise the reserve in build.sh")
EOF

"$GCC" $CFLAGS $OPTFLAG -nostartfiles -T "$LDSCRIPT" -Wl,-e,_start -Wl,--gc-sections -Wl,--no-check-sections -o "$ELF" "${OBJLIST[@]}" || build_error

"$OBJDUMP" -d "$ELF" > "$OUT_ASM" || build_error


"$OBJCOPY" -O binary -j .text "$ELF" "$IMEM_BIN" || build_error
"$OBJCOPY" -O binary -j .rodata -j .data -j .sdata -j .bss "$ELF" "$DMEM_BIN" || build_error

cat > "$BIN2HEX_PY_HIGH_ENDIAN" <<'EOF'
import sys

bin_file, hex_file = sys.argv[1], sys.argv[2]

with open(bin_file, "rb") as f:
    data = f.read()

pad = (4 - (len(data) % 4)) % 4
if pad:
    data += b"\x00" * pad

lines = []
for i in range(0, len(data), 4):
    b0, b1, b2, b3 = data[i], data[i+1], data[i+2], data[i+3]
    lines.append("{:02x}{:02x}{:02x}{:02x}".format(b3, b2, b1, b0))

with open(hex_file, "w", newline="\n") as f:
    f.write("\n".join(lines))
EOF
cat > "$BIN2HEX_PY_LITTLE_ENDIAN" <<'EOF'
import sys

bin_file, hex_file = sys.argv[1], sys.argv[2]

with open(bin_file, "rb") as f:
    data = f.read()

pad = (4 - (len(data) % 4)) % 4
if pad:
    data += b"\x00" * pad

lines = []
for i in range(0, len(data), 4):
    b0, b1, b2, b3 = data[i], data[i+1], data[i+2], data[i+3]
    lines.append("{:02x}{:02x}{:02x}{:02x}".format(b0, b1, b2, b3))

with open(hex_file, "w", newline="\n") as f:
    f.write("\n".join(lines))
EOF
python3 "$BIN2HEX_PY_HIGH_ENDIAN" "$IMEM_BIN" "$OUT_IMEM_HEX" || build_error
python3 "$BIN2HEX_PY_LITTLE_ENDIAN" "$DMEM_BIN" "$OUT_DMEM_HEX" || build_error

echo
echo "Build succeeded ($SRCCOUNT source file(s), optimization $OPTLEVEL):"
echo "  $OUT_ASM"
echo "  $OUT_IMEM_HEX   (IMEM, $IMEM_SIZE bytes total)"
echo "  $OUT_DMEM_HEX   (DMEM, $DMEM_SIZE bytes total, $STATIC_RESERVE bytes reserved for statics)"
echo

if command -v "$NM" >/dev/null 2>&1; then
    echo "Symbol check:"
    "$NM" "$ELF" 2>/dev/null | grep -E '__static_used|__static_reserve|__global_pointer|__stack_top' | sort -k3
    echo
fi

cleanup

cat > "$SENDER" <<'EOF'
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
EOF
echo "Launching sender..."
python3 $SENDER "$OUT_IMEM_HEX" "$OUT_DMEM_HEX"

if [ -z "$CUSTOM_BASENAME" ]; then
    rm -f "$OUT_ASM" "$OUT_IMEM_HEX" "$OUT_DMEM_HEX"
fi
rm $SENDER
exit 0
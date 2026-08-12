#!/usr/bin/env bash
# ============================================================
#  build.sh - RV32IM freestanding C build (multi-TU)
#  Usage: build.sh <src1.c> [src2.c ...] [O0|O1|O2|O3|Os]
# ============================================================

set -u

ARGS=("$@")
N=${#ARGS[@]}

if [ "$N" -eq 0 ]; then
    echo "Usage: build.sh <src1.c> [src2.c ...] [O0|O1|O2|O3|Os]"
    exit 1
fi

# --- detect trailing optimization level (case-insensitive) ---
LASTVAL="${ARGS[$((N-1))]}"
OPTLEVEL=""
for L in O0 O1 O2 O3 Os; do
    if [ "$(printf '%s' "$LASTVAL" | tr '[:upper:]' '[:lower:]')" = "$(printf '%s' "$L" | tr '[:upper:]' '[:lower:]')" ]; then
        OPTLEVEL="$L"
    fi
done

if [ -n "$OPTLEVEL" ]; then
    SRCCOUNT=$((N - 1))
else
    OPTLEVEL="O0"
    SRCCOUNT=$N
fi

if [ "$SRCCOUNT" -eq 0 ]; then
    echo "ERROR: no source files provided."
    exit 1
fi

SOURCES=()
for ((I=0; I<SRCCOUNT; I++)); do
    SRC="${ARGS[$I]}"
    if [ ! -e "$SRC" ]; then
        echo "ERROR: source file \"$SRC\" not found."
        exit 1
    fi
    SOURCES+=("$SRC")
done

OPTFLAG="-$OPTLEVEL"

GCC="riscv64-unknown-elf-gcc"
OBJCOPY="riscv64-unknown-elf-objcopy"
OBJDUMP="riscv64-unknown-elf-objdump"

command -v "$GCC" >/dev/null 2>&1 || { echo "ERROR: $GCC not found in PATH."; exit 1; }
command -v "$OBJCOPY" >/dev/null 2>&1 || { echo "ERROR: $OBJCOPY not found in PATH."; exit 1; }
command -v "$OBJDUMP" >/dev/null 2>&1 || { echo "ERROR: $OBJDUMP not found in PATH."; exit 1; }

FIRST_SRC="${SOURCES[0]}"
BASE_NOEXT="$(basename "$FIRST_SRC")"
BASENAME="${BASE_NOEXT%.*}"
OUT_ASM="${BASENAME}.s"
OUT_HEX="${BASENAME}.hex"

STARTUP_S="__startup_tmp.s"
STARTUP_O="__startup_tmp.o"
LDSCRIPT="__link_tmp.ld"
ELF="__out_tmp.elf"
BIN="__out_tmp.bin"
BIN2HEX_PY="__bin2hex_tmp.py"

CFLAGS="-march=rv32imf -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables"

OBJLIST=()
TMPFILELIST=()

cleanup() {
    for F in "$STARTUP_S" "$STARTUP_O" "$LDSCRIPT" "$ELF" "$BIN" "$BIN2HEX_PY"; do
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

cat > "$STARTUP_S" <<'EOF'
    .section .text.start,"ax"
    .globl _start
_start:
    li sp, 0x8000
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

cat > "$LDSCRIPT" <<'EOF'
ENTRY(_start)
MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 32K
}
SECTIONS
{
    . = 0x00000000;
    .text : { KEEP(*(.text.start)) *(.text*) } > RAM
    .rodata : { *(.rodata*) } > RAM
    .data : { *(.data*) } > RAM
    .bss : { *(.bss*) *(COMMON) } > RAM
}
EOF

# shellcheck disable=SC2086
"$GCC" $CFLAGS $OPTFLAG -nostartfiles -T "$LDSCRIPT" -Wl,-e,_start -Wl,--gc-sections -o "$ELF" "${OBJLIST[@]}" || build_error

"$OBJDUMP" -d "$ELF" > "$OUT_ASM" || build_error

"$OBJCOPY" -O binary "$ELF" "$BIN" || build_error

cat > "$BIN2HEX_PY" <<'EOF'
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

python3 "$BIN2HEX_PY" "$BIN" "$OUT_HEX" || build_error

echo
echo "Build succeeded ($SRCCOUNT source file(s), optimization $OPTLEVEL):"
echo "  $OUT_ASM"
echo "  $OUT_HEX"

cleanup
exit 0
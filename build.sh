#!/usr/bin/env bash
# ============================================================
#  build.sh - RV32IM freestanding C build (multi-TU, Linux)
#  Usage: ./build.sh <src1.c> [src2.c ...] [O0|O1|O2|O3|Os]
# ============================================================

set -u

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <src1.c> [src2.c ...] [O0|O1|O2|O3|Os]"
    exit 1
fi

ARGS=("$@")
N=${#ARGS[@]}
LAST="${ARGS[$((N-1))]}"

OPTLEVEL=""
case "$LAST" in
    O0|O1|O2|O3|Os) OPTLEVEL="$LAST" ;;
esac

if [ -n "$OPTLEVEL" ]; then
    SOURCES=("${ARGS[@]:0:$((N-1))}")
else
    OPTLEVEL="O0"
    SOURCES=("${ARGS[@]}")
fi

if [ "${#SOURCES[@]}" -eq 0 ]; then
    echo "ERROR: no source files provided."
    exit 1
fi

for f in "${SOURCES[@]}"; do
    if [ ! -f "$f" ]; then
        echo "ERROR: source file \"$f\" not found."
        exit 1
    fi
done

OPTFLAG="-$OPTLEVEL"

GCC="riscv64-unknown-elf-gcc"
OBJCOPY="riscv64-unknown-elf-objcopy"

if ! command -v "$GCC" >/dev/null 2>&1; then
    echo "ERROR: $GCC not found in PATH."
    exit 1
fi
if ! command -v "$OBJCOPY" >/dev/null 2>&1; then
    echo "ERROR: $OBJCOPY not found in PATH."
    exit 1
fi

# ---------------- Output names derived from FIRST source file ----------------
FIRST_BASE="$(basename -- "${SOURCES[0]}")"
BASENAME="${FIRST_BASE%.*}"
OUT_ASM="${BASENAME}.s"
OUT_HEX="${BASENAME}.hex"

# ---------------- Temp workspace ----------------
TMPDIR="$(mktemp -d)"

STARTUP_S="$TMPDIR/startup.s"
STARTUP_O="$TMPDIR/startup.o"
LDSCRIPT="$TMPDIR/link.ld"
ELF="$TMPDIR/out.elf"
BIN="$TMPDIR/out.bin"

cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

build_error() {
    echo
    echo "BUILD FAILED."
    exit 1
}

clean_asm() {
    # $1 = input .s, $2 = output cleaned .s
    awk '
    {
        line = $0
        trimmed = line
        gsub(/^[ \t]+|[ \t]+$/, "", trimmed)

        if (trimmed == "") next
        if (trimmed ~ /^#/) next
        if (trimmed ~ /^\.L[0-9]+:$/) { print line; next }
        if (trimmed ~ /^\./) next

        print line
    }
    ' "$1" > "$2"
}

# ---------------- Step 1: startup assembly source ----------------
cat > "$STARTUP_S" <<'EOF'
    .section .text.start,"ax"
    .globl _start
_start:
    li sp, 0x8000
    call main
halt_loop:
    j halt_loop
EOF

"$GCC" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie $OPTFLAG -c "$STARTUP_S" -o "$STARTUP_O" || build_error

OBJLIST=("$STARTUP_O")

# ---------------- Step 2: compile each translation unit ----------------
{
    echo "_start:"
    echo "    li sp,0x8000"
    echo "    call main"
    echo
    echo "halt_loop:"
    echo "    j halt_loop"
    echo
} > "$OUT_ASM"

IDX=0
for SRC in "${SOURCES[@]}"; do
    IDX=$((IDX+1))
    OBJ="$TMPDIR/tu${IDX}.o"
    ASM="$TMPDIR/tu${IDX}.s"
    ASMCLEAN="$TMPDIR/tu${IDX}_clean.s"

    "$GCC" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie $OPTFLAG -c "$SRC" -o "$OBJ" || build_error
    "$GCC" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie $OPTFLAG -S "$SRC" -o "$ASM" || build_error

    clean_asm "$ASM" "$ASMCLEAN"

    {
        echo "# ---- file: $SRC ----"
        echo
        cat "$ASMCLEAN"
        echo
    } >> "$OUT_ASM"

    OBJLIST+=("$OBJ")
done

# ---------------- Step 3: linker script ----------------
cat > "$LDSCRIPT" <<'EOF'
ENTRY(_start)
MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 32K
}
SECTIONS
{
    . = 0x00000000;
    .text : { *(.text.start) *(.text*) } > RAM
    .rodata : { *(.rodata*) } > RAM
    .data : { *(.data*) } > RAM
    .bss : { *(.bss*) *(COMMON) } > RAM
}
EOF

# ---------------- Step 4: link all objects (resolves cross-file calls/branches) ----------------
"$GCC" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -nostartfiles $OPTFLAG -T "$LDSCRIPT" -Wl,-e,_start -o "$ELF" "${OBJLIST[@]}" || build_error

# ---------------- Step 5: extract raw binary ----------------
"$OBJCOPY" -O binary "$ELF" "$BIN" || build_error

# ---------------- Step 6: binary -> hex ----------------
python3 - "$BIN" "$OUT_HEX" <<'PYEOF'
import sys

bin_path, hex_path = sys.argv[1], sys.argv[2]

with open(bin_path, "rb") as f:
    data = f.read()

pad = (-len(data)) % 4
if pad:
    data += b"\x00" * pad

lines = []
for i in range(0, len(data), 4):
    b0, b1, b2, b3 = data[i], data[i + 1], data[i + 2], data[i + 3]
    word = f"{b3:02x}{b2:02x}{b1:02x}{b0:02x}"
    lines.append(word)

with open(hex_path, "w") as f:
    f.write("\n".join(lines))
    if lines:
        f.write("\n")
PYEOF
[ $? -eq 0 ] || build_error

echo
echo "Build succeeded (${#SOURCES[@]} source file(s), optimization $OPTLEVEL):"
echo "  $OUT_ASM"
echo "  $OUT_HEX"

exit 0
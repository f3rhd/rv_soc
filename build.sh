#!/usr/bin/env bash
# ============================================================
#  build.sh - RV32IM freestanding C build (multi-TU, Harvard)
#  Usage: build.sh <src1.c> [src2.c ...] [O0|O1|O2|O3|Os]
#
#  Produces TWO separate hex images (instruction memory and
#  data memory are physically separate on this core, so they
#  cannot share one flat binary):
#     <base>_imem.hex   -> .text                (code only)
#     <base>_dmem.hex   -> .rodata/.data/.sdata/.bss (globals)
# ============================================================

set -u

ARGS=("$@")
N=${#ARGS[@]}

if [ "$N" -eq 0 ]; then
    echo "Usage: build.sh <src1.c> [src2.c ...] [O0|O1|O2|O3|Os|Ofast]"
    exit 1
fi

# --- detect trailing optimization level (case-insensitive) ---
LASTVAL="${ARGS[$((N-1))]}"
OPTLEVEL=""
for L in O0 O1 O2 O3 Os Ofast; do
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
DMEM_SIZE=$((DMEM_DEPTH * DMEM_UNIT * DMEM_MULT))
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

FIRST_SRC="${SOURCES[0]}"
BASE_NOEXT="$(basename "$FIRST_SRC")"
BASENAME="${BASE_NOEXT%.*}"
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
    /* gp must be set with relaxation disabled for this one
       instruction: relaxation is what turns other loads/stores
       into gp-relative accesses, so gp itself can't rely on
       that not-yet-initialized value while being set. */
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
# IMEM gets .text only. DMEM gets everything a load/store can
# touch: .rodata, .data, .sdata (small data), .bss/.sbss.
# The whole DMEM footprint must fit in STATIC_RESERVE bytes,
# enforced by the ASSERT below - the build fails loudly if you
# blow the budget instead of silently corrupting the stack.
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

# Two independent flat binaries - IMEM and DMEM never overlap
# on the wire even though both regions are ORIGIN 0x0 in the
# core's address space.
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
exit 0
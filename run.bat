@echo off
setlocal EnableDelayedExpansion
REM ============================================================
REM  run.bat - RV32IM freestanding C build (multi-TU, Harvard)
REM  Usage: run.bat [options] <src1.c> [src2.c ...] [O0|O1|O2|O3|Os|Ofast]
REM  Optionsu
REM    -o <name>    Specify custom base name for output files
REM
REM  Produces TWO separate hex images (instruction memory and
REM  data memory are physically separate on this core):
REM     <base>_imem.hex   -> .text                (code only)
REM     <base>_dmem.hex   -> .rodata/.data/.sdata/.bss (globals)
REM
REM  Notes on this port:
REM   - Requires cmd.exe (not PowerShell), and riscv64-unknown-elf-*
REM     tools plus python3 available on PATH.

set "SOURCES_COUNT=0"
set "CUSTOM_BASENAME="
set "OPTLEVEL="

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="-o" (
    if "%~2"=="" (
        echo ERROR: -o requires a filename argument.
        exit /b 1
    )
    set "CUSTOM_BASENAME=%~2"
    shift
    shift
    goto parse_args
)

set "ISOPT=0"
for %%K in (O0 O1 O2 O3 Os Ofast) do (
    if /I "%~1"=="%%K" set "ISOPT=1"
)
if "!ISOPT!"=="1" (
    set "OPTLEVEL=%~1"
) else (
    set /a SOURCES_COUNT+=1
    set "SOURCES[!SOURCES_COUNT!]=%~1"
)
shift
goto parse_args

:args_done

if "%OPTLEVEL%"=="" set "OPTLEVEL=O0"

if %SOURCES_COUNT%==0 (
    echo Usage: run.bat [-o custom_name] ^<src1.c^> [src2.c ...] [O0^|O1^|O2^|O3^|Os^|Ofast]
    exit /b 1
)

REM Validate sources exist
for /L %%I in (1,1,%SOURCES_COUNT%) do (
    if not exist "!SOURCES[%%I]!" (
        echo ERROR: source file "!SOURCES[%%I]!" not found.
        exit /b 1
    )
)

set "OPTFLAG=-%OPTLEVEL%"

REM ============================================================
REM  Memory geometry - EDIT THESE ONLY. Everything else derives
REM  from these values, so re-synthesizing with a different
REM  depth/width just means changing a number here once.
REM ============================================================

REM Instruction memory: IMEM_SIZE = IMEM_DEPTH * IMEM_UNIT bytes
set /a IMEM_DEPTH=1024
set /a IMEM_UNIT=32
set "IMEM_BASE=0x00000000"

REM Data memory: DMEM_SIZE = DMEM_DEPTH * DMEM_UNIT * DMEM_MULT bytes
set /a DMEM_DEPTH=1024
set /a DMEM_UNIT=32
set /a DMEM_MULT=4
set "DMEM_BASE=0x00000000"

REM KB of DMEM carved out at the bottom for globals/statics
REM (.rodata + .data + .sdata + .bss + .sbss). The rest of DMEM,
REM from the top down, is stack.
set /a STATIC_RESERVE_KB=4

set /a IMEM_SIZE=IMEM_DEPTH*IMEM_UNIT
set /a DMEM_SIZE=DMEM_DEPTH*IMEM_UNIT*DMEM_MULT
set /a STATIC_RESERVE=STATIC_RESERVE_KB*1024

if !STATIC_RESERVE! GEQ !DMEM_SIZE! (
    echo ERROR: STATIC_RESERVE ^(!STATIC_RESERVE! bytes^) ^>= DMEM_SIZE ^(!DMEM_SIZE! bytes^).
    echo        Leave room for a stack.
    exit /b 1
)

set "GCC=riscv64-unknown-elf-gcc"
set "OBJCOPY=riscv64-unknown-elf-objcopy"
set "OBJDUMP=riscv64-unknown-elf-objdump"
set "NM=riscv64-unknown-elf-nm"

where "%GCC%" >nul 2>&1
if errorlevel 1 (
    echo ERROR: %GCC% not found in PATH.
    exit /b 1
)
where "%OBJCOPY%" >nul 2>&1
if errorlevel 1 (
    echo ERROR: %OBJCOPY% not found in PATH.
    exit /b 1
)
where "%OBJDUMP%" >nul 2>&1
if errorlevel 1 (
    echo ERROR: %OBJDUMP% not found in PATH.
    exit /b 1
)

REM Determine output base name (custom or derived from first source)
if not "%CUSTOM_BASENAME%"=="" (
    set "BASENAME=%CUSTOM_BASENAME%"
) else (
    for %%F in ("!SOURCES[1]!") do set "BASENAME=%%~nF"
)

set "OUT_ASM=%BASENAME%.s"
set "OUT_IMEM_HEX=%BASENAME%_imem.hex"
set "OUT_DMEM_HEX=%BASENAME%_dmem.hex"

set "STARTUP_S=__startup_tmp.s"
set "STARTUP_O=__startup_tmp.o"
set "LDSCRIPT=__link_tmp.ld"
set "ELF=__out_tmp.elf"
set "IMEM_BIN=__out_tmp_imem.bin"
set "DMEM_BIN=__out_tmp_dmem.bin"
set "BIN2HEX_PY_HIGH_ENDIAN=__bin2hex_tmp_high_endian.py"
set "BIN2HEX_PY_LITTLE_ENDIAN=__bin2hex_tmp_little_endian.py"
set "SENDER=__sender.py"

set "CFLAGS=-march=rv32imf -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables"

goto :main

REM ------------------------------------------------------------
REM  Subroutines
REM ------------------------------------------------------------
:cleanup
for %%F in ("%STARTUP_S%" "%STARTUP_O%" "%LDSCRIPT%" "%ELF%" "%IMEM_BIN%" "%DMEM_BIN%" "%BIN2HEX_PY_LITTLE_ENDIAN%" "%BIN2HEX_PY_HIGH_ENDIAN%") do (
    if exist %%F del /f /q %%F >nul 2>&1
)
del /f /q __tu*_tmp.o >nul 2>&1
exit /b 0

:build_error
echo.
echo BUILD FAILED.
call :cleanup
exit /b 1

:main
call :cleanup

REM ------------------------------------------------------------
REM  Startup code: sets gp (for gp-relative small-data access),
REM  then sp (top of DMEM), then jumps into main.
REM ------------------------------------------------------------
(
echo     .section .text.start,"ax"
echo     .globl _start
echo _start:
echo     .option push
echo     .option norelax
echo     la gp, __global_pointer$
echo     .option pop
echo.
echo     la sp, __stack_top
echo.
echo     call main
echo halt_loop:
echo     j halt_loop
) > "%STARTUP_S%"

"%GCC%" %CFLAGS% %OPTFLAG% -c "%STARTUP_S%" -o "%STARTUP_O%" || goto :build_error

set "OBJLIST=%STARTUP_O%"

for /L %%I in (1,1,%SOURCES_COUNT%) do (
    set "THISSRC=!SOURCES[%%I]!"
    set "OBJ=__tu%%I_tmp.o"
    "%GCC%" %CFLAGS% %OPTFLAG% -c "!THISSRC!" -o "!OBJ!" || goto :build_error
    set "OBJLIST=!OBJLIST! !OBJ!"
)

REM ------------------------------------------------------------
REM  Linker script: two distinct memory regions (Harvard).
REM ------------------------------------------------------------
(
echo ENTRY^(_start^)
echo.
echo MEMORY
echo {
echo     IMEM ^(rx^) : ORIGIN = %IMEM_BASE%, LENGTH = %IMEM_SIZE%
echo     DMEM ^(rw^) : ORIGIN = %DMEM_BASE%, LENGTH = %DMEM_SIZE%
echo }
echo.
echo __static_reserve = %STATIC_RESERVE%;
echo __stack_top      = ALIGN^(ORIGIN^(DMEM^) + LENGTH^(DMEM^), 32^);
echo.
echo SECTIONS
echo {
echo     . = ORIGIN^(IMEM^);
echo     .text : { KEEP^(*^(.text.start^)^) *^(.text*^) } ^> IMEM
echo.
echo     . = ORIGIN^(DMEM^);
echo     .rodata : { *^(.rodata .rodata.*^) } ^> DMEM
echo     .data   : { *^(.data .data.*^) } ^> DMEM
echo.
echo     .sdata : {
echo         . = ALIGN^(32^);
echo         PROVIDE^(__global_pointer$ = . + 0x800^);
echo         *^(.srodata.cst16^) *^(.srodata.cst8^) *^(.srodata.cst4^) *^(.srodata.cst2^) *^(.srodata*^)
echo         *^(.sdata .sdata.*^) *^(.gnu.linkonce.s.*^)
echo     } ^> DMEM
echo.
echo     .bss : {
echo         *^(.sbss .sbss.*^) *^(.gnu.linkonce.sb.*^)
echo         *^(.bss .bss.*^)
echo         *^(COMMON^)
echo     } ^> DMEM
echo.
echo     __static_end  = .;
echo     __static_used = __static_end - ORIGIN^(DMEM^);
echo }
echo.
echo ASSERT^(__static_used ^<= __static_reserve, "ERROR: global/static data footprint exceeds STATIC_RESERVE_KB budget - shrink your globals or raise the reserve in run.bat"^)
) > "%LDSCRIPT%"

"%GCC%" %CFLAGS% %OPTFLAG% -nostartfiles -T "%LDSCRIPT%" -Wl,-e,_start -Wl,--gc-sections -Wl,--no-check-sections -o "%ELF%" %OBJLIST% -lgcc || goto :build_error

"%OBJDUMP%" -d "%ELF%" > "%OUT_ASM%" || goto :build_error

"%OBJCOPY%" -O binary -j .text "%ELF%" "%IMEM_BIN%" || goto :build_error
"%OBJCOPY%" -O binary -j .rodata -j .data -j .sdata -j .bss "%ELF%" "%DMEM_BIN%" || goto :build_error

(
echo import sys
echo.
echo bin_file, hex_file = sys.argv[1], sys.argv[2]
echo.
echo with open^(bin_file, "rb"^) as f:
echo     data = f.read^(^)
echo.
echo pad = ^(4 - ^(len^(data^) %%%% 4^)^) %%%% 4
echo if pad:
echo     data += b"\x00" * pad
echo.
echo lines = []
echo for i in range^(0, len^(data^), 4^):
echo     b0, b1, b2, b3 = data[i], data[i+1], data[i+2], data[i+3]
echo     lines.append^("{:02x}{:02x}{:02x}{:02x}".format^(b3, b2, b1, b0^)^)
echo.
echo with open^(hex_file, "w", newline="\n"^) as f:
echo     f.write^("\n".join^(lines^)^)
) > "%BIN2HEX_PY_HIGH_ENDIAN%"

(
echo import sys
echo.
echo bin_file, hex_file = sys.argv[1], sys.argv[2]
echo.
echo with open^(bin_file, "rb"^) as f:
echo     data = f.read^(^)
echo.
echo pad = ^(4 - ^(len^(data^) %%%% 4^)^) %%%% 4
echo if pad:
echo     data += b"\x00" * pad
echo.
echo lines = []
echo for i in range^(0, len^(data^), 4^):
echo     b0, b1, b2, b3 = data[i], data[i+1], data[i+2], data[i+3]
echo     lines.append^("{:02x}{:02x}{:02x}{:02x}".format^(b0, b1, b2, b3^)^)
echo.
echo with open^(hex_file, "w", newline="\n"^) as f:
echo     f.write^("\n".join^(lines^)^)
) > "%BIN2HEX_PY_LITTLE_ENDIAN%"

python3 "%BIN2HEX_PY_HIGH_ENDIAN%" "%IMEM_BIN%" "%OUT_IMEM_HEX%" || goto :build_error
python3 "%BIN2HEX_PY_LITTLE_ENDIAN%" "%DMEM_BIN%" "%OUT_DMEM_HEX%" || goto :build_error

echo.
echo Build succeeded (%SOURCES_COUNT% source file(s), optimization %OPTLEVEL%):
echo   %OUT_ASM%
echo   %OUT_IMEM_HEX%   (IMEM, %IMEM_SIZE% bytes total)
echo   %OUT_DMEM_HEX%   (DMEM, %DMEM_SIZE% bytes total, %STATIC_RESERVE% bytes reserved for statics)
echo.

where "%NM%" >nul 2>&1
if not errorlevel 1 (
    echo Symbol check:
    REM Note: unlike the bash version's "sort -k3", this simply
    REM prints matches in nm's own output order.
    "%NM%" "%ELF%" 2>nul | findstr /C:"__static_used" /C:"__static_reserve" /C:"__global_pointer" /C:"__stack_top"
    echo.
)

call :cleanup

(
echo import serial
echo import time
echo import sys
echo import os
echo.
echo SERIAL_PORT = 'COM3'
echo BAUD_RATE   =  115200
echo.
echo BEGIN_SIGNAL = b'\x72'
echo BOOT_SIGNAL = b'\x69'
echo STATIC_DATA_SIGNAL = b'\x31'
echo.
echo.
echo def validate_hex_file^(file_path^):
echo     if not os.path.exists^(file_path^):
echo         raise FileNotFoundError^(f"'{file_path}' does not exist."^)
echo.
echo     if not os.path.isfile^(file_path^):
echo         raise ValueError^(f"'{file_path}' is not a regular file."^)
echo.
echo     try:
echo         with open^(file_path, 'r'^) as f:
echo             hex_content = f.read^(^)
echo     except UnicodeDecodeError:
echo         raise ValueError^(f"'{file_path}' is not a valid text/hex file ^(binary content detected^)."^)
echo.
echo     cleaned_hex = ''.join^(hex_content.split^(^)^)
echo.
echo     if len^(cleaned_hex^) %%%% 2 != 0:
echo         raise ValueError^(f"'{file_path}' has an odd number of hex digits ^({len^(cleaned_hex^)}^); "
echo                           f"each byte needs two hex characters."^)
echo.
echo     if not all^(c in '0123456789abcdefABCDEF' for c in cleaned_hex^):
echo         bad_chars = sorted^(set^(c for c in cleaned_hex if c not in '0123456789abcdefABCDEF'^)^)
echo         raise ValueError^(f"'{file_path}' contains non-hex characters: {bad_chars}"^)
echo.
echo     try:
echo         data = bytes.fromhex^(cleaned_hex^)
echo     except ValueError as e:
echo         raise ValueError^(f"'{file_path}' could not be parsed as hex: {e}"^)
echo.
echo     return data
echo.
echo.
echo def wait_and_send_data^(ser, signal_byte, signal_name, data, file_path^):
echo     while True:
echo         print^(f"Waiting for a {signal_name} signal..."^)
echo         byte = ser.read^(1^)
echo         if not byte:
echo             continue
echo         if byte == signal_byte:
echo             print^(f"{signal_name.capitalize^(^)} signal received.\nSending data..."^)
echo             break
echo         else:
echo             print^(f"  ^(unexpected byte: {byte.hex^(^)} -- still waiting^)"^)
echo.
echo     total = len^(data^)
echo     print^(f"Sending {total} byte^(s^) from '{file_path}'..."^)
echo.
echo     for i in total.to_bytes^(4, 'big'^):
echo         ser.write^(bytes^([i]^)^)
echo         time.sleep^(0.00001^)
echo.
echo     for i, b in enumerate^(data^):
echo         ser.write^(bytes^([b]^)^)
echo         time.sleep^(0.00001^)
echo         print^(f"  [{i+1:^>4}/{total}] sent 0x{b:02X}"^)
echo.
echo.
echo def send_program^(^):
echo     if len^(sys.argv^) ^< 3:
echo         print^("Error: Please provide both hex file paths."^)
echo         print^("Usage: python3 sender.py ^<program.hex^> ^<memory.hex^>"^)
echo         return
echo.
echo     program_hex_path = sys.argv[1]
echo     memory_hex_path = sys.argv[2]
echo.
echo     try:
echo         print^(f"Validating '{program_hex_path}'..."^)
echo         program_data = validate_hex_file^(program_hex_path^)
echo         print^(f"  OK -- {len^(program_data^)} byte^(s^) of valid hex data."^)
echo.
echo         print^(f"Validating '{memory_hex_path}'..."^)
echo         memory_data = validate_hex_file^(memory_hex_path^)
echo         print^(f"  OK -- {len^(memory_data^)} byte^(s^) of valid hex data."^)
echo     except FileNotFoundError as e:
echo         print^(f"Error: File not found. Check your file name or path. ^({e}^)"^)
echo         return
echo     except ValueError as e:
echo         print^(f"Error: Invalid hex file. ^({e}^)"^)
echo         return
echo.
echo     print^("Both files validated successfully. Proceeding to connect and handshake...\n"^)
echo.
echo     try:
echo         ser = serial.Serial^(SERIAL_PORT, BAUD_RATE, timeout=5^)
echo         print^(f"Connected to {SERIAL_PORT} @ {BAUD_RATE} baud"^)
echo.
echo         ser.write^(BEGIN_SIGNAL^)
echo         print^("Sent begin signal to the core."^)
echo         wait_and_send_data^(ser, BOOT_SIGNAL, "boot", program_data, program_hex_path^)
echo         wait_and_send_data^(ser, STATIC_DATA_SIGNAL, "static data", memory_data, memory_hex_path^)
echo.
echo         ser.close^(^)
echo         print^("Success"^)
echo.
echo     except serial.SerialException as e:
echo         print^(f"Serial error: {e}"^)
echo     except Exception as e:
echo         print^(f"Unexpected error: {e}"^)
echo.
echo.
echo if __name__ == "__main__":
echo     send_program^(^)
) > "%SENDER%"

echo Launching sender...
python3 "%SENDER%" "%OUT_IMEM_HEX%" "%OUT_DMEM_HEX%"

if "%CUSTOM_BASENAME%"=="" (
    del /f /q "%OUT_ASM%" "%OUT_IMEM_HEX%" "%OUT_DMEM_HEX%" >nul 2>&1
)
del /f /q "%SENDER%" >nul 2>&1
exit /b 0
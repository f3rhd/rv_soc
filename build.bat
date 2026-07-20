@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  build.bat - RV32IM freestanding C build (multi-TU)
REM  Usage: build.bat <src1.c> [src2.c ...] [O0|O1|O2|O3|Os]
REM ============================================================


set "N=0"
for %%A in (%*) do (
    set /a N+=1
    set "ARG!N!=%%~A"
)

if "%N%"=="0" (
    echo Usage: build.bat ^<src1.c^> [src2.c ...] [O0^|O1^|O2^|O3^|Os]
    exit /b 1
)


set "LASTVAL=!ARG%N%!"
set "OPTLEVEL="
for %%L in (O0 O1 O2 O3 Os) do (
    if /I "!LASTVAL!"=="%%L" set "OPTLEVEL=%%L"
)

if defined OPTLEVEL (
    set /a SRCCOUNT=N-1
) else (
    set "OPTLEVEL=O0"
    set /a SRCCOUNT=N
)

if "%SRCCOUNT%"=="0" (
    echo ERROR: no source files provided.
    exit /b 1
)


for /l %%I in (1,1,%SRCCOUNT%) do (
    set "SOURCES%%I=!ARG%%I!"
    if not exist "!ARG%%I!" (
        echo ERROR: source file "!ARG%%I!" not found.
        exit /b 1
    )
)

set "OPTFLAG=-%OPTLEVEL%"

set "GCC=riscv64-unknown-elf-gcc"
set "OBJCOPY=riscv64-unknown-elf-objcopy"

where %GCC% >nul 2>nul
if errorlevel 1 (
    echo ERROR: %GCC% not found in PATH.
    exit /b 1
)
where %OBJCOPY% >nul 2>nul
if errorlevel 1 (
    echo ERROR: %OBJCOPY% not found in PATH.
    exit /b 1
)


set "BASENAME=%~n1"
set "OUT_ASM=%BASENAME%.s"
set "OUT_HEX=%BASENAME%.hex"


set "STARTUP_S=__startup_tmp.s"
set "STARTUP_O=__startup_tmp.o"
set "LDSCRIPT=__link_tmp.ld"
set "ELF=__out_tmp.elf"
set "BIN=__out_tmp.bin"
set "FILTER_PS1=__filter_tmp.ps1"
set "BIN2HEX_PS1=__bin2hex_tmp.ps1"

set "OBJLIST="
set "TMPFILELIST="

call :cleanup


> "%STARTUP_S%" (
    echo     .section .text.start,"ax"
    echo     .globl _start
    echo _start:
    echo     li sp, 0x8000
    echo     call main
    echo halt_loop:
    echo     j halt_loop
)

"%GCC%" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie %OPTFLAG% -c "%STARTUP_S%" -o "%STARTUP_O%"
if errorlevel 1 goto :build_error

set "OBJLIST=%STARTUP_O%"


> "%FILTER_PS1%" (
    echo param^([string]$InputFile,[string]$OutputFile^)
    echo $lines = Get-Content -LiteralPath $InputFile
    echo $result = New-Object System.Collections.Generic.List[string]
    echo foreach ^($line in $lines^) {
    echo     $trimmed = $line.Trim^(^)
    echo     if ^($trimmed -eq ""^) { continue }
    echo     if ^($trimmed -match '^^\s*#'^) { continue }
    echo     if ^($trimmed -match '^^\.L[0-9]+:$'^) { $result.Add^($line^); continue }
    echo     if ^($trimmed -match '^^\.'^) { continue }
    echo     $result.Add^($line^)
    echo }
    echo Set-Content -LiteralPath $OutputFile -Value $result -Encoding ascii
)

> "%OUT_ASM%" (
    echo _start:
    echo     li sp,0x8000
    echo     call main
    echo.
    echo halt_loop:
    echo     j halt_loop
    echo.
)

for /l %%I in (1,1,%SRCCOUNT%) do (
    set "THISSRC=!SOURCES%%I!"
    set "OBJ_%%I=__tu%%I_tmp.o"
    set "ASM_%%I=__tu%%I_tmp.s"
    set "ASMCLEAN_%%I=__tu%%I_clean_tmp.s"

    "%GCC%" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie %OPTFLAG% -c "!THISSRC!" -o "!OBJ_%%I!"
    if errorlevel 1 goto :build_error

    "%GCC%" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -fno-pic -fno-pie %OPTFLAG% -S "!THISSRC!" -o "!ASM_%%I!"
    if errorlevel 1 goto :build_error

    powershell -NoProfile -ExecutionPolicy Bypass -File "%FILTER_PS1%" -InputFile "!ASM_%%I!" -OutputFile "!ASMCLEAN_%%I!"
    if errorlevel 1 goto :build_error

    >> "%OUT_ASM%" echo # ---- file: !THISSRC! ----
    >> "%OUT_ASM%" echo.
    type "!ASMCLEAN_%%I!" >> "%OUT_ASM%"
    >> "%OUT_ASM%" echo.

    set "OBJLIST=!OBJLIST! !OBJ_%%I!"
    set "TMPFILELIST=!TMPFILELIST! !OBJ_%%I! !ASM_%%I! !ASMCLEAN_%%I!"
)


> "%LDSCRIPT%" (
    echo ENTRY(_start^)
    echo MEMORY
    echo {
    echo     RAM ^(rwx^) : ORIGIN = 0x00000000, LENGTH = 32K
    echo }
    echo SECTIONS
    echo {
    echo     . = 0x00000000;
    echo     .text : { *^(.text.start^) *^(.text*^) } ^> RAM
    echo     .rodata : { *^(.rodata*^) } ^> RAM
    echo     .data : { *^(.data*^) } ^> RAM
    echo     .bss : { *^(.bss*^) *^(COMMON^) } ^> RAM
    echo }
)


"%GCC%" -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -nostartfiles %OPTFLAG% -T "%LDSCRIPT%" -Wl,-e,_start -o "%ELF%" %OBJLIST%
if errorlevel 1 goto :build_error


"%OBJCOPY%" -O binary "%ELF%" "%BIN%"
if errorlevel 1 goto :build_error


> "%BIN2HEX_PS1%" (
    echo param^([string]$BinFile,[string]$HexFile^)
    echo $bytes = [System.IO.File]::ReadAllBytes^($BinFile^)
    echo $pad = ^(4 - ^($bytes.Length %% 4^)^) %% 4
    echo if ^($pad -gt 0^) {
    echo     $extra = New-Object byte[] $pad
    echo     $bytes = $bytes + $extra
    echo }
    echo $sb = New-Object System.Text.StringBuilder
    echo for ^($i = 0; $i -lt $bytes.Length; $i += 4^) {
    echo     $b0 = $bytes[$i]
    echo     $b1 = $bytes[$i+1]
    echo     $b2 = $bytes[$i+2]
    echo     $b3 = $bytes[$i+3]
    echo     $word = ^("{0:x2}{1:x2}{2:x2}{3:x2}" -f $b3,$b2,$b1,$b0^)
    echo     [void]$sb.AppendLine^($word^)
    echo }
    echo Set-Content -LiteralPath $HexFile -Value $sb.ToString^(^).TrimEnd^(^) -Encoding ascii
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%BIN2HEX_PS1%" -BinFile "%BIN%" -HexFile "%OUT_HEX%"
if errorlevel 1 goto :build_error

echo.
echo Build succeeded ^(%SRCCOUNT% source file(s), optimization %OPTLEVEL%^):
echo   %OUT_ASM%
echo   %OUT_HEX%

call :cleanup
endlocal
exit /b 0

:build_error
echo.
echo BUILD FAILED.
call :cleanup
endlocal
exit /b 1

:cleanup
for %%F in (
    "%STARTUP_S%" "%STARTUP_O%" "%LDSCRIPT%" "%ELF%" "%BIN%"
    "%FILTER_PS1%" "%BIN2HEX_PS1%"
) do (
    if exist %%F del /f /q %%F >nul 2>nul
)
for %%F in (%TMPFILELIST%) do (
    if exist %%F del /f /q %%F >nul 2>nul
)

for %%F in (__tu*_tmp.o __tu*_tmp.s __tu*_clean_tmp.s) do (
    if exist "%%F" del /f /q "%%F" >nul 2>nul
)
exit /b 0
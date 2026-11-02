@echo off
rem ============================================================
rem  Split mod scripts into small text batches for chat/GitHub
rem  Reads: C:\Users\drdre\Desktop\mod_scripts_for_github
rem  Writes: C:\Users\drdre\Desktop\batches\NNN_<name>.txt
rem  Each batch <= ~45 KB so pasting never hits the quota.
rem ============================================================
setlocal EnableDelayedExpansion

set "SRC=C:\Users\drdre\Desktop\mod_scripts_for_github"
set "DST=C:\Users\drdre\Desktop\batches"
set "MAXKB=45"

if not exist "%SRC%" (
    echo [ERROR] Source folder not found: "%SRC%"
    echo Run copy_scripts_fixed.cmd first.
    pause & exit /b 1
)
if not exist "%DST%" mkdir "%DST%"
del /q "%DST%\*.*" 2>nul

set /a IDX=100
set /a SIZE=0
set "OUTF="

for /f "usebackq delims=" %%F in (`dir /s /b "%SRC%\*.txt" ^| sort`) do (
    set "FSIZE=0"
    for %%S in ("%%F") do set /a FSIZE=%%~zS/1024
    if !FSIZE! GTR %MAXKB% (
        echo [SKIP big file, send separately] %%F  ^(!FSIZE! KB^)
        goto :next
    )
    set /a NEWSIZE=SIZE+FSIZE
    if !NEWSIZE! GTR %MAXKB% (
        set /a IDX+=1
        set SIZE=0
        set "OUTF=%DST%\batch_!IDX:~1!.txt"
        if exist "!OUTF!" del /q "!OUTF!"
    )
    if not defined OUTF set "OUTF=%DST%\batch_!IDX:~1!.txt"
    echo(===== FILE: %%F =====>> "!OUTF!"
    type "%%F">>"!OUTF!" 2>nul
    echo().>> "!OUTF!"
    set SIZE=!NEWSIZE!
    :next
)

echo.
echo ============ RESULT ============
dir "%DST%\batch_*.txt"
echo.
echo Open a batch file, copy its contents and paste into chat
echo (one message per batch). Quota-safe: each is under %MAXKB% KB.
pause
endlocal

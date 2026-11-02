@echo off
rem ============================================================
rem  Copy ONLY .txt scripts from AGOT + LoTR RIE for GitHub
rem  Run by double-click, or from CMD. No admin needed.
rem  Result: C:\Users\drdre\Desktop\mod_scripts_for_github
rem          C:\Users\drdre\Desktop\mod_scripts.zip
rem ============================================================

setlocal
set "WS=C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310"
set "OUT=%USERPROFILE%\Desktop\mod_scripts_for_github"
set "ZIP=%USERPROFILE%\Desktop\mod_scripts.zip"

echo Working dir: %CD%
if not exist "%WS%" (
    echo [ERROR] Steam workshop folder not found:
    echo         "%WS%"
    pause & exit /b 1
)

rem --- create destination explicitly (fixes "file never appears") ---
if not exist "%OUT%" mkdir "%OUT%"
if not exist "%OUT%\agot"     mkdir "%OUT%\agot"
if not exist "%OUT%\lotr_rie" mkdir "%OUT%\lotr_rie"

echo.
echo === AGOT (2962333032) ===
for %%D in (common events history localization gui interface) do (
    if exist "%WS%\2962333032\%%D" (
        echo   copying %%D ...
        robocopy "%WS%\2962333032\%%D" "%OUT%\agot\%%D" *.txt /S /NFL /NDL /NJH /NJS /NP
    ) else (
        echo   skip %%D - folder not present in mod
    )
)

echo.
echo === LoTR RIE (2291024373) ===
for %%D in (common events history localization gui interface) do (
    if exist "%WS%\2291024373\%%D" (
        echo   copying %%D ...
        robocopy "%WS%\2291024373\%%D" "%OUT%\lotr_rie\%%D" *.txt /S /NFL /NDL /NJH /NJS /NP
    ) else (
        echo   skip %%D - folder not present in mod
    )
)

rem robocopy returns non-zero codes even on success -> reset errorlevel
ver >nul

echo.
echo ============ RESULT ============
for /f %%N in ('dir /s /b "%OUT%\*.txt" 2^>nul ^| find /c /v ""') do set "CNT=%%N"
echo Files copied : %CNT% .txt files
for /f %%N in ('powershell -NoProfile -Command "[int]((Get-ChildItem '%OUT%' -Recurse -File ^| Measure-Object Length -Sum).Sum/1MB*10)/10"') do echo Total size   : %%N MB

if not exist "%OUT%\agot\common\dragon_types" (
    echo.
    echo [WARN] No dragon_types folder inside agot\common - the ID may be wrong.
    echo        Check folder names here: "%WS%"
)

echo.
echo === Zipping to %ZIP% ===
powershell -NoProfile -Command "Compress-Archive -Path '%OUT%\*' -DestinationPath '%ZIP%' -Force"
if exist "%ZIP%" (echo ZIP ready: %ZIP%) else (echo [ERROR] zip failed)

start "" explorer "%OUT%"
pause
endlocal

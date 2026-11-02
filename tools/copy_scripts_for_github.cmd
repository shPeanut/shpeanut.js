@echo off
REM ============================================================
REM  Nazgul Dragons - copy ONLY text scripts from LoTR RIE + AGOT
REM  for GitHub upload (no gfx/models/sounds -> small size)
REM  Run: double-click this file, or in CMD:
REM     copy_scripts_for_github.cmd
REM  Result: %USERPROFILE%\Desktop\mod_scripts_for_github\
REM           \agot\  and  \lotr_rie\   (folder structure kept)
REM ============================================================

set "WS=C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310"
set "AGOT=%WS%\2962333032"
set "LOTR=%WS%\2291024373"
set "OUT=%USERPROFILE%\Desktop\mod_scripts_for_github"

echo [1/4] Checking source folders...
if not exist "%AGOT%" echo ERROR: AGOT folder not found: %AGOT% & pause & exit /b 1
if not exist "%LOTR%" echo ERROR: LoTR RIE folder not found: %LOTR% & pause & exit /b 1

echo [2/4] Copying AGOT text scripts...
for %%D in (common events history localization gui interface) do (
    if exist "%AGOT%\%%D" robocopy "%AGOT%\%%D" "%OUT%\agot\%%D" *.txt /S /NFL /NDL /NJH /NJS /NP >nul
)

echo [3/4] Copying LoTR RIE text scripts...
for %%D in (common events history localization gui interface) do (
    if exist "%LOTR%\%%D" robocopy "%LOTR%\%%D" "%OUT%\lotr_rie\%%D" *.txt /S /NFL /NDL /NJH /NJS /NP >nul
)

echo [4/4] Packing zip for GitHub / chat upload...
powershell -NoProfile -Command "Compress-Archive -Path '%OUT%\*' -DestinationPath '%USERPROFILE%\Desktop\mod_scripts.zip' -Force"

echo.
echo DONE!
echo   Folder : %OUT%
echo   Zip    : %USERPROFILE%\Desktop\mod_scripts.zip
echo Upload the folder to a GitHub repo (or send the zip).
pause

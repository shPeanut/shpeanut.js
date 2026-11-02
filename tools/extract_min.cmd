@echo off
rem ============================================================
rem  extract_min.cmd - vypisivaet TOLKO te stroki iz modov,
rem  kotorye realno nuzhny dlya doshivki submoda.
rem  Razmer vyvoda: neskolko KB - vsegda prohodit v chaty.
rem  Zapusk: dvoinym klikom ili iz CMD.
rem ============================================================
setlocal
set "WS=C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310"
set "OUT=C:\Users\drdre\Desktop\nazgul_extract"
if not exist "%OUT%" mkdir "%OUT%"

echo === [1] AGOT dragon traits: full trait blocks ===
powershell -NoProfile -Command "$out=''; Get-ChildItem '%WS%\2962333032\common\traits' -Filter *.txt -Recurse -EA SilentlyContinue | ForEach-Object { $t=Get-Content $_.FullName -Raw; foreach($m in ([regex]::Matches($t,'(?m)^(dragon[a-z_0-9]*|wyvern|theresalikeserpent)\s*=\s*\{'))){ $i=$m.Index; $d=0; $j=$i; while($j -lt $t.Length){ if($t[$j] -eq '{'){$d++}; if($t[$j] -eq '}'){$d--;$j++; if($d -eq 0){break}}; $j++ }; $out += \"`n### $($_.Name)`n\" + $t.Substring($i,[Math]::Min($j,$t.Length)-$i) } }; Set-Content '%OUT%\agot_dragon_traits.txt' $out -Encoding UTF8"

echo === [2] AGOT: dragon-rider decisions ===
powershell -NoProfile -Command "$out=''; Get-ChildItem '%WS%\2962333032\common\decisions' -Filter *.txt -Recurse -EA SilentlyContinue | ForEach-Object { $t=Get-Content $_.FullName -Raw; foreach($m in ([regex]::Matches($t,'(?mi)^\s*(dragon[a-z_0-9]*|wyvern[a-z_0-9]*)\s*=\s*\{[^}]*\}\s*\}')){ $out += \"`n### $($_.Name)`n\" + $m.Value } }; Set-Content '%OUT%\agot_dragon_decisions.txt' $out -Encoding UTF8"

echo === [3] LoTR RIE: nazgul/trait keys ===
powershell -NoProfile -Command "$out=''; Get-ChildItem '%WS%\2291024373\common\traits' -Filter *.txt -Recurse -EA SilentlyContinue | ForEach-Object { $t=Get-Content $_.FullName -Raw; foreach($m in ([regex]::Matches($t,'(?m)^([a-z_0-9]*(nazg|black_ride|ringwraith|terror|fell)[a-z_0-9]*)\s*=\s*\{'))){ $out += $_.Name + ' : ' + $m.Groups[1].Value + \"`n\" } }; Set-Content '%OUT%\lotr_nazgul_trait_keys.txt' $out -Encoding UTF8"

echo === [4] LoTR RIE: terror mechanic lines ===
powershell -NoProfile -Command "$out=''; Get-ChildItem '%WS%\2291024373\common' -Filter *.txt -Recurse -EA SilentlyContinue | Select-String -Pattern 'terror' -SimpleMatch | ForEach-Object { $out += $_.Filename + ':' + $_.LineNumber + ': ' + $_.Line.Trim() + \"`n\" }; if($out.Length -gt 30000){$out=$out.Substring(0,30000)}; Set-Content '%OUT%\lotr_terror_lines.txt' $out -Encoding UTF8"

echo === [5] listing of AGOT dragon model folder ===
dir /b "%WS%\2962333032\gfx\models\portraits\agot_creatures\dragon" > "%OUT%\agot_dragon_models_list.txt" 2>nul

echo.
echo ============ RESULT ============
for /f %%N in ('dir /b "%OUT%\*.txt" 2^>nul ^| find /c /v ""') do echo Fileov sozdano: %%N
for %%F in ("%OUT%\*.txt") do echo   %%~nxF  -  %%~zF bayt
echo.
echo Otkroyte papku i vkopiruyte soderzhimoe faylov PRYAMO v chat
echo (kazhdyy fayl otdelno soobshcheniem). Oni malenkie - kvota ne budet prevyshena.
start "" explorer "%OUT%"
pause
endlocal

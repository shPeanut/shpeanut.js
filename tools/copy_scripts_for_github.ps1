# copy_scripts_for_github.ps1
# Быстро копирует ВСЕ текстовые скрипты AGOT и LoTR RIE в одну папку для загрузки на GitHub.
# Использование:  powershell -ExecutionPolicy Bypass -File .\copy_scripts_for_github.ps1
# Результат:      $env:USERPROFILE\Desktop\mod_scripts_for_github\agot\...  и  ...\lotr_rie\...

$ErrorActionPreference = 'Stop'

# Папки Workshop-модов (ID можно поправить, если у вас другие)
$mods = [ordered]@{
    agot     = "C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310\2962333032"   # A Game of Thrones
    lotr_rie = "C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310\2291024373"   # LotR: Realms in Exile (проверьте ID!)
}

# Только текстовые расширения (без gfx/models/звука — они не нужны для реверса)
$textExt = @('.txt', '.log')

# Подпапки мода, которые реально содержат скрипты/данные/локализацию
$subdirs = @('common', 'events', 'history', 'localization', 'gui', 'interface')

$outRoot = Join-Path ([Environment]::GetFolderPath('Desktop')) 'mod_scripts_for_github'

foreach ($name in $mods.Keys) {
    $src = $mods[$name]
    if (-not (Test-Path $src)) {
        Write-Warning "Не найдено: $src (поправьте ID в массиве `$mods)"
        continue
    }
    $dst = Join-Path $outRoot $name
    foreach ($sub in $subdirs) {
        $srcSub = Join-Path $src $sub
        if (-not (Test-Path $srcSub)) { continue }
        Get-ChildItem -Path $srcSub -Recurse -File |
            Where-Object { $textExt -contains $_.Extension.ToLower() } |
            ForEach-Object {
                $rel  = $_.FullName.Substring($src.Length).TrimStart('\')
                $dest = Join-Path $dst $rel
                $null = New-Item -ItemType Directory -Force -Path (Split-Path $dest)
                Copy-Item $_.FullName $dest -Force
            }
    }
}

# Итог
if (Test-Path $outRoot) {
    $size = (Get-ChildItem $outRoot -Recurse -File | Measure-Object Length -Sum).Sum / 1MB
    $cnt  = (Get-ChildItem $outRoot -Recurse -File).Count
    Write-Host "`nГотово: $cnt файлов, ~{0:N1} МБ" -f $size
    Write-Host "Папка: $outRoot"
    Write-Host "Дальше: залейте её в GitHub (Drag&Drop в веб-интерфейс нового репо или git add/commit/push)."
    Write-Host "Если хотите архив: Compress-Archive -Path '$outRoot\*' -DestinationPath '$env:USERPROFILE\Desktop\mod_scripts.zip' -Force"
}

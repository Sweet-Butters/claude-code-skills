# 연세 프리미엄 인강 - Claude Code 스킬 설치 (Windows)
$ErrorActionPreference = "Stop"
$dst = Join-Path $HOME ".claude\skills"
New-Item -ItemType Directory -Force $dst | Out-Null
$src = Join-Path $PSScriptRoot "skills"
Get-ChildItem $src -Directory | ForEach-Object {
    Copy-Item -Recurse -Force $_.FullName $dst
    Write-Host ("  설치됨  " + $_.Name)
}
Write-Host ""
Write-Host "설치 위치 : $dst"
Write-Host "Claude Code 를 새로 켜고 / 를 눌러 보세요."

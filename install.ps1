# 연세 프리미엄 인강 - Claude Code 스킬 설치 (Windows)
$ErrorActionPreference = "Stop"
$dst = Join-Path $HOME ".claude\skills"
New-Item -ItemType Directory -Force $dst | Out-Null
$src = Join-Path $PSScriptRoot "skills"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

Get-ChildItem $src -Directory | ForEach-Object {
    $target = Join-Path $dst $_.Name
    if (Test-Path $target) {
        $backup = "$target.backup-$stamp"
        Move-Item $target $backup
        Write-Host ("  기존 것 백업  " + $_.Name + "  ->  " + (Split-Path $backup -Leaf)) -ForegroundColor Yellow
    }
    Copy-Item -Recurse $_.FullName $dst
    Write-Host ("  설치됨        " + $_.Name)
}
Write-Host ""
Write-Host "설치 위치 : $dst"
Write-Host "Claude Code 를 새로 켜면 목록에 잡힙니다."

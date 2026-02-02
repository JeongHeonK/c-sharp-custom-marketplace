# setup.ps1 — Hook 파일 복사 + 디렉토리 생성
# Usage: pwsh setup.ps1 <target-dir>
#
# 이 스크립트는 최소한의 작업만 수행합니다:
# - assets/hooks/* → <target>/scripts/hooks/ 복사
# - .claude/context/, .claude/learnings/ 디렉토리 생성
#
# CLAUDE.md 및 settings.local.json 조작은 Claude 도구가 담당합니다.

param(
    [string]$TargetDir = "."
)

$ErrorActionPreference = "Stop"

# 절대 경로로 변환
$TargetDir = Resolve-Path $TargetDir -ErrorAction Stop

# 이 스크립트의 위치 기준으로 assets/hooks 경로 결정
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AssetsDir = Join-Path (Split-Path -Parent $ScriptDir) "assets/hooks"

if (-not (Test-Path $AssetsDir)) {
    Write-Error "Assets directory not found: $AssetsDir"
    exit 1
}

# 1. Hook 파일 복사
$HooksDest = Join-Path $TargetDir "scripts/hooks"
New-Item -ItemType Directory -Path "$HooksDest/lib" -Force | Out-Null

# Bash 스크립트
Copy-Item "$AssetsDir/lib/utils.sh" "$HooksDest/lib/utils.sh" -Force
Copy-Item "$AssetsDir/session-start.sh" "$HooksDest/session-start.sh" -Force
Copy-Item "$AssetsDir/pre-compact.sh" "$HooksDest/pre-compact.sh" -Force
Copy-Item "$AssetsDir/session-complete.sh" "$HooksDest/session-complete.sh" -Force

# PowerShell 스크립트
Copy-Item "$AssetsDir/lib/utils.ps1" "$HooksDest/lib/utils.ps1" -Force
Copy-Item "$AssetsDir/session-start.ps1" "$HooksDest/session-start.ps1" -Force
Copy-Item "$AssetsDir/pre-compact.ps1" "$HooksDest/pre-compact.ps1" -Force
Copy-Item "$AssetsDir/session-complete.ps1" "$HooksDest/session-complete.ps1" -Force

# 2. Claude 컨텍스트 디렉토리 생성
New-Item -ItemType Directory -Path "$TargetDir/.claude/context" -Force | Out-Null
New-Item -ItemType Directory -Path "$TargetDir/.claude/learnings" -Force | Out-Null

Write-Output "OK: Hook scripts installed to $HooksDest"
Write-Output "OK: Context directories created at $TargetDir/.claude/"

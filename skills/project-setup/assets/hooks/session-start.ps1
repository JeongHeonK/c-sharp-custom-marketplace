# session-start.ps1 — SessionStart hook
# stdin으로 hook 데이터를 받고, stdout으로 컨텍스트를 출력합니다.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir/lib/utils.ps1"

$ContextDir = ".claude/context"
$LearningsDir = ".claude/learnings"

Ensure-Dir $ContextDir
Ensure-Dir $LearningsDir

# stdin 읽기
$json = Read-StdinJson
$source = if ($json -and $json.source) { $json.source } else { "startup" }

# --- 컨텍스트 출력 ---

Write-Output "## Session Context"
Write-Output ""
Write-Output "**Branch**: $(Get-GitBranch)"
Write-Output "**Time**: $(Get-FormattedDate)"
Write-Output ""

# Git 상태 출력
$status = Get-GitStatusShort
if ($status) {
    Write-Output "### Uncommitted Changes"
    Write-Output '```'
    Write-Output $status
    Write-Output '```'
    Write-Output ""
}

# compact 복구인 경우 이전 상태 파일 읽기
if ($source -eq "compact") {
    $recentState = Get-RecentFile -Dir $ContextDir -Pattern "state_*.md" -Count 1
    if ($recentState) {
        Write-Output "### Restored State (pre-compact)"
        Get-Content $recentState.FullName
        Write-Output ""
    }
}

# 최근 세션 학습 내용 읽기
$recentLearning = Get-RecentFile -Dir $LearningsDir -Pattern "session_*.md" -Count 1
if ($recentLearning) {
    Write-Output "### Previous Session Learnings"
    Get-Content $recentLearning.FullName
    Write-Output ""
}

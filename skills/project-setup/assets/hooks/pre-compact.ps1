# pre-compact.ps1 — PreCompact hook
# 컨텍스트 압축 전 현재 상태를 저장합니다.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir/lib/utils.ps1"

$ContextDir = ".claude/context"
Ensure-Dir $ContextDir

$ts = Get-Timestamp
$stateFile = "$ContextDir/state_$ts.md"

# 현재 상태 수집
$content = @()
$content += "## State Snapshot"
$content += ""
$content += "**Branch**: $(Get-GitBranch)"
$content += "**Time**: $(Get-FormattedDate)"
$content += ""

# Git diff 통계
$diffStat = Get-GitDiffStat
if ($diffStat) {
    $content += "### Working Changes"
    $content += '```'
    $content += $diffStat
    $content += '```'
    $content += ""
}

# 최근 커밋
$commits = Get-GitRecentCommits -Count 5
if ($commits) {
    $content += "### Recent Commits"
    $content += '```'
    $content += $commits
    $content += '```'
    $content += ""
}

# 미커밋 변경 파일 목록
$status = Get-GitStatusShort
if ($status) {
    $content += "### Uncommitted Files"
    $content += '```'
    $content += $status
    $content += '```'
    $content += ""
}

$content | Out-File -FilePath $stateFile -Encoding utf8

# 최근 3개만 유지
Remove-OldFiles -Dir $ContextDir -Pattern "state_*.md" -Keep 3

Write-Output "State saved to $stateFile"

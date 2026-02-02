# session-complete.ps1 — Stop hook
# 세션 종료 시 학습 내용을 기록합니다.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir/lib/utils.ps1"

$LearningsDir = ".claude/learnings"
Ensure-Dir $LearningsDir

$ts = Get-Timestamp
$sessionFile = "$LearningsDir/session_$ts.md"

# 세션 정보 수집
$content = @()
$content += "## Session Summary"
$content += ""
$content += "**Branch**: $(Get-GitBranch)"
$content += "**Time**: $(Get-FormattedDate)"
$content += ""

# 최근 커밋
$commits = Get-GitRecentCommits -Count 10
if ($commits) {
    $content += "### Commits This Session"
    $content += '```'
    $content += $commits
    $content += '```'
    $content += ""
}

# 미커밋 변경사항
$status = Get-GitStatusShort
if ($status) {
    $content += "### Uncommitted Changes"
    $content += '```'
    $content += $status
    $content += '```'
    $content += ""
}

$content | Out-File -FilePath $sessionFile -Encoding utf8

# 최근 5개만 유지
Remove-OldFiles -Dir $LearningsDir -Pattern "session_*.md" -Keep 5

Write-Output "Session recorded to $sessionFile"

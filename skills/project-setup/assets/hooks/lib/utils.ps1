# utils.ps1 — 공유 PowerShell 유틸리티
# Hook 스크립트에서 . (dot-source)하여 사용

# --- Git 유틸 ---

function Get-GitBranch {
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0 -and $branch) { return $branch }
    } catch {}
    return "unknown"
}

function Get-GitStatusShort {
    try { return (git status --short 2>$null) } catch { return "" }
}

function Get-GitDiffStat {
    try { return (git diff --stat 2>$null) } catch { return "" }
}

function Get-GitRecentCommits {
    param([int]$Count = 5)
    try { return (git log --oneline -n $Count 2>$null) } catch { return "" }
}

# --- 시간 유틸 ---

function Get-Timestamp {
    return (Get-Date -Format "yyyyMMdd_HHmmss")
}

function Get-FormattedDate {
    return (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}

# --- 파일 유틸 ---

function Get-RecentFile {
    param(
        [string]$Dir,
        [string]$Pattern,
        [int]$Count = 1
    )
    if (-not (Test-Path $Dir)) { return @() }
    return Get-ChildItem -Path $Dir -Filter $Pattern -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First $Count
}

function Remove-OldFiles {
    param(
        [string]$Dir,
        [string]$Pattern,
        [int]$Keep = 3
    )
    if (-not (Test-Path $Dir)) { return }
    $files = Get-ChildItem -Path $Dir -Filter $Pattern -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -Skip $Keep
    foreach ($f in $files) {
        Remove-Item $f.FullName -Force
    }
}

function Ensure-Dir {
    param([string]$Dir)
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

# --- stdin 파싱 유틸 ---

function Read-StdinJson {
    try {
        $input_text = [Console]::In.ReadToEnd()
        if ($input_text) {
            return $input_text | ConvertFrom-Json -ErrorAction SilentlyContinue
        }
    } catch {}
    return $null
}

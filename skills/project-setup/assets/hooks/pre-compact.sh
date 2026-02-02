#!/usr/bin/env bash
# pre-compact.sh — PreCompact hook
# 컨텍스트 압축 전 현재 상태를 저장합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/utils.sh
source "$SCRIPT_DIR/lib/utils.sh"

CONTEXT_DIR=".claude/context"
ensure_dir "$CONTEXT_DIR"

TS=$(timestamp)
STATE_FILE="$CONTEXT_DIR/state_${TS}.md"

# 현재 상태 수집
{
    echo "## State Snapshot"
    echo ""
    echo "**Branch**: $(git_branch)"
    echo "**Time**: $(format_date)"
    echo ""

    # Git diff 통계
    DIFF_STAT=$(git_diff_stat)
    if [ -n "$DIFF_STAT" ]; then
        echo "### Working Changes"
        echo '```'
        echo "$DIFF_STAT"
        echo '```'
        echo ""
    fi

    # 최근 커밋
    COMMITS=$(git_recent_commits 5)
    if [ -n "$COMMITS" ]; then
        echo "### Recent Commits"
        echo '```'
        echo "$COMMITS"
        echo '```'
        echo ""
    fi

    # 미커밋 변경 파일 목록
    STATUS=$(git_status_short)
    if [ -n "$STATUS" ]; then
        echo "### Uncommitted Files"
        echo '```'
        echo "$STATUS"
        echo '```'
        echo ""
    fi
} > "$STATE_FILE"

# 최근 3개만 유지
prune_files "$CONTEXT_DIR" "state_*.md" 3

echo "State saved to $STATE_FILE"

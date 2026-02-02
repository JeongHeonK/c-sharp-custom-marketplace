#!/usr/bin/env bash
# session-complete.sh — Stop hook
# 세션 종료 시 학습 내용을 기록합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/utils.sh
source "$SCRIPT_DIR/lib/utils.sh"

LEARNINGS_DIR=".claude/learnings"
ensure_dir "$LEARNINGS_DIR"

TS=$(timestamp)
SESSION_FILE="$LEARNINGS_DIR/session_${TS}.md"

# 세션 정보 수집
{
    echo "## Session Summary"
    echo ""
    echo "**Branch**: $(git_branch)"
    echo "**Time**: $(format_date)"
    echo ""

    # 최근 커밋 (이 세션에서 작성된 것들)
    COMMITS=$(git_recent_commits 10)
    if [ -n "$COMMITS" ]; then
        echo "### Commits This Session"
        echo '```'
        echo "$COMMITS"
        echo '```'
        echo ""
    fi

    # 미커밋 변경사항
    STATUS=$(git_status_short)
    if [ -n "$STATUS" ]; then
        echo "### Uncommitted Changes"
        echo '```'
        echo "$STATUS"
        echo '```'
        echo ""
    fi
} > "$SESSION_FILE"

# 최근 5개만 유지
prune_files "$LEARNINGS_DIR" "session_*.md" 5

echo "Session recorded to $SESSION_FILE"

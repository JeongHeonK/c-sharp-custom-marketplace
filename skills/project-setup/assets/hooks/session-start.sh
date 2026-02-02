#!/usr/bin/env bash
# session-start.sh — SessionStart hook
# stdin으로 hook 데이터를 받고, stdout으로 컨텍스트를 출력합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/utils.sh
source "$SCRIPT_DIR/lib/utils.sh"

CONTEXT_DIR=".claude/context"
LEARNINGS_DIR=".claude/learnings"

ensure_dir "$CONTEXT_DIR"
ensure_dir "$LEARNINGS_DIR"

# stdin 읽기 (SessionStart hook은 JSON 데이터를 받음)
INPUT=$(parse_stdin)
SOURCE=$(echo "$INPUT" | json_field "source")
SOURCE="${SOURCE:-startup}"

# --- 컨텍스트 출력 ---

echo "## Session Context"
echo ""
echo "**Branch**: $(git_branch)"
echo "**Time**: $(format_date)"
echo ""

# Git 상태 출력
STATUS=$(git_status_short)
if [ -n "$STATUS" ]; then
    echo "### Uncommitted Changes"
    echo '```'
    echo "$STATUS"
    echo '```'
    echo ""
fi

# compact 복구인 경우 이전 상태 파일 읽기
if [ "$SOURCE" = "compact" ]; then
    RECENT_STATE=$(get_recent_file "$CONTEXT_DIR" "state_*.md" 1)
    if [ -n "$RECENT_STATE" ]; then
        echo "### Restored State (pre-compact)"
        cat "$RECENT_STATE"
        echo ""
    fi
fi

# 최근 세션 학습 내용 읽기
RECENT_LEARNING=$(get_recent_file "$LEARNINGS_DIR" "session_*.md" 1)
if [ -n "$RECENT_LEARNING" ]; then
    echo "### Previous Session Learnings"
    cat "$RECENT_LEARNING"
    echo ""
fi

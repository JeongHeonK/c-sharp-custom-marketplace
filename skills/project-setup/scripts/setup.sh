#!/usr/bin/env bash
# setup.sh — Hook 파일 복사 + 디렉토리 생성
# Usage: bash setup.sh <target-dir>
#
# 이 스크립트는 최소한의 작업만 수행합니다:
# - assets/hooks/* → <target>/scripts/hooks/ 복사
# - chmod +x 설정
# - .claude/context/, .claude/learnings/ 디렉토리 생성
#
# CLAUDE.md 및 settings.local.json 조작은 Claude 도구가 담당합니다.

set -euo pipefail

TARGET_DIR="${1:-.}"

# 절대 경로로 변환
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo "ERROR: Target directory does not exist: $1" >&2
    exit 1
}

# 이 스크립트의 위치 기준으로 assets/hooks 경로 결정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets/hooks"

if [ ! -d "$ASSETS_DIR" ]; then
    echo "ERROR: Assets directory not found: $ASSETS_DIR" >&2
    exit 1
fi

# 1. Hook 파일 복사
HOOKS_DEST="$TARGET_DIR/scripts/hooks"
mkdir -p "$HOOKS_DEST/lib"

# Bash 스크립트
cp "$ASSETS_DIR/lib/utils.sh" "$HOOKS_DEST/lib/utils.sh"
cp "$ASSETS_DIR/session-start.sh" "$HOOKS_DEST/session-start.sh"
cp "$ASSETS_DIR/pre-compact.sh" "$HOOKS_DEST/pre-compact.sh"
cp "$ASSETS_DIR/session-complete.sh" "$HOOKS_DEST/session-complete.sh"

# PowerShell 스크립트
cp "$ASSETS_DIR/lib/utils.ps1" "$HOOKS_DEST/lib/utils.ps1"
cp "$ASSETS_DIR/session-start.ps1" "$HOOKS_DEST/session-start.ps1"
cp "$ASSETS_DIR/pre-compact.ps1" "$HOOKS_DEST/pre-compact.ps1"
cp "$ASSETS_DIR/session-complete.ps1" "$HOOKS_DEST/session-complete.ps1"

# 2. 실행 권한 설정 (bash)
chmod +x "$HOOKS_DEST/session-start.sh"
chmod +x "$HOOKS_DEST/pre-compact.sh"
chmod +x "$HOOKS_DEST/session-complete.sh"

# 3. Claude 컨텍스트 디렉토리 생성
mkdir -p "$TARGET_DIR/.claude/context"
mkdir -p "$TARGET_DIR/.claude/learnings"

echo "OK: Hook scripts installed to $HOOKS_DEST"
echo "OK: Context directories created at $TARGET_DIR/.claude/"

#!/usr/bin/env bash
# utils.sh — 공유 bash 유틸리티
# Hook 스크립트에서 source하여 사용

# --- Git 유틸 ---

git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) && echo "$branch" || echo "unknown"
}

git_status_short() {
    git status --short 2>/dev/null || echo ""
}

git_diff_stat() {
    git diff --stat 2>/dev/null || echo ""
}

git_recent_commits() {
    local count="${1:-5}"
    git log --oneline -n "$count" 2>/dev/null || echo ""
}

# --- 시간 유틸 ---

timestamp() {
    date +%Y%m%d_%H%M%S
}

format_date() {
    date +"%Y-%m-%d %H:%M:%S"
}

# --- 파일 유틸 ---

# 디렉토리에서 패턴에 맞는 최근 파일 반환
# Usage: get_recent_file <dir> <pattern> [count]
get_recent_file() {
    local dir="$1"
    local pattern="$2"
    local count="${3:-1}"

    if [ ! -d "$dir" ]; then
        return
    fi

    # shellcheck disable=SC2012
    ls -t "$dir"/$pattern 2>/dev/null | head -n "$count"
}

# 디렉토리에서 오래된 파일 삭제 (최근 N개만 유지)
# Usage: prune_files <dir> <pattern> <keep_count>
prune_files() {
    local dir="$1"
    local pattern="$2"
    local keep="${3:-3}"

    if [ ! -d "$dir" ]; then
        return
    fi

    # shellcheck disable=SC2012
    local files
    files=$(ls -t "$dir"/$pattern 2>/dev/null | tail -n +$((keep + 1)))

    if [ -n "$files" ]; then
        echo "$files" | xargs rm -f
    fi
}

# 디렉토리 존재 확인 및 생성
ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
}

# --- stdin 파싱 유틸 ---

# stdin에서 JSON-like 입력 읽기
parse_stdin() {
    cat
}

# 간단한 grep 기반 JSON 필드 추출
# Usage: echo '{"key":"value"}' | json_field "key"
json_field() {
    local field="$1"
    grep -o "\"$field\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" 2>/dev/null | head -1 | sed 's/.*: *"\(.*\)"/\1/' || echo ""
}

# CLAUDE.md

이 파일은 **이 저장소를 개발/유지보수하는 Claude Code**를 위한 가이드입니다.

## Overview

C#/.NET 및 WPF 개발을 위한 Claude Code 플러그인 마켓플레이스 (v1.6.0)

- **GitHub**: `JeongHeonK/c-sharp-custom-marketplace`
- **License**: MIT
- **Requirements**: Claude Code 2.1.x+

## Architecture

### 3-tier 구조

```
agents/   → 전문가 에이전트 (실제 작업 수행)
skills/   → 사용자 호출 스킬 (워크플로우 정의, 에이전트에 위임)
rules/    → 스킬 내부 knowledge-base (skills/*/rules/)
```

### 모델 계층화

| 역할 | 모델 | 예시 |
|------|------|------|
| 오케스트레이션 (복잡한 워크플로우 조율) | Opus | `csharp-tdd-develop`, `csharp-test-develop` |
| 전문가 에이전트 (실제 코드 작성/분석) | Sonnet | `csharp-expert`, `wpf-expert` |
| Knowledge-base (가이드라인 참조) | 미지정 (호출측 모델) | `csharp-best-practices` |

### 위임 패턴

스킬이 오케스트레이터 역할을 하고, `csharp-expert` 에이전트에 실제 작업을 위임:

```
사용자 → /csharp-tdd-develop → (워크플로우 조율) → Task(csharp-expert) → 코드 작성
```

### 스킬 context 모드

| 모드 | 동작 | 사용처 |
|------|------|--------|
| `fork` | 독립 실행, 완료 후 결과 반환 | `csharp-code-review`, `csharp-refactor`, `wpf-mvvm-generator` |
| `current` | 현재 컨텍스트에서 실행 | `csharp-tdd-develop`, `csharp-test-develop`, `csharp-best-practices`, `project-setup` |

## File Structure

```
/
├── agents/
│   ├── csharp-expert.md          # C#/.NET 전문가 에이전트
│   └── wpf-expert.md             # WPF/MVVM 전문가 에이전트
├── skills/
│   ├── csharp-code-review/SKILL.md
│   ├── csharp-refactor/SKILL.md
│   ├── csharp-best-practices/
│   │   ├── SKILL.md
│   │   └── rules/                # 14개 규칙 파일 (cs12-*, modern-*)
│   ├── csharp-tdd-develop/
│   │   ├── SKILL.md
│   │   └── scripts/              # test-detector.js
│   ├── csharp-test-develop/
│   │   ├── SKILL.md
│   │   └── references/           # csharp-test-patterns.md
│   ├── project-setup/
│   │   ├── SKILL.md
│   │   ├── scripts/              # setup.sh, setup.ps1
│   │   ├── references/           # claude-md-template.md
│   │   └── assets/hooks/         # hook 스크립트 (.sh + .ps1)
│   └── wpf-mvvm-generator/SKILL.md
├── .claude-plugin/
│   └── marketplace.json          # 마켓플레이스 매니페스트
├── .mcp.json                     # MCP 서버 설정 (context7)
├── README.md                     # 영문 문서
└── README.ko.md                  # 한국어 문서
```

## YAML Frontmatter 필수 필드

### Agent (`agents/*.md`)

```yaml
name: <agent-name>
description: <영문 설명>
model: sonnet | opus | haiku
permissionMode: default
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - Bash(dotnet *)
  - Bash(nuget *)
disallowedTools:
  - WebSearch
```

### Skill (`skills/*/SKILL.md`)

```yaml
name: <skill-name>
description: <설명>
user-invocable: true
context: fork | current
model: sonnet | opus        # knowledge-base 스킬은 생략 가능
argument-hint: "<hint>"
allowed-tools:
  - Read
  - Glob
  - Grep
  # context: current + 위임 패턴인 경우 Task 포함
```

## Documentation Language

| 파일 | 언어 |
|------|------|
| SKILL.md 본문 | 한국어 |
| Agent .md 본문 | 영어 |
| README.md | 영어 |
| README.ko.md | 한국어 |
| Git 커밋 메시지 | 한국어 (Conventional Commits) |

## Version Management

버전 변경 시 다음 3곳을 동시에 업데이트:

1. `.claude-plugin/marketplace.json` — `metadata.version` + `plugins[0].version`
2. `CLAUDE.md` — Overview 섹션의 버전 표기
3. `README.md` / `README.ko.md` — 배지 및 Changelog 섹션

## Development Guidelines

### 스킬 추가/수정 시 docs 업데이트 체크리스트

새 스킬을 추가하거나 기존 스킬을 수정할 때 반드시 다음을 업데이트:

1. **Knowledge-base 스킬 추가 시**:
   - `skills/project-setup/references/claude-md-template.md`의 `## C#/.NET Quick Reference` 섹션에 인라인 요약 추가
   - `## Detailed References` 섹션에 파일 경로 + "When to Read" 트리거 조건 행 추가
   - `/csharp-best-practices` SKILL.md Rules 테이블에도 동기화

2. **Workflow/Generator 스킬 추가 시**:
   - `skills/project-setup/references/claude-md-template.md`의 `Skill Workflows` 섹션에 행 추가
   - "Pre-invoke" 컬럼에 explore-first 지시 포함

3. **rules/ 파일 추가/삭제 시**:
   - `claude-md-template.md` Quick Reference 인라인 요약 + Detailed References 테이블 동기화
   - `csharp-best-practices/SKILL.md` Rules 테이블 동기화

4. **조건부 섹션 관련**:
   - WPF 비대상 시 제거: `### WPF/MVVM Patterns` + `Scaffolding` 워크플로우
   - 테스트 미존재 시 제거: `### Test Patterns` + Test 커맨드 행
   - TargetFramework < net8.0: C# 12 섹션에 경고 노트 추가 (섹션 유지)

4. **공통**:
   - `README.md` / `README.ko.md` Skills 섹션 업데이트
   - `CLAUDE.md` File Structure 트리 업데이트

### 스킬 작성 규칙
- Knowledge-base 스킬: `allowed-tools`에 Read, Glob, Grep만. Edit/Write 불가.
- Fork 스킬: 독립 실행 가능한 결과물 생성. 호출자 컨텍스트 의존 불가.
- Current+Task 스킬: SKILL.md에 오케스트레이션만. 실제 코드 작업은 Task로 에이전트 위임.

### 테스트
- 스킬 수정 후 대표 인자로 직접 호출하여 검증.
- rules/ 파일 수정 후 참조하는 스킬로 올바른 파일 해석 확인.

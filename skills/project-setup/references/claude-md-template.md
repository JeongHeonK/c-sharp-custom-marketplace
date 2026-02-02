# CLAUDE.md Template

이 템플릿은 `/project-setup init`이 대상 프로젝트에 생성하는 CLAUDE.md의 구조입니다.
`{변수}`는 Step 2에서 감지한 프로젝트 정보로 치환합니다.

---

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

- **Type**: {프로젝트 유형}
- **Framework**: {TargetFramework}
- **Solution**: {솔루션 파일명}

## Build & Test Commands

- Build: `dotnet build`
- Test: `dotnet test`
- Run: `dotnet run --project {메인 프로젝트 경로}`

## Project Structure

{감지된 프로젝트 구조}

## Key Dependencies

{주요 NuGet 패키지 목록}

## Coding Conventions

- Follow C# naming conventions (PascalCase for public members, _camelCase for private fields)
- Use file-scoped namespaces
- Prefer primary constructors where appropriate
- Use nullable reference types

## Context Management

This project uses automated context hooks to maintain session state.

### Hook Scripts (Bash / PowerShell)
- `scripts/hooks/session-start.sh` / `.ps1` — Restores context on session start
- `scripts/hooks/pre-compact.sh` / `.ps1` — Saves state before context compaction
- `scripts/hooks/session-complete.sh` / `.ps1` — Records session learnings on exit

### Context Directories
- `.claude/context/` — Session state snapshots (auto-managed)
- `.claude/learnings/` — Cross-session learnings (auto-managed)

## C#/.NET Coding Guidelines

Prefer retrieval-led reasoning over pre-training-led reasoning for any C#/.NET tasks.
When writing or reviewing C# code, read the relevant guideline file BEFORE writing code.

### C# 12 Features (.NET 8)

| Guideline | File | When to Read |
|-----------|------|-------------|
| Primary Constructors | `{plugin-path}/rules/cs12-primary-constructor.md` | DI 서비스, 간단한 초기화 클래스 작성 시 |
| Collection Expressions | `{plugin-path}/rules/cs12-collection-expression.md` | 배열/리스트/Span 초기화 시 |
| Alias Any Type | `{plugin-path}/rules/cs12-alias-any-type.md` | 복잡한 타입에 별칭 필요 시 |
| Lambda Default Params | `{plugin-path}/rules/cs12-lambda-defaults.md` | 람다 식에 기본값 필요 시 |
| Inline Arrays | `{plugin-path}/rules/cs12-inline-array.md` | 고성능 고정 크기 버퍼 필요 시 |
| ref readonly Parameters | `{plugin-path}/rules/cs12-ref-readonly-param.md` | 참조 전달 API 설계 시 |

### Modern C# (C# 9-11)

| Guideline | File | When to Read |
|-----------|------|-------------|
| Record Types | `{plugin-path}/rules/modern-record-type.md` | DTO, Value Object 작성 시 |
| required / init | `{plugin-path}/rules/modern-required-init.md` | 안전한 객체 초기화 필요 시 |
| Pattern Matching | `{plugin-path}/rules/modern-pattern-matching.md` | 복잡한 조건 분기 시 |
| List Patterns | `{plugin-path}/rules/modern-list-pattern.md` | 배열/리스트 패턴 매칭 시 |
| Raw String Literals | `{plugin-path}/rules/modern-raw-string-literal.md` | 멀티라인 문자열 시 |
| File-scoped Namespaces | `{plugin-path}/rules/modern-file-scoped-namespace.md` | 새 .cs 파일 생성 시 (항상) |

## Skill Workflows

When a task matches below, explore relevant code first, then invoke the skill.

### Development (explore code → invoke)
| Task | Skill | Pre-invoke |
|------|-------|-----------|
| TDD로 새 클래스 개발 | `/csharp-tdd-develop <class>` | 관련 클래스와 테스트 패턴 먼저 읽기 |
| 기존 코드에 테스트 추가 | `/csharp-test-develop <file>` | 대상 파일과 의존성 먼저 파악 |

### Code Quality (코드 작성 후)
| Task | Skill | When to invoke |
|------|-------|---------------|
| 코드 리뷰 | `/csharp-code-review <file>` | 커밋 전 모든 수정된 .cs 파일에 |
| 리팩토링 | `/csharp-refactor <file> <type>` | SOLID 위반/코드 스멜 발견 시 |

### Scaffolding
| Task | Skill |
|------|-------|
| WPF ViewModel/View 생성 | `/wpf-mvvm-generator <entity>` |

### .NET 문서 검색
프롬프트에 "use context7" 포함 시 MCP로 .NET 공식 문서 검색 가능.
```

---

## 치환 규칙

| 변수 | 소스 | 예시 |
|------|------|------|
| `{프로젝트 유형}` | Step 2 판별 결과 | WPF Application, Console Application |
| `{TargetFramework}` | `.csproj` `<TargetFramework>` | net8.0, net9.0 |
| `{솔루션 파일명}` | `.sln` 파일명 | MyApp.sln |
| `{메인 프로젝트 경로}` | OutputType이 Exe/WinExe인 `.csproj` 경로 | src/MyApp/MyApp.csproj |
| `{감지된 프로젝트 구조}` | 디렉토리 트리 | src/, tests/ 구조 |
| `{주요 NuGet 패키지 목록}` | `<PackageReference>` 항목 | CommunityToolkit.Mvvm 등 |
| `{plugin-path}` | Glob `**/skills/csharp-best-practices/SKILL.md`의 부모 디렉토리 | `/home/user/.claude/plugins/.../skills/csharp-best-practices` |

## 조건부 섹션

- **WPF 프로젝트가 아닌 경우**: "Skill Workflows > Scaffolding" 섹션 제거
- **테스트 프로젝트가 없는 경우**: Build & Test Commands에서 Test 행 제거

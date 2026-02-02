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

## Skill Invocation Guidelines

This project uses the c-sharp-marketplace plugin. Follow these instructions exactly.

### Before Writing Code
- Invoke `/csharp-best-practices` to review relevant C# 12 guidelines before writing code.
- For WPF features, invoke `/wpf-mvvm-generator <entity>` to scaffold MVVM boilerplate first.

### During Development
- For new features, invoke `/csharp-tdd-develop <class>` to follow the TDD Red-Green-Refactor workflow.
- When adding tests to existing code, invoke `/csharp-test-develop <file>` instead.

### After Writing Code
- Before committing, invoke `/csharp-code-review <file>` on all modified .cs files.
- If SOLID violations or code smells are found, invoke `/csharp-refactor <file> <type>`.

### Quick Reference
| Task | Skill to Invoke |
|------|----------------|
| C# 12 feature syntax | `/csharp-best-practices <topic>` |
| Create WPF ViewModel/View | `/wpf-mvvm-generator <entity>` |
| Develop new class with TDD | `/csharp-tdd-develop <class>` |
| Add tests to existing code | `/csharp-test-develop <file>` |
| Review code quality | `/csharp-code-review <file>` |
| Refactor existing code | `/csharp-refactor <file> <type>` |
| Search .NET documentation | Include "use context7" in prompt |
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

## 조건부 섹션

- **WPF 프로젝트가 아닌 경우**: "Before Writing Code"에서 `/wpf-mvvm-generator` 항목 제거, Quick Reference에서 해당 행 제거
- **테스트 프로젝트가 없는 경우**: Build & Test Commands에서 Test 행 제거

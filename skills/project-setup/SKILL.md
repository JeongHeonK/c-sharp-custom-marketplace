---
name: project-setup
description: C#/.NET 프로젝트를 Claude Code용으로 초기화. CLAUDE.md 생성 + 컨텍스트 hook 설치 (Bash/PowerShell). Use when setting up new C# projects for Claude Code, migrating existing projects, or updating context hooks.
user-invocable: true
context: current
model: sonnet
argument-hint: "<init|migrate|hooks> [project-path]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---

# Project Setup

C#/.NET 프로젝트를 Claude Code용으로 초기화하는 스킬. CLAUDE.md 생성과 컨텍스트 hook(Bash/PowerShell)을 설치합니다.

## Arguments

- `$ARGUMENTS[0]`: 서브커맨드 (`init` | `migrate` | `hooks`)
- `$ARGUMENTS[1]`: 대상 프로젝트 경로 (선택, 기본값: 현재 디렉토리)

### 서브커맨드

| 커맨드 | 설명 |
|--------|------|
| `init` | 새 프로젝트 초기화 (CLAUDE.md 생성 + hook 설치) |
| `migrate` | 기존 CLAUDE.md에 Context Management 섹션 추가 + hook 설치 |
| `hooks` | hook 스크립트만 설치/업데이트 |

---

## Workflow

### Step 1: 인자 파싱

```
서브커맨드 = $ARGUMENTS[0] (기본값: "init")
대상 경로 = $ARGUMENTS[1] (기본값: 현재 작업 디렉토리)
```

서브커맨드가 `init`, `migrate`, `hooks` 중 하나가 아니면:
- 첫 번째 인자를 경로로 간주하고 서브커맨드를 `init`으로 설정

---

### Step 2: C# 프로젝트 감지 (init/migrate)

`hooks` 서브커맨드인 경우 이 단계 건너뛰기.

1. Glob으로 대상 경로에서 `.sln`, `.csproj` 파일 탐색
2. `.csproj` 파일들을 Read하여 다음 정보 추출:
   - `<TargetFramework>` (예: net8.0, net9.0)
   - `<OutputType>` (예: WinExe, Exe, Library)
   - `<UseWPF>true</UseWPF>` 여부
   - `<PackageReference>` 목록 (주요 NuGet 패키지)
3. 프로젝트 유형 판별:

| OutputType | UseWPF | 판별 결과 |
|------------|--------|-----------|
| WinExe | true | WPF Application |
| Exe | - | Console Application |
| Library | - | Class Library |
| - | - (WebAPI 패키지 있음) | ASP.NET WebAPI |
| - | - (테스트 패키지 있음) | Test Project |

4. 솔루션 구조 파악:
   - `.sln` 파일에서 프로젝트 목록 추출
   - src/tests 디렉토리 구조 확인

---

### Step 3: Hook 스크립트 설치

**OS 감지**: `uname -s` 결과로 환경 판별:

| `uname -s` 결과 | 환경 | 스크립트 |
|-----------------|------|----------|
| `Linux` | Linux/WSL | setup.sh |
| `Darwin` | macOS | setup.sh |
| `MINGW*` / `MSYS*` / `CYGWIN*` | Git Bash/MSYS2 | setup.sh |
| 명령 실패 또는 그 외 | Windows (native) | setup.ps1 |

#### Bash 환경 (Linux/macOS/WSL):
```bash
bash <plugin-path>/skills/project-setup/scripts/setup.sh <target-dir>
```

#### PowerShell 환경 (Windows):
```powershell
pwsh <plugin-path>/skills/project-setup/scripts/setup.ps1 -TargetDir <target-dir>
```

`<plugin-path>`는 이 SKILL.md의 부모 디렉토리(`skills/project-setup/`)의 절대 경로입니다. setup 스크립트가 hook 파일 복사, 실행 권한 설정, 디렉토리 생성을 수행합니다.

---

### Step 4: CLAUDE.md 생성 또는 업데이트

#### init 서브커맨드: CLAUDE.md 신규 생성

Write 도구로 `<target>/CLAUDE.md` 생성. `references/claude-md-template.md` 템플릿을 참조하여 Step 2에서 감지한 정보로 `{변수}`를 치환합니다.

1. Read로 `references/claude-md-template.md` 읽기
2. 템플릿의 `{변수}`를 Step 2 감지 결과로 치환
3. 조건부 섹션 적용:
   - **WPF 프로젝트가 아닌 경우**: `### WPF/MVVM Patterns` 섹션 제거 + `Skill Workflows > Scaffolding` 섹션 제거
   - **테스트 프로젝트가 없는 경우**: `### Test Patterns` 섹션 제거 + `Build & Test Commands`에서 Test 행 제거
   - **TargetFramework < net8.0인 경우**: `### C# 12 Features (.NET 8)` 섹션 상단에 경고 노트 추가 (`> ⚠ 현재 프로젝트는 {TargetFramework}입니다. C# 12 기능은 .NET 8+ 에서 사용 가능합니다.`)
4. Write로 `<target>/CLAUDE.md` 생성

#### migrate 서브커맨드: 기존 CLAUDE.md에 섹션 추가

1. 기존 CLAUDE.md를 Read
2. `## Context Management` 섹션이 없으면 Edit으로 추가
3. `## C#/.NET Quick Reference` 섹션이 없으면 Edit으로 추가 (템플릿의 Quick Reference 전체)
4. `## Detailed References` 섹션이 없으면 Edit으로 추가 (기존 `## C#/.NET Coding Guidelines`가 있으면 `## Detailed References`로 리네임)
5. `## Skill Workflows` 섹션이 없으면 Edit으로 추가
6. 기존 내용은 절대 삭제하지 않음

---

### Step 5: settings.local.json 업데이트

1. Read로 `<target>/.claude/settings.local.json` 읽기 (없으면 새로 생성)
2. Step 3에서 감지한 OS에 따라 hook command 결정:
   - **Bash 환경**: `bash scripts/hooks/<name>.sh`
   - **PowerShell 환경**: `pwsh scripts/hooks/<name>.ps1`
3. 기존 hooks 설정이 있으면 병합, 없으면 새로 추가:

#### Hook 등록 구조

```json
{
  "hooks": {
    "SessionStart": [{ "matcher": "", "hooks": [{ "type": "command", "command": "<runner> scripts/hooks/session-start.<ext>" }] }],
    "PreCompact":   [{ "matcher": "", "hooks": [{ "type": "command", "command": "<runner> scripts/hooks/pre-compact.<ext>" }] }],
    "Stop":         [{ "matcher": "", "hooks": [{ "type": "command", "command": "<runner> scripts/hooks/session-complete.<ext>" }] }]
  }
}
```

**`<runner>` / `<ext>` 치환:**

| 환경 | `<runner>` | `<ext>` |
|------|-----------|---------|
| Bash (Linux/macOS/WSL) | `bash` | `sh` |
| PowerShell (Windows) | `pwsh` | `ps1` |

4. 기존 설정이 있으면 `hooks` 키에 병합 (기존 hook은 유지)

---

### Step 6: 검증 체크리스트

모든 설치가 완료된 후 검증:

- [ ] `scripts/hooks/session-start.sh` + `.ps1` 존재
- [ ] `scripts/hooks/pre-compact.sh` + `.ps1` 존재
- [ ] `scripts/hooks/session-complete.sh` + `.ps1` 존재
- [ ] `scripts/hooks/lib/utils.sh` + `utils.ps1` 존재
- [ ] Bash 스크립트 실행 권한 확인 (Linux/macOS)
- [ ] `.claude/context/` 디렉토리 존재
- [ ] `.claude/learnings/` 디렉토리 존재
- [ ] `.claude/settings.local.json`에 hook 등록 확인
- [ ] `CLAUDE.md`에 `## C#/.NET Quick Reference` 섹션 존재 (init/migrate)
- [ ] `CLAUDE.md`에 `## Detailed References` 섹션 존재 (init/migrate)
- [ ] `CLAUDE.md`에 `## Skill Workflows` 섹션 존재 (init/migrate)
- [ ] 조건부 섹션 정상 적용: WPF가 아닌 경우 WPF 섹션 없음, 테스트 없는 경우 Test 섹션 없음

검증 실패 항목이 있으면 사용자에게 알리고 수동 조치 방법 안내.

---

## 현재 전달받은 인자

**ARGUMENTS**: $ARGUMENTS

## 실행 지시

위 ARGUMENTS를 파싱하여 워크플로우를 시작하세요.

**ARGUMENTS가 비어있으면** `init`을 기본 서브커맨드로 사용하고, 현재 디렉토리를 대상으로 합니다.

**호출 예시:**
- `/project-setup` → init + 현재 디렉토리
- `/project-setup init` → init + 현재 디렉토리
- `/project-setup init /path/to/project` → init + 지정 경로
- `/project-setup migrate` → 기존 CLAUDE.md에 섹션 추가
- `/project-setup hooks` → hook 스크립트만 설치
- `/project-setup /path/to/project` → init + 지정 경로 (경로가 서브커맨드가 아닌 경우)

---

## Error Handling

| 상황 | 처리 |
|------|------|
| .csproj 없음 | 경고 출력 후 기본 CLAUDE.md 생성 |
| CLAUDE.md 이미 존재 (init) | 사용자에게 덮어쓰기 확인 또는 migrate 제안 |
| settings.local.json 파싱 실패 | 백업 후 새로 생성 |
| setup 스크립트 실행 실패 | 에러 내용 출력 + 수동 설치 방법 안내 |

---

## .gitignore 안내

설치 완료 후 사용자에게 `.gitignore`에 다음 추가를 안내:

```
# Claude Code context (auto-generated, session-specific)
.claude/context/
.claude/learnings/
```

`scripts/hooks/`는 팀 공유를 위해 커밋하는 것을 권장.

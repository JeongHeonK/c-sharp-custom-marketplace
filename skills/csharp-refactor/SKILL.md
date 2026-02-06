---
name: csharp-refactor
description: C# code refactoring skill. Applies SOLID principles, extracts methods/classes, introduces design patterns, and modernizes syntax. Use when improving code maintainability, addressing code smells, or modernizing legacy C# code.
user-invocable: true
argument-hint: "[file_path] [refactor_type]"
context: fork
model: sonnet
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
---

# C# 리팩토링 스킬

유지보수성, 가독성, 베스트 프랙티스 준수를 위해 C# 코드를 체계적으로 리팩토링합니다.

**중요: 모든 결과는 반드시 한국어로 작성합니다.** 코드 식별자, 기술 용어, 패턴 이름 등은 원문 그대로 유지하되, 설명·문제점·개선안 등 서술 부분은 한국어를 사용합니다.

## 인자

- `$ARGUMENTS[0]`: 대상 파일 경로 (선택, 미지정 시 .cs 파일 탐색)
- `$ARGUMENTS[1]`: 리팩토링 유형 (선택): `solid`, `pattern`, `modern`, `extract`, `all`
  - 미지정 시: 모든 카테고리를 스캔하고, 발견된 항목만 적용

## 실행 단계

### 1단계: 대상 식별

파일이 지정되지 않은 경우 (`$ARGUMENTS[0]`이 비어있음):
- 최근 수정된 `.cs` 파일 탐색
- 사용자에게 대상 파일 선택 요청

### 2단계: 코드 분석

대상 코드를 읽고 리팩토링 기회를 분석합니다.

**TargetFramework 확인**: `.csproj`에서 `<TargetFramework>`를 읽어 C# 버전을 파악하고, 해당 버전에서 사용 가능한 기능만 제안합니다.

### 3단계: 리팩토링 적용

`$ARGUMENTS[1]` 기준 또는 전체 카테고리를 분석합니다:

## 리팩토링 카테고리

### SOLID 리팩토링 (`solid`)

| 위반 | 리팩토링 |
|------|----------|
| **SRP** | Extract class, 책임 분리 |
| **OCP** | Strategy/Template Method 패턴 도입 |
| **LSP** | 상속 계층 수정, Composition 사용 |
| **ISP** | 인터페이스를 작은 단위로 분리 |
| **DIP** | 인터페이스 추출, 의존성 주입 |

### Pattern 도입 (`pattern`)

| Code Smell | 권장 패턴 |
|------------|-----------|
| 복잡한 객체 생성 | Builder, Factory Method |
| 타입별 다중 조건문 | Strategy, State |
| 전역 상태 접근 | Singleton (신중하게), DI |
| 복잡한 하위 시스템 | Facade |
| 트리/복합 구조 | Composite |
| 동적 기능 추가 | Decorator |
| 요청 처리 체인 | Chain of Responsibility |

### Modern C# 문법 (`modern`)

| 기존 문법 | Modern 대안 | 최소 버전 |
|-----------|-------------|-----------|
| 생성자 + 필드 할당 | Primary constructor | C# 12 |
| `new List<T> { ... }` | Collection expressions `[...]` | C# 12 |
| 다중 null 체크 | Pattern matching, `?.`, `??` | C# 8 |
| 장황한 switch 문 | Switch expressions | C# 8 |
| 수동 INPC 구현 | `[ObservableProperty]` (CommunityToolkit.Mvvm) | - |
| 변경 가능한 프로퍼티 (non-MVVM) | `required`, `init` | C# 11 |
| 단순 데이터용 class | Record types | C# 9 |
| 전통적 foreach | LINQ (적절한 경우) | - |

### Extract 리팩토링 (`extract`)

- **Extract Method**: 긴 메서드 → 작고 집중된 메서드
- **Extract Class**: 큰 클래스 → 여러 응집된 클래스
- **Extract Interface**: 구체 의존성 → 인터페이스 추상화
- **Extract Base Class**: 중복 코드 → 공유 기반 클래스
- **Extract Parameter Object**: 다수 매개변수 → 단일 객체

## 출력 형식

모든 내용은 **한국어**로 작성합니다. 코드 식별자와 기술 용어는 원문을 유지합니다.

```markdown
# 리팩토링 결과

## 대상
- 파일: {파일 경로}
- 리팩토링 유형: {유형}
- TargetFramework: {버전}

## 적용된 변경

### {리팩토링 이름}
- 위치: `file.cs:line`
- 변경 전:
```csharp
// 기존 코드
```
- 변경 후:
```csharp
// 리팩토링된 코드
```
- 이점: {설명}

## 요약
- 총 리팩토링: {N}건
- 변경된 줄 수: {N}
- 새로 생성된 파일: {목록}

## 추가 권장 사항
- 추가로 적용 가능한 개선 사항
- 고려할 관련 패턴
```

## 에러 처리

| 상황 | 처리 |
|------|------|
| `.cs` 파일 없음 | "리팩토링 대상 .cs 파일이 없습니다" 메시지 출력 후 종료 |
| 대상 파일 미발견 | 사용자에게 파일 경로 재확인 요청 |
| TargetFramework < net8.0 | C# 12 전용 기능 제안 제외, 경고 노트 출력 |

## 가이드라인

- 기존 기능을 유지합니다 (동작 변경 없음)
- 대규모 재작성이 아닌 점진적 변경을 합니다
- 영리함보다 가독성을 우선합니다
- 팀의 패턴 친숙도를 고려합니다
- 로직이 명확하지 않은 경우에만 주석을 추가합니다
- 테스트 프로젝트가 존재하면 `dotnet test` 실행 후 회귀 없음을 확인합니다

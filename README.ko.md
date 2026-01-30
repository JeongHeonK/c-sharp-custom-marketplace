# C# Marketplace Plugin

[![Version](https://img.shields.io/badge/version-1.5.0-blue.svg)]()
[![.NET](https://img.shields.io/badge/.NET-8%2F9-purple.svg)]()
[![C#](https://img.shields.io/badge/C%23-12%2F13-green.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude_Code-2.1.3+-orange.svg)]()

C# 및 WPF 개발을 위한 Claude Code 플러그인입니다. Modern C# 12/13, OOP 원칙, SOLID 원칙, GoF 디자인 패턴에 중점을 둔 전문가 에이전트와 코드 리뷰/리팩토링/MVVM 생성 스킬을 제공합니다.

## 주요 기능

### Agents
| Agent | 설명 |
|-------|------|
| **C# Expert** | Modern C# 12/13, SOLID 원칙, GoF 패턴, Performance 최적화 전문가 |
| **WPF Expert** | CommunityToolkit.Mvvm, MVVM 패턴, 데이터 바인딩, Modern UI 전문가 |

### Skills
| Skill | 설명 |
|-------|------|
| **csharp-code-review** | OOP/SOLID/GoF + Performance/Security/Async 코드 리뷰 |
| **csharp-refactor** | SOLID 원칙 적용, 디자인 패턴 도입, Modern C# 문법 전환 |
| **wpf-mvvm-generator** | CommunityToolkit.Mvvm 기반 ViewModel/View/Model 생성 |
| **csharp-best-practices** | C# 12/.NET 8 코드 작성 가이드라인 knowledge-base (12개 규칙, vercel-react-best-practices 3-tier 아키텍처 참조) |
| **csharp-tdd-develop** | TDD 기반 C# 개발 (Red-Green-Refactor 워크플로우) |
| **csharp-test-develop** | 기존 C# 코드에 테스트 코드 작성 |

### MCP Servers
| Server | 설명 |
|--------|------|
| **Context7** | .NET, WPF, NuGet 공식 문서 검색 |

## 지원 기능

### Modern C# Features (C# 12/13)
- Primary constructors
- Collection expressions `[1, 2, 3]`
- required / init properties
- Pattern matching
- Record types
- params collections (C# 13)
- System.Threading.Lock (C# 13)

### CommunityToolkit.Mvvm
- `[ObservableProperty]` Source Generator
- `[RelayCommand]` / `[AsyncRelayCommand]`
- `WeakReferenceMessenger` Pub/Sub
- Dependency Injection Integration

### Code Review 검토 항목
- OOP 4대 원칙
- SOLID 원칙
- GoF 디자인 패턴 적용 기회
- Modern C# 기능 활용
- Performance (메모리 할당, Span<T>, Memory<T>, LOH)
- Async/Await 패턴
- Security (SQL Injection, XSS 등)

## 설치 방법

### 방법 1: npx로 설치 (권장)
```bash
# 모든 스킬 설치
npx skills add JeongHeonK/c-sharp-custom-marketplace

# 특정 스킬만 설치
npx skills add JeongHeonK/c-sharp-custom-marketplace --skill csharp-code-review
npx skills add JeongHeonK/c-sharp-custom-marketplace --skill csharp-refactor wpf-mvvm-generator
```

### 방법 2: Claude Code UI에서 설치
1. `/plugin` 입력하여 플러그인 매니저 열기
2. **Tab** 키로 **Marketplaces** 탭 이동
3. **Add Marketplace** 선택 후 Enter
4. 경로 입력: `JeongHeonK/c-sharp-custom-marketplace`
5. **Discover** 탭에서 원하는 스킬 선택하여 설치

### 설치 범위 (Scope)

`/plugin` UI에서 설치 시 범위를 선택할 수 있습니다:
- **User scope**: 모든 프로젝트에서 사용 (기본값)
- **Project scope**: 해당 저장소의 모든 협업자가 사용
- **Local scope**: 해당 저장소에서 본인만 사용

## 플러그인 구조

```
c-sharp-marketplace/
├── .claude-plugin/
│   └── marketplace.json     # 마켓플레이스 매니페스트
├── agents/
│   ├── csharp-expert.md     # C#/.NET 전문가 에이전트
│   └── wpf-expert.md        # WPF/MVVM 전문가 에이전트
├── skills/
│   ├── csharp-best-practices/
│   │   ├── SKILL.md         # 베스트 프랙티스 가이드라인 스킬
│   │   ├── AGENTS.md        # Knowledge-base 에이전트
│   │   └── rules/           # 12개 가이드라인 규칙 파일
│   ├── csharp-code-review/
│   │   └── SKILL.md         # 코드 리뷰 스킬
│   ├── csharp-refactor/
│   │   └── SKILL.md         # 리팩토링 스킬
│   ├── csharp-tdd-develop/
│   │   ├── SKILL.md         # TDD 워크플로우 조율 스킬
│   │   └── scripts/
│   │       └── test-detector.js  # .csproj 테스트 환경 감지
│   ├── csharp-test-develop/
│   │   ├── SKILL.md         # 테스트 코드 작성 스킬
│   │   └── references/
│   │       └── csharp-test-patterns.md  # C# 테스트 패턴 가이드
│   └── wpf-mvvm-generator/
│       └── SKILL.md         # MVVM 생성 스킬
├── .mcp.json                # MCP 서버 설정
├── CLAUDE.md                # 프로젝트 컨벤션
└── README.md
```

> **Note**: 플러그인 설치 후 `agents/`와 `skills/` 디렉토리가 자동으로 인식되어 슬래시 커맨드(`/skill-name`)와 에이전트 멘션(`@agent-name`)을 사용할 수 있습니다. (Claude Code 2.1.3+)

## 사용법

### Agents

에이전트는 `@agent-name` 형태로 직접 호출하거나, 작업 컨텍스트에 따라 Claude Code가 자동으로 호출합니다.

#### C# Expert Agent (`@csharp-expert`)
```
@csharp-expert "User 엔티티에 대한 Repository 패턴 구현해줘"
@csharp-expert "이 코드를 SOLID 원칙에 맞게 리팩토링해줘"
@csharp-expert "Primary constructor로 변환해줘"
@csharp-expert "Span<T>를 사용해서 성능 최적화해줘"
```

#### WPF Expert Agent (`@wpf-expert`)
```
@wpf-expert "CommunityToolkit.Mvvm으로 ViewModel 만들어줘"
@wpf-expert "[ObservableProperty]와 [RelayCommand] 사용해서 구현해줘"
@wpf-expert "WeakReferenceMessenger로 ViewModel 간 통신 구현해줘"
@wpf-expert "날짜 선택용 커스텀 컨트롤 만들어줘"
```

### Skills

#### 코드 리뷰
```
/csharp-code-review
/csharp-code-review src/Services/UserService.cs
```

#### 코드 리팩토링
```
/csharp-refactor                                    # 전체 분석
/csharp-refactor src/Services/UserService.cs        # 특정 파일
/csharp-refactor src/Services/UserService.cs solid  # SOLID 리팩토링만
/csharp-refactor src/Services/UserService.cs modern # Modern C# 문법 전환
```

#### 베스트 프랙티스 가이드라인
```
/csharp-best-practices                      # 전체 규칙 목록
/csharp-best-practices primary-constructor  # 특정 토픽
/csharp-best-practices record              # Record 타입 가이드
```

#### TDD 개발
```
/csharp-tdd-develop UserService            # UserService TDD 워크플로우
/csharp-tdd-develop 주문 처리 서비스        # 주문 처리 서비스 TDD 워크플로우
```

#### 테스트 코드 작성
```
/csharp-test-develop src/Services/UserService.cs  # 파일 대상 테스트 작성
/csharp-test-develop OrderService                  # 클래스 찾아서 테스트 작성
```

#### MVVM 코드 생성
```
/wpf-mvvm-generator User                    # User에 대한 전체 MVVM 생성
/wpf-mvvm-generator Product viewmodel       # ProductViewModel만 생성
/wpf-mvvm-generator Order view              # OrderView만 생성
```

### MCP 서버 (Context7)

문서 검색을 위해 프롬프트에 "use context7"을 추가하세요:
```
"C#에서 IAsyncEnumerable 사용법 알려줘 use context7"
"CommunityToolkit.Mvvm ObservableProperty 예제 use context7"
".NET 8 Span<T> 모범 사례 use context7"
```

## 코드 원칙

### OOP 4대 원칙
- 캡슐화 (Encapsulation)
- 상속 (Inheritance)
- 다형성 (Polymorphism)
- 추상화 (Abstraction)

### SOLID 원칙
| 원칙 | 설명 |
|------|------|
| **SRP** | 단일 책임 원칙 (Single Responsibility Principle) |
| **OCP** | 개방-폐쇄 원칙 (Open/Closed Principle) |
| **LSP** | 리스코프 치환 원칙 (Liskov Substitution Principle) |
| **ISP** | 인터페이스 분리 원칙 (Interface Segregation Principle) |
| **DIP** | 의존성 역전 원칙 (Dependency Inversion Principle) |

### GoF 디자인 패턴

**생성 패턴**: Singleton, Factory Method, Abstract Factory, Builder, Prototype

**구조 패턴**: Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy

**행동 패턴**: Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor

## 네이밍 컨벤션

| 타입 | 컨벤션 | 예시 |
|------|--------|------|
| 클래스, 메서드, 프로퍼티 | PascalCase | `UserService`, `GetById` |
| 지역 변수, 매개변수 | camelCase | `userId`, `isActive` |
| Private 필드 | _camelCase | `_repository`, `_logger` |
| 인터페이스 | I 접두사 | `IRepository`, `IUserService` |
| Async 메서드 | Async 접미사 | `GetByIdAsync` |

## 권장 프로젝트 구조

```
/src
  /Models          - 도메인 모델
  /ViewModels      - MVVM ViewModel (partial classes)
  /Views           - WPF XAML Views
  /Services        - 비즈니스 서비스
  /Repositories    - 데이터 접근 계층
  /Messages        - Messenger 메시지 타입
  /Converters      - IValueConverter 구현
  /Infrastructure  - 공통 인프라
/tests
  /UnitTests       - 단위 테스트
  /IntegrationTests - 통합 테스트
```

## 요구사항

- **Claude Code CLI 2.1.3+** (필수, 심볼릭 링크 스킬 지원)
- Node.js 18+ (Context7 MCP 서버용)
- .NET 8/9 SDK
- Visual Studio 2022 / JetBrains Rider

## 변경 이력

### v1.5.0 (2025-01-30)

**플러그인 모듈화**

베스트 프랙티스, TDD 개발, 테스트 코드 작성을 위한 새로운 스킬을 추가했습니다. `csharp-best-practices` 스킬은 [vercel-react-best-practices](https://github.com/anthropics/claude-code/tree/main/skills/vercel-react-best-practices)의 3-tier 아키텍처(SKILL.md + AGENTS.md + rules/)를 참조하여 구현했습니다.

| 변경 사항 | 설명 |
|-----------|------|
| **csharp-best-practices** (신규) | C# 12/.NET 8 코드 작성 가이드라인 knowledge-base, 12개 규칙 파일 (vercel-react-best-practices 패턴 참조) |
| **csharp-tdd-develop** (신규) | TDD Red-Green-Refactor 워크플로우 조율, csharp-expert에 위임 |
| **csharp-test-develop** (신규) | 기존 코드에 테스트 코드 작성 (xUnit/Moq/FluentAssertions) |
| **csharp-code-review** (수정) | "Positive Aspects" 섹션 제거 — 수정할 점만 출력 |

---

### v1.4.0 (2025-01-27)

**Claude Code 2.1.x 호환성 개선**

Claude Code 2.1.3+에서 skills와 slash commands가 통합됨에 따라 문서 및 구조를 개선했습니다.

| 변경 사항 | 설명 | 관련 버전 |
|-----------|------|-----------|
| 에이전트 `@mention` 호출 | `@csharp-expert`, `@wpf-expert` 직접 호출 지원 | v2.1.0 |
| 스킬 슬래시 커맨드 | `/csharp-code-review` 등 직접 호출 | v2.1.3 |
| `user-invocable` 설정 | 슬래시 커맨드 메뉴 표시 설정 | v2.1.3 |
| 문서 개선 | 플러그인 구조 및 사용법 명확화 | - |

---

### v1.3.0 (2025-01-24)

**Claude Code 2.1.x 호환성 업데이트**

이번 업데이트는 Claude Code 2.0.x ~ 2.1.x 릴리스 노트의 주요 변경사항을 반영합니다.

#### Agent 업데이트
| 항목 | 설명 | 관련 버전 |
|------|------|-----------|
| `model` field | 에이전트가 사용할 모델 지정 (sonnet/opus/haiku) | v2.0.64 |
| `permissionMode` field | 에이전트 권한 모드 설정 | v2.0.43 |
| `allowed-tools` | YAML 리스트 형태 도구 허용 목록 | v2.1.0 |
| `disallowedTools` | 명시적 도구 차단 목록 | v2.0.30 |

#### Skill 업데이트
| 항목 | 설명 | 관련 버전 |
|------|------|-----------|
| `context: fork` | 포크된 서브에이전트 컨텍스트에서 실행 | v2.1.0 |
| `argument-hint` | 슬래시 커맨드 인자 힌트 표시 | v2.1.0 |
| `user-invocable` | 슬래시 커맨드 메뉴 표시 여부 | v2.1.3 |
| `skills` field | 서브에이전트용 스킬 자동 로드 | v2.1.0 |
| `$ARGUMENTS[0]` | 새로운 인자 접근 문법 (기존 `$ARGUMENTS.0` 대체) | v2.1.19 |

#### 새로운 Skills
- **csharp-refactor**: SOLID 원칙 적용, 디자인 패턴 도입, Modern C# 문법 전환
- **wpf-mvvm-generator**: CommunityToolkit.Mvvm 기반 ViewModel/View/Model 코드 생성

#### 기타
- LSP 도구 지원 추가 (go-to-definition, find-references, hover) - v2.0.74
- 새로운 Task Management System 지원 - v2.1.16

---

### v1.2.0
- Marketplace 배포를 위한 marketplace.json 파일 추가
- 플러그인 설치 방법 가이드 개선

### v1.1.0
- Modern C# 12/13 기능 지원 추가
- CommunityToolkit.Mvvm Source Generators 가이드 추가
- Performance Review 섹션 추가 (Span<T>, Memory<T>, LOH)
- Async Code Review 체크리스트 추가
- Security Review 섹션 추가

### v1.0.0
- 초기 릴리즈
- C# Expert, WPF Expert 에이전트
- Code Review 스킬
- Context7 MCP 서버 설정

## 라이센스

MIT

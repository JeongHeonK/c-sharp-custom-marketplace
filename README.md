# C# Marketplace Plugin

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)]()
[![.NET](https://img.shields.io/badge/.NET-8%2F9-purple.svg)]()
[![C#](https://img.shields.io/badge/C%23-12%2F13-green.svg)]()

C# 및 WPF 개발을 위한 Claude Code 플러그인입니다. Modern C# 12/13, OOP 원칙, SOLID 원칙, GoF 디자인 패턴에 중점을 둔 전문가 에이전트와 코드 리뷰 스킬을 제공합니다.

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

### 방법 1: Clone 후 설치
```bash
git clone https://github.com/JeongHeonK/c-sharp-custom-marketplace.git
cd c-sharp-custom-marketplace
claude plugins install .
```

### 방법 2: 레지스트리에서 설치 (배포 후)
```bash
claude plugins install c-sharp-marketplace
```

## 플러그인 구조

```
c-sharp-marketplace/
├── .claude-plugin/
│   └── plugin.json          # 플러그인 매니페스트
├── agents/
│   ├── csharp-expert.md     # C#/.NET 전문가 에이전트
│   └── wpf-expert.md        # WPF/MVVM 전문가 에이전트
├── skills/
│   └── csharp-code-review/
│       └── SKILL.md         # 코드 리뷰 스킬
├── .mcp.json                # MCP 서버 설정
├── CLAUDE.md                # 프로젝트 컨벤션
└── README.md
```

## 사용법

### Agents

에이전트는 작업 컨텍스트에 따라 Claude Code가 자동으로 호출하거나, 명시적으로 요청할 수 있습니다.

#### C# Expert Agent
```
"User 엔티티에 대한 Repository 패턴 구현해줘"
"이 코드를 SOLID 원칙에 맞게 리팩토링해줘"
"Primary constructor로 변환해줘"
"Span<T>를 사용해서 성능 최적화해줘"
```

#### WPF Expert Agent
```
"CommunityToolkit.Mvvm으로 ViewModel 만들어줘"
"[ObservableProperty]와 [RelayCommand] 사용해서 구현해줘"
"WeakReferenceMessenger로 ViewModel 간 통신 구현해줘"
"날짜 선택용 커스텀 컨트롤 만들어줘"
```

### Skills

#### 코드 리뷰
```
/csharp-code-review
/csharp-code-review src/Services/UserService.cs
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

- Claude Code CLI
- Node.js (Context7 MCP 서버용)
- .NET 8/9 SDK
- Visual Studio 2022 / Rider

## 변경 이력

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

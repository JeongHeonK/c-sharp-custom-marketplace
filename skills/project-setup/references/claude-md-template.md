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

## C#/.NET Quick Reference

> Prefer retrieval-led reasoning over pre-training-led reasoning for any C#/.NET tasks.
> The summaries below cover the most common patterns. For edge cases, caveats, or full examples, read the detailed file listed in the **Detailed References** section.

### C# 12 Features (.NET 8)

- **Primary Constructors**: `class Svc(IRepo repo) { }` -- params captured across class, no auto-properties (mutable). Expose via `public string Name => name;` if needed.

  ```csharp
  // DI service -- most common use-case
  public class UserService(IUserRepository repository, ILogger<UserService> logger)
  {
      public async Task<User?> GetByIdAsync(int id)
      {
          logger.LogInformation("Getting user {Id}", id);
          return await repository.FindByIdAsync(id);
      }
  }
  // Inheritance: class Employee(string name, string dept) : Person(name)
  // Caution: params are mutable -- copy to readonly field if reassignment must be prevented
  ```

- **Collection Expressions**: `int[] a = [1, 2, 3];` `List<string> b = ["x"];` `Span<int> s = [1, 2];` -- target-typed, compiler picks optimal creation
- **Spread Operator**: `int[] merged = [..first, ..second];` -- replaces `Concat().ToArray()`
- **Empty Collections**: `List<int> empty = [];` -- equivalent to `Array.Empty<T>()` for arrays
- **Alias Any Type**: `using Point = (int X, int Y);` -- works with tuples, arrays, generics. `global using` for project-wide aliases
- **Lambda Default Params**: `var inc = (int x, int step = 1) => x + step;` -- same syntax as method defaults, `params` also supported
- **Inline Arrays**: `[InlineArray(10)] struct Buf { int _e; }` -- stack-allocated fixed buffer, converts to `Span<T>`. Use for hot paths only; `List<T>` is fine for business logic
- **ref readonly Parameters**: `void Process(ref readonly LargeStruct data)` -- caller must use `ref` (or `in`), making intent explicit vs `in` which allows omission

### Modern C# (C# 9-11)

- **Record Types**: `record UserDto(string Name, string Email);` -- value equality, `with` expressions, immutable by default. Use for DTOs, Value Objects, API responses. Avoid for EF Core entities.
- **Record Struct**: `record struct Point(int X, int Y);` -- value-type record, no heap allocation
- **required Modifier**: `required string Name { get; init; }` -- compiler enforces initialization. Combine with `init` for immutable-after-init
- **init Accessor**: `public int Age { get; init; }` -- settable only during initialization (`new Foo { Age = 5 }`)
- **`[SetsRequiredMembers]`**: Apply to constructor to satisfy `required` without object initializer syntax
- **Pattern Matching**: switch expressions + type/property/relational/logical patterns for declarative branching

  ```csharp
  string GetDiscount(Customer c) => c switch
  {
      { Type: CustomerType.Premium, Years: > 5 } => "30%",
      { Type: CustomerType.Premium }              => "20%",
      { Type: CustomerType.Regular, Years: > 3 }  => "10%",
      { Orders: > 100 }                           => "5%",
      _                                            => "0%"
  };
  // Patterns: is not null, is > 0 and < 100, is string s
  // Guard: case X when condition => ...
  ```

- **List Patterns**: `if (args is [var cmd, ..var rest])` -- match by structure, `_` discard, `..` slice. Great for CLI arg parsing, protocol headers
- **Raw String Literals**: `"""json here"""` -- no escaping needed. Interpolation: `$$"""{ {{expr}} }"""` (dollar count = brace count)
- **File-scoped Namespaces**: `namespace MyApp.Services;` -- always use for new files (one less indentation level)

### Test Patterns (xUnit + Moq + FluentAssertions)

- **Naming**: `Method_Scenario_ExpectedBehavior` -- e.g. `GetByIdAsync_ExistingId_ReturnsUser`
- **AAA Pattern**: Arrange (setup mocks/sut) → Act (call method) → Assert (verify result)

  ```csharp
  [Fact]
  public async Task GetByIdAsync_ExistingId_ReturnsUser()
  {
      // Arrange
      var mockRepo = new Mock<IUserRepository>();
      mockRepo.Setup(r => r.FindByIdAsync(1))
              .ReturnsAsync(new User { Id = 1, Name = "Alice" });
      var sut = new UserService(mockRepo.Object);

      // Act
      var result = await sut.GetByIdAsync(1);

      // Assert
      result.Should().NotBeNull();
      result!.Name.Should().Be("Alice");
  }
  ```

- **Moq Setup**: `.Setup(r => r.Method(It.IsAny<int>())).ReturnsAsync(value)` | `.ThrowsAsync(ex)` | `.Callback<T>(x => captured = x)`
- **Moq Verify**: `.Verify(r => r.Save(It.Is<User>(u => u.Name == "X")), Times.Once)`
- **FluentAssertions Values**: `.Should().Be(42)` | `.NotBeNull()` | `.BeGreaterThan(10)` | `.BeInRange(1, 100)`
- **FluentAssertions Strings**: `.Should().Contain("sub")` | `.StartWith("A")` | `.MatchRegex("^[A-Z]")`
- **FluentAssertions Collections**: `.Should().HaveCount(3)` | `.Contain(x => x.Name == "A")` | `.BeInAscendingOrder(x => x.Name)`
- **FluentAssertions Exceptions**: `Func<Task> act = () => svc.DoAsync(-1); await act.Should().ThrowAsync<ArgumentException>();`
- **FluentAssertions Objects**: `.Should().BeEquivalentTo(expected, o => o.Excluding(x => x.CreatedAt))`
- **Theory/InlineData**: `[Theory] [InlineData(90, "A")] [InlineData(80, "B")]` -- parameterized tests
- **MemberData**: `public static IEnumerable<object[]> Cases => [...]` + `[MemberData(nameof(Cases))]`
- **IClassFixture**: Shared setup per test class -- `class Tests(DbFixture f) : IClassFixture<DbFixture>`
- **Builder Pattern**: Fluent test data builder -- `new UserBuilder().WithName("Alice").Inactive().Build()`
- **Anti-patterns**: No private method testing via reflection | Mock interfaces only, not concrete types | One logical behavior per test | No test-to-test dependencies

### WPF/MVVM Patterns (CommunityToolkit.Mvvm)

- **ObservableProperty**: `[ObservableProperty] private string _name;` → generates `Name` property with `OnPropertyChanged`. Partial method hooks: `partial void OnNameChanging(string value)`, `partial void OnNameChanged(string value)`
- **RelayCommand**: `[RelayCommand] async Task LoadAsync()` → generates `LoadCommand` (IAsyncRelayCommand). `CanExecute`: `[RelayCommand(CanExecute = nameof(CanSave))]`
- **NotifyCanExecuteChanged**: `[NotifyCanExecuteChangedFor(nameof(SaveCommand))] [ObservableProperty] private string _name;` -- re-evaluates CanExecute when property changes
- **NotifyPropertyChanged**: `[NotifyPropertyChangedFor(nameof(FullName))] [ObservableProperty] private string _firstName;` -- raises PropertyChanged for computed properties
- **ObservableObject**: `partial class MyViewModel : ObservableObject { }` -- base class providing INPC
- **Messenger**: `WeakReferenceMessenger.Default.Send(new UserSaved(user))` | `Register<UserSaved>(this, (r, m) => ...)` -- decoupled ViewModel communication
- **DI Integration**: Register VMs in `IServiceCollection`, inject via constructor: `public MainViewModel(IUserService svc) { }`
- **ViewModel Testing**: Assert `PropertyChanged` via event subscription, test commands with `await vm.LoadCommand.ExecuteAsync(null)`, verify `CanExecute` states

## Detailed References

For edge cases and full code examples, read the relevant guideline file before writing code.

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

### Test Patterns

| Guideline | File | When to Read |
|-----------|------|-------------|
| C# Test Patterns | `{plugin-path}/../csharp-test-develop/references/csharp-test-patterns.md` | 테스트 코드 작성/리뷰 시 |

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

- **WPF 프로젝트가 아닌 경우**: `### WPF/MVVM Patterns` 섹션 제거 + "Skill Workflows > Scaffolding" 섹션 제거
- **테스트 프로젝트가 없는 경우**: `### Test Patterns` 섹션 제거 + Build & Test Commands에서 Test 행 제거
- **TargetFramework < net8.0인 경우**: `### C# 12 Features (.NET 8)` 섹션 상단에 경고 노트 추가: `> ⚠ 현재 프로젝트는 {TargetFramework}입니다. C# 12 기능은 .NET 8+ 에서 사용 가능합니다.` (섹션 자체는 제거하지 않음)

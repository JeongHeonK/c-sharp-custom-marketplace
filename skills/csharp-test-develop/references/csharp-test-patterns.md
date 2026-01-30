# C# Test Patterns

C# 테스트 코드 작성 시 참조하는 패턴 가이드.

## Test Pyramid

```
         /\
        /  \         E2E Tests (적음)
       /----\
      / Inte \       Integration Tests (중간)
     / gration \
    /------------\
   /    Unit      \  Unit Tests (많음)
  /----------------\
 /   Static Types   \ Static Analysis (C# compiler)
/--------------------\
```

- **Unit Tests**: 단일 클래스/메서드 격리 테스트 (가장 많이)
- **Integration Tests**: 여러 컴포넌트 결합 테스트 (DB, API 등)
- **E2E Tests**: 전체 시스템 테스트 (최소한)

---

## AAA Pattern

Arrange-Act-Assert 패턴:

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

---

## Naming Convention

`Method_Scenario_ExpectedBehavior` 패턴:

```csharp
[Fact]
public async Task GetByIdAsync_ExistingId_ReturnsUser() { }

[Fact]
public async Task GetByIdAsync_NonExistingId_ReturnsNull() { }

[Fact]
public async Task CreateAsync_DuplicateEmail_ThrowsConflictException() { }

[Fact]
public void Calculate_NegativeInput_ThrowsArgumentException() { }
```

---

## Mock 설정 (Moq)

### 기본 Setup

```csharp
var mockRepo = new Mock<IUserRepository>();

// 반환값 설정
mockRepo.Setup(r => r.FindByIdAsync(It.IsAny<int>()))
        .ReturnsAsync(new User { Id = 1, Name = "Alice" });

// null 반환
mockRepo.Setup(r => r.FindByIdAsync(999))
        .ReturnsAsync((User?)null);

// 예외 발생
mockRepo.Setup(r => r.DeleteAsync(-1))
        .ThrowsAsync(new ArgumentException("Invalid ID"));
```

### Verify

```csharp
// 호출 횟수 검증
mockRepo.Verify(r => r.SaveAsync(It.IsAny<User>()), Times.Once);
mockRepo.Verify(r => r.DeleteAsync(It.IsAny<int>()), Times.Never);

// 특정 인자로 호출 검증
mockRepo.Verify(r => r.SaveAsync(It.Is<User>(u => u.Name == "Alice")), Times.Once);
```

### Callback

```csharp
User? savedUser = null;
mockRepo.Setup(r => r.SaveAsync(It.IsAny<User>()))
        .Callback<User>(u => savedUser = u)
        .ReturnsAsync(true);
```

---

## FluentAssertions

### 기본 Assertion

```csharp
// 값 비교
result.Should().Be(42);
result.Should().NotBe(0);
result.Should().BeGreaterThan(10);
result.Should().BeInRange(1, 100);

// null 체크
result.Should().NotBeNull();
result.Should().BeNull();

// 문자열
name.Should().Be("Alice");
name.Should().Contain("Ali");
name.Should().StartWith("A");
name.Should().MatchRegex("^[A-Z]");

// boolean
isActive.Should().BeTrue();
isDeleted.Should().BeFalse();
```

### 컬렉션

```csharp
users.Should().NotBeEmpty();
users.Should().HaveCount(3);
users.Should().Contain(u => u.Name == "Alice");
users.Should().BeInAscendingOrder(u => u.Name);
users.Should().OnlyContain(u => u.IsActive);
users.Should().AllSatisfy(u => u.Id.Should().BePositive());
```

### 예외

```csharp
// 동기
Action act = () => service.Process(-1);
act.Should().Throw<ArgumentException>()
   .WithMessage("*negative*");

// 비동기
Func<Task> act = () => service.ProcessAsync(-1);
await act.Should().ThrowAsync<ArgumentException>()
         .WithMessage("*negative*");

// 예외 없음
await act.Should().NotThrowAsync();
```

### 객체 비교

```csharp
// 프로퍼티 비교
result.Should().BeEquivalentTo(new UserDto
{
    Id = 1,
    Name = "Alice",
    Email = "alice@example.com"
});

// 특정 프로퍼티 제외
result.Should().BeEquivalentTo(expected, opts =>
    opts.Excluding(u => u.CreatedAt));
```

---

## xUnit Theory / InlineData

매개변수화 테스트:

```csharp
[Theory]
[InlineData(90, "A")]
[InlineData(80, "B")]
[InlineData(70, "C")]
[InlineData(60, "D")]
[InlineData(50, "F")]
public void GetGrade_GivenScore_ReturnsExpectedGrade(int score, string expected)
{
    // Arrange
    var grader = new Grader();

    // Act
    var result = grader.GetGrade(score);

    // Assert
    result.Should().Be(expected);
}
```

### MemberData

```csharp
public static IEnumerable<object[]> InvalidInputs =>
[
    [null!, "Name is required"],
    ["", "Name is required"],
    ["AB", "Name must be at least 3 characters"],
];

[Theory]
[MemberData(nameof(InvalidInputs))]
public void Validate_InvalidInput_ReturnsError(string input, string expectedError)
{
    var result = Validator.Validate(input);
    result.Error.Should().Be(expectedError);
}
```

---

## Fixture Pattern

### IClassFixture (클래스 공유)

```csharp
public class DatabaseFixture : IDisposable
{
    public DbContext Context { get; }

    public DatabaseFixture()
    {
        Context = new TestDbContext();
        Context.Database.EnsureCreated();
    }

    public void Dispose() => Context.Dispose();
}

public class UserRepositoryTests(DatabaseFixture fixture) : IClassFixture<DatabaseFixture>
{
    private readonly DbContext _context = fixture.Context;

    [Fact]
    public async Task FindByIdAsync_ReturnsUser()
    {
        var repo = new UserRepository(_context);
        var result = await repo.FindByIdAsync(1);
        result.Should().NotBeNull();
    }
}
```

### CollectionFixture (컬렉션 공유)

```csharp
[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture> { }

[Collection("Database")]
public class OrderRepositoryTests(DatabaseFixture fixture)
{
    // fixture는 컬렉션 내 모든 테스트 클래스에서 공유
}
```

---

## Builder Pattern (테스트 데이터)

```csharp
public class UserBuilder
{
    private int _id = 1;
    private string _name = "Default User";
    private string _email = "default@example.com";
    private bool _isActive = true;

    public UserBuilder WithId(int id) { _id = id; return this; }
    public UserBuilder WithName(string name) { _name = name; return this; }
    public UserBuilder WithEmail(string email) { _email = email; return this; }
    public UserBuilder Inactive() { _isActive = false; return this; }

    public User Build() => new()
    {
        Id = _id,
        Name = _name,
        Email = _email,
        IsActive = _isActive
    };
}

// 사용
var user = new UserBuilder().WithName("Alice").WithEmail("alice@test.com").Build();
var inactiveUser = new UserBuilder().Inactive().Build();
```

---

## Async 테스트

```csharp
[Fact]
public async Task ProcessAsync_ValidInput_ReturnsResult()
{
    // Arrange
    var service = CreateService();

    // Act
    var result = await service.ProcessAsync("input");

    // Assert
    result.Should().NotBeNull();
}

[Fact]
public async Task ProcessAsync_InvalidInput_ThrowsException()
{
    // Arrange
    var service = CreateService();

    // Act & Assert
    await Assert.ThrowsAsync<ArgumentException>(
        () => service.ProcessAsync(null!));

    // 또는 FluentAssertions
    Func<Task> act = () => service.ProcessAsync(null!);
    await act.Should().ThrowAsync<ArgumentException>();
}
```

---

## ViewModel 테스트 (MVVM)

CommunityToolkit.Mvvm 기반 ViewModel 테스트:

```csharp
[Fact]
public void Name_WhenSet_RaisesPropertyChanged()
{
    // Arrange
    var vm = new UserViewModel();
    var changedProperties = new List<string>();
    vm.PropertyChanged += (_, e) => changedProperties.Add(e.PropertyName!);

    // Act
    vm.Name = "Alice";

    // Assert
    changedProperties.Should().Contain("Name");
}

[Fact]
public async Task LoadCommand_Executes_LoadsData()
{
    // Arrange
    var mockService = new Mock<IUserService>();
    mockService.Setup(s => s.GetAllAsync())
               .ReturnsAsync([new User { Name = "Alice" }]);
    var vm = new UserViewModel(mockService.Object);

    // Act
    await vm.LoadCommand.ExecuteAsync(null);

    // Assert
    vm.Users.Should().HaveCount(1);
    vm.Users[0].Name.Should().Be("Alice");
}

[Fact]
public void SaveCommand_WhenNameEmpty_CannotExecute()
{
    // Arrange
    var vm = new UserViewModel { Name = "" };

    // Assert
    vm.SaveCommand.CanExecute(null).Should().BeFalse();
}
```

---

## Anti-patterns

### 1. 구현 디테일 테스트 금지

```csharp
// Bad - private 메서드 테스트
var method = typeof(Service).GetMethod("Calculate", BindingFlags.NonPublic);

// Good - public API를 통해 테스트
var result = service.Process(input);
result.Should().Be(expected);
```

### 2. 과도한 Mock 금지

```csharp
// Bad - 모든 것을 mock
var mockString = new Mock<string>(); // ?!

// Good - 인터페이스 경계만 mock
var mockRepo = new Mock<IUserRepository>();
```

### 3. 하나의 테스트에 여러 Assert 주의

```csharp
// Bad - 너무 많은 assert
[Fact]
public void Test_Everything()
{
    // ... 10개의 assert
}

// Good - 시나리오별 분리
[Fact]
public void Create_ValidInput_ReturnsCreatedUser() { }

[Fact]
public void Create_ValidInput_SavestoRepository() { }
```

### 4. 테스트 간 의존성 금지

```csharp
// Bad - 테스트 순서에 의존
static User? _createdUser;

[Fact]
public void Test1_CreateUser() { _createdUser = ...; }

[Fact]
public void Test2_UseCreatedUser() { /* _createdUser 사용 */ }

// Good - 각 테스트 독립적
[Fact]
public void CreateUser_ReturnsUser()
{
    var user = service.Create(...);
    user.Should().NotBeNull();
}
```

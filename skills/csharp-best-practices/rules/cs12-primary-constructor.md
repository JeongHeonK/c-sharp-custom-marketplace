# Primary Constructors (C# 12)

class와 struct에서 직접 생성자 매개변수를 선언할 수 있습니다.

## When to Use

- DI(Dependency Injection) 서비스 클래스
- 간단한 초기화만 필요한 클래스
- 필드 할당이 주 목적인 생성자

## Before (C# 11)

```csharp
public class UserService
{
    private readonly IUserRepository _repository;
    private readonly ILogger<UserService> _logger;

    public UserService(IUserRepository repository, ILogger<UserService> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task<User?> GetByIdAsync(int id)
    {
        _logger.LogInformation("Getting user {Id}", id);
        return await _repository.FindByIdAsync(id);
    }
}
```

## After (C# 12)

```csharp
public class UserService(IUserRepository repository, ILogger<UserService> logger)
{
    public async Task<User?> GetByIdAsync(int id)
    {
        logger.LogInformation("Getting user {Id}", id);
        return await repository.FindByIdAsync(id);
    }
}
```

## Key Points

- 매개변수는 클래스 전체에서 접근 가능 (captured parameter)
- `private readonly` 필드 선언 + 생성자 할당이 불필요
- record와 달리 **프로퍼티를 자동 생성하지 않음**
- 매개변수를 프로퍼티로 노출하려면 명시적 선언 필요:
  ```csharp
  public class Person(string name, int age)
  {
      public string Name => name;
      public int Age => age;
  }
  ```

## Caution

- 매개변수가 mutable하므로 재할당 방지가 필요하면 `private readonly` 필드로 복사
- 상속 시 `base()` 호출 구문: `class Employee(string name, string dept) : Person(name)`
- 매개변수를 프로퍼티로 노출할 때는 record 사용도 고려

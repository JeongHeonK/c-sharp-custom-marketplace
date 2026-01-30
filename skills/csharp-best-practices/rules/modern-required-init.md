# required / init Properties (C# 11)

`required` 수정자와 `init` 접근자로 안전한 객체 초기화를 보장합니다.

## When to Use

- 생성자 없이 필수 프로퍼티 초기화 강제
- 불변 객체 생성 (init-only)
- 객체 이니셜라이저 패턴에서 필수값 보장

## Before

```csharp
public class UserConfig
{
    public string ConnectionString { get; set; } = string.Empty;
    public int MaxRetries { get; set; }
    public TimeSpan Timeout { get; set; }
}

// 문제: 필수값 누락 가능
var config = new UserConfig
{
    MaxRetries = 3
    // ConnectionString 누락 — 컴파일 에러 없음!
};
```

## After

```csharp
public class UserConfig
{
    public required string ConnectionString { get; init; }
    public required int MaxRetries { get; init; }
    public TimeSpan Timeout { get; init; } = TimeSpan.FromSeconds(30); // 선택
}

// 필수값 누락 시 컴파일 에러
var config = new UserConfig
{
    ConnectionString = "Server=...",
    MaxRetries = 3
    // Timeout은 기본값 사용
};
```

## init vs set

```csharp
public class Person
{
    public required string Name { get; init; }  // 초기화 후 불변
    public string? Nickname { get; set; }        // 언제든 변경 가능
}

var person = new Person { Name = "Alice" };
// person.Name = "Bob";  // 컴파일 에러: init-only
person.Nickname = "Ali"; // OK
```

## With SetsRequiredMembers

```csharp
public class Service
{
    public required string Name { get; init; }
    public required int Port { get; init; }

    [System.Diagnostics.CodeAnalysis.SetsRequiredMembers]
    public Service(string name, int port)
    {
        Name = name;
        Port = port;
    }
}

// 둘 다 가능
var s1 = new Service("API", 8080);
var s2 = new Service { Name = "API", Port = 8080 };
```

## Key Points

- `required`: 객체 이니셜라이저에서 반드시 설정해야 하는 프로퍼티
- `init`: 초기화 시에만 값 설정 가능 (이후 불변)
- `required init` 조합이 가장 안전한 패턴
- `[SetsRequiredMembers]`로 생성자와 required 프로퍼티 동시 지원

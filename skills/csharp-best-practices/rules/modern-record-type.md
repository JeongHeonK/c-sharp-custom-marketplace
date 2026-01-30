# Record Types (C# 9+)

값 기반 동등성(Value-based equality)을 가진 불변 참조 타입입니다.

## When to Use

- DTO(Data Transfer Object)
- 값 객체(Value Object) — DDD
- 불변 데이터 모델
- API 응답/요청 모델

## Before

```csharp
public class UserDto
{
    public int Id { get; init; }
    public string Name { get; init; } = string.Empty;
    public string Email { get; init; } = string.Empty;

    // Equals, GetHashCode, ToString 수동 구현 필요
    public override bool Equals(object? obj) =>
        obj is UserDto other && Id == other.Id && Name == other.Name && Email == other.Email;

    public override int GetHashCode() =>
        HashCode.Combine(Id, Name, Email);

    public override string ToString() =>
        $"UserDto {{ Id = {Id}, Name = {Name}, Email = {Email} }}";
}
```

## After

```csharp
// Positional record (간결)
public record UserDto(int Id, string Name, string Email);

// 또는 프로퍼티 record (더 많은 제어)
public record UserDto
{
    public int Id { get; init; }
    public required string Name { get; init; }
    public required string Email { get; init; }
}
```

## with Expression

```csharp
var user = new UserDto(1, "Alice", "alice@example.com");
var updated = user with { Name = "Bob" }; // 비파괴적 변경
```

## record struct (C# 10)

```csharp
// 값 타입 record — 작은 데이터에 적합
public record struct Point(int X, int Y);
```

## Key Points

- `Equals`, `GetHashCode`, `ToString` 자동 생성
- `with` 표현식으로 비파괴적 변경 (nondestructive mutation)
- `record class` (기본) = 참조 타입, `record struct` = 값 타입
- Deconstruction 자동 지원 (positional record)
- 상속 가능: `public record Student(int Id, string Name, string Major) : UserDto(Id, Name, "");`

## Caution

- EF Core 엔티티로 사용 시 주의 (변경 추적 이슈)
- mutable 상태가 필요한 경우 class 사용

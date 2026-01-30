# Pattern Matching (C# 8-11)

switch 표현식과 패턴으로 복잡한 조건 분기를 선언적으로 작성합니다.

## When to Use

- 복잡한 if-else / switch-case 분기
- 타입 검사 + 값 추출
- null 체크와 조건 결합
- 범위 기반 분기

## Before

```csharp
public string GetDiscount(Customer customer)
{
    if (customer == null)
        throw new ArgumentNullException(nameof(customer));

    if (customer.Type == CustomerType.Premium && customer.Years > 5)
        return "30%";
    else if (customer.Type == CustomerType.Premium)
        return "20%";
    else if (customer.Type == CustomerType.Regular && customer.Years > 3)
        return "10%";
    else
        return "0%";
}
```

## After (Switch Expression)

```csharp
public string GetDiscount(Customer customer) => customer switch
{
    null => throw new ArgumentNullException(nameof(customer)),
    { Type: CustomerType.Premium, Years: > 5 } => "30%",
    { Type: CustomerType.Premium } => "20%",
    { Type: CustomerType.Regular, Years: > 3 } => "10%",
    _ => "0%"
};
```

## Pattern Types

### Type Pattern

```csharp
object obj = "hello";
if (obj is string s)
{
    Console.WriteLine(s.Length);
}
```

### Property Pattern

```csharp
if (person is { Age: >= 18, Name.Length: > 0 })
{
    // 성인이고 이름이 있는 경우
}
```

### Relational Pattern (C# 9)

```csharp
string GetGrade(int score) => score switch
{
    >= 90 => "A",
    >= 80 => "B",
    >= 70 => "C",
    >= 60 => "D",
    _ => "F"
};
```

### Logical Pattern (C# 9)

```csharp
bool IsValidAge(int age) => age is > 0 and < 150;
bool IsWeekend(DayOfWeek day) => day is DayOfWeek.Saturday or DayOfWeek.Sunday;
bool IsNotNull(object? obj) => obj is not null;
```

## Key Points

- switch 표현식은 모든 케이스를 커버해야 함 (exhaustive)
- `_`는 discard 패턴 (default 대체)
- `when` 가드로 추가 조건 지정 가능
- 패턴은 중첩 가능 (`{ Address: { City: "Seoul" } }`)
- `and`, `or`, `not` 논리 패턴으로 조합

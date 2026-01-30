# List Patterns (C# 11)

배열, 리스트 등 countable/indexable 컬렉션에 대해 패턴 매칭을 수행합니다.

## When to Use

- 컬렉션의 구조 기반 분기
- 첫 번째/마지막 요소 추출
- 컬렉션 길이 기반 분기
- 명령줄 인자 파싱

## Before

```csharp
int[] numbers = { 1, 2, 3 };

if (numbers.Length == 0)
    Console.WriteLine("empty");
else if (numbers.Length == 1)
    Console.WriteLine($"single: {numbers[0]}");
else
    Console.WriteLine($"first: {numbers[0]}, rest: {numbers.Length - 1} items");
```

## After

```csharp
int[] numbers = [1, 2, 3];

var result = numbers switch
{
    [] => "empty",
    [var single] => $"single: {single}",
    [var first, .. var rest] => $"first: {first}, rest: {rest.Length} items"
};
```

## Pattern Types

### Constant Pattern

```csharp
if (numbers is [1, 2, 3])
{
    // 정확히 [1, 2, 3]과 일치
}
```

### Discard Pattern

```csharp
if (numbers is [_, _, 3])
{
    // 길이 3이고 마지막이 3
}
```

### Slice Pattern (..)

```csharp
if (numbers is [var first, .. var middle, var last])
{
    // first = 첫 번째, last = 마지막, middle = 나머지
}
```

### Command-line Args Parsing

```csharp
string response = args switch
{
    ["--help"] => ShowHelp(),
    ["--version"] => ShowVersion(),
    ["--output", var path] => SetOutput(path),
    [var file] => ProcessFile(file),
    [] => ShowUsage(),
    _ => "Unknown arguments"
};
```

## Key Points

- `[]` = 빈 컬렉션 매칭
- `[..]` = 모든 컬렉션 매칭 (와일드카드)
- `..` slice 패턴은 0개 이상의 요소 매칭
- 배열, `List<T>`, `Span<T>` 등 countable + indexable 타입에 적용
- 중첩 패턴 결합 가능: `[{ Name: "Admin" }, ..]`

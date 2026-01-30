# Collection Expressions (C# 12)

배열, 리스트, Span 등을 `[1, 2, 3]` 통합 구문으로 초기화합니다.

## When to Use

- 컬렉션 초기화
- 빈 컬렉션 생성
- 컬렉션 병합 (spread 연산자 `..`)

## Before (C# 11)

```csharp
int[] numbers = new int[] { 1, 2, 3 };
List<string> names = new List<string> { "Alice", "Bob" };
Span<int> span = stackalloc int[] { 1, 2, 3 };

// 컬렉션 병합
int[] first = { 1, 2, 3 };
int[] second = { 4, 5, 6 };
int[] combined = first.Concat(second).ToArray();
```

## After (C# 12)

```csharp
int[] numbers = [1, 2, 3];
List<string> names = ["Alice", "Bob"];
Span<int> span = [1, 2, 3];

// Spread 연산자로 병합
int[] first = [1, 2, 3];
int[] second = [4, 5, 6];
int[] combined = [..first, ..second];
```

## Empty Collections

```csharp
// Before
List<int> empty = new List<int>();
int[] emptyArray = Array.Empty<int>();

// After
List<int> empty = [];
int[] emptyArray = [];
```

## Key Points

- 대상 타입에 따라 `T[]`, `List<T>`, `Span<T>`, `ReadOnlySpan<T>` 등 자동 변환
- Spread 연산자 `..`로 컬렉션 결합 가능
- `[]`은 `Array.Empty<T>()`와 동등한 빈 컬렉션 생성
- 성능: 컴파일러가 최적의 생성 방법 선택

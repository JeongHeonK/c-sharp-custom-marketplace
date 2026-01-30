# Lambda Default Parameters (C# 12)

람다 식에 기본 매개변수 값을 지정할 수 있습니다.

## When to Use

- 람다 식에 선택적 매개변수가 필요할 때
- Func/Action 델리게이트의 유연성 향상
- 메서드와 동일한 기본값 패턴 적용

## Before (C# 11)

```csharp
// 기본값을 위해 오버로드 또는 nullable 사용
var increment = (int x, int? step) => x + (step ?? 1);
int result = increment(5, null); // 6

// 또는 두 개의 람다로 분리
Func<int, int> incrementByOne = x => x + 1;
Func<int, int, int> incrementByN = (x, step) => x + step;
```

## After (C# 12)

```csharp
var increment = (int x, int step = 1) => x + step;

int result1 = increment(5);     // 6
int result2 = increment(5, 3);  // 8
```

## With params

```csharp
var join = (string separator = ", ", params string[] items) =>
    string.Join(separator, items);

string result = join(items: ["A", "B", "C"]); // "A, B, C"
```

## Key Points

- 일반 메서드의 기본 매개변수와 동일한 문법
- `params` 매개변수도 람다에서 사용 가능
- Delegate 타입 추론 시 기본값 정보 포함
- 과도한 사용 시 가독성 저하 주의

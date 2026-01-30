# Alias Any Type (C# 12)

`using` 지시문으로 모든 타입에 별칭을 지정할 수 있습니다. 튜플, 배열, 포인터 등 모든 타입을 지원합니다.

## When to Use

- 복잡한 튜플 타입에 의미 있는 이름 부여
- 긴 제네릭 타입 간소화
- 도메인 특화 타입 별칭 생성

## Before (C# 11)

```csharp
// 튜플 타입을 alias로 사용 불가
public (double Latitude, double Longitude) GetLocation() => (37.5665, 126.9780);

// 긴 제네릭 타입 반복
Dictionary<string, List<(int Id, string Name)>> GetGroupedUsers() => ...;
```

## After (C# 12)

```csharp
using Point = (int X, int Y);
using Coordinate = (double Latitude, double Longitude);
using UserGroup = System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<(int Id, string Name)>>;

public Coordinate GetLocation() => (37.5665, 126.9780);

public UserGroup GetGroupedUsers() => ...;

Point origin = (0, 0);
```

## Key Points

- 네임스페이스된 타입뿐 아니라 **튜플, 배열, 포인터 타입**도 alias 가능
- 파일 범위(file-scoped)로 적용
- `global using`과 결합하여 프로젝트 전체 적용 가능:
  ```csharp
  // GlobalUsings.cs
  global using Point = (int X, int Y);
  ```
- 가독성 향상이 목적이므로, 간단한 타입에는 불필요

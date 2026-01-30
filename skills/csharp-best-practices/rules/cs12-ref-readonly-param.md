# ref readonly Parameters (C# 12)

`ref readonly` 매개변수로 참조 전달 API의 의도를 명확히 표현합니다.

## When to Use

- 큰 struct를 복사 없이 전달하되 수정을 방지할 때
- `in` 매개변수의 의도를 더 명확히 표현할 때
- API 설계 시 호출자에게 참조 전달 의도를 명시할 때

## Before (C# 11)

```csharp
// in 매개변수: 암묵적 ref readonly이지만 호출부에서 불명확
void Process(in LargeStruct data)
{
    // data는 readonly
    Console.WriteLine(data.Value);
}

// 호출 시 in 키워드 생략 가능 → 의도 불명확
LargeStruct s = new();
Process(s);       // in이 숨겨짐
Process(in s);    // 명시적이지만 선택사항
```

## After (C# 12)

```csharp
// ref readonly: 호출부에서 ref 전달 의도 명시
void Process(ref readonly LargeStruct data)
{
    // data는 readonly
    Console.WriteLine(data.Value);
}

// 호출
LargeStruct s = new();
Process(ref s);    // ref 키워드 필수 → 의도 명확
Process(in s);     // in도 허용 (하위 호환)
```

## in vs ref readonly

| 특성 | `in` | `ref readonly` |
|------|------|----------------|
| 호출부 키워드 | 선택사항 | `ref` 또는 `in` 필수 |
| API 의도 | 암묵적 | 명시적 |
| 하위 호환 | 기존 코드 | `in` 호환 |

## Key Points

- `in`은 호출부에서 키워드 생략 가능 → 값 복사와 구분 어려움
- `ref readonly`는 호출부에서 `ref` 키워드 필수 → API 의도 명확
- 기존 `in` 매개변수를 `ref readonly`로 변경 시 하위 호환 유지 (`in` 허용)
- 큰 struct (16바이트 초과) 전달 시 성능 이점

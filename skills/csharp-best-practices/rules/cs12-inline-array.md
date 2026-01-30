# Inline Arrays (C# 12)

struct에 고정 크기 배열을 인라인으로 선언하여 성능을 최적화합니다.

## When to Use

- 고정 크기 버퍼가 필요한 고성능 시나리오
- 힙 할당을 피해야 하는 핫 패스
- 네이티브 interop 버퍼

## Before (C# 11)

```csharp
// unsafe fixed buffer (unsafe 컨텍스트 필요)
unsafe struct FixedBuffer
{
    public fixed int Data[10];
}

// 또는 stackalloc
Span<int> buffer = stackalloc int[10];
```

## After (C# 12)

```csharp
[System.Runtime.CompilerServices.InlineArray(10)]
public struct Buffer10
{
    private int _element0;
}

// 사용
Buffer10 buffer = new();
buffer[0] = 42;

// Span으로 변환 가능
Span<int> span = buffer;
foreach (var item in span)
{
    Console.WriteLine(item);
}
```

## Key Points

- `[InlineArray(N)]` 특성으로 크기 지정
- struct 내에 **단일 필드**만 선언 (타입 결정)
- unsafe 없이 고정 크기 버퍼 생성
- `Span<T>`, `ReadOnlySpan<T>`로 암묵적 변환
- 스택 할당으로 GC 압력 감소
- 런타임/컴파일러 인프라, 고성능 라이브러리에 주로 사용
- 일반 비즈니스 로직에서는 `List<T>` 또는 배열이 더 적절

## Caution

- 일반 애플리케이션 코드에서는 과도한 최적화 (over-engineering)
- 주로 런타임 라이브러리, 고성능 서버, 게임 엔진 등에서 활용

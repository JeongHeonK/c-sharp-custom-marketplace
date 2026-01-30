# Raw String Literals (C# 11)

`"""` 구문으로 이스케이프 없이 멀티라인 문자열을 작성합니다.

## When to Use

- JSON, XML, SQL, HTML 등 내장 문자열
- 이스케이프 문자가 많은 문자열
- 코드 생성, 템플릿 문자열

## Before

```csharp
string json = "{\n  \"name\": \"Alice\",\n  \"age\": 30,\n  \"address\": {\n    \"city\": \"Seoul\"\n  }\n}";

// 또는 verbatim string
string sql = @"
SELECT u.Id, u.Name
FROM Users u
WHERE u.IsActive = 1
  AND u.Age > 18";

// 보간 + verbatim
string query = $@"
SELECT * FROM Users
WHERE Name = '{name}'"; // SQL injection 위험!
```

## After

```csharp
string json = """
    {
      "name": "Alice",
      "age": 30,
      "address": {
        "city": "Seoul"
      }
    }
    """;

string sql = """
    SELECT u.Id, u.Name
    FROM Users u
    WHERE u.IsActive = 1
      AND u.Age > 18
    """;
```

## With Interpolation

```csharp
// $의 개수가 보간에 필요한 중괄호 수를 결정
string json = $$"""
    {
      "name": "{{name}}",
      "age": {{age}},
      "data": { "raw": "braces are fine" }
    }
    """;
```

## Key Points

- `"""` 여는 따옴표 다음 줄부터 내용 시작
- 닫는 `"""`의 들여쓰기가 기준선 (자동 trim)
- 이스케이프 불필요: `"`, `\`, `{` 등 그대로 사용
- `$` 개수 = 보간에 필요한 `{` 개수 (`$$` → `{{expr}}`)
- 따옴표 3개 이상 가능: `""""` 안에 `"""` 포함 가능

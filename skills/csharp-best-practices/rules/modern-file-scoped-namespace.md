# File-scoped Namespaces (C# 10)

파일 전체에 네임스페이스를 적용하여 들여쓰기를 줄입니다.

## When to Use

- 모든 C# 파일 (기본 스타일로 권장)
- 파일당 하나의 네임스페이스 (일반적 관례)

## Before

```csharp
namespace MyApp.Services
{
    public class UserService
    {
        private readonly IUserRepository _repository;

        public UserService(IUserRepository repository)
        {
            _repository = repository;
        }

        public async Task<User?> GetByIdAsync(int id)
        {
            return await _repository.FindByIdAsync(id);
        }
    }
}
```

## After

```csharp
namespace MyApp.Services;

public class UserService
{
    private readonly IUserRepository _repository;

    public UserService(IUserRepository repository)
    {
        _repository = repository;
    }

    public async Task<User?> GetByIdAsync(int id)
    {
        return await _repository.FindByIdAsync(id);
    }
}
```

## Key Points

- `namespace X.Y.Z;` — 세미콜론으로 종료
- 파일 전체에 적용 (중괄호 불필요)
- 들여쓰기 1레벨 감소 → 가독성 향상
- 파일당 하나의 네임스페이스만 가능
- .editorconfig로 팀 표준 강제 가능:
  ```ini
  [*.cs]
  csharp_style_namespace_declarations = file_scoped:warning
  ```
- 새 프로젝트에서는 file-scoped를 기본으로 사용 권장

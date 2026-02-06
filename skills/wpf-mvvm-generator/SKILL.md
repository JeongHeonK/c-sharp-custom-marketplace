---
name: wpf-mvvm-generator
description: WPF MVVM code generator. Creates ViewModel, View, and Model with CommunityToolkit.Mvvm source generators. Use when scaffolding new WPF features or entities following MVVM pattern.
user-invocable: true
argument-hint: "<entity_name> [type]"
context: fork
model: sonnet
allowed-tools:
  - Read
  - Glob
  - Write
  - Edit
---

# WPF MVVM Generator 스킬

CommunityToolkit.Mvvm source generator를 사용하여 WPF MVVM 컴포넌트를 생성합니다.

**중요: 모든 결과는 반드시 한국어로 작성합니다.** 코드 식별자, 기술 용어, 패턴 이름 등은 원문 그대로 유지하되, 설명 부분은 한국어를 사용합니다.

## 인자

- `$ARGUMENTS[0]`: 엔티티 이름 (필수) - 예: `User`, `Product`, `Order`
- `$ARGUMENTS[1]`: 생성 유형 (선택): `viewmodel`, `view`, `model`, `all` (기본값: `all`)
  - `all`: Model + ViewModel + View + Code-Behind + Messages + Service Interface 모두 생성

## 실행 단계

### 1단계: 인자 검증

`$ARGUMENTS[0]`이 비어있는 경우:
- 사용자에게 엔티티 이름 요청
- 프로젝트의 기존 Model 기반으로 제안

**엔티티 이름 검증:**
- PascalCase 여부 확인
- C# 예약어 사용 확인
- 특수문자, 공백 포함 시 사용자에게 재입력 요청

### 2단계: 프로젝트 구조 탐색

기존 패턴을 식별:
- `Glob("**/*ViewModel.cs")`로 기존 ViewModel 패턴 확인
- 첫 번째 발견된 파일에서 네임스페이스 추출
- `/ViewModels`, `/Views`, `/Models` 디렉토리 존재 여부 확인
- 기존 베이스 클래스 또는 인터페이스 탐색

### 3단계: 코드 생성

`$ARGUMENTS[1]` 기준으로 생성:

## 생성 컴포넌트

### Model (`model`)

```csharp
namespace {Namespace}.Models;

/// <summary>
/// {EntityName} domain model
/// </summary>
public sealed class {EntityName}
{
    public required int Id { get; init; }
    public required string Name { get; init; }
    // 컨텍스트에 따른 추가 프로퍼티
}
```

### ViewModel (`viewmodel`)

```csharp
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using CommunityToolkit.Mvvm.Messaging;

namespace {Namespace}.ViewModels;

/// <summary>
/// ViewModel for {EntityName} management
/// </summary>
public partial class {EntityName}ViewModel : ObservableObject
{
    private readonly I{EntityName}Service _{entityName}Service;

    public {EntityName}ViewModel(I{EntityName}Service {entityName}Service)
    {
        _{entityName}Service = {entityName}Service;
    }

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(HasSelection))]
    [NotifyCanExecuteChangedFor(nameof(DeleteCommand))]
    private {EntityName}? _selected{EntityName};

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(SaveCommand))]
    private bool _isModified;

    [ObservableProperty]
    private bool _isLoading;

    public bool HasSelection => Selected{EntityName} is not null;

    [RelayCommand]
    private async Task LoadAsync(CancellationToken cancellationToken = default)
    {
        IsLoading = true;
        try
        {
            // Load logic
        }
        finally
        {
            IsLoading = false;
        }
    }

    [RelayCommand(CanExecute = nameof(CanSave))]
    private async Task SaveAsync(CancellationToken cancellationToken = default)
    {
        await _{entityName}Service.SaveAsync(Selected{EntityName}!, cancellationToken);
        IsModified = false;
    }

    private bool CanSave() => IsModified && Selected{EntityName} is not null;

    [RelayCommand(CanExecute = nameof(CanDelete))]
    private async Task DeleteAsync(CancellationToken cancellationToken = default)
    {
        if (Selected{EntityName} is null) return;

        await _{entityName}Service.DeleteAsync(Selected{EntityName}.Id, cancellationToken);

        WeakReferenceMessenger.Default.Send(
            new {EntityName}DeletedMessage(Selected{EntityName}));

        Selected{EntityName} = null;
    }

    private bool CanDelete() => Selected{EntityName} is not null;
}
```

### View (`view`)

```xml
<UserControl x:Class="{Namespace}.Views.{EntityName}View"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
             xmlns:vm="{Namespace}.ViewModels"
             mc:Ignorable="d"
             d:DataContext="{d:DesignInstance vm:{EntityName}ViewModel, IsDesignTimeCreatable=False}">

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Header -->
        <TextBlock Grid.Row="0"
                   Text="{EntityName} Management"
                   Style="{StaticResource HeaderStyle}"/>

        <!-- Content -->
        <ContentControl Grid.Row="1"
                        Content="{Binding Selected{EntityName}}"
                        Visibility="{Binding HasSelection, Converter={StaticResource BoolToVisibility}}"/>

        <!-- Actions -->
        <StackPanel Grid.Row="2"
                    Orientation="Horizontal"
                    HorizontalAlignment="Right">
            <Button Content="Save"
                    Command="{Binding SaveCommand}"/>
            <Button Content="Delete"
                    Command="{Binding DeleteCommand}"/>
        </StackPanel>

        <!-- Loading Overlay -->
        <Border Grid.RowSpan="3"
                Background="#80000000"
                Visibility="{Binding IsLoading, Converter={StaticResource BoolToVisibility}}">
            <ProgressBar IsIndeterminate="True" Width="200"/>
        </Border>
    </Grid>
</UserControl>
```

### Code-Behind (최소한)

```csharp
namespace {Namespace}.Views;

public partial class {EntityName}View : UserControl
{
    public {EntityName}View()
    {
        InitializeComponent();
    }
}
```

### Message Types

```csharp
namespace {Namespace}.Messages;

public sealed record {EntityName}DeletedMessage({EntityName} Deleted{EntityName});
public sealed record {EntityName}SelectedMessage({EntityName} Selected{EntityName});
public sealed record {EntityName}SavedMessage({EntityName} Saved{EntityName});
```

### Service Interface

```csharp
namespace {Namespace}.Services;

public interface I{EntityName}Service
{
    Task<IReadOnlyList<{EntityName}>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<{EntityName}?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task SaveAsync({EntityName} entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(int id, CancellationToken cancellationToken = default);
}
```

## 출력 형식

모든 내용은 **한국어**로 작성합니다. 코드 식별자와 기술 용어는 원문을 유지합니다.

```markdown
# MVVM 생성 결과

## 엔티티: {EntityName}

### 생성된 파일
| 파일 | 경로 | 상태 |
|------|------|------|
| Model | /Models/{EntityName}.cs | 생성됨 |
| ViewModel | /ViewModels/{EntityName}ViewModel.cs | 생성됨 |
| View | /Views/{EntityName}View.xaml | 생성됨 |
| Code-Behind | /Views/{EntityName}View.xaml.cs | 생성됨 |
| Messages | /Messages/{EntityName}Messages.cs | 생성됨 |
| Service Interface | /Services/I{EntityName}Service.cs | 생성됨 |

### 다음 단계
1. `I{EntityName}Service` 구현
2. DI 컨테이너에 등록
3. View 내비게이션 추가
4. 필요 시 디자인 타임 데이터 생성
```

## 에러 처리

| 상황 | 처리 |
|------|------|
| 엔티티 이름 미입력 | 사용자에게 요청, 기존 Model 기반 제안 |
| 유효하지 않은 이름 (특수문자, 예약어) | 사용자에게 재입력 요청 |
| ViewModels/Views/Models 디렉토리 없음 | 디렉토리 자동 생성 후 진행 |
| 동일 이름 파일 존재 | 사용자에게 덮어쓰기 확인 |

## 가이드라인

- CommunityToolkit.Mvvm source generator를 사용합니다
- 기존 프로젝트 명명 규칙을 따릅니다
- 최소한의 Code-Behind을 생성합니다 (UI 로직만)
- 적절한 XML 문서화를 포함합니다
- 비동기 작업에 CancellationToken을 지원합니다
- ViewModel 간 통신에 WeakReferenceMessenger를 사용합니다

# C# Marketplace Plugin

## Overview

C#/.NET 및 WPF 개발을 위한 Claude Code 플러그인 (v1.4.0)

## Tech Stack

- Language: C# 12/13 (.NET 8/9)
- UI Framework: WPF
- Architecture: MVVM (CommunityToolkit.Mvvm)
- Claude Code: 2.1.x+

## Code Principles

### OOP Four Pillars
- Encapsulation, Inheritance, Polymorphism, Abstraction

### SOLID Principles (Required)
- **S**ingle Responsibility Principle
- **O**pen/Closed Principle
- **L**iskov Substitution Principle
- **I**nterface Segregation Principle
- **D**ependency Inversion Principle

### GoF Design Patterns
- Apply design patterns in appropriate situations
- Avoid over-engineering

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes, Methods, Properties | PascalCase | `UserService`, `GetById` |
| Local variables, Parameters | camelCase | `userId`, `isActive` |
| Private fields | _camelCase | `_repository`, `_logger` |
| Interfaces | I prefix | `IRepository`, `IUserService` |
| Async methods | Async suffix | `GetByIdAsync` |

## Project Structure (Recommended)

```
/src
  /Models          - Domain models
  /ViewModels      - MVVM ViewModels (partial classes)
  /Views           - WPF XAML Views
  /Services        - Business services
  /Repositories    - Data access layer
  /Messages        - Messenger message types
  /Converters      - IValueConverter implementations
  /Infrastructure  - Common infrastructure
/tests
  /UnitTests       - Unit tests
  /IntegrationTests - Integration tests
```

## Available Tools

### Agents

| Agent | Description | Model |
|-------|-------------|-------|
| `csharp-expert` | C# code writing and analysis expert | Sonnet |
| `wpf-expert` | WPF/MVVM expert | Sonnet |

### Skills

| Skill | Description | Usage |
|-------|-------------|-------|
| `/csharp-code-review` | OOP/SOLID/GoF based code review | `/csharp-code-review [file]` |
| `/csharp-refactor` | SOLID/Pattern/Modern C# refactoring | `/csharp-refactor [file] [type]` |
| `/wpf-mvvm-generator` | MVVM code generation | `/wpf-mvvm-generator <entity> [type]` |

### MCP Servers

- `context7`: Library/framework documentation search
  - Usage: Include "use context7" in your prompt
  - Example: "C# List<T> usage use context7"
  - Supports .NET, WPF, NuGet package documentation

## Modern C# Features (Preferred)

- Primary constructors
- Collection expressions `[1, 2, 3]`
- required / init properties
- Pattern matching
- Record types
- File-scoped namespaces
- Raw string literals

# C# Marketplace Plugin

[![Version](https://img.shields.io/badge/version-1.6.0-blue.svg)]()
[![.NET](https://img.shields.io/badge/.NET-8%2F9-purple.svg)]()
[![C#](https://img.shields.io/badge/C%23-12%2F13-green.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude_Code-2.1.3+-orange.svg)]()

[**한국어**](README.ko.md)

A Claude Code plugin for C# and WPF development. Provides expert agents and code review/refactoring/MVVM generation skills focused on Modern C# 12/13, OOP principles, SOLID principles, and GoF design patterns.

## Key Features

### Agents
| Agent | Description |
|-------|-------------|
| **C# Expert** | Modern C# 12/13, SOLID principles, GoF patterns, performance optimization expert |
| **WPF Expert** | CommunityToolkit.Mvvm, MVVM patterns, data binding, Modern UI expert |

### Skills
| Skill | Description |
|-------|-------------|
| **csharp-code-review** | OOP/SOLID/GoF + Performance/Security/Async code review |
| **csharp-refactor** | Apply SOLID principles, introduce design patterns, convert to Modern C# syntax |
| **wpf-mvvm-generator** | Generate ViewModel/View/Model based on CommunityToolkit.Mvvm |
| **csharp-best-practices** | C# 12/.NET 8 coding guidelines knowledge-base (12 rules, 3-tier architecture inspired by vercel-react-best-practices) |
| **csharp-tdd-develop** | TDD-based C# development (Red-Green-Refactor workflow) |
| **csharp-test-develop** | Write test code for existing C# classes |
| **project-setup** | Initialize C#/.NET project for Claude Code (CLAUDE.md + context hooks for Bash/PowerShell) — based on [agents.md outperforms skills](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) |

### MCP Servers
| Server | Description |
|--------|-------------|
| **Context7** | .NET, WPF, NuGet official documentation search |

## Supported Features

### Modern C# Features (C# 12/13)
- Primary constructors
- Collection expressions `[1, 2, 3]`
- required / init properties
- Pattern matching
- Record types
- params collections (C# 13)
- System.Threading.Lock (C# 13)

### CommunityToolkit.Mvvm
- `[ObservableProperty]` Source Generator
- `[RelayCommand]` / `[AsyncRelayCommand]`
- `WeakReferenceMessenger` Pub/Sub
- Dependency Injection Integration

### Code Review Checklist
- OOP four pillars
- SOLID principles
- GoF design pattern opportunities
- Modern C# feature utilization
- Performance (memory allocation, Span<T>, Memory<T>, LOH)
- Async/Await patterns
- Security (SQL Injection, XSS, etc.)

## Installation

### Method 1: Install via npx (Recommended)
```bash
# Install all skills
npx skills add JeongHeonK/c-sharp-custom-marketplace

# Install specific skills only
npx skills add JeongHeonK/c-sharp-custom-marketplace --skill csharp-code-review
npx skills add JeongHeonK/c-sharp-custom-marketplace --skill csharp-refactor wpf-mvvm-generator
```

### Method 2: Install via Claude Code UI
1. Type `/plugin` to open the plugin manager
2. Press **Tab** to navigate to the **Marketplaces** tab
3. Select **Add Marketplace** and press Enter
4. Enter the path: `JeongHeonK/c-sharp-custom-marketplace`
5. Select desired skills from the **Discover** tab to install

### Installation Scope

When installing via the `/plugin` UI, you can choose the scope:
- **User scope**: Available across all projects (default)
- **Project scope**: Available to all collaborators in the repository
- **Local scope**: Available only to you in the repository

## Plugin Structure

```
c-sharp-marketplace/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest
├── agents/
│   ├── csharp-expert.md     # C#/.NET expert agent
│   └── wpf-expert.md        # WPF/MVVM expert agent
├── skills/
│   ├── csharp-best-practices/
│   │   ├── SKILL.md         # Best practices guideline skill
│   │   ├── AGENTS.md        # Knowledge-base agent
│   │   └── rules/           # 12 guideline rule files
│   ├── csharp-code-review/
│   │   └── SKILL.md         # Code review skill
│   ├── csharp-refactor/
│   │   └── SKILL.md         # Refactoring skill
│   ├── csharp-tdd-develop/
│   │   ├── SKILL.md         # TDD workflow orchestrator
│   │   └── scripts/
│   │       └── test-detector.js  # .csproj test env detection
│   ├── csharp-test-develop/
│   │   ├── SKILL.md         # Test code writing skill
│   │   └── references/
│   │       └── csharp-test-patterns.md  # C# test patterns guide
│   ├── project-setup/
│   │   ├── SKILL.md         # Project initialization skill
│   │   ├── scripts/
│   │   │   ├── setup.sh     # Hook setup (Bash)
│   │   │   └── setup.ps1    # Hook setup (PowerShell)
│   │   ├── references/
│   │   │   └── claude-md-template.md  # CLAUDE.md generation template
│   │   └── assets/hooks/    # Hook scripts (.sh + .ps1)
│   └── wpf-mvvm-generator/
│       └── SKILL.md         # MVVM generation skill
├── .mcp.json                # MCP server configuration
├── CLAUDE.md                # Project conventions
└── README.md
```

> **Note**: After installing the plugin, the `agents/` and `skills/` directories are automatically recognized, enabling slash commands (`/skill-name`) and agent mentions (`@agent-name`). (Claude Code 2.1.3+)

## Usage

### Agents

Agents can be invoked directly using `@agent-name`, or Claude Code will automatically invoke them based on task context.

#### C# Expert Agent (`@csharp-expert`)
```
@csharp-expert "Implement a Repository pattern for the User entity"
@csharp-expert "Refactor this code to follow SOLID principles"
@csharp-expert "Convert to primary constructors"
@csharp-expert "Optimize performance using Span<T>"
```

#### WPF Expert Agent (`@wpf-expert`)
```
@wpf-expert "Create a ViewModel using CommunityToolkit.Mvvm"
@wpf-expert "Implement using [ObservableProperty] and [RelayCommand]"
@wpf-expert "Implement inter-ViewModel communication with WeakReferenceMessenger"
@wpf-expert "Create a custom date picker control"
```

### Skills

#### Code Review
```
/csharp-code-review
/csharp-code-review src/Services/UserService.cs
```

#### Code Refactoring
```
/csharp-refactor                                    # Full analysis
/csharp-refactor src/Services/UserService.cs        # Specific file
/csharp-refactor src/Services/UserService.cs solid  # SOLID refactoring only
/csharp-refactor src/Services/UserService.cs modern # Modern C# syntax conversion
```

#### Best Practices Guidelines
```
/csharp-best-practices                      # Show all rules
/csharp-best-practices primary-constructor  # Specific topic
/csharp-best-practices record              # Record types guide
```

#### TDD Development
```
/csharp-tdd-develop UserService            # TDD workflow for UserService
/csharp-tdd-develop 주문 처리 서비스        # TDD workflow for order service
```

#### Test Code Writing
```
/csharp-test-develop src/Services/UserService.cs  # Write tests for file
/csharp-test-develop OrderService                  # Find and write tests for class
```

#### MVVM Code Generation
```
/wpf-mvvm-generator User                    # Generate full MVVM for User
/wpf-mvvm-generator Product viewmodel       # Generate ProductViewModel only
/wpf-mvvm-generator Order view              # Generate OrderView only
```

#### Project Setup
```
/project-setup                              # Initialize current project
/project-setup init /path/to/project        # Initialize specific project
/project-setup migrate                      # Add sections to existing CLAUDE.md
/project-setup hooks                        # Install hook scripts only
```

### MCP Server (Context7)

Add "use context7" to your prompt for documentation search:
```
"Show me how to use IAsyncEnumerable in C# use context7"
"CommunityToolkit.Mvvm ObservableProperty examples use context7"
".NET 8 Span<T> best practices use context7"
```

## Code Principles

### OOP Four Pillars
- Encapsulation
- Inheritance
- Polymorphism
- Abstraction

### SOLID Principles
| Principle | Description |
|-----------|-------------|
| **SRP** | Single Responsibility Principle |
| **OCP** | Open/Closed Principle |
| **LSP** | Liskov Substitution Principle |
| **ISP** | Interface Segregation Principle |
| **DIP** | Dependency Inversion Principle |

### GoF Design Patterns

**Creational Patterns**: Singleton, Factory Method, Abstract Factory, Builder, Prototype

**Structural Patterns**: Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy

**Behavioral Patterns**: Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes, Methods, Properties | PascalCase | `UserService`, `GetById` |
| Local variables, Parameters | camelCase | `userId`, `isActive` |
| Private fields | _camelCase | `_repository`, `_logger` |
| Interfaces | I prefix | `IRepository`, `IUserService` |
| Async methods | Async suffix | `GetByIdAsync` |

## Recommended Project Structure

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

## Requirements

- **Claude Code CLI 2.1.3+** (required, supports symlinked skills)
- Node.js 18+ (for Context7 MCP server)
- .NET 8/9 SDK
- Visual Studio 2022 / JetBrains Rider

## Changelog

### v1.6.0 (2026-02-02)

**Docs Index Pattern for CLAUDE.md Template**

Applied the "docs index" pattern from [Vercel's agents.md outperforms skills](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) research to the CLAUDE.md template generated by `project-setup`.

| Change | Description |
|--------|-------------|
| **claude-md-template.md** (Updated) | Replaced "Skill Invocation Guidelines" with docs index (`C#/.NET Coding Guidelines`) + explore-first (`Skill Workflows`) sections |
| **project-setup/SKILL.md** (Updated) | Verification checklist aligned with new section names |
| **CLAUDE.md** (Updated) | Added `Development Guidelines` section for plugin maintainers |

---

### v1.5.0 (2025-01-30)

**Plugin Modularization**

Added new skills for best practices, TDD development, and test code writing. The `csharp-best-practices` skill follows the 3-tier architecture (SKILL.md + AGENTS.md + rules/) inspired by [vercel-react-best-practices](https://github.com/anthropics/claude-code/tree/main/skills/vercel-react-best-practices).

| Change | Description |
|--------|-------------|
| **csharp-best-practices** (New) | C# 12/.NET 8 coding guidelines knowledge-base with 12 rule files (modeled after vercel-react-best-practices) |
| **csharp-tdd-develop** (New) | TDD Red-Green-Refactor workflow orchestrator delegating to csharp-expert |
| **csharp-test-develop** (New) | Test code writing skill for existing code (xUnit/Moq/FluentAssertions) |
| **csharp-code-review** (Updated) | Removed "Positive Aspects" section — issues only output |

---

### v1.4.0 (2025-01-27)

**Claude Code 2.1.x Compatibility Improvements**

Updated documentation and structure in accordance with the integration of skills and slash commands in Claude Code 2.1.3+.

| Change | Description | Related Version |
|--------|-------------|-----------------|
| Agent `@mention` invocation | Direct invocation support for `@csharp-expert`, `@wpf-expert` | v2.1.0 |
| Skill slash commands | Direct invocation via `/csharp-code-review`, etc. | v2.1.3 |
| `user-invocable` setting | Slash command menu visibility configuration | v2.1.3 |
| Documentation improvements | Clarified plugin structure and usage | - |

---

### v1.3.0 (2025-01-24)

**Claude Code 2.1.x Compatibility Update**

This update reflects major changes from the Claude Code 2.0.x ~ 2.1.x release notes.

#### Agent Updates
| Item | Description | Related Version |
|------|-------------|-----------------|
| `model` field | Specify the model for agents (sonnet/opus/haiku) | v2.0.64 |
| `permissionMode` field | Configure agent permission mode | v2.0.43 |
| `allowed-tools` | Tool allowlist in YAML list format | v2.1.0 |
| `disallowedTools` | Explicit tool blocklist | v2.0.30 |

#### Skill Updates
| Item | Description | Related Version |
|------|-------------|-----------------|
| `context: fork` | Execute in forked sub-agent context | v2.1.0 |
| `argument-hint` | Slash command argument hint display | v2.1.0 |
| `user-invocable` | Slash command menu visibility | v2.1.3 |
| `skills` field | Auto-load skills for sub-agents | v2.1.0 |
| `$ARGUMENTS[0]` | New argument access syntax (replaces `$ARGUMENTS.0`) | v2.1.19 |

#### New Skills
- **csharp-refactor**: Apply SOLID principles, introduce design patterns, convert to Modern C# syntax
- **wpf-mvvm-generator**: Generate ViewModel/View/Model code based on CommunityToolkit.Mvvm

#### Other
- Added LSP tool support (go-to-definition, find-references, hover) - v2.0.74
- New Task Management System support - v2.1.16

---

### v1.2.0
- Added marketplace.json for Marketplace distribution
- Improved plugin installation guide

### v1.1.0
- Added Modern C# 12/13 feature support
- Added CommunityToolkit.Mvvm Source Generators guide
- Added Performance Review section (Span<T>, Memory<T>, LOH)
- Added Async Code Review checklist
- Added Security Review section

### v1.0.0
- Initial release
- C# Expert, WPF Expert agents
- Code Review skill
- Context7 MCP server configuration

## License

MIT

# C# Marketplace Plugin

[![Version](https://img.shields.io/badge/version-1.8.0-blue.svg)]()
[![.NET](https://img.shields.io/badge/.NET-8%2F9-purple.svg)]()
[![C#](https://img.shields.io/badge/C%23-12%2F13-green.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude_Code-2.1.3+-orange.svg)]()

[**한국어**](README.ko.md)

A Claude Code plugin for C# and WPF development. Provides code review/refactoring/MVVM generation skills focused on Modern C# 12/13, OOP principles, SOLID principles, and GoF design patterns.

## Key Features

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
├── skills/
│   ├── csharp-best-practices/
│   │   ├── SKILL.md         # Best practices guideline skill
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

> **Note**: After installing the plugin, the `skills/` directory is automatically recognized, enabling slash commands (`/skill-name`). (Claude Code 2.1.3+)

## Usage

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

### v1.8.0 (2026-02-10)

**Remove Custom Agents — npx skills Compatibility**

Removed `agents/` directory and switched to `general-purpose` sub-agent delegation for full `npx skills add` compatibility. Agent expertise is now provided via inline prompt context and existing rules/references.

| Change | Description |
|--------|-------------|
| **agents/** (Removed) | Removed `csharp-expert.md`, `wpf-expert.md`, `AGENTS.md` |
| **csharp-tdd-develop** (Updated) | Switched to `general-purpose` sub-agent; added C# expert context to Task prompts |
| **csharp-test-develop** (Updated) | Same changes as csharp-tdd-develop |
| **CLAUDE.md** (Updated) | 3-tier → 2-tier architecture documentation |

---

### v1.7.0 (2026-02-06)

**Skills Localization & Quality Improvements**

Converted all user-facing skill outputs to Korean and improved skill quality based on systematic audit.

| Change | Description |
|--------|-------------|
| **csharp-code-review** (Updated) | SKILL.md body localized to Korean; output format template fully translated; technical term consistency enforced |
| **csharp-refactor** (Updated) | SKILL.md body localized to Korean; added C# version annotations to Modern syntax table; added TargetFramework detection; added error handling section |
| **wpf-mvvm-generator** (Updated) | SKILL.md body localized to Korean; clarified `all` option generates 6 component types; added entity name validation; added error handling section; improved project structure scanning with Glob patterns |

---

### v1.6.1 (2026-02-03)

**Inline Docs Index Pattern — Passive Context for CLAUDE.md**

Applied a 2-tier "inline docs index" pattern to the CLAUDE.md template generated by `project-setup`. Key patterns from C# best practices, test patterns, and WPF/MVVM are now **inlined as compact summaries** in `## C#/.NET Quick Reference`, enabling agents to leverage them as passive context every turn without explicit file reads. Detailed reference files are preserved in `## Detailed References` for edge cases.

| Change | Description |
|--------|-------------|
| **claude-md-template.md** (Updated) | Added `## C#/.NET Quick Reference` (~140 lines of compact inline summaries); renamed file-path tables to `## Detailed References`; added conditional sections for WPF, Test, and TargetFramework |
| **project-setup/SKILL.md** (Updated) | Extended Step 4 conditional section handling (4 conditions); added Quick Reference verification to Step 6 checklist; updated migrate subcommand |
| **CLAUDE.md** (Updated) | Updated Development Guidelines with Quick Reference + Detailed References maintenance instructions |

---

### v1.5.0 (2025-01-30)

**Plugin Modularization**

Added new skills for best practices, TDD development, and test code writing. The `csharp-best-practices` skill follows the 3-tier architecture (SKILL.md + AGENTS.md + rules/) inspired by [vercel-react-best-practices](https://github.com/anthropics/claude-code/tree/main/skills/vercel-react-best-practices).

| Change | Description |
|--------|-------------|
| **csharp-best-practices** (New) | C# 12/.NET 8 coding guidelines knowledge-base with 12 rule files (modeled after vercel-react-best-practices) |
| **csharp-tdd-develop** (New) | TDD Red-Green-Refactor workflow orchestrator |
| **csharp-test-develop** (New) | Test code writing skill for existing code (xUnit/Moq/FluentAssertions) |
| **csharp-code-review** (Updated) | Removed "Positive Aspects" section — issues only output |

---

### v1.4.0 (2025-01-27)

**Claude Code 2.1.x Compatibility Improvements**

Updated documentation and structure in accordance with the integration of skills and slash commands in Claude Code 2.1.3+.

| Change | Description | Related Version |
|--------|-------------|-----------------|
| Skill slash commands | Direct invocation via `/csharp-code-review`, etc. | v2.1.3 |
| `user-invocable` setting | Slash command menu visibility configuration | v2.1.3 |
| Documentation improvements | Clarified plugin structure and usage | - |

---

### v1.3.0 (2025-01-24)

**Claude Code 2.1.x Compatibility Update**

This update reflects major changes from the Claude Code 2.0.x ~ 2.1.x release notes.

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
- Code Review skill
- Context7 MCP server configuration

## License

MIT

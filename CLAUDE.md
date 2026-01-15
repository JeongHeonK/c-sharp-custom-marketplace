# C# Marketplace Project

## Overview
C# based marketplace application

## Tech Stack
- Language: C# (.NET)
- UI Framework: WPF
- Architecture: MVVM

## Code Principles

### OOP Four Pillars
- Encapsulation, Inheritance, Polymorphism, Abstraction

### SOLID Principles (Required)
- Single Responsibility Principle
- Open/Closed Principle
- Liskov Substitution Principle
- Interface Segregation Principle
- Dependency Inversion Principle

### GoF Design Patterns
- Apply design patterns in appropriate situations
- Avoid over-engineering

## Naming Conventions
- PascalCase: Classes, methods, properties, events
- camelCase: Local variables, parameters
- _camelCase: Private fields
- I prefix: Interfaces (e.g., IRepository)

## Project Structure (Recommended)
```
/src
  /Models          - Domain models
  /ViewModels      - MVVM ViewModels
  /Views           - WPF XAML Views
  /Services        - Business services
  /Repositories    - Data access layer
  /Infrastructure  - Common infrastructure
/tests
  /UnitTests       - Unit tests
  /IntegrationTests - Integration tests
```

## Available Tools

### Agents
- `csharp-expert`: C# code writing and analysis expert
- `wpf-expert`: WPF/MVVM expert

### Skills
- `/csharp-code-review`: OOP/SOLID/GoF based code review

### MCP Servers
- `context7`: Library/framework documentation search
  - Usage: Include "use context7" in your prompt
  - Example: "C# List<T> usage use context7"
  - Supports .NET, WPF, NuGet package documentation

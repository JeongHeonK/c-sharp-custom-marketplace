---
name: csharp-code-review
description: C# code review skill. Analyzes code quality from OOP, SOLID, and GoF design pattern perspectives and suggests improvements.
---

# C# Code Review Skill

Systematically reviews C# code from OOP principles, SOLID principles, and GoF design pattern perspectives.

## Execution Steps

### Step 1: Identify Review Target
If the user hasn't specified a file:
- Check recently modified `.cs` files
- Or ask the user to specify files/directories to review

### Step 2: Code Analysis
Read the target code and analyze from the following perspectives.

## Review Checklist

### OOP Four Pillars
| Principle | Review Items |
|-----------|--------------|
| **Encapsulation** | Private fields, property access, hidden implementation details |
| **Inheritance** | Proper inheritance hierarchy, composition over inheritance |
| **Polymorphism** | Interface/abstract class usage, virtual method appropriateness |
| **Abstraction** | Appropriate abstraction level, unnecessary detail exposure |

### SOLID Principles
| Principle | Review Items | Violation Signs |
|-----------|--------------|-----------------|
| **SRP** | Does the class have single responsibility? | Class changes for multiple reasons, too many methods |
| **OCP** | Open for extension, closed for modification? | Existing code requires modification for new features, switch/if-else chains |
| **LSP** | Can subtypes substitute base types? | Exceptions in subclasses, empty method overrides |
| **ISP** | Are interfaces segregated per client? | NotImplementedException in implementations, unused methods |
| **DIP** | Depending on abstractions? | Direct instantiation with new, concrete class type dependencies |

### GoF Design Pattern Opportunities
Identify areas in the code where these patterns could be applied:

**Creational Patterns**
- Complex object creation → Builder
- Separate object creation logic → Factory Method / Abstract Factory
- Global single instance → Singleton (caution: avoid overuse)

**Structural Patterns**
- Incompatible interface connection → Adapter
- Dynamic feature addition → Decorator
- Simplify complex subsystems → Facade
- Object tree structures → Composite

**Behavioral Patterns**
- Interchangeable algorithms → Strategy
- State-dependent behavior changes → State
- Object communication → Observer / Mediator
- Request processing chain → Chain of Responsibility
- Undo/Redo → Command + Memento

### Code Quality Review
- [ ] Naming conventions (PascalCase, camelCase, _privateField)
- [ ] Null safety (nullable reference types, null checks)
- [ ] Exception handling (specific exception catch, proper logging)
- [ ] Correct async/await usage (.ConfigureAwait, deadlock prevention)
- [ ] IDisposable pattern compliance (using statements, Dispose implementation)
- [ ] Collection usage (appropriate type selection, LINQ usage)
- [ ] Magic numbers/strings should be constants
- [ ] Duplicate code elimination

## Step 3: Output Review Results

### Output Format

```markdown
# Code Review Results

## Summary
- File: {file path}
- Overall Assessment: {Excellent/Good/Needs Improvement/Critical}
- Major Issues: {N} items

## SOLID Principles Analysis

### SRP Violation (Severity: High/Medium/Low)
- Location: `ClassName.cs:line`
- Problem: {description}
- Suggestion: {improvement}

### OCP Violation
...

## Applicable Design Patterns

### {Pattern Name} Pattern Recommended
- Current code: {problem}
- Benefits of applying: {description}
- Example code: {brief example}

## Code Quality Issues

### {Issue Title}
- Location: `file.cs:line`
- Current: {code}
- Improved: {code}

## Positive Aspects
- {mention well-written parts}

## Prioritized Improvements
1. [High] {item}
2. [Medium] {item}
3. [Low] {item}
```

## Guidelines
- Don't just criticize; mention positive aspects too.
- Provide improvements with concrete code examples.
- Don't recommend over-engineering.
- Make practical suggestions considering context.

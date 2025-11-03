# Repository Guidelines

## Project Structure & Module Organization
- `Package.swift` defines the SwiftPM executable target `xcodecd` and pulls in the `swift-argument-parser` dependency.
- `Sources/xcodecd/` contains the CLI entry point. Extend `xcodecd.swift` with additional commands or helpers; group supporting types with `fileprivate` scope when practical.
- `Tests/` is currently absent. Add SwiftPM test targets under `Tests/<TargetName>Tests/` when introducing automated coverage.

## Build, Test, and Development Commands
- `swift build` – compiles the CLI with the default (debug) configuration.
- `swift run xcodecd [args]` – runs thetool. 
- `swift test` – executes SwiftPM test targets once they are added.
- Please ask permissions when you cannot run `swift` command deu to sandbox environment.

## Coding Style & Naming Conventions
- Follow standard Swift API Design Guidelines: UpperCamelCase for types, lowerCamelCase for values, protocol names ending in nouns/adjectives.
- Use 4-space indentation and keep line length reasonable (<120 chars).
- Prefer `private`/`fileprivate` access control and mark pure helpers as `internal` only when shared.
- Write DocC as much as possible.

# Contributing to asdf-acceleration-middleware

Thank you for your interest in contributing! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contribution Workflow](#contribution-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [TPCF Framework](#tpcf-framework)
- [Review Process](#review-process)

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

- **Rust**: 1.70.0 or later
- **Cargo**: Latest stable
- **Just**: Command runner (optional but recommended)
- **Nix**: For reproducible builds (optional)
- **asdf**: For testing integration

### First Contribution Ideas

- 🐛 Fix a bug from the issue tracker
- 📝 Improve documentation
- ✨ Add tests
- 🎨 Improve error messages
- 🌐 Add shell completions
- 📊 Add benchmarks

## Development Setup

```bash
# Clone repository
git clone https://github.com/Hyperpolymath/asdf-acceleration-middleware
cd asdf-acceleration-middleware

# Install dependencies
cargo build

# Run tests
cargo test

# Run with just (recommended)
just build
just test
just lint
```

### Workspace Structure

The project uses a Cargo workspace with multiple crates:

```
crates/
├── asdf-core/         # Core library
├── asdf-cache/        # Caching layer
├── asdf-parallel/     # Parallel execution
├── asdf-config/       # Configuration
├── asdf-metrics/      # Metrics
├── asdf-accelerate/   # Main CLI
├── asdf-bench/        # Benchmarking
├── asdf-discover/     # Auto-discovery
└── asdf-monitor/      # Monitoring
```

## Contribution Workflow

### 1. Create an Issue

Before starting work:
- Check existing issues
- Create new issue describing the change
- Discuss approach with maintainers

### 2. Fork and Branch

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/asdf-acceleration-middleware
cd asdf-acceleration-middleware
git remote add upstream https://github.com/Hyperpolymath/asdf-acceleration-middleware

# Create feature branch
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Write code following [Coding Standards](#coding-standards)
- Add tests for new functionality
- Update documentation
- Ensure all tests pass

### 4. Commit

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add caching for plugin metadata

- Implement LRU cache for frequently accessed plugins
- Add configurable TTL
- Add cache invalidation on updates
- Add tests for cache behavior"
```

#### Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Examples**:
```
feat(cache): add LRU caching layer
fix(parallel): handle thread panic gracefully
docs(readme): update installation instructions
test(bench): add comparison benchmarks
```

### 5. Push and Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name

# Create Pull Request on GitHub
# - Describe changes
# - Link related issues
# - Add screenshots if applicable
```

## Coding Standards

### Rust Style

- Follow [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- Use `rustfmt` for formatting
- Use `clippy` for linting
- Avoid `unsafe` unless absolutely necessary

```bash
# Format code
cargo fmt

# Run clippy
cargo clippy -- -D warnings

# Or use just
just lint
```

### Code Quality

- **Type Safety**: Leverage Rust's type system
- **Error Handling**: Use `Result<T, E>` and `anyhow`/`thiserror`
- **Documentation**: Document public APIs with `///` comments
- **Testing**: Aim for >80% code coverage
- **Performance**: Profile before optimizing

### Examples

#### Good Error Handling

```rust
use anyhow::{Context, Result};

pub fn load_config(path: &Path) -> Result<Config> {
    let content = std::fs::read_to_string(path)
        .with_context(|| format!("Failed to read config from {}", path.display()))?;

    toml::from_str(&content)
        .context("Failed to parse config")
}
```

#### Good Documentation

```rust
/// Executes asdf commands in parallel using Rayon.
///
/// # Arguments
///
/// * `commands` - List of commands to execute
/// * `max_jobs` - Maximum parallel jobs (None = number of CPUs)
///
/// # Returns
///
/// Vector of results for each command
///
/// # Errors
///
/// Returns error if any command fails and error handling is set to fail-fast
///
/// # Examples
///
/// ```
/// let results = execute_parallel(&commands, Some(4))?;
/// ```
pub fn execute_parallel(
    commands: &[Command],
    max_jobs: Option<usize>,
) -> Result<Vec<CommandResult>> {
    // ...
}
```

## Testing

### Test Types

1. **Unit Tests**: Test individual functions
2. **Integration Tests**: Test crate interactions
3. **Benchmark Tests**: Performance testing
4. **RSR Compliance Tests**: Verify framework compliance

### Running Tests

```bash
# All tests
cargo test

# Specific crate
cargo test -p asdf-cache

# With output
cargo test -- --nocapture

# Benchmarks
cargo bench

# Using just
just test
just bench
```

### Writing Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_cache_hit() {
        let cache = Cache::new(100);
        cache.insert("key", "value");
        assert_eq!(cache.get("key"), Some("value"));
    }

    #[test]
    fn test_cache_miss() {
        let cache = Cache::new(100);
        assert_eq!(cache.get("nonexistent"), None);
    }
}
```

## Documentation

### What to Document

- Public APIs (functions, structs, enums)
- Complex algorithms
- Non-obvious behavior
- Examples of usage
- Error conditions

### Documentation Standards

- Use Rust doc comments (`///` for items, `//!` for modules)
- Include examples in doc comments
- Keep CLAUDE.md updated with architecture changes
- Update README for user-facing changes

## TPCF Framework

This project uses the **Tri-Perimeter Contribution Framework**:

### Perimeter 3: Community Sandbox (Current)

**Access**: Public contributions welcome

**Requirements**:
- ✅ Follow Code of Conduct
- ✅ Sign commits (optional but recommended)
- ✅ Pass all CI checks
- ✅ Code review approval

**Process**:
1. Fork repository
2. Make changes
3. Submit PR
4. Code review
5. Maintainer approval
6. Merge

### Future Perimeters

As the project matures, we may introduce:
- **Perimeter 2**: Trusted Contributors (direct commit access)
- **Perimeter 1**: Core Maintainers (release authority)

## Review Process

### What Reviewers Look For

- ✅ Code quality and style
- ✅ Test coverage
- ✅ Documentation
- ✅ Performance implications
- ✅ Security considerations
- ✅ Breaking changes
- ✅ RSR compliance

### Timeline

- **Initial Review**: Within 3 days
- **Follow-up**: Within 2 days of updates
- **Merge**: After approval + CI pass

### Feedback

All feedback is:
- **Constructive**: Focused on improvement
- **Respectful**: Per Code of Conduct
- **Educational**: Explaining the "why"
- **Actionable**: Clear next steps

## Getting Help

- 💬 **Discussions**: GitHub Discussions
- 🐛 **Issues**: GitHub Issues
- 📧 **Email**: See MAINTAINERS.md
- 📖 **Docs**: Check `docs/` directory

## Recognition

Contributors are acknowledged in:
- 🎖️ CHANGELOG.md for each release
- 🏆 `.well-known/humans.txt`
- 📜 Git history (permanent record)

## License

By contributing, you agree that your contributions will be dual-licensed under MIT OR Palimpsest-0.8.

---

**Thank you for contributing!** 🎉

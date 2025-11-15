# NestJS Template Generator

Reusable NestJS project template with built-in best practices, testing infrastructure, and developer experience features.

**Onboarding**: If you're new to this repo, start with the [QUICKSTART guide](./docs/QUICKSTART.md) and read the [CONTRIBUTING guide](./CONTRIBUTING.md) for the development workflow and commit conventions.

## AI-Assisted Development

This project includes **agent-driven workflow prompts** that reduce AI token consumption by 60-70% and accelerate development through structured, interactive sessions.

**Key Resources:**

- **[Workflow Prompts Guide](./docs/prompts/README.md)** - How to use AI workflows
- **[Morning Context Builder](./docs/prompts/morning-context-builder.md)** - Daily session initialization
- **[Debug Session Workflow](./docs/prompts/daily-debug-session.md)** - Structured 7-phase debugging
- **[Copilot Instructions](./.github/copilot-instructions.md)** - Complete AI guidance for this project
- **[Paradigm Shift Article](./docs/articles/agent-driven-context-paradigm.md)** - Deep dive into agent-driven development

**Quick Start with AI:**

```text
# In GitHub Copilot Agent chat:
"Execute morning-context-builder.md workflow"

# Answer 2-5 triage questions
# Agent gathers context automatically
# Start coding with optimized AI assistance
```

**Benefits:**

- 📉 70% token reduction (5000→1500 per session)
- ⚡ 65% time reduction (20 min→7 min debugging)
- 🔄 Self-improving through feedback loops
- 🎯 90% information relevance (vs 40% traditional)

## Features

- **TypeScript** with strict mode and strong typing
- **Testing infrastructure** with Jest (unit, integration, e2e)
- **ESLint + Prettier + SonarJS** for code quality and cognitive complexity analysis
- **TypeScript strict mode** with strong typing enforcement
- **Environment validation** with Joi
- **Swagger/OpenAPI** documentation
- **Health checks** endpoint
- **Centralized logging** with Winston and error handling
- **Git hooks** with Husky + lint-staged + commitlint
- **Automated release management** with conventional commits
- **Docker Compose** for PostgreSQL development database
- **Safety guards** for test execution (prevent production DB accidents)

## Quick Start

```bash
# Install dependencies
npm install

# Verify project health (format, lint, test, build)
npm run verify

# Start development server
npm run start:dev
```

## Development

### Testing

```bash
# Unit tests (fast, no DB required)
npm test

# Unit tests with coverage
npm run test:coverage

# Integration tests (requires PostgreSQL)
npm run test:integration:safe

# E2E tests (requires PostgreSQL)
npm run test:e2e:safe

# TDD mode (watch + coverage)
npm run test:tdd
```

### Code Quality

```bash
# Check formatting + linting + complexity analysis
npm run quality

# Fix formatting and linting issues
npm run quality:fix

# Analyze cognitive complexity
npm run analyze
```

### Project Health Check

```bash
# Quick verification (format, lint, test, build)
npm run verify

# Full verification (+ coverage + analysis)
npm run verify:full

# CI pipeline simulation
npm run ci
```

### Build & Run

```bash
# Build for production
npm run build

# Run production build
npm run start:prod
```

## Project Structure

```text
src/
├── common/          # Shared utilities, filters, interceptors
├── config/          # Configuration and env validation
├── health/          # Health check endpoints
├── swagger/         # API documentation setup
└── main.ts          # Application bootstrap

.github/
└── workflows/       # CI/CD automation (templates available as .bak files)
    ├── ci.yml.bak       # Tests, lint, build on PRs
    └── release.yml.bak  # Automated releases on main

.husky/              # Git hooks
├── commit-msg       # Conventional commits validation
├── pre-commit       # Lint staged files
└── pre-push         # Build + auto-release (configurable)

Configuration:
├── .release-config.json  # Release automation settings
├── .husky-config.json    # Git hooks behavior
└── commitlint.config.js  # Commit message rules
```

## Configuration

### Release Configuration (`.release-config.json`)

Control automated releases per branch:

```json
{
  "branches": {
    "main": {
      "autoRelease": true, // Auto-release on push
      "releaseType": "auto", // auto, major, minor, patch
      "pushTag": true // Push tags to remote
    },
    "develop": {
      "autoRelease": false, // No auto-release
      "releaseType": "prerelease"
    },
    "feature/*": {
      "autoRelease": false // No release on feature branches
    }
  }
}
```

#### Test Configuration

Control which test suites run in git hooks (granular per suite, per branch):

```json
{
  "hooks": {
    "pre-commit": {
      "tests": {
        "unit": false, // Fast: ~5s, parallel
        "integration": false, // Medium: ~30s, requires DB
        "e2e": false // Slow: ~60s, full stack
      }
    },
    "pre-push": {
      "tests": {
        "unit": false,
        "integration": false,
        "e2e": false
      },
      "branches": {
        "main": {
          "tests": {
            "unit": true, // Override: always test on main
            "integration": true
          }
        }
      }
    }
  },
  "testSuites": {
    "unit": {
      "command": "npm test",
      "timeout": "5s",
      "parallel": true,
      "requiresDb": false
    },
    "integration": {
      "command": "npm run test:integration",
      "timeout": "30s",
      "parallel": false,
      "requiresDb": true
    },
    "e2e": {
      "command": "npm run test:e2e",
      "timeout": "60s",
      "parallel": false,
      "requiresDb": true
    }
  }
}
```

**Best Practice (TBD + CI/CD)**:

- Keep tests **disabled** in hooks (fast feedback <10s)
- Run full test suite in CI pipeline
- Enable locally only if no CI available

**Configuration Guidelines**:

- `unit`: Enable for critical projects without CI (5s impact)
- `integration`: Rarely needed in hooks (requires DB, 30s)
- `e2e`: Never in hooks (too slow, use CI)
- Branch overrides: Stricter checks on `main`, relaxed on feature branches

#### Known Gap: Auto-Release and Tests

When `autoRelease` is enabled in `.release-config.json`, the release process **bypasses pre-push tests** (sets `SKIP_PRE_PUSH_HOOK=true`). This is intentional to prevent circular dependencies, but creates a gap:

- **Local workflow**: Auto-release → skips tests → creates tag → pushes
- **Recommended**: Enable tests in CI/CD pipeline before merge to `main`
- **Alternative**: Run `npm run release:suggest` first to preview changes, then manually test before actual release

**Test Strategies by Branch:**

- **`main/master`**: No tests in hooks (CI/CD handles everything)
- **`develop`**: Unit + Integration tests on push
- **`feature/*`**: Skip all hooks (fast iteration)
- **Custom**: Configure per your workflow needs

### Release Configuration

Control semantic versioning and automated releases:

```json
{
  "enabled": true,
  "branches": {
    "main": {
      "autoRelease": true,
      "releaseType": "auto",
      "runBuild": true,
      "pushTag": true
    },
    "develop": {
      "autoRelease": false
    },
    "feature/*": {
      "autoRelease": false
    }
  },
  "versioning": {
    "strategy": "semver",
    "syncLockFile": true
  },
  "git": {
    "tagPrefix": "v",
    "remoteName": "origin"
  }
}
```

#### Advisory: Test Before Auto-Release

Before enabling `autoRelease: true` on a branch:

1. Run `npm run release:suggest` to preview version bump
2. Ensure CI/CD pipeline runs full test suite before merge
3. Consider enabling `pre-push.tests` in `.husky-config.json` for additional safety
4. Verify rollback strategy if release fails mid-process

**Release Workflow**:

1. Commit semantic changes (`feat:`, `fix:`, `BREAKING CHANGE:`)
2. Push to configured branch
3. Auto-release analyzes commits → calculates version
4. Updates `package.json`, `package-lock.json`, `CHANGELOG.md`
5. Creates git tag `v{version}`
6. Pushes tag to remote
7. CI/CD (if configured) handles deployment

**Manual Release Commands**:

- `npm run release:suggest` - Preview what would be released (dry-run)
- `npm run release` - Manual trigger (respects config)
- `npm run release:patch` - Force patch bump (0.0.X)
- `npm run release:minor` - Force minor bump (0.X.0)
- `npm run release:major` - Force major bump (X.0.0)

### Branch Strategies

- **`main/master`**: Auto-release enabled, full CI/CD
- **`develop`**: Build only, no releases
- **`feature/*`**: Skip hooks, tests in CI only
- **`fix/*`**: Skip hooks, fast iteration

## File Structure

```text
src/
├── common/          # Shared utilities, filters, interceptors
├── config/          # Configuration and env validation
├── health/          # Health check endpoints
├── swagger/         # API documentation setup
└── main.ts          # Application bootstrap
```

## Scripts Reference

| Script                          | Purpose                              | DB Required |
| ------------------------------- | ------------------------------------ | ----------- |
| `npm run verify`                | Check project health                 | No          |
| `npm run verify:full`           | Full health + coverage + analyze     | No          |
| `npm run ci`                    | CI/CD pipeline simulation            | No          |
| `npm test`                      | Run unit tests                       | No          |
| `npm run test:integration`      | Run integration tests                | Yes         |
| `npm run test:integration:safe` | Safe integration tests (with guards) | Yes         |
| `npm run test:e2e`              | Run e2e tests                        | Yes         |
| `npm run test:e2e:safe`         | Safe e2e tests (with guards)         | Yes         |
| `npm run quality`               | Check code quality                   | No          |
| `npm run quality:fix`           | Fix code quality issues              | No          |
| `npm run analyze`               | Analyze cognitive complexity         | No          |
| `npm run analyze:report`        | Generate complexity report           | No          |
| `npm run build`                 | Build production bundle              | No          |
| `npm run release:suggest`       | Preview next release version         | No          |

## Code Quality Analysis

Analyze cognitive complexity and code quality metrics using ESLint with SonarJS:

```bash
# Analyze all complexity issues
npm run analyze

# Specific analyses
npm run analyze:cognitive     # Cognitive complexity only
npm run analyze:cyclomatic    # Cyclomatic complexity only
npm run analyze:functions     # Long functions only
npm run analyze:security      # Security issues only

# Generate JSON report
npm run analyze:report        # Saves to reports/complexity-report.json
```

### Complexity Thresholds

Current project thresholds (configured in `eslint.config.mjs`):

- **Cognitive Complexity**: 10 (max mental effort to understand code)
- **Cyclomatic Complexity**: 10 (max independent code paths)
- **Function Length**: 50 lines (excluding comments/blank lines)
- **Max Parameters**: 4 (SOLID principle compliance)
- **Max Nesting Depth**: 3 (avoid deep nesting)

### Refactoring Strategies

When analysis reports violations:

1. **Extract Method**: Break complex functions into smaller, focused ones
2. **Early Returns**: Reduce nesting with guard clauses
3. **Configuration Objects**: Replace multiple parameters with config objects
4. **Strategy Pattern**: Replace complex conditionals with polymorphism

Example:

```typescript
// Before: Cognitive complexity = 15
function processUser(user: User) {
  if (user.isActive) {
    if (user.hasPermissions) {
      if (user.isVerified) {
        // complex logic...
      }
    }
  }
}

// After: Cognitive complexity = 3
function processUser(user: User) {
  if (!isEligibleUser(user)) return;
  handleUserProcessing(user);
}

function isEligibleUser(user: User): boolean {
  return user.isActive && user.hasPermissions && user.isVerified;
}
```

### CI/CD Integration

Add to your workflow:

```yaml
- name: Analyze Code Quality
  run: npm run analyze:report
- name: Upload Report
  uses: actions/upload-artifact@v3
  with:
    name: complexity-report
    path: reports/complexity-report.json
```

## Environment Setup

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

Required variables are validated at startup using Joi schema.

## Git Workflow

This project uses:

- **Conventional Commits** for commit messages
- **Husky** for git hooks (pre-commit, pre-push)
- **lint-staged** for staged files validation
- **Automated releases** based on commit types

```text
# Commit format
<type>(<scope>): <description>

# Examples
feat(auth): add JWT token refresh
fix(health): resolve database connection check
docs(readme): update installation instructions
```

## License

UNLICENSED

# Project Backlog

> **Note**: This file tracks bugs, improvements, and future work discovered during development.
> Items here should eventually move to GitHub Issues or be converted to TASK-XXX.md files.

## 🐛 Bugs

### BUG-001: auto-release.js dry-run modifies files

- **Status**: ✅ **RESOLVED** (v0.2.0)
- **Priority**: Medium
- **Discovered**: 2025-11-15
- **Resolved**: 2025-11-15
- **Description**: Running `npm run release:suggest` (with `--dry-run` flag) actually modifies `package.json` and `package-lock.json` instead of just previewing changes.
- **Root Cause**: Missing `--dry-run` flag propagation to version-calculator.js in auto-release.js line 376
- **Fix Applied**: Added `--dry-run` flag to execCommand when calling version-calculator.js
- **Verification**: MD5 checksums of package.json and package-lock.json remain identical before/after dry-run execution
- **Commit**: Included in v0.2.0 release (commit cb50cba)

## 🔧 Technical Debt

### DEBT-001: Missing /docs/project structure

- **Status**: In Progress
- **Priority**: Low
- **Description**: Project lacks formal documentation structure per copilot-instructions
- **Required Structure**:

  ```text
  /docs/
  ├── dev/           # .gitignored, agent session notes
  └── project/       # Version controlled
      ├── ROADMAP.md
      ├── BACKLOG.md (this file)
      ├── EPIC-XXX.md
      ├── STORY-XXX.md
      └── TASK-XXX.md
  ```

## 💡 Improvements

### IMPROVE-001: Add CHANGELOG.md generation

- **Status**: Not Started
- **Priority**: Medium
- **Description**: auto-release.js references changelog generation but CHANGELOG.md doesn't exist
- **Details**:
  - Script says "Would execute: npm run release:changelog"
  - No `release:changelog` script in package.json
  - Need conventional-changelog integration
- **Acceptance Criteria**:
  - [ ] Add CHANGELOG.md template
  - [ ] Create `release:changelog` script
  - [ ] Integrate with auto-release.js
  - [ ] Follow Keep a Changelog format

### IMPROVE-002: CI/CD GitHub Actions activation

- **Status**: Blocked (no GitHub credits)
- **Priority**: High (when unblocked)
- **Description**: Workflows exist as .bak templates but not active
- **Files**:
  - `.github/workflows/ci.yml.bak`
  - `.github/workflows/release.yml.bak`
- **Next Steps**:
  - Rename .bak → .yml when GitHub credits available
  - Test workflows in CI environment
  - Verify test suite runs in GitHub Actions

## 📋 Future Features

### FEATURE-001: Integration test Docker orchestration

- **Status**: Not Started
- **Priority**: Low
- **Description**: Improve test:integration:safe with better Docker health checks
- **Details**: Current implementation checks container, could add connection pooling validation

### FEATURE-002: E2E test coverage reporting

- **Status**: Not Started
- **Priority**: Low
- **Description**: E2E tests don't generate coverage reports (by design, but could be optional)

## 🎯 Roadmap Items (Future)

- [ ] Add ROADMAP.md with quarterly goals
- [ ] Define EPIC-001: Production deployment strategy
- [ ] Define STORY-001: Monitoring and observability setup
- [ ] Add security scanning (Snyk, Dependabot)

## 🛠️ Compatibility / Deprecations

### HUSKY-001: Husky v10 compatibility (DEPRECATED lines)

- **Status**: Open
- **Priority**: Low
- **Discovered**: 2025-11-15
- **Description**: Older Husky hook scripts often include the following two lines at the top of hook files:

  ```sh
  #!/usr/bin/env sh
  . "$(dirname -- "$0")/_/husky.sh"
  ```

- **Problem**: These lines will fail under Husky v10.0.0 and newer in certain environments. The project should remove them from hook files that rely on the new Husky behaviour.
- **Files Affected**: `.husky/commit-msg` (and possibly other hooks copied from older templates)
- **Recommended Change**:
  - Remove the two lines shown above from the top of `.husky/commit-msg` and other hook files.
  - Ensure hook scripts remain executable and call tools (like `npx --no-install commitlint`) directly.
  - Prefer the modern Husky installation/setup method documented by the Husky project.
- **Acceptance Criteria**:
  - [ ] `.husky/commit-msg` no longer contains the deprecated shebang and souring lines
  - [ ] Hooks still execute correctly on developers' machines
  - [ ] Add a short note in `CONTRIBUTING.md` about Husky version expectations
- **Workaround**: If a developer has an older environment, use a local script wrapper or pin Husky to a compatible version in the local environment (not recommended long-term).

- [ ] Performance benchmarking baseline

---

**Last Updated**: 2025-11-15
**Maintained By**: Development Team

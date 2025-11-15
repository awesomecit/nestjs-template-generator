# Project Backlog

> **Note**: This file tracks bugs, improvements, and future work discovered during development.
> Items here should eventually move to GitHub Issues or be converted to TASK-XXX.md files.

## 🐛 Bugs

### BUG-001: auto-release.js dry-run modifies files

- **Status**: Open
- **Priority**: Medium
- **Discovered**: 2025-11-15
- **Description**: Running `npm run release:suggest` (with `--dry-run` flag) actually modifies `package.json` and `package-lock.json` instead of just previewing changes.
- **Expected**: Dry-run should NOT modify any files
- **Actual**: Files are modified, requiring git restore or committing
- **Impact**: Confusing UX, potentially dangerous if user expects no side effects
- **Location**: `scripts/auto-release.js`
- **Workaround**: Use `git restore package.json package-lock.json` after dry-run
- **Fix Required**:
  - Store modifications in memory during dry-run
  - Print preview to console
  - Only write to disk when `--dry-run` is NOT set

## 🔧 Technical Debt

### DEBT-001: Missing /docs/project structure

- **Status**: In Progress
- **Priority**: Low
- **Description**: Project lacks formal documentation structure per copilot-instructions
- **Required Structure**:
  ```
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
- [ ] Performance benchmarking baseline

---

**Last Updated**: 2025-11-15
**Maintained By**: Development Team

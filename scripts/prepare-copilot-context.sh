#!/bin/bash
set -euo pipefail

# ==============================================================================
# Copilot Context Preparation Script
# ==============================================================================
# Genera un file di contesto compatto (~500-1000 token) con tutte le info
# necessarie per iniziare una sessione di debug/development con Copilot.
#
# Usage:
#   ./scripts/prepare-copilot-context.sh [optional-issue-description]
#   
# Output:
#   /tmp/copilot-context-$(date +%Y%m%d-%H%M%S).md
# ==============================================================================

OUTPUT_FILE="${1:-/tmp/copilot-context-$(date +%Y%m%d-%H%M%S).md}"
ISSUE_DESC="${2:-[DESCRIVI IL PROBLEMA QUI]}"

echo "📝 Generating Copilot context..."

cat > "$OUTPUT_FILE" << 'CONTEXT_START'
# Copilot Session Context
> Generated: $(date -Iseconds)
> Project: $(jq -r '.name' package.json) v$(jq -r '.version' package.json)

---

## 🔧 PROJECT SNAPSHOT

**Stack:**
- Runtime: Node $(jq -r '.engines.node' package.json 2>/dev/null || echo "N/A")
- Language: TypeScript $(jq -r '.devDependencies.typescript' package.json 2>/dev/null || echo "N/A")
- Framework: NestJS $(jq -r '.dependencies."@nestjs/core"' package.json 2>/dev/null || echo "N/A")
- Test Runner: Jest $(jq -r '.devDependencies.jest' package.json 2>/dev/null || echo "N/A")
- Package Manager: $([ -f "pnpm-lock.yaml" ] && echo "pnpm" || [ -f "yarn.lock" ] && echo "yarn" || echo "npm")

**Repository State:**
- Branch: $(git branch --show-current)
- Last Commit: $(git log -1 --format='%h - %s (%cr)')
- Sync Status: $(git status -sb | head -1)
- Uncommitted: $(git status --porcelain | wc -l) files

---

## 🐛 ISSUE DESCRIPTION

**Problem:**
$ISSUE_DESC

**Reproduction:**
\`\`\`bash
# [Aggiungi comando che riproduce il problema]
# Esempio: npm run release:suggest
\`\`\`

**Expected Behavior:**
[Descrivi cosa dovrebbe accadere]

**Actual Behavior:**
[Descrivi cosa accade invece]

---

## 📊 RECENT CHANGES (Last 7 Commits)

\`\`\`
$(git log --oneline --graph --decorate -7)
\`\`\`

**Modified Files (if any):**
\`\`\`
$(git status --porcelain)
\`\`\`

**Uncommitted Diff Summary:**
\`\`\`
$(git diff --stat 2>/dev/null || echo "Working tree clean")
\`\`\`

---

## 🔍 RELEVANT CONFIGURATION

**Release Config (.release-config.json):**
\`\`\`json
$(cat .release-config.json 2>/dev/null | jq -c 'del(._advisory)' || echo "N/A")
\`\`\`

**Jest Coverage Thresholds:**
\`\`\`javascript
$(sed -n '/coverageThreshold:/,/^  },/p' jest.config.js 2>/dev/null | head -20 || echo "N/A")
\`\`\`

**Husky Hooks Status:**
\`\`\`
$(ls -la .husky/ 2>/dev/null | grep -v '^d' | awk '{print $9, $10, $11}' || echo "N/A")
\`\`\`

**NPM Scripts (relevant):**
\`\`\`json
$(jq -r '.scripts | to_entries[] | select(.key | test("test|release|build|lint")) | "\(.key): \(.value)"' package.json)
\`\`\`

---

## 🧪 PRE-ANALYSIS (Local Investigation)

**File Writes in Scripts:**
\`\`\`
$(grep -rn "writeFileSync\|writeFile\|appendFile\|copyFileSync" scripts/ --include="*.js" 2>/dev/null | head -20 || echo "No writes found")
\`\`\`

**Dry-Run Guards:**
\`\`\`
$(grep -rn "dryRun\|dry-run" scripts/ --include="*.js" 2>/dev/null | grep -E "if.*dryRun|--dry-run" | head -15 || echo "No guards found")
\`\`\`

**External Script Invocations:**
\`\`\`
$(grep -rn "execCommand.*\.js\|execSync.*\.js" scripts/ --include="*.js" 2>/dev/null | head -15 || echo "None found")
\`\`\`

---

## 💡 HYPOTHESIS & DEBUG TRAIL

**Initial Hypothesis:**
- [ ] [La tua ipotesi principale]
- [ ] [Ipotesi alternativa 1]
- [ ] [Ipotesi alternativa 2]

**Already Verified:**
- ✅ [Cosa hai già controllato che funziona]
- ❌ [Cosa hai controllato che NON funziona]
- ⏭️  [Cosa NON hai ancora verificato]

**Suspected Files:**
1. \`path/to/file1.js:lineNumber\` - [motivo]
2. \`path/to/file2.js:lineNumber\` - [motivo]

---

## 📋 QUICK COMMANDS (Copy-Paste)

\`\`\`bash
# Verify current state
git status --porcelain
npm run verify

# Run tests
npm test

# Dry-run release
npm run release:suggest

# Check last release
git describe --tags --abbrev=0
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Restore if needed
git restore package.json package-lock.json
\`\`\`

---

## 📖 PROJECT DOCUMENTATION LINKS

- BACKLOG: \`docs/project/BACKLOG.md\`
- CONTRIBUTING: \`CONTRIBUTING.md\`
- ROADMAP: \`docs/project/ROADMAP.md\` (if exists)

**Open Issues in BACKLOG:**
\`\`\`
$(grep -A 5 "Status.*Open" docs/project/BACKLOG.md 2>/dev/null | head -30 || echo "No BACKLOG.md found")
\`\`\`

---

## 🎯 SESSION GOALS

**Primary Objective:**
[Cosa vuoi ottenere da questa sessione]

**Success Criteria:**
- [ ] [Criterio 1]
- [ ] [Criterio 2]
- [ ] [Criterio 3]

**Out of Scope:**
- [Cosa NON vuoi affrontare ora]

---

## 📎 ATTACHMENTS (if needed)

**Error Output:**
\`\`\`
[Incolla l'output dell'errore qui - max 50 righe]
\`\`\`

**Relevant Code Snippet:**
\`\`\`typescript
[Incolla codice rilevante - max 30 righe]
\`\`\`

---

**🤖 Ready to paste into Copilot Chat**

CONTEXT_START

# Replace template variables
sed -i "s|\$ISSUE_DESC|$ISSUE_DESC|g" "$OUTPUT_FILE"
sed -i "s|\$(date -Iseconds)|$(date -Iseconds)|g" "$OUTPUT_FILE"
sed -i "s|\$(jq -r '.name' package.json)|$(jq -r '.name' package.json)|g" "$OUTPUT_FILE"
sed -i "s|\$(jq -r '.version' package.json)|$(jq -r '.version' package.json)|g" "$OUTPUT_FILE"
sed -i "s|\$(jq -r '.engines.node' package.json 2>/dev/null \|\| echo \"N/A\")|$(jq -r '.engines.node' package.json 2>/dev/null || echo "N/A")|g" "$OUTPUT_FILE"
sed -i "s|\$(jq -r '.devDependencies.typescript' package.json 2>/dev/null \|\| echo \"N/A\")|$(jq -r '.devDependencies.typescript' package.json 2>/dev/null || echo "N/A")|g" "$OUTPUT_FILE"
sed -i "s|\$(jq -r '.dependencies.\"@nestjs/core\"' package.json 2>/dev/null \|\| echo \"N/A\")|$(jq -r '.dependencies."@nestjs/core"' package.json 2>/dev/null || echo "N/A")|g" "$OUTPUT_FILE"
sed -i "s|\$(jq -r '.devDependencies.jest' package.json 2>/dev/null \|\| echo \"N/A\")|$(jq -r '.devDependencies.jest' package.json 2>/dev/null || echo "N/A")|g" "$OUTPUT_FILE"

# Execute shell commands embedded in the template
while IFS= read -r line; do
  if [[ $line =~ \$\(([^)]+)\) ]]; then
    cmd="${BASH_REMATCH[1]}"
    result=$(eval "$cmd" 2>/dev/null || echo "N/A")
    echo "${line//\$($cmd)/$result}"
  else
    echo "$line"
  fi
done < "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

echo "✅ Context generated: $OUTPUT_FILE"
echo ""
echo "📋 File size: $(wc -c < "$OUTPUT_FILE") bytes (~$(wc -c < "$OUTPUT_FILE" | awk '{print int($1/4)}') tokens)"
echo ""
echo "🚀 Next steps:"
echo "   1. Edit the file to add specific issue details"
echo "   2. Copy-paste the entire content into Copilot Chat"
echo "   3. Start your debug session!"
echo ""
echo "💡 Tip: cat $OUTPUT_FILE | pbcopy  # (macOS) or xclip -sel clip (Linux)"

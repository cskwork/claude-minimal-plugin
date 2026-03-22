# Use a Workflow from the Library

## Context
Apply a role-specific workflow (developer, manager, designer, marketer) to the current project or globally. A workflow bundles CLAUDE.md, settings.json, and a curated set of skills/agents/MCPs for a specific role.

## Input
The user provides a workflow name (e.g., `developer`, `manager`, `designer`, `marketer`).
Optionally: `--global` to apply to all projects.

## Steps

### 1. Sync the Library Repo
Pull the latest catalog before reading:
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Find the Workflow
- Read `library.yaml`
- Search `library.workflows` by name (exact match)
- If no match, list available workflows and ask the user to pick one
- If no workflows section exists, tell the user no workflows are available

### 3. Read Workflow Files
The workflow directory contains:
```
workflow/<name>/
  CLAUDE.md        # Role-specific system prompt
  settings.json    # MCP servers + permissions
  manifest.yaml    # Included skills/agents/commands
  README.md        # Usage guide (Korean)
```

Read all files from `<LIBRARY_SKILL_DIR>/workflow/<name>/`.

### 4. Check for Existing Configuration
Before copying, check if the target already has configuration files:

```bash
# Project-level
ls .claude/CLAUDE.md .claude/settings.local.json 2>/dev/null

# Global-level (if --global)
ls ~/.claude/CLAUDE.md ~/.claude/settings.json 2>/dev/null
```

If existing files are found:
- **AskUserQuestion** with options:
  - A) **Merge** — append workflow CLAUDE.md content to existing, merge settings.json mcpServers and permissions
  - B) **Replace** — overwrite existing files with workflow files
  - C) **Cancel** — abort without changes

### 5. Determine Target and Copy

**Project-level (default):**
```bash
# Ensure .claude/ directory exists
mkdir -p .claude

# Copy CLAUDE.md
cp <LIBRARY_SKILL_DIR>/workflow/<name>/CLAUDE.md .claude/CLAUDE.md

# Copy settings as settings.local.json (project-level)
cp <LIBRARY_SKILL_DIR>/workflow/<name>/settings.json .claude/settings.local.json
```

**Global-level (--global):**
```bash
# Copy CLAUDE.md
cp <LIBRARY_SKILL_DIR>/workflow/<name>/CLAUDE.md ~/.claude/CLAUDE.md

# Copy settings as settings.json (global-level)
cp <LIBRARY_SKILL_DIR>/workflow/<name>/settings.json ~/.claude/settings.json
```

### 6. Handle Merge (if user chose Merge)

**For CLAUDE.md:**
- Read existing CLAUDE.md
- Append a separator and the workflow content:
  ```markdown

  ---
  <!-- Workflow: <name> (added by /library workflow-use) -->

  <workflow CLAUDE.md content here>
  ```

**For settings.json:**
- Read existing settings JSON
- Merge `mcpServers` objects (workflow entries added, existing preserved)
- Merge `permissions.allow` arrays (deduplicate)
- Write back the merged JSON using Python for safety:
  ```bash
  python3 -c "
  import json
  existing = json.load(open('<target_settings>'))
  workflow = json.load(open('<workflow_settings>'))
  # Merge mcpServers
  existing.setdefault('mcpServers', {}).update(workflow.get('mcpServers', {}))
  # Merge permissions
  existing_allow = set(existing.get('permissions', {}).get('allow', []))
  workflow_allow = set(workflow.get('permissions', {}).get('allow', []))
  existing.setdefault('permissions', {})['allow'] = sorted(existing_allow | workflow_allow)
  json.dump(existing, open('<target_settings>', 'w'), indent=2)
  "
  ```

### 7. Resolve Secret Placeholders
Scan the copied settings.json for `{{PLACEHOLDER}}` patterns:
- For each placeholder found, **AskUserQuestion** for the actual value
- Replace the placeholder with the provided value
- If user skips, leave placeholder as-is and warn them to fill it later

### 8. Install Referenced Skills (Optional)
Read `manifest.yaml` from the workflow and ask the user:
- "이 워크플로우에 포함된 스킬을 설치할까요?"
- If yes: for each skill in `manifest.yaml`, run `/library use <skill_name>`
- If no: skip (user can install later with `/library use`)

### 9. Verify Installation
- Confirm target CLAUDE.md exists and contains workflow content
- Confirm target settings.json exists and is valid JSON
- Report which MCP servers were configured
- Report any placeholders that still need to be filled

### 10. Confirm
Tell the user:
- Which workflow was applied and where (project vs global)
- Whether files were merged or replaced
- List of MCP servers configured
- Any remaining setup needed (API keys, tool installations)
- Tip: "각 워크플로우의 README.md에서 상세 사용법을 확인하세요"

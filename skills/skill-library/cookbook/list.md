# List Available Skills

## Context
Show the full library catalog with install status.

## Steps

### 1. Sync the Library Repo
Pull the latest catalog before reading:
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Read the Catalog
- Read `library.yaml`
- Parse all entries from `library.skills`, `library.agents`, `library.prompts`, and `library.tools`

### 3. Check Install Status
For each entry:
- Determine the type (skill, agent, prompt, or tool) and corresponding default/global directories from `default_dirs`
- Check if a directory matching the entry name exists in the **default** directory
- Check if a directory matching the entry name exists in the **global** directory
- For skills with `scope: global`, additionally check:
  - `~/.codex/skills/<name>/`
  - `~/.gemini/skills/<name>/`
  - `~/.gsd/agent/skills/<name>/`
- Search recursively for name matches
- Mark as: `installed (default)`, `installed (global)`, or `not installed`

### 4. Display Results

Format the output as a table grouped by type:

```
## Skills
| Name | Scope | Description | Status |
|------|-------|-------------|--------|
| commit | global | Create a git commit | installed (claude,codex,gemini,gsd) |
| cert-study | project | 자격증 시험 공부 자료 | not installed |

## Agents
| Name | Description | Status |
|------|-------------|--------|
| agent-name | agent-description | installed (global) |

## Prompts
| Name | Description | Status |
|------|-------------|--------|
| prompt-name | prompt-description | not installed |

## Tools
| Name | Description | Status |
|------|-------------|--------|
| tool-name | tool-description | installed (default) |
```

- Skills 테이블에는 `Scope` 컬럼을 포함한다 (`project` 또는 `global`)
- `scope: global` 스킬은 각 타겟별 설치 상태를 표시한다 (claude, codex, gemini, gsd)
- If a section is empty, show: `No <type> in catalog.`

### 5. Summary
At the bottom, show:
- Total entries in catalog
- Total installed locally
- Total not installed

Run `/library mcp-list` to see MCP servers.

# List Available Workflows

## Context
Show all available workflows from the library catalog with their descriptions and status.

## Input
No input required.

## Steps

### 1. Sync the Library Repo
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Read Workflows
- Read `library.yaml`
- Find the `library.workflows` section
- If no workflows section exists, tell user "No workflows available"

### 3. Check Install Status
For each workflow, check if it's currently applied:

**Project-level:**
```bash
# Check if CLAUDE.md contains workflow marker
grep -l "Workflow: <name>" .claude/CLAUDE.md 2>/dev/null
```

**Global-level:**
```bash
grep -l "Workflow: <name>" ~/.claude/CLAUDE.md 2>/dev/null
```

### 4. Display Table
Show a formatted table:

```
Available Workflows:

| Name       | Description                          | Based On            | Status   |
|------------|--------------------------------------|---------------------|----------|
| developer  | Superpowers 기반 개발자 워크플로우    | obra/superpowers     | applied  |
| manager    | gstack 기반 매니저 워크플로우         | garrytan/gstack      | -        |
| designer   | Impeccable 기반 디자이너 워크플로우   | pbakaus/impeccable   | -        |
| marketer   | 콘텐츠 마케터 워크플로우              | library              | -        |

Use `/library workflow-use <name>` to apply a workflow.
Use `/library workflow-use <name> --global` to apply globally.
```

### 5. Show Details (if user asks)
If the user asks about a specific workflow, read and display its README.md:
```bash
cat <LIBRARY_SKILL_DIR>/workflow/<name>/README.md
```

# Add an MCP Server to the Library Catalog

## Context
Register a new MCP server configuration in the library catalog. MCP servers are stored in `library.yaml` under `library.mcps`, not as files.

## Input
The user provides MCP server details directly, or asks to capture an existing entry from `~/.claude.json`.

## Steps

### 1. Sync the Library Repo
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Gather MCP Server Details
If the user provides details directly, collect:
- **name**: unique identifier (lowercase, hyphens allowed)
- **description**: one-line description of what the MCP does
- **type**: `stdio` or `http`
- **config**: the full MCP config object (type, command/url, args, env, headers)

If the user says "capture from config" or references an existing MCP:
- Read `~/.claude.json`
- Parse `mcpServers` object
- Find the specified server entry
- Extract its config

### 3. Detect and Replace Secrets
Scan all config values (including nested `env` and `headers`) for sensitive data:
- **Auto-detect keys**: any field name containing `key`, `token`, `secret`, `password`, `credential`, or `auth` (case-insensitive)
- **Replace pattern**: replace the actual value with `{{UPPER_SNAKE_CASE_FIELD_NAME}}`
  - Example: `GEMINI_API_KEY: "ai-abc123"` → `GEMINI_API_KEY: "{{GEMINI_API_KEY}}"`
- **Show the user** what was replaced and confirm before proceeding
- If a value is already a `{{PLACEHOLDER}}`, keep it as-is

### 4. Validate Entry
- Confirm `name` is unique in `library.mcps`
- Confirm `type` is `stdio` or `http`
- For `stdio`: config must have `command`
- For `http`: config must have `url`

### 5. Add to library.yaml
Read `library.yaml`, add the new entry under `library.mcps` in **alphabetical order** by name:

```yaml
- name: <name>
  description: <description>
  type: <stdio|http>
  config:
    # full config object
```

**YAML formatting rules:**
- 4-space indentation under `library.mcps` (matches existing sections)
- List items use `- ` prefix
- Keep entries alphabetically sorted by name

### 6. Commit and Push
```bash
cd <LIBRARY_SKILL_DIR>
git add library.yaml
git commit -m "library: added mcp <name>"
git push
```

### 7. Confirm
Tell the user:
- The MCP server has been added to the catalog
- Any secrets that were replaced with placeholders
- They can install it with `/library mcp-use <name>`

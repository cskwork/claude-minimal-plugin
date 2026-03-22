# Install an MCP Server from the Library Catalog

## Context
Install an MCP server from the catalog into `~/.claude.json`'s `mcpServers` object. Handles secret placeholder resolution and safe JSON modification.

## Input
The user provides an MCP server name from the catalog.

## Steps

### 1. Sync the Library Repo
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Find the Entry
- Read `library.yaml`
- Search `library.mcps` for a matching name (exact or fuzzy)
- If no match, tell the user and suggest `/library mcp-list`
- If multiple matches, show them and ask the user to pick one

### 3. Check Existing Installation
- Read `~/.claude.json`
- Check if `mcpServers.<name>` already exists
- If it does, show the existing config and ask: "**<name>** is already installed. Overwrite?"
- If the user declines, abort

### 4. Resolve Secret Placeholders
For each `{{VARIABLE_NAME}}` placeholder found in the config:
1. Check if an environment variable with that name is already set: `echo $VARIABLE_NAME`
2. If set, offer to use the existing value
3. If not set, ask the user to provide the value
4. Replace the placeholder with the actual value in the config

Show a summary of all resolved values (masked) before proceeding.

### 5. Backup ~/.claude.json
```bash
cp ~/.claude.json ~/.claude.json.bak
```

### 6. Write to ~/.claude.json
Use `python3` for safe JSON round-trip (**never** edit JSON as text):

```bash
python3 -c "
import json, sys

config_path = '$HOME/.claude.json'
with open(config_path, 'r') as f:
    data = json.load(f)

if 'mcpServers' not in data:
    data['mcpServers'] = {}

data['mcpServers']['<name>'] = <config_json>

with open(config_path, 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')
"
```

### 7. Validate JSON
```bash
python3 -c "import json; json.load(open('$HOME/.claude.json'))"
```
If validation fails:
- Restore from backup: `cp ~/.claude.json.bak ~/.claude.json`
- Report the error and abort

### 8. Confirm
Tell the user:
- The MCP server **<name>** has been installed
- Config location: `~/.claude.json` → `mcpServers.<name>`
- **Restart Claude Code** to activate the new MCP server
- Backup is available at `~/.claude.json.bak`

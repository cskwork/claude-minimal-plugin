# Remove an MCP Server

## Context
Remove an MCP server from `~/.claude.json`. By default, the catalog (`library.yaml`) is NOT modified — it serves as a reference of available items. Only remove from the catalog if the user explicitly requests it.

## Input
The user provides an MCP server name.

## Steps

### 1. Find the Entry
- Read `~/.claude.json` and check `mcpServers` for the name
- If not found in `~/.claude.json`, abort with message: "**<name>** is not installed in `~/.claude.json`"

### 2. Remove from ~/.claude.json

#### 5a. Backup
```bash
cp ~/.claude.json ~/.claude.json.bak
```

#### 5b. Remove via python3
```bash
python3 -c "
import json

config_path = '$HOME/.claude.json'
with open(config_path, 'r') as f:
    data = json.load(f)

if 'mcpServers' in data and '<name>' in data['mcpServers']:
    del data['mcpServers']['<name>']

with open(config_path, 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')
"
```

#### 5c. Validate JSON
```bash
python3 -c "import json; json.load(open('$HOME/.claude.json'))"
```
If validation fails, restore from backup and abort.

### 3. (Optional) Remove from library.yaml — only if user explicitly requests
If the user explicitly asks to also remove from the catalog:
1. Sync the library repo: `cd <LIBRARY_SKILL_DIR> && git pull`
2. Read `library.yaml` and remove the entry from `library.mcps`
3. Write back the file
4. Commit and push:
```bash
cd <LIBRARY_SKILL_DIR>
git add library.yaml
git commit -m "library: removed mcp <name>"
git push
```

### 4. Confirm
Tell the user:
- **<name>** removed from `~/.claude.json`
- **Restart Claude Code** to apply changes
- Backup available at `~/.claude.json.bak`
- Catalog entry in `library.yaml` is preserved (can re-install with `/library mcp-use <name>`)

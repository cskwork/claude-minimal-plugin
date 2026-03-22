# List MCP Servers

## Context
Show all MCP servers from the catalog and `~/.claude.json` with install status.

## Steps

### 1. Sync the Library Repo
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Read Sources
- Read `library.yaml` and parse `library.mcps`
- Read `~/.claude.json` and parse `mcpServers`

### 3. Build Cataloged MCPs Table
For each entry in `library.mcps`:
- Check if a matching key exists in `mcpServers` from `~/.claude.json`
- Mark status: `installed` or `not installed`

Display as:
```
## Cataloged MCP Servers
| Name | Description | Type | Status |
|------|-------------|------|--------|
| context7 | Up-to-date library documentation lookup | http | installed |
| svgmaker | SVG generation via SVGMaker API | stdio | not installed |
```

### 4. Build Uncataloged MCPs Table
Find MCP servers in `~/.claude.json` that are NOT in `library.mcps`:

```
## Uncataloged MCP Servers (in config but not in catalog)
| Name | Type | Command/URL |
|------|------|-------------|
| my-custom-mcp | stdio | npx my-custom-mcp |
```

If none, show: "All configured MCP servers are in the catalog."

### 5. Summary
```
Total cataloged: X (Y installed, Z not installed)
Uncataloged in config: N
```

### 6. Next Actions
Suggest relevant actions:
- "Run `/library mcp-use <name>` to install a cataloged MCP server."
- "Run `/library mcp-add` to add an uncataloged MCP to the catalog."
- "Run `/library mcp-remove <name>` to remove an MCP server."
- "Run `/library list` to see skills, agents, prompts, and tools."

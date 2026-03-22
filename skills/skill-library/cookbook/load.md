# Load a Skill into Current Session (Temporary)

## Context
Read a skill, agent, or prompt from cold storage into the current session context without installing it to the hot path. The content is available only for the duration of this session.

Unlike `/library use` which copies files to `~/.claude/skills/` or `~/.claude/agents/` (permanent install), `/library load` reads the file content directly into context (temporary, session-only).

## Input
The user provides a name. Optionally: `--type agent|skill|prompt`.

## Steps

### 1. Find the Entry
- Read `library.yaml`
- Search across `library.skills`, `library.agents`, `library.prompts`
- Match by name (exact) or description (fuzzy/keyword match)
- If multiple matches, show them and ask the user to pick one

### 2. Locate the File

**If `local_path` exists in the entry:**
- Use `local_path` directly (resolve `~` to home directory)
- For agents: read `<local_path>` (the .md file)
- For skills: read `<local_path>/SKILL.md`
- For prompts: read `<local_path>` (the .md file)

**If `local_path` does not exist:**
- Check if the item exists in the hot path (`~/.claude/agents/`, `~/.claude/skills/`, `~/.claude/commands/`)
- If found, read from hot path
- If not found, check cold storage (`~/.claude/storage/agents/`, `~/.claude/storage/skills/`)
- If still not found, suggest `/library use <name>` to install first

### 3. Read and Present Content
- Read the file using the Read tool
- The file content is now in the session context and available for use
- For skills: the skill's instructions are now active for this session
- For agents: the agent definition is now available for `Agent` tool's `subagent_type`

### 4. Confirm
Tell the user:
- What was loaded and from where
- That this is a temporary load (session-only)
- The content is now available for use
- To permanently install, use `/library use <name>`

## Notes
- `/library load` does NOT copy files to the hot path
- `/library load` does NOT modify the filesystem
- The loaded content is available only in the current session
- Multiple items can be loaded in sequence
- If the agent is needed as a `subagent_type`, note that it must be in `~/.claude/agents/` for auto-discovery. For cold storage agents, the content is in context but may not be auto-discoverable by the Agent tool

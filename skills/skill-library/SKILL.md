---
name: library
description: Private skill distribution system. Use when the user wants to install, use, add, push, remove, sync, list, or search for skills, agents, prompts, tools, or MCP servers from their private library catalog. Triggers on /library commands or mentions of library, skill distribution, or agentic management.
argument-hint: "[command or prompt] [name or details]"
---

# The Library

A meta-skill for private-first distribution of agentics (skills, agents, prompts, tools, and MCP servers) across agents, devices, and teams.

## Variables

> Update these after forking and cloning the library repo.

- **LIBRARY_REPO_URL**: `https://github.com/<your-org>/<your-library-repo>.git`
- **LIBRARY_YAML_PATH**: `~/.claude/skills/skill-library/library.yaml`
- **LIBRARY_SKILL_DIR**: `~/.claude/skills/skill-library/`

## How It Works

The Library is a catalog of references to your agentics. The `library.yaml` file points to where skills, agents, prompts, and tools live (local filesystem or GitHub repos). Nothing is fetched until you ask for it.

**The `library.yaml` is a catalog, not a manifest.** Entries define what's *available* — not what gets installed. You pull specific items on demand with `/library use <name>`.

## Commands

| Command                     | Purpose                                  |
| --------------------------- | ---------------------------------------- |
| `/library install`          | First-time setup: fork, clone, configure |
| `/library add <details>`    | Register a new entry in the catalog      |
| `/library use <name>`       | Pull from source (install or refresh)    |
| `/library push <name>`      | Push local changes back to source        |
| `/library remove <name>`    | Remove from catalog and optionally local |
| `/library list`             | Show full catalog with install status    |
| `/library sync`             | Re-pull all installed items from source   |
| `/library load <name>`      | Read from cold storage into session (temporary) |
| `/library search <keyword>` | Find entries by keyword                  |
| `/library sync-all`         | GitHub repo pull + 모든 에이전트에 global 동기화 |
| `/library mcp-add <details>` | Register a new MCP server in the catalog |
| `/library mcp-use <name>`   | Install an MCP server from catalog       |
| `/library mcp-remove <name>` | Remove MCP from ~/.claude.json (catalog preserved) |
| `/library mcp-list`          | Show all MCP servers with install status |
| `/library workflow-use <name>` | Apply a role workflow to project or global |
| `/library workflow-list`       | Show all available workflows              |
| `/library auto-sync`          | Set up automatic periodic sync (macOS/Linux/Windows) |

## Cookbook

Each command has a detailed step-by-step guide. **Read the relevant cookbook file before executing a command.**

| Command | Cookbook                                 | Use When                                                    |
| ------- | --------------------------------------- | ----------------------------------------------------------- |
| install | [cookbook/install.md](cookbook/install.md) | First-time setup on a new device                            |
| add     | [cookbook/add.md](cookbook/add.md)         | User wants to register a new skill/agent/prompt in catalog  |
| use     | [cookbook/use.md](cookbook/use.md)         | User wants to pull or refresh a skill from the catalog      |
| push    | [cookbook/push.md](cookbook/push.md)       | User improved a skill locally and wants to update the source |
| remove  | [cookbook/remove.md](cookbook/remove.md)   | User wants to remove an entry from the catalog               |
| list    | [cookbook/list.md](cookbook/list.md)       | User wants to see what's available and what's installed      |
| sync    | [cookbook/sync.md](cookbook/sync.md)       | User wants to refresh all installed items at once            |
| search  | [cookbook/search.md](cookbook/search.md)   | User is looking for a skill but doesn't know the exact name |
| load    | [cookbook/load.md](cookbook/load.md)       | User wants to temporarily load a cold storage item into session |
| sync-all | [cookbook/sync-all.md](cookbook/sync-all.md) | GitHub pull 후 scope:global 스킬을 모든 에이전트에 동기화 |
| mcp-add | [cookbook/mcp-add.md](cookbook/mcp-add.md) | User wants to register a new MCP server in the catalog      |
| mcp-use | [cookbook/mcp-use.md](cookbook/mcp-use.md) | User wants to install an MCP server from the catalog        |
| mcp-remove | [cookbook/mcp-remove.md](cookbook/mcp-remove.md) | User wants to remove an MCP server                   |
| mcp-list | [cookbook/mcp-list.md](cookbook/mcp-list.md) | User wants to see all MCP servers with install status     |
| workflow-use | [cookbook/workflow-use.md](cookbook/workflow-use.md) | User wants to apply a role workflow (developer, manager, designer, marketer) |
| workflow-list | [cookbook/workflow-list.md](cookbook/workflow-list.md) | User wants to see available workflows |
| auto-sync | [cookbook/auto-sync.md](cookbook/auto-sync.md) | User wants automatic periodic sync across all agents |

**When a user invokes a `/library` command, read the matching cookbook file first, then execute the steps.**

## Source Format

The `source` field in `library.yaml` supports these formats (auto-detected):

- `/absolute/path/to/SKILL.md` — local filesystem
- `https://github.com/org/repo/blob/main/path/to/SKILL.md` — GitHub browser URL
- `https://raw.githubusercontent.com/org/repo/main/path/to/SKILL.md` — GitHub raw URL

Both GitHub URL formats are supported. Parse org, repo, branch, and file path from the URL structure. For private repos, use SSH or `GITHUB_TOKEN` for auth automatically.

**Important:** The source points to a specific file (SKILL.md, AGENT.md, TOOL.md, or prompt file). We always pull the entire parent directory, not just the file.

## Source Parsing Rules

**Local paths** start with `/` or `~`:
- Use the path directly. Copy the parent directory of the referenced file.

**GitHub browser URLs** match `https://github.com/<org>/<repo>/blob/<branch>/<path>`:
- Parse: `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://github.com/<org>/<repo>.git`
- File location within repo: `<path>`

**GitHub raw URLs** match `https://raw.githubusercontent.com/<org>/<repo>/<branch>/<path>`:
- Parse: `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://github.com/<org>/<repo>.git`
- File location within repo: `<path>`

**Generic Git hosting URLs** (Gitea, GitLab 등) match `https://<host>/<org>/<repo>/blob/<branch>/<path>` where `<host>` is NOT `github.com`:
- Parse: `host`, `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://<host>/<org>/<repo>.git`
- File location within repo: `<path>`

## GitHub Workflow

When working with GitHub sources, prefer `gh api` for accessing single files (e.g., reading a SKILL.md to check metadata). For pulling entire skill directories, clone into a temp dir per the steps below.

**Fetching (use):**
1. Clone the repo with `git clone --depth 1 <clone_url>` into a temporary directory
2. Navigate to the parent directory of the referenced file
3. Copy that entire directory to the target local directory
4. The temporary directory is cleaned up automatically

**Pushing (push):**
1. Clone the repo with `git clone --depth 1 <clone_url>` into a temporary directory
2. Overwrite the skill directory in the clone with the local version
3. Stage only the relevant changes: `git add <skill_directory_path>`
4. Commit with message: `library: updated <skill name> <what changed>`
5. Push to remote
6. The temporary directory is cleaned up automatically

## Typed Dependencies

The `requires` field uses typed references to avoid ambiguity:
- `skill:name` — references a skill in the library catalog
- `agent:name` — references an agent in the library catalog
- `prompt:name` — references a prompt in the library catalog
- `tool:name` — references a CLI tool in the library catalog
- `mcp:name` — references an MCP server in the library catalog

When resolving dependencies: look up each reference in `library.yaml`, fetch all dependencies first (recursively), then fetch the requested item.

## Target Directories

By default, items are installed to the **default** directory from `library.yaml`:

```yaml
default_dirs:
    skills:
        - default: .claude/skills/
        - global: ~/.claude/skills/
        - codex_global: ~/.codex/skills/
        - gemini_global: ~/.gemini/skills/
        - gsd_global: ~/.gsd/agent/skills/
    agents:
        - default: .claude/agents/
        - global: ~/.claude/agents/
    prompts:
        - default: .claude/commands/
        - global: ~/.claude/commands/
    tools:
        - default: .claude/tool-cli/
        - global: ~/.claude/tool-cli/
```

- If the user says "global" or "globally", use the `global` directory.
- If the user specifies a custom path, use that path.
- Otherwise, use the `default` directory.

## Scope Field

각 스킬 엔트리에 `scope` 필드를 지정할 수 있다:

- `scope: project` (기본값) — `/library use` 시 `.claude/skills/`에만 설치
- `scope: global` — `/library use`시 모든 에이전트 타겟(claude, codex, gemini, gsd)에 설치. `/library sync-all`의 대상이 된다.

`scope` 필드가 없으면 `project`로 간주한다.

## Library Repo Sync

The library skill itself lives in `<LIBRARY_SKILL_DIR>` as a cloned git repo. When running `add` (which modifies `library.yaml`), always:
1. `git pull` in the library directory first to get latest
2. Make the changes
3. `git add library.yaml && git commit && git push`

This keeps the catalog in sync across devices.

## MCP Server Management

MCP servers differ from file-based items (skills, agents, prompts, tools). They are **config entries** stored in `~/.claude.json` under the `mcpServers` key, while the catalog definition lives in `library.yaml` under `library.mcps`.

### Config Format

Each MCP entry in `library.yaml` has:
```yaml
- name: server-name
  description: What the MCP does
  type: stdio|http
  config:
    # For stdio: command, args, env
    # For http: url, headers
```

### Security: Secret Placeholders

Sensitive values (API keys, tokens) are stored as `{{PLACEHOLDER}}` in the catalog. When installing via `mcp-use`, the user is prompted for actual values.

**Auto-detect fields**: any config key containing `key`, `token`, `secret`, `password`, `credential`, or `auth` (case-insensitive) is treated as sensitive.

### JSON Safety

When modifying `~/.claude.json`:
1. Always backup first: `cp ~/.claude.json ~/.claude.json.bak`
2. Use `python3` for JSON round-trip (never edit JSON as text)
3. Validate after write: `python3 -c "import json; json.load(open('$HOME/.claude.json'))"`
4. Restore from backup if validation fails

## Example Filled Library File

```yaml
default_dirs:
  skills:
    - default: .claude/skills/
    - global: ~/.claude/skills/
  agents:
    - default: .claude/agents/
    - global: ~/.claude/agents/
  prompts:
    - default: .claude/prompts/
    - global: ~/.claude/prompts/
  tools:
    - default: .claude/tool-cli/
    - global: ~/.claude/tool-cli/

library:
  skills:
    - name: firecrawl
      description: Scrape, crawl, and search websites using Firecrawl CLI
      source: /Users/me/projects/tools/skills/firecrawl/SKILL.md

    - name: meta-skill
      description: Creates new Agent Skills following best practices
      source: /Users/me/projects/tools/skills/meta-skill/SKILL.md

    - name: diagram-kroki
      description: Generate diagrams via Kroki HTTP API supporting 28+ languages
      source: https://github.com/myorg/private-skills/blob/main/skills/diagram-kroki/SKILL.md
      requires: [skill:firecrawl]

    - name: green-screen-captions
      description: Generate and burn AI-powered captions onto green screen videos
      source: https://raw.githubusercontent.com/myorg/video-tools/main/skills/green-screen-captions/SKILL.md
      requires: [agent:video-processor, prompt:caption-style]

  agents:
    - name: video-processor
      description: Processes video files with ffmpeg and whisper transcription
      source: /Users/me/projects/tools/agents/video-processor/AGENT.md

    - name: code-reviewer
      description: Reviews code for quality, security, and performance
      source: https://github.com/myorg/agent-configs/blob/main/agents/code-reviewer/AGENT.md

  prompts:
    - name: caption-style
      description: Style guide for generating video captions
      source: /Users/me/projects/content/prompts/caption-style.md

    - name: commit-message
      description: Standardized commit message format for all projects
      source: https://github.com/myorg/team-prompts/blob/main/prompts/commit-message.md

  tools:
    - name: jk
      description: Jenkins CLI for job management and pipeline control
      source: /Users/me/projects/tools/tool-cli/jk/TOOL.md

    - name: browser-cli
      description: Headless browser automation for web scraping
      source: https://github.com/myorg/cli-tools/blob/main/tool-cli/browser-cli/TOOL.md

  mcps:
    - name: context7
      description: Up-to-date library documentation lookup via Context7
      type: http
      config:
        type: "http"
        url: "https://mcp.context7.com/mcp"
        headers:
          CONTEXT7_API_KEY: "{{CONTEXT7_API_KEY}}"

    - name: svgmaker
      description: SVG generation via SVGMaker API
      type: stdio
      config:
        type: "stdio"
        command: "npx"
        args: ["-y", "@genwave/svgmaker-mcp"]
        env:
          SVGMAKER_API_KEY: "{{SVGMAKER_API_KEY}}"
```

# Use a Skill from the Library

## Context
Pull a skill, agent, prompt, or tool from the catalog into the local environment. If already installed locally, overwrite with the latest from the source (refresh).

## Input
The user provides a skill name or description.

## Steps

### 1. Sync the Library Repo
Pull the latest catalog before reading:
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Find the Entry
- Read `library.yaml`
- Search across `library.skills`, `library.agents`, `library.prompts`, and `library.tools`
- Match by name (exact) or description (fuzzy/keyword match)
- If multiple matches, show them and ask the user to pick one
- If no match, tell the user and suggest `/library search`

### 3. Resolve Dependencies
If the entry has a `requires` field:
- For each typed reference (`skill:name`, `agent:name`, `prompt:name`, `tool:name`):
  - Look it up in `library.yaml`
  - If found, recursively run the `use` workflow for that dependency first
  - If not found, warn the user: "Dependency <ref> not found in library catalog"
- Process all dependencies before the requested item

### 4. Determine Target Directory
- Read `default_dirs` from `library.yaml`
- Check the entry's `scope` field (기본값: `project`)
- If user said "global" or "globally", **or** entry has `scope: global` → 멀티타겟 배포:
  - `~/.claude/skills/<name>/` (전체 디렉토리)
  - `~/.codex/skills/<name>/` (전체 디렉토리)
  - `~/.gemini/skills/<name>/` (전체 디렉토리)
  - `~/.gsd/agent/skills/<name>/` (SKILL.md만 복사 — gsd 포맷 호환)
- If user specified a custom path → use that path
- Otherwise → use the `default` path
- Select the correct section based on type (skills/agents/prompts/tools)

### 5. Fetch from Source

**If source is a local path** (starts with `/` or `~`):
- Resolve `~` to the home directory
- Get the parent directory of the referenced file
- For skills: copy the entire parent directory to the target:
  ```bash
  cp -R <parent_directory>/ <target_directory>/<name>/
  ```
- For agents: copy just the agent file to the target:
  ```bash
  cp <agent_file> <target_directory>/<agent_name>.md
  ```
- For prompts: copy just the prompt file to the target:
  ```bash
  cp <prompt_file> <target_directory>/<prompt_name>.md
  ```
- For tools: copy the entire parent directory to the target (same as skills):
  ```bash
  cp -R <parent_directory>/ <target_directory>/<name>/
  ```
- If the agent or prompt is nested in a subdirectory under the `agents/` or `commands/` directories, copy the subdirectory to the target as well, creating the subdir if it doesn't exist. This is useful because it keeps the agents or commands grouped together.

**If source is a GitHub URL**:
- Parse the URL to extract: `org`, `repo`, `branch`, `file_path`
  - Browser URL pattern: `https://github.com/<org>/<repo>/blob/<branch>/<path>`
  - Raw URL pattern: `https://raw.githubusercontent.com/<org>/<repo>/<branch>/<path>`
- Determine the clone URL: `https://github.com/<org>/<repo>.git`
- Determine the parent directory path within the repo (everything before the filename)
- Clone into a temporary directory:
  ```bash
  tmp_dir=$(mktemp -d)
  git clone --depth 1 --branch <branch> https://github.com/<org>/<repo>.git "$tmp_dir"
  ```
- Copy the parent directory of the file to the target:
  ```bash
  cp -R "$tmp_dir/<parent_path>/" <target_directory>/<name>/
  ```
- Clean up:
  ```bash
  rm -rf "$tmp_dir"
  ```

**If clone fails (private repo)**, try SSH:
  ```bash
  git clone --depth 1 --branch <branch> git@github.com:<org>/<repo>.git "$tmp_dir"
  ```

**If source is a non-GitHub Git hosting URL** (e.g., Gitea, GitLab):
- URL 패턴: `https://<host>/<org>/<repo>/blob/<branch>/<path>` (host가 `github.com`이 아닌 경우)
- Parse: `host`, `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://<host>/<org>/<repo>.git`
- 나머지 flow는 GitHub와 동일:
  ```bash
  tmp_dir=$(mktemp -d)
  git clone --depth 1 --branch <branch> https://<host>/<org>/<repo>.git "$tmp_dir"
  cp -R "$tmp_dir/<parent_path>/" <target_directory>/<name>/
  rm -rf "$tmp_dir"
  ```
- **If clone fails (private repo)**, try SSH:
  ```bash
  git clone --depth 1 --branch <branch> git@<host>:<org>/<repo>.git "$tmp_dir"
  ```

### 5b. Post-fetch Verification (tools only)
If the fetched item is a tool:
1. Read the TOOL.md file and parse YAML frontmatter
2. Extract the `verify` field (e.g., "jk --version")
3. Run the verify command
4. If it succeeds: report "Tool <name> is installed and ready"
5. If it fails: show the `install` map from frontmatter and ask the user if they want to install it
   - Tool installation requires user confirmation (system-level changes like brew/npm)

### 6. Verify Installation
- Confirm the target directory exists
- Confirm the main file (SKILL.md, AGENT.md, or prompt file) exists in it
- Report success with the installed path

### 7. Confirm
Tell the user:
- What was installed and where
- Any dependencies that were also installed
- If this was a refresh (overwrite), mention that

# Install The Library

## Context
First-time setup of The Library on a new device. The user either has the template repo cloned directly, or has already forked it to their own private repo.

## Steps

### 1. Check Prerequisites
- Verify `git` is installed: `git --version`
- Verify the global skills directory exists or can be created: `~/.claude/skills/`

### 2. Determine Fork Status
Ask the user: **"Is this the template repo or your own fork?"**

**If template repo (hasn't forked yet):**
- Instruct the user to create a private fork on GitHub
- Note the fork URL for step 3

**If already forked:**
- Note the existing repo URL for step 3

### 3. Clone to Global Skills Directory (Sparse Checkout)
Use sparse checkout to clone only the essential files (`library.yaml` + skill-library skill):

```bash
git clone --depth 1 --filter=blob:none --sparse <LIBRARY_REPO_URL> <LIBRARY_SKILL_DIR>
cd <LIBRARY_SKILL_DIR>
git sparse-checkout set library.yaml .claude/skills/skill-library
```

This avoids pulling thousands of unrelated files (agents, docs, other skills).

If already cloned as a full repo, convert to sparse checkout:
```bash
cd <LIBRARY_SKILL_DIR>
git sparse-checkout init --cone
git sparse-checkout set library.yaml .claude/skills/skill-library
```

### 4. Update Variables
- Open `SKILL.md` in the library directory (at `<LIBRARY_SKILL_DIR>/.claude/skills/skill-library/SKILL.md`)
- Take note of your current working directory.
- Update the `## Variables` section:
  - **LIBRARY_REPO_URL**: Set to the user's fork URL
  - **LIBRARY_YAML_PATH**: Confirm path (default: `~/.claude/skills/skill-library/library.yaml`)
  - **LIBRARY_SKILL_DIR**: Confirm path (default: `~/.claude/skills/skill-library/`)

### 5. Verify Installation
- Confirm library.yaml exists at `<LIBRARY_SKILL_DIR>/library.yaml`
- Confirm SKILL.md exists at `<LIBRARY_SKILL_DIR>/.claude/skills/skill-library/SKILL.md`
- Confirm the `/library` command is now available

### 6. Done
Tell the user:
- The Library is now globally available
- `/library list` will show the catalog
- `/library add` to start adding skills, agents, and prompts

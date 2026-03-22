# Claude Minimal Plugin

Lightweight essential plugin for Claude Code. Core skills only, no external integrations.

## Install

### Option A: Plugin Marketplace (recommended)

```bash
# Register marketplace (once)
/plugin marketplace add cskwork/claude-minimal-plugin

# Install
/plugin install minimal
```

### Option B: Script

```bash
git clone https://github.com/cskwork/claude-minimal-plugin.git
cd claude-minimal-plugin
chmod +x install.sh && ./install.sh
```

## CLAUDE.md Setup

The included `CLAUDE.md` provides a battle-tested system prompt. Install it to `~/.claude/CLAUDE.md`:

```bash
# Backup existing (if any)
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak

# Install
cp CLAUDE.md ~/.claude/CLAUDE.md
```

## What's Included

| Type | Count | Items |
|------|-------|-------|
| Skills | 15 | agent-browser, brutalist-skill, claude-hud, find-skills, install-plugins, korean-frontend-defaults, mcp-builder, minimalist-skill, output-skill, redesign-skill, skill-creator, skill-library, soft-skill, stitch-skill, taste-skill |
| Agents | 6 | code-reviewer, frontend-developer, feature-tester, ui-designer, ux-researcher, workflow-orchestrator |
| Commands | 3 | /build-fix, /plan, /tdd |

## What's NOT Included

docx, pdf, gitea-mcp, huly-jarvis, teams-message -- external service dependencies removed for lightweight setup.

## License

MIT

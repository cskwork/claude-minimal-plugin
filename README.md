<p align="center">
  <h1 align="center">Claude Minimal Plugin</h1>
  <p align="center">
    <strong>A curated Claude Code toolkit for web developers who ship.</strong>
    <br />
    15 skills. 6 agents. 3 commands. Zero bloat.
  </p>
</p>

<p align="center">
  <a href="https://github.com/cskwork/claude-minimal-plugin/stargazers"><img src="https://img.shields.io/github/stars/cskwork/claude-minimal-plugin?style=social" alt="Stars"></a>
  <a href="https://github.com/cskwork/claude-minimal-plugin/blob/main/LICENSE"><img src="https://img.shields.io/github/license/cskwork/claude-minimal-plugin" alt="License"></a>
  <a href="https://github.com/cskwork/claude-minimal-plugin/network/members"><img src="https://img.shields.io/github/forks/cskwork/claude-minimal-plugin" alt="Forks"></a>
</p>

---

## The Problem

Most Claude Code plugin collections give you **1,000+ skills** and leave you to figure out which ones work, which conflict, and which are just noise.

You don't need 1,000 skills. You need the **right 24**.

## What This Is

A **hand-picked, zero-dependency toolkit** for web developers. Every skill, agent, and command is selected to work together as a cohesive development environment -- not a junk drawer.

```
You get:
  A design team       (5 UI/UX design skills)
  A dev team          (6 specialized agents)
  A workflow system   (TDD, planning, build-fix)
  A system prompt     (battle-tested CLAUDE.md)
```

## Quick Start

```bash
git clone https://github.com/cskwork/claude-minimal-plugin.git
cd claude-minimal-plugin
./install.sh
```

Restart Claude Code. Done.

> The installer symlinks everything to `~/.claude/` and backs up your existing config automatically.

<details>
<summary>Alternative: Plugin Marketplace</summary>

```bash
# Register marketplace (once)
/plugin marketplace add cskwork/claude-minimal-plugin

# Install
/plugin install minimal
```

</details>

## What's Inside

### Design Skills -- Build UIs That Don't Look AI-Generated

| Skill | What It Does |
|-------|-------------|
| **taste-skill** | Overrides Claude's default "Bootstrap-looking" output. Adds design dials (variance, motion, density) for precise control over visual output. |
| **brutalist-skill** | Swiss typography + military terminal aesthetics. For data-heavy dashboards and admin panels that command attention. |
| **minimalist-skill** | Clean editorial layouts with warm monochrome palettes. No gradients, no shadows -- just typography and space. |
| **soft-skill** | Awwwards-tier design with spring physics animations, cinematic motion, and premium font pairings. |
| **stitch-skill** | Generates semantic design system tokens for Google Stitch. Anti-generic UI standards baked in. |

### Development Skills -- Build Faster, Ship Better

| Skill | What It Does |
|-------|-------------|
| **agent-browser** | Automates browser interactions -- navigation, form filling, data extraction -- through Chrome CDP. |
| **mcp-builder** | Step-by-step guide to building production MCP servers with proper tool schemas (Zod/Pydantic). |
| **output-skill** | Bans placeholder code. Forces Claude to generate complete, unabridged implementations -- no `// ... rest of code`. |
| **skill-creator** | Create your own skills with proper structure, progressive disclosure, and reusable resource bundling. |
| **korean-frontend-defaults** | Korean market frontend defaults: Pretendard font, `word-break: keep-all`, proper hangul typography. |

### Meta Skills -- Manage Your Setup

| Skill | What It Does |
|-------|-------------|
| **claude-hud** | Real-time statusline showing context usage, active tools, agent status, and todo progress. |
| **find-skills** | Discover and install skills from the open ecosystem with quality filters. |
| **install-plugins** | Multi-tool plugin installer across Claude Code, Cursor, and other AI tools. |
| **skill-library** | Private skill distribution across devices and teams via GitHub-synced catalog. |
| **redesign-skill** | Audit existing websites and apply high-end design standards without breaking functionality. |

### Agents -- Your AI Dev Team

Six specialized agents that work together through the workflow orchestrator:

| Agent | Role | Specialty |
|-------|------|-----------|
| **workflow-orchestrator** | Project Lead | Designs and executes complex processes. Coordinates the other agents. |
| **frontend-developer** | Senior Frontend Dev | React components, scalable architecture, maintainability-first. |
| **ui-designer** | Senior UI Designer | Interface design balancing aesthetics, accessibility, and brand alignment. |
| **ux-researcher** | Senior UX Researcher | Mixed-methods research, user insights, design validation. |
| **code-reviewer** | Senior Code Reviewer | Reviews against plans, enforces architecture and quality standards. |
| **feature-tester** | QA Engineer | Systematic frontend + backend testing before production. |

### Commands -- Three Workflows That Matter

| Command | Usage | What It Does |
|---------|-------|-------------|
| `/plan` | Before starting | Breaks down requirements into phases, identifies risks, waits for your approval. |
| `/tdd` | During development | Enforces test-first: scaffold interfaces, write tests, implement minimal code, hit 80%+ coverage. |
| `/build-fix` | When things break | Parses build errors, shows context, fixes incrementally, re-runs until green. |

## Why This Over [Big Collection X]?

| | Claude Minimal Plugin | 1000+ Skill Collections |
|---|---|---|
| **Setup time** | 30 seconds | Hours of configuration |
| **Conflicts** | Skills tested together | Unknown interactions |
| **Design quality** | 5 curated design systems | Generic Bootstrap output |
| **Team workflow** | 6 agents + orchestrator | Individual skills, no coordination |
| **Maintenance** | One repo to update | Track dozens of sources |
| **Dependencies** | Zero external services | Often requires API keys, accounts |

## The CLAUDE.md

The included `CLAUDE.md` system prompt establishes a disciplined development workflow:

1. **Gather Context** before coding
2. **Plan First** with risk assessment
3. **TDD** -- test, fail, implement, pass
4. **Verify** -- lint, build, fix automatically
5. **Root Cause Only** -- no bandaid fixes

Install it separately if you only want the prompt:

```bash
cp CLAUDE.md ~/.claude/CLAUDE.md
```

## Recommended Pairing

| Plugin | Why | Install |
|--------|-----|---------|
| [superpowers](https://github.com/obra/superpowers) | Adds systematic debugging, advanced code review, and extended TDD workflows | `claude install-github-skill https://github.com/obra/superpowers` |

## What's NOT Included (By Design)

These were deliberately removed to keep the plugin dependency-free:

- **docx/pdf** -- requires external document processing libraries
- **gitea-mcp** -- requires Gitea server
- **huly-jarvis** -- requires Huly workspace
- **teams-message** -- requires Microsoft Teams credentials

## Uninstall

```bash
./uninstall.sh
```

Removes all symlinks and restores your backed-up config files.

## Contributing

Found a skill that should be in the collection? Have a design system to add?

1. Fork this repo
2. Add your skill/agent/command
3. Test it works with the existing set (no conflicts)
4. Open a PR explaining **why** it belongs in a minimal collection

The bar is intentionally high. "Useful" isn't enough -- it needs to be **essential**.

## License

[MIT](LICENSE)

---

<p align="center">
  <sub>Built for developers who believe less tooling, done right, beats more tooling done poorly.</sub>
</p>

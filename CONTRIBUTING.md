# Contributing

This is a curated collection. The bar is intentionally high.

## What We Accept

- **Design skills** that produce visually distinct, non-generic output
- **Dev skills** that solve a common web development pain point
- **Agents** that fill a missing role in the dev team
- **Commands** that automate a workflow developers repeat daily

## What We Don't Accept

- Skills that require external API keys or service accounts
- Skills that duplicate existing functionality
- "Nice to have" skills -- everything here must be **essential**
- Skills without clear documentation

## How to Submit

1. Fork this repo
2. Add your skill to `skills/`, agent to `agents/`, or command to `commands/`
3. Verify it works alongside the existing set (no conflicts)
4. Run `./install.sh` and test in a fresh Claude Code session
5. Open a PR with:
   - **What it does** (one sentence)
   - **Why it belongs** in a minimal collection
   - **How you tested** it

## Skill Structure

```
skills/
  your-skill/
    SKILL.md          # Required: skill definition
    README.md         # Optional: detailed docs
    examples/         # Optional: usage examples
```

## Code of Conduct

Be respectful. Focus on the work. Ship things that matter.

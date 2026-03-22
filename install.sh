#!/bin/sh
# Minimal Plugin Installer
# Installs skills, agents, and commands to ~/.claude/
# Optionally sets up CLAUDE.md system prompt

set -eu

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"
CLAUDE_DIR="$HOME_DIR/.claude"

echo ""
echo "=========================================="
echo "  Claude Minimal Plugin Installer"
echo "=========================================="
echo ""

# --- Create directories ---
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands"

# --- Install skills ---
echo "[1/5] Skills..."
count=0
for skill_dir in "$REPO_ROOT/skills"/*/; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  ln -sfn "$skill_dir" "$CLAUDE_DIR/skills/$name"
  count=$((count + 1))
done
echo "  $count skills installed"

# --- Install agents ---
echo "[2/5] Agents..."
count=0
for agent in "$REPO_ROOT/agents"/*.md; do
  [ -f "$agent" ] || continue
  name="$(basename "$agent")"
  ln -sfn "$agent" "$CLAUDE_DIR/agents/$name"
  count=$((count + 1))
done
echo "  $count agents installed"

# --- Install commands ---
echo "[3/5] Commands..."
count=0
for cmd in "$REPO_ROOT/commands"/*.md; do
  [ -f "$cmd" ] || continue
  name="$(basename "$cmd")"
  ln -sfn "$cmd" "$CLAUDE_DIR/commands/$name"
  count=$((count + 1))
done
echo "  $count commands installed"

# --- CLAUDE.md setup ---
echo "[4/5] CLAUDE.md..."
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
  echo "  Existing CLAUDE.md backed up to CLAUDE.md.bak"
fi
cp "$REPO_ROOT/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  CLAUDE.md installed"

# --- settings.json setup ---
echo "[5/5] settings.json..."
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
  echo "  Existing settings.json backed up to settings.json.bak"
fi
cp "$REPO_ROOT/settings.json" "$CLAUDE_DIR/settings.json"
echo "  settings.json installed"

echo ""
echo "Done. Restart Claude Code to apply changes."

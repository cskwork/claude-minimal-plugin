#!/bin/sh
# Minimal Plugin Uninstaller
# Removes symlinks created by install.sh and restores backups

set -eu

CLAUDE_DIR="$HOME/.claude"

echo ""
echo "=========================================="
echo "  Claude Minimal Plugin Uninstaller"
echo "=========================================="
echo ""

# --- Remove skills ---
echo "[1/5] Removing skills..."
count=0
for name in agent-browser brutalist-skill claude-hud find-skills install-plugins korean-frontend-defaults mcp-builder minimalist-skill output-skill redesign-skill skill-creator skill-library soft-skill stitch-skill taste-skill; do
  if [ -L "$CLAUDE_DIR/skills/$name" ]; then
    rm "$CLAUDE_DIR/skills/$name"
    count=$((count + 1))
  fi
done
echo "  $count skills removed"

# --- Remove agents ---
echo "[2/5] Removing agents..."
count=0
for name in code-reviewer feature-tester frontend-developer ui-designer ux-researcher workflow-orchestrator; do
  if [ -L "$CLAUDE_DIR/agents/$name.md" ]; then
    rm "$CLAUDE_DIR/agents/$name.md"
    count=$((count + 1))
  fi
done
echo "  $count agents removed"

# --- Remove commands ---
echo "[3/5] Removing commands..."
count=0
for name in build-fix plan tdd; do
  if [ -L "$CLAUDE_DIR/commands/$name.md" ]; then
    rm "$CLAUDE_DIR/commands/$name.md"
    count=$((count + 1))
  fi
done
echo "  $count commands removed"

# --- Restore CLAUDE.md ---
echo "[4/5] Restoring CLAUDE.md..."
if [ -f "$CLAUDE_DIR/CLAUDE.md.bak" ]; then
  mv "$CLAUDE_DIR/CLAUDE.md.bak" "$CLAUDE_DIR/CLAUDE.md"
  echo "  Restored from backup"
else
  echo "  No backup found, skipped"
fi

# --- Restore settings.json ---
echo "[5/5] Restoring settings.json..."
if [ -f "$CLAUDE_DIR/settings.json.bak" ]; then
  mv "$CLAUDE_DIR/settings.json.bak" "$CLAUDE_DIR/settings.json"
  echo "  Restored from backup"
else
  echo "  No backup found, skipped"
fi

echo ""
echo "Done. Restart Claude Code to apply changes."

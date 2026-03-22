# Auto-Sync Setup

## Context
Set up automatic periodic synchronization of the skill-library across all agent directories (Claude, Codex, Gemini, GSD). Asks the user interactively whether to enable auto-sync, and configures the OS-appropriate scheduler.

## Input
No input required. The command is interactive.

## Steps

### 1. Detect OS
Determine if the user is on macOS, Linux, or Windows.

### 2. Run the Appropriate Script
Execute the platform-specific script from the `scripts/` directory:

**macOS / Linux:**
```bash
bash <LIBRARY_SKILL_DIR>/scripts/auto-sync.sh
```

**Windows:**
```cmd
<LIBRARY_SKILL_DIR>\scripts\auto-sync.bat
```

### 3. Script Flow (Interactive)
The script will:
1. Display the library directory path and OS info
2. Show which agent directories will be symlinked
3. **Ask the user**: "자동 동기화를 설정하시겠습니까? (y/N)"
4. If no: offer a one-time sync instead, then exit
5. If yes: ask for sync interval (default 60 minutes)
6. Run an immediate sync (git pull + symlink update)
7. Register the scheduler:
   - **macOS**: launchd plist at `~/Library/LaunchAgents/com.claude.skill-library-sync.plist`
   - **Linux**: systemd user timer (preferred) or cron job (fallback)
   - **Windows**: Task Scheduler entry `SkillLibraryAutoSync`

### 4. What the Sync Does
Each scheduled run:
1. `git pull --rebase --autostash` in the library directory
2. Recreate symlinks for all agent directories:
   - `~/.claude/skills/skill-library`
   - `~/.codex/skills/skill-library`
   - `~/.gemini/skills/skill-library`
   - `~/.gsd/agent/skills/skill-library`

### 5. Uninstall
To remove the auto-sync schedule:

**macOS / Linux:**
```bash
bash <LIBRARY_SKILL_DIR>/scripts/auto-sync.sh --uninstall
```

**Windows:**
```cmd
<LIBRARY_SKILL_DIR>\scripts\auto-sync.bat --uninstall
```

### 6. Confirm
Tell the user:
- Whether auto-sync was enabled or skipped
- The sync interval if enabled
- Log location (macOS: `~/.claude/logs/skill-library-sync.log`)
- How to uninstall later

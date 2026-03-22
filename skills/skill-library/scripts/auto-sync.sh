#!/usr/bin/env bash
# auto-sync.sh — skill-library 자동 동기화 설정 (macOS / Linux)
# 사용법: bash auto-sync.sh [--uninstall]
set -euo pipefail

# ── 설정 ──────────────────────────────────────────────
LIBRARY_DIR="${SKILL_LIBRARY_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
SYNC_INTERVAL_SECONDS=3600  # 1시간
PLIST_LABEL="com.claude.skill-library-sync"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_LABEL}.plist"
CRON_MARKER="# skill-library-auto-sync"
SYSTEMD_SERVICE="skill-library-sync"
SYSTEMD_TIMER_DIR="$HOME/.config/systemd/user"

# ── 색상 ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ── 사전 검증 ────────────────────────────────────────
check_prerequisites() {
    command -v git &>/dev/null || { echo -e "${RED}[error]${NC} git not found. Please install git first."; exit 1; }
    [[ -d "$LIBRARY_DIR/.git" || -d "$LIBRARY_DIR/../.git" ]] || { echo -e "${RED}[error]${NC} ${LIBRARY_DIR} is not inside a git repository."; exit 1; }
}

# ── 동기화 로직 (실제 sync 수행) ─────────────────────
do_sync() {
    check_prerequisites
    echo -e "${CYAN}[sync]${NC} git pull in ${LIBRARY_DIR}..."
    (cd "$LIBRARY_DIR" && git pull --rebase --autostash 2>/dev/null || git pull)

    echo -e "${CYAN}[sync]${NC} Updating symlinks..."
    local targets=(
        "$HOME/.claude/skills/skill-library"
        "$HOME/.codex/skills/skill-library"
        "$HOME/.gemini/skills/skill-library"
        "$HOME/.gsd/agent/skills/skill-library"
    )
    for target in "${targets[@]}"; do
        mkdir -p "$(dirname "$target")"
        if [[ -e "$target" && ! -L "$target" ]]; then
            echo -e "${YELLOW}[warn]${NC} $target exists and is not a symlink. Skipping."
            continue
        fi
        ln -sfn "$LIBRARY_DIR" "$target"
    done

    echo -e "${GREEN}[done]${NC} Sync complete at $(date '+%Y-%m-%d %H:%M:%S')"
}

# ── 제거 ──────────────────────────────────────────────
uninstall() {
    echo -e "${YELLOW}[uninstall]${NC} Removing auto-sync schedule..."

    if [[ "$OSTYPE" == darwin* ]]; then
        if [[ -f "$PLIST_PATH" ]]; then
            launchctl bootout "gui/$(id -u)" "$PLIST_PATH" 2>/dev/null || true
            rm -f "$PLIST_PATH"
            echo -e "${GREEN}[done]${NC} launchd plist removed."
        else
            echo -e "${YELLOW}[skip]${NC} No launchd plist found."
        fi
    else
        # Linux: systemd or cron
        if [[ -d "$SYSTEMD_TIMER_DIR" ]] && systemctl --user is-enabled "${SYSTEMD_SERVICE}.timer" 2>/dev/null; then
            systemctl --user disable --now "${SYSTEMD_SERVICE}.timer"
            rm -f "${SYSTEMD_TIMER_DIR}/${SYSTEMD_SERVICE}.service"
            rm -f "${SYSTEMD_TIMER_DIR}/${SYSTEMD_SERVICE}.timer"
            systemctl --user daemon-reload
            echo -e "${GREEN}[done]${NC} systemd timer removed."
        else
            crontab -l 2>/dev/null | grep -v "$CRON_MARKER" | crontab -
            echo -e "${GREEN}[done]${NC} cron job removed."
        fi
    fi
    exit 0
}

# ── macOS: launchd ────────────────────────────────────
install_macos() {
    mkdir -p "$(dirname "$PLIST_PATH")"
    local script_abs_path
    script_abs_path="$(cd "$(dirname "$0")" && pwd)/auto-sync.sh"

    # Use quoted heredoc to avoid shell expansion, then substitute with sed
    cat > "$PLIST_PATH" <<'PLIST_TEMPLATE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>__PLIST_LABEL__</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>__SCRIPT_PATH__</string>
        <string>--run</string>
    </array>
    <key>StartInterval</key>
    <integer>__INTERVAL__</integer>
    <key>StandardOutPath</key>
    <string>__LOG_PATH__</string>
    <key>StandardErrorPath</key>
    <string>__LOG_PATH__</string>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
PLIST_TEMPLATE

    sed -i '' \
        -e "s|__PLIST_LABEL__|${PLIST_LABEL}|g" \
        -e "s|__SCRIPT_PATH__|${script_abs_path}|g" \
        -e "s|__INTERVAL__|${SYNC_INTERVAL_SECONDS}|g" \
        -e "s|__LOG_PATH__|${HOME}/.claude/logs/skill-library-sync.log|g" \
        "$PLIST_PATH"

    mkdir -p "$HOME/.claude/logs"
    if ! launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH" 2>/dev/null && \
       ! launchctl load "$PLIST_PATH" 2>/dev/null; then
        echo -e "${RED}[error]${NC} Failed to register launchd agent. Check plist syntax."
        exit 1
    fi

    echo -e "${GREEN}[done]${NC} launchd plist installed at ${PLIST_PATH}"
    echo -e "${CYAN}[info]${NC} Sync runs every $((SYNC_INTERVAL_SECONDS / 60)) minutes."
    echo -e "${CYAN}[info]${NC} Logs: ~/.claude/logs/skill-library-sync.log"
}

# ── Linux: systemd (preferred) or cron (fallback) ────
install_linux() {
    if command -v systemctl &>/dev/null && systemctl --user status 2>/dev/null; then
        mkdir -p "$SYSTEMD_TIMER_DIR"
        local script_path
        script_path="$(cd "$(dirname "$0")" && pwd)/auto-sync.sh"

        cat > "${SYSTEMD_TIMER_DIR}/${SYSTEMD_SERVICE}.service" <<SVC
[Unit]
Description=Skill Library Auto Sync

[Service]
Type=oneshot
ExecStart=/bin/bash ${script_path} --run
SVC

        cat > "${SYSTEMD_TIMER_DIR}/${SYSTEMD_SERVICE}.timer" <<TMR
[Unit]
Description=Skill Library Sync Timer

[Timer]
OnBootSec=5min
OnUnitActiveSec=${SYNC_INTERVAL_SECONDS}s
Persistent=true

[Install]
WantedBy=timers.target
TMR

        systemctl --user daemon-reload
        systemctl --user enable --now "${SYSTEMD_SERVICE}.timer"
        echo -e "${GREEN}[done]${NC} systemd timer installed."
    else
        local cron_cmd="0 * * * * /bin/bash $(cd "$(dirname "$0")" && pwd)/auto-sync.sh --run ${CRON_MARKER}"
        (crontab -l 2>/dev/null | grep -v "$CRON_MARKER"; echo "$cron_cmd") | crontab -
        echo -e "${GREEN}[done]${NC} cron job installed (hourly)."
    fi
    echo -e "${CYAN}[info]${NC} Sync runs every $((SYNC_INTERVAL_SECONDS / 60)) minutes."
}

# ── 메인 ──────────────────────────────────────────────
main() {
    # --run: 실제 동기화만 수행 (스케줄러에서 호출)
    if [[ "${1:-}" == "--run" ]]; then
        do_sync
        exit 0
    fi

    # --uninstall: 제거
    if [[ "${1:-}" == "--uninstall" ]]; then
        uninstall
    fi

    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  Skill Library Auto-Sync Setup${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    echo -e "  Library: ${GREEN}${LIBRARY_DIR}${NC}"
    echo -e "  OS:      ${GREEN}${OSTYPE}${NC}"
    echo ""
    echo "  이 스크립트는 skill-library를 주기적으로"
    echo "  git pull하고 모든 에이전트에 symlink를 갱신합니다."
    echo ""
    echo -e "  동기화 대상:"
    echo "    ~/.claude/skills/skill-library"
    echo "    ~/.codex/skills/skill-library"
    echo "    ~/.gemini/skills/skill-library"
    echo "    ~/.gsd/agent/skills/skill-library"
    echo ""

    read -rp "자동 동기화를 설정하시겠습니까? (y/N): " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}[skip]${NC} 자동 동기화 설정을 건너뜁니다."
        echo ""
        read -rp "지금 한 번만 동기화할까요? (y/N): " once
        if [[ "$once" =~ ^[Yy]$ ]]; then
            do_sync
        fi
        exit 0
    fi

    echo ""
    read -rp "동기화 간격 (분, 기본 60): " interval_input
    if [[ -n "$interval_input" && "$interval_input" =~ ^[0-9]+$ ]]; then
        SYNC_INTERVAL_SECONDS=$((interval_input * 60))
    fi

    # 즉시 1회 동기화
    do_sync

    # OS별 스케줄러 설치
    if [[ "$OSTYPE" == darwin* ]]; then
        install_macos
    else
        install_linux
    fi

    echo ""
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "제거: ${CYAN}bash $(cd "$(dirname "$0")" && pwd)/auto-sync.sh --uninstall${NC}"
    echo ""
}

main "$@"

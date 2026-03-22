---
name: claude-hud
description: Claude Code의 statusline HUD 플러그인. context 사용량, tool 활동, agent 추적, todo 진행상황을 실시간으로 표시한다. statusline 설정, HUD 커스터마이징, 또는 context 모니터링이 필요할 때 사용한다.
---

# Claude HUD - Statusline HUD Plugin

## 개요

Claude Code의 native statusline API를 사용하는 HUD 플러그인이다. 별도의 tmux나 외부 도구 없이 모든 터미널에서 동작한다. context 사용량, tool 활동, agent 상태, todo 진행상황을 statusline에 실시간으로 표시한다.

- GitHub: https://github.com/jarrodwatts/claude-hud

## 기능

HUD는 statusline에 다음 정보를 표시한다:

**Line 1 (기본 정보):**
- 사용 중인 모델명
- Plan 이름
- 프로젝트 경로
- Git branch

**Line 2 (Context 사용량):**
- Context bar: 사용량에 따라 green -> yellow -> red 색상 변환
- Usage rate limits 표시

**선택 표시 항목:**
- Tools activity (현재 실행 중인 도구)
- Agent status (활성 에이전트 추적)
- Todo progress (할 일 진행률)

## 설치

### Step 1: Marketplace에 claude-hud 추가

```bash
/plugin marketplace add jarrodwatts/claude-hud
```

### Step 2: 플러그인 설치

```bash
/plugin install claude-hud
```

### Step 3: Statusline 설정

```bash
/claude-hud:setup
```

setup 명령어가 statusline 구성을 자동으로 완료한다.

> 설치 후 Claude Code 재시작 필요.

## 설정

### 커스터마이징

```bash
/claude-hud:configure
```

### Presets

| Preset | 설명 |
|--------|------|
| Full | 전체 항목 표시 (context, tools, agents, todo) |
| Essential | 활동 상태 + git 정보만 표시 |
| Minimal | 코어 정보만 표시 (모델, context bar) |

### Layout

| Layout | 설명 |
|--------|------|
| Expanded | 멀티라인 레이아웃 (정보가 여러 줄에 분산) |
| Compact | 싱글라인 레이아웃 (한 줄에 압축 표시) |

### Config 파일

설정 파일 위치: `~/.claude/plugins/claude-hud/config.json`

## 트러블슈팅

| 증상 | 해결 |
|------|------|
| HUD 미표시 | Claude Code 재시작 |
| Linux EXDEV 오류 | `mkdir -p ~/.cache/tmp && TMPDIR=~/.cache/tmp claude` |
| Ghost install (설치됐으나 동작 안 함) | `/claude-hud:setup` 의 Step 0 참조 |
| Runtime 감지 실패 | Node.js 18+ 또는 Bun 설치 확인 |

## 요구사항

- Claude Code v1.0.80+
- Node.js 18+ 또는 Bun

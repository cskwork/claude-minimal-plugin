---
name: install-plugins
description: Use when a user asks how to install plugins from this marketplace, needs onboarding to the Claude Code plugin system, or encounters plugin installation errors like "marketplace not found" or "plugin not registered"
---

# Plugin Marketplace 설치 가이드

## 개요

Claude Code Plugin은 5가지 구성요소를 하나의 패키지로 묶어 배포하는 단위이다. 설치 스크립트 또는 `/plugin` 명령어로 Claude, Codex, Gemini, GSD에 동시 설치한다.

## 플러그인 구성요소

| 구성 요소 | 역할 | 플러그인 내 경로 | 설치 위치 |
|-----------|------|-----------------|-----------|
| Skills | 특화된 작업 가이드 (SKILL.md) | `skills/<name>/SKILL.md` | `~/.{tool}/skills/` |
| Agents | 하위 에이전트 정의 | `agents/<name>.md` | `~/.{tool}/agents/` |
| Commands | 슬래시 명령어 | `commands/<name>.md` | `~/.claude/commands/` |
| MCP Servers | 외부 서비스 연동 서버 | `mcp-servers/<name>/` | plugin.json 자동 등록 |
| CLI Tools | 커맨드라인 도구 | `tools/<name>/` | `~/.claude/tool-cli/` |

### 도구별 설치 경로 매핑

| 구성요소 | Claude | Codex | Gemini | GSD |
|----------|--------|-------|--------|-----|
| Skills | `~/.claude/skills/` | `~/.codex/skills/` | `~/.gemini/skills/` | `~/.gsd/agent/skills/` |
| Agents | `~/.claude/agents/` | `~/.codex/agents/` | `~/.gemini/agents/` | `~/.gsd/agent/agents/` |
| Commands | `~/.claude/commands/` | - | - | - |
| MCP Servers | plugin.json 자동 | 수동 설정 | 수동 설정 | 수동 설정 |
| CLI Tools | `~/.claude/tool-cli/` | - | - | - |

## plugin.json 스키마

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": { "name": "Author Name" },
  "agents": ["./agents/my-agent.md"],
  "commands": "./commands",
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/mcp-servers/my-server/dist/index.js"],
      "env": { "API_KEY": "${API_KEY}" }
    }
  }
}
```

## 플러그인 카탈로그

| 플러그인 | 카테고리 | Skills | Agents | Commands | 설명 |
|----------|----------|--------|--------|----------|------|
| `minimal` | onboarding | 15 | 6 | 3 | 핵심 스킬만 포함, 외부 연동 없음 |

## 설치 방법

### 방법 A: 설치 스크립트 (권장)

**Mac/Linux:**
```bash
git clone https://github.com/cskwork/claude-minimal-plugin.git
cd claude-minimal-plugin
chmod +x install.sh && ./install.sh
```

설치 스크립트는 4단계를 순서대로 실행한다:
1. Skills -> `~/.claude/skills/`에 심링크
2. Agents -> `~/.claude/agents/`에 심링크
3. Commands -> `~/.claude/commands/`에 심링크
4. CLAUDE.md -> `~/.claude/CLAUDE.md` 설치 (기존 파일 .bak 백업)

### 방법 B: Claude Plugin System

Claude Code 전용으로 `/plugin` 명령어를 사용한다.

#### Step 1: Marketplace 등록 (최초 1회)

```bash
/plugin marketplace add cskwork/claude-minimal-plugin
```

#### Step 2: 플러그인 설치

```bash
/plugin install minimal
```

#### Step 3: 스킬 사용

설치된 스킬은 `/<plugin>:<skill>` 형식으로 호출한다:

```bash
/minimal:install-plugins     # 이 가이드
/minimal:find-skills          # 스킬 검색
/minimal:agent-browser        # 브라우저 자동화 설정
/minimal:claude-hud           # statusline HUD 설정
/minimal:skill-library        # 스킬 카탈로그 관리
/minimal:skill-creator        # 새 스킬 생성 가이드
```

#### Step 4: 업데이트

```bash
/plugin marketplace update    # marketplace 카탈로그 갱신
/plugin update minimal        # 플러그인 업데이트
```

## 플러그인에 새 구성요소 추가하기

### Commands 추가
```
plugins/my-plugin/
  commands/
    my-command.md    # --- name: my-command ...frontmatter ---
```

### MCP Server 추가
```
plugins/my-plugin/
  mcp-servers/
    my-server/
      package.json
      src/index.ts
  .claude-plugin/
    plugin.json      # mcpServers 섹션에 등록
```

### CLI Tool 추가
```
plugins/my-plugin/
  tools/
    my-tool/
      TOOL.md        # 사용법 문서
      bin/            # 실행 파일
```

## 트러블슈팅

| 증상 | 원인 | 해결 |
|------|------|------|
| `marketplace not found` | marketplace 미등록 | `/plugin marketplace add` 실행 |
| `plugin not found` | 플러그인 이름 오타 | 카탈로그 테이블에서 이름 확인 |
| 스킬 호출 무반응 | 플러그인 미설치 | `/plugin install <name>` 실행 |
| 변경 미반영 | 캐시 문제 | Claude Code 재시작 |
| MCP 서버 연결 실패 | 환경 변수 미설정 | plugin.json의 env 섹션 확인 |
| Windows 심링크 실패 | 권한 부족 | 관리자 실행 또는 Developer Mode 활성화 |
| Codex/Gemini에 agent 안 보임 | agents 디렉토리 없음 | `mkdir ~/.codex/agents` 후 재설치 |

## FAQ

**Q: `npx skills`와 `/plugin`의 차이는?**
- `npx skills`: 외부 오픈소스 생태계 (skills.sh)에서 개별 스킬 검색/설치
- `/plugin`: 이 marketplace의 큐레이션된 플러그인 번들 설치

**Q: MCP 서버를 Codex/Gemini에서 사용하려면?**
MCP 서버는 Claude plugin system에서 자동 등록된다. 다른 도구에서 사용하려면 해당 도구의 설정 파일에 MCP config를 수동으로 추가한다.

**Q: 개별 스킬만 설치할 수 있는가?**
플러그인은 번들 단위로 설치된다. 개별 스킬이 필요하면 `library.yaml`의 source URL에서 직접 복사하여 skills 디렉토리에 배치한다.

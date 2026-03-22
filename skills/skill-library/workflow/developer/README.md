# Developer (개발자) 워크플로우

## 이 워크플로우는 무엇인가요?

이 워크플로우는 AI 코딩 에이전트(Claude Code)가 **전문 개발자처럼** 체계적으로 코드를 작성하도록 만들어주는 설정 묶음입니다.

[obra/superpowers](https://github.com/obra/superpowers)라는 오픈소스 프로젝트에서 핵심 내용을 추출하여, 초보자도 쉽게 사용할 수 있도록 구성했습니다.

## 무엇이 들어있나요?

| 파일 | 역할 |
|------|------|
| `CLAUDE.md` | AI에게 전달되는 작업 규칙과 개발 프로세스 |
| `settings.json` | MCP 서버(context7) 연결 설정과 권한 |
| `manifest.yaml` | 이 워크플로우에 포함된 스킬, 에이전트, 명령어 목록 |
| `README.md` | 지금 읽고 있는 이 안내서 |

## 어떤 기능을 제공하나요?

### 1. Superpowers 스킬 파이프라인
코드를 작성하기 전에 반드시 **설계 -> 계획 -> 구현 -> 리뷰 -> 검증** 순서를 따릅니다.
"일단 코드부터 짜자"가 아니라, "먼저 생각하고, 계획하고, 그 다음에 코드를 짠다"는 접근입니다.

### 2. TDD (테스트 주도 개발)
코드를 작성하기 **전에** 테스트를 먼저 작성합니다.
- 테스트가 실패하는 것을 확인한다 (RED)
- 테스트를 통과하는 최소한의 코드를 작성한다 (GREEN)
- 코드를 깔끔하게 정리한다 (REFACTOR)

### 3. 체계적 디버깅
버그가 발생하면 추측하지 않고, 체계적으로 원인을 추적합니다.
증상 수집 -> 가설 수립 -> 가설 검증 -> 근본 원인 수정

### 4. 코드 리뷰
작업이 끝나면 자동으로 코드 리뷰를 수행합니다.
계획 준수, 아키텍처, 보안, 테스트 커버리지를 확인합니다.

### 5. context7 MCP
외부 라이브러리(React, Vue, Express 등)의 **최신 공식 문서**를 실시간으로 조회합니다.
오래된 정보가 아닌, 항상 최신 문법과 사용법을 참고합니다.

## 어떻게 사용하나요?

### 방법 1: 프로젝트에 적용 (권장)
프로젝트 루트의 `.claude/` 디렉토리에 이 워크플로우의 파일들을 복사합니다:

```bash
# 프로젝트 루트에서 실행
cp workflow/developer/CLAUDE.md .claude/CLAUDE.md
cp workflow/developer/settings.json .claude/settings.local.json
```

### 방법 2: 글로벌 적용
모든 프로젝트에 적용하려면 홈 디렉토리의 `.claude/`에 복사합니다:

```bash
cp workflow/developer/CLAUDE.md ~/.claude/CLAUDE.md
cp workflow/developer/settings.json ~/.claude/settings.json
```

### 방법 3: Library 명령어 사용
```bash
/library workflow-use developer
```

## 포함된 스킬 설명

| 스킬 이름 | 언제 사용되나요? |
|-----------|-----------------|
| `brainstorming` | 새 기능을 만들기 전에 아이디어를 정리할 때 |
| `writing-plans` | 구현 계획을 세울 때 |
| `test-driven-development` | 코드를 작성할 때 (항상) |
| `systematic-debugging` | 버그를 고칠 때 |
| `verification-before-completion` | "다 됐어요"라고 말하기 전에 |
| `requesting-code-review` | 작업 완료 후 리뷰를 받을 때 |
| `subagent-driven-development` | 여러 작업을 동시에 처리할 때 |
| `using-git-worktrees` | 별도의 작업 공간이 필요할 때 |

## 주의사항

- `superpowers` 플러그인이 Claude Code에 설치되어 있어야 합니다
  - 설치: `/plugin install superpowers@claude-plugins-official`
- context7 MCP는 인터넷 연결이 필요합니다
- 기존 프로젝트의 CLAUDE.md가 있다면, 이 파일의 내용을 기존 파일에 **병합**하세요 (덮어쓰기하지 마세요)

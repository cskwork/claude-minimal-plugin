# Manager (매니저) 워크플로우

## 이 워크플로우는 무엇인가요?

이 워크플로우는 AI 코딩 에이전트(Claude Code)가 **제품 매니저/프로젝트 리더처럼** 다양한 관점에서 제품을 검토하고 관리하도록 만들어주는 설정 묶음입니다.

[garrytan/gstack](https://github.com/garrytan/gstack)이라는 오픈소스 프로젝트에서 핵심 내용을 추출하여, 초보자도 쉽게 사용할 수 있도록 구성했습니다.

Garry Tan은 Y Combinator의 CEO로, 이 도구는 그의 제품 관리 철학을 AI 워크플로우로 구현한 것입니다.

## 무엇이 들어있나요?

| 파일 | 역할 |
|------|------|
| `CLAUDE.md` | AI에게 전달되는 매니저 역할 규칙과 리뷰 프로세스 |
| `settings.json` | MCP 서버(vibe_kanban) 연결 설정과 권한 |
| `manifest.yaml` | 이 워크플로우에 포함된 스킬, 에이전트, 명령어 목록 |
| `README.md` | 지금 읽고 있는 이 안내서 |

## 핵심 철학: "Boil the Lake" (완전성 원칙)

AI가 작업의 비용을 거의 0으로 만들었다면, **절반만 하지 말고 완전하게 하라**는 원칙입니다.

예를 들어:
- 코드 리뷰를 할 때 → 주요 파일 3개만 보지 말고, **모든 변경 파일**을 본다
- QA를 할 때 → 메인 기능만 테스트하지 말고, **엣지 케이스까지 모두** 테스트한다
- 계획을 세울 때 → 대략적인 방향만 잡지 말고, **구체적인 실행 계획**까지 세운다

## 어떤 기능을 제공하나요?

### 1. CEO 리뷰 (제품 방향성)
"우리가 만들고 있는 것이 정말 최선인가?" 라는 질문으로 시작합니다.
- 현재 계획을 근본적으로 재검토
- 더 나은 제품 비전 탐색
- 범위를 늘릴지, 줄일지, 유지할지 결정

### 2. 엔지니어링 리뷰 (기술 실행)
"이 계획을 어떻게 구현할 것인가?"에 집중합니다.
- 아키텍처와 데이터 흐름 검증
- 성능, 보안, 테스트 커버리지 확인
- 이슈별로 하나씩 대화형으로 해결

### 3. 디자인 리뷰 (사용자 경험)
"사용자가 이것을 쉽고 즐겁게 쓸 수 있는가?"를 평가합니다.
- UX 패턴, 접근성, 반응형 디자인 점검
- 시각적 일관성과 브랜드 정합성 확인

### 4. QA (품질 보증)
실제 브라우저에서 웹 애플리케이션을 테스트합니다.
- 버그를 찾고, 심각도별로 분류하고, 직접 수정
- 수정 전후 비교 스크린샷 제공

### 5. 출시 관리 (Ship)
코드 완성부터 PR 생성까지 출시 프로세스를 자동화합니다.
- 테스트 실행 → diff 리뷰 → 버전 업데이트 → CHANGELOG → PR 생성

## 어떻게 사용하나요?

### 방법 1: 프로젝트에 적용 (권장)
```bash
# 프로젝트 루트에서 실행
cp workflow/manager/CLAUDE.md .claude/CLAUDE.md
cp workflow/manager/settings.json .claude/settings.local.json
```

### 방법 2: 글로벌 적용
```bash
cp workflow/manager/CLAUDE.md ~/.claude/CLAUDE.md
cp workflow/manager/settings.json ~/.claude/settings.json
```

### 방법 3: Library 명령어 사용
```bash
/library workflow-use manager
```

## gstack 전체 설치 (선택사항)

이 워크플로우는 gstack의 핵심 개념만 추출한 것입니다.
gstack의 모든 기능(헤드리스 브라우저 등)을 사용하려면 직접 설치하세요:

```bash
git clone https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

## 포함된 스킬 설명

| 스킬 이름 | 언제 사용되나요? |
|-----------|-----------------|
| `plan-ceo-review` | 제품 방향성을 재검토할 때 |
| `plan-eng-review` | 기술 실행 계획을 확정할 때 |
| `plan-design-review` | UX/디자인을 점검할 때 |
| `qa` | 웹 애플리케이션을 테스트하고 버그를 수정할 때 |
| `ship` | 코드를 출시할 때 |
| `review` | PR이나 코드를 리뷰할 때 |
| `retro` | 개발 회고를 할 때 |

## 주의사항

- gstack의 일부 스킬(`browse`, `qa`)은 Playwright가 설치되어 있어야 합니다
  - `npm install -g playwright` 또는 `npx playwright install`
- vibe_kanban MCP는 프로젝트 관리 보드를 제공합니다 (선택사항)
- 기존 프로젝트의 CLAUDE.md가 있다면, 이 파일의 내용을 기존 파일에 **병합**하세요

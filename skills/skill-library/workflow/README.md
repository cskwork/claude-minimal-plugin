# Workflow (워크플로우)

역할별로 최적화된 AI 코딩 환경 설정 묶음입니다.
각 워크플로우를 프로젝트의 `.claude/` 디렉토리에 복사하면 해당 역할에 맞는 환경이 즉시 구성됩니다.

## 사용 가능한 워크플로우

| 워크플로우 | 대상 역할 | 기반 프로젝트 | 핵심 기능 |
|-----------|----------|-------------|----------|
| [developer](developer/) | 소프트웨어 개발자 | [obra/superpowers](https://github.com/obra/superpowers) | TDD, 체계적 디버깅, 브레인스토밍, 코드 리뷰 |
| [manager](manager/) | 제품 매니저 / 리더 | [garrytan/gstack](https://github.com/garrytan/gstack) | CEO/엔지니어링/디자인 리뷰, QA, 출시 관리 |
| [designer](designer/) | UI/UX 디자이너 | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | 7대 디자인 도메인, 20개 명령어, 안티패턴 |
| [marketer](marketer/) | 콘텐츠 마케터 | 자체 라이브러리 | YouTube 리서치, Excalidraw 시각화 |

## 각 워크플로우에 포함된 파일

```
workflow/<역할>/
  CLAUDE.md        # AI 시스템 프롬프트 (역할별 규칙과 프로세스)
  settings.json    # MCP 서버 연결 + 권한 설정
  manifest.yaml    # 포함된 스킬/에이전트/명령어 목록
  README.md        # 초보자를 위한 상세 안내서 (한국어)
```

## 빠른 시작

### 1. 워크플로우 선택
자신의 역할에 맞는 워크플로우를 선택합니다.

### 2. 프로젝트에 적용
```bash
# 예: 개발자 워크플로우 적용
cp workflow/developer/CLAUDE.md   <프로젝트>/.claude/CLAUDE.md
cp workflow/developer/settings.json <프로젝트>/.claude/settings.local.json
```

### 3. 글로벌 적용 (모든 프로젝트)
```bash
# 예: 매니저 워크플로우를 모든 프로젝트에 적용
cp workflow/manager/CLAUDE.md   ~/.claude/CLAUDE.md
cp workflow/manager/settings.json ~/.claude/settings.json
```

### 4. Library 명령어 사용 (향후 지원)
```bash
/library workflow-use developer
```

## 주의사항

- 기존 `.claude/CLAUDE.md`가 있다면, 내용을 **병합**하세요 (덮어쓰기 주의)
- `settings.json`의 `{{PLACEHOLDER}}`는 실제 API 키로 교체해야 합니다
- 각 워크플로우의 README.md에 상세한 설정 방법이 있습니다
- 워크플로우는 조합 가능합니다 (예: developer + designer)

## 워크플로우 조합

두 개 이상의 워크플로우를 조합하려면:

1. 각 워크플로우의 CLAUDE.md 내용을 하나의 파일에 합칩니다
2. settings.json의 mcpServers를 합칩니다
3. permissions.allow 배열을 합칩니다

예: 개발자 + 디자이너 조합
```bash
# CLAUDE.md는 수동 병합 필요
# settings.json은 mcpServers 키를 합치기
```

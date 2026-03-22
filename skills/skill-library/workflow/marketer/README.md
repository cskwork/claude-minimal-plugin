# Marketer (마케터) 워크플로우

## 이 워크플로우는 무엇인가요?

이 워크플로우는 AI 코딩 에이전트(Claude Code)가 **콘텐츠 마케터처럼** 리서치하고, 시각 자료를 만들고, 콘텐츠를 제작하도록 돕는 설정 묶음입니다.

코딩 능력이 없어도 사용할 수 있습니다. YouTube 영상에서 인사이트를 추출하고, 전문적인 다이어그램을 자동으로 생성합니다.

## 무엇이 들어있나요?

| 파일 | 역할 |
|------|------|
| `CLAUDE.md` | AI에게 전달되는 콘텐츠 제작 규칙과 파이프라인 |
| `settings.json` | 이미지 생성(mcp-image, SVGMaker) MCP 연결 설정 |
| `manifest.yaml` | 이 워크플로우에 포함된 스킬과 도구 목록 |
| `README.md` | 지금 읽고 있는 이 안내서 |

## 어떤 기능을 제공하나요?

### 1. YouTube 트랜스크립트 추출
YouTube 영상의 자막을 텍스트로 추출합니다.

**이런 때 사용합니다:**
- 경쟁사의 YouTube 영상 내용을 분석하고 싶을 때
- 전문가 강연의 핵심 포인트를 정리하고 싶을 때
- 영상 콘텐츠를 블로그 글로 변환하고 싶을 때
- 업계 트렌드를 빠르게 파악하고 싶을 때

**사용 예시:**
```
"이 YouTube 영상의 트랜스크립트를 추출해주세요: https://youtube.com/watch?v=..."
"추출된 내용에서 핵심 포인트 5가지를 정리해주세요"
"이 내용을 블로그 포스트로 변환해주세요"
```

### 2. Excalidraw 다이어그램 생성
텍스트 설명만으로 전문적인 다이어그램을 자동 생성합니다.

**이런 때 사용합니다:**
- 프로세스 흐름도가 필요할 때
- 마인드맵으로 아이디어를 정리하고 싶을 때
- 비교 표나 구조도를 만들고 싶을 때
- 프레젠테이션에 넣을 시각 자료가 필요할 때

**지원하는 다이어그램 종류:**
- 프로세스 플로우차트 (예: 고객 여정)
- 마인드맵 (예: 콘텐츠 아이디어 정리)
- 비교 다이어그램 (예: 우리 제품 vs 경쟁사)
- 조직도 / 구조도
- 타임라인 (예: 프로젝트 일정)

**3가지 출력 형식:**
1. **Obsidian 형식** (.md) - Obsidian 노트에 바로 삽입
2. **표준 형식** (.excalidraw) - Excalidraw 앱에서 편집 가능
3. **애니메이션 형식** (.excalidraw) - 프레젠테이션에서 단계별 표시

### 3. 이미지 생성 (MCP)
AI로 이미지를 생성합니다 (Gemini API 활용).
- 블로그 썸네일
- 소셜 미디어 이미지
- 프레젠테이션 삽화

## 콘텐츠 제작 흐름 (처음부터 끝까지)

```
1. 리서치
   YouTube 영상 → 트랜스크립트 추출 → 핵심 포인트 정리

2. 구조화
   핵심 포인트 → 콘텐츠 구조 설계 → 아웃라인 작성

3. 시각화
   핵심 개념 → Excalidraw 다이어그램 생성

4. 콘텐츠 제작
   아웃라인 + 시각 자료 → 블로그 / 소셜 / 뉴스레터

5. 검토
   품질 체크리스트로 최종 확인
```

## 어떻게 사용하나요?

### 방법 1: 프로젝트에 적용 (권장)
```bash
cp workflow/marketer/CLAUDE.md .claude/CLAUDE.md
cp workflow/marketer/settings.json .claude/settings.local.json
```

### 방법 2: 글로벌 적용
```bash
cp workflow/marketer/CLAUDE.md ~/.claude/CLAUDE.md
cp workflow/marketer/settings.json ~/.claude/settings.json
```

### 방법 3: Library 명령어 사용
```bash
/library workflow-use marketer
```

## MCP 연결 설정

| MCP | 역할 | 필요한 것 |
|-----|------|----------|
| **mcp-image** | AI 이미지 생성 | Gemini API 키 |
| **SVGMaker** | SVG 이미지 생성 | SVGMaker API 키 |

API 키 설정:
1. `settings.json`을 열어주세요
2. `{{GEMINI_API_KEY}}`를 실제 Gemini API 키로 교체
3. `{{SVGMAKER_API_KEY}}`를 실제 SVGMaker API 키로 교체
4. `{{IMAGE_OUTPUT_DIR}}`을 이미지 저장 경로로 교체 (예: `./output/images`)

## 사전 준비

YouTube 트랜스크립트 추출을 위해 `yt-dlp`가 필요할 수 있습니다:
```bash
# Windows
winget install yt-dlp

# macOS
brew install yt-dlp

# 또는 pip
pip install yt-dlp
```

## 주의사항

- YouTube 트랜스크립트는 자막이 있는 영상에서만 추출 가능합니다
- 자동 생성 자막은 정확도가 낮을 수 있으니 확인이 필요합니다
- 다른 사람의 콘텐츠를 사용할 때는 반드시 출처를 명시하세요
- API 키는 절대 공개 저장소에 업로드하지 마세요
- 기존 프로젝트의 CLAUDE.md가 있다면, 이 파일의 내용을 기존 파일에 **병합**하세요

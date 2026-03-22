# Vibe Coder 워크플로우

## 이 워크플로우는 무엇인가요?

Supanova Design Skill을 기반으로 한 **Vibe Coder** 워크플로우입니다. 프리미엄 랜딩 페이지와 웹 프로토타입을 빠르게 만들어내는 데 특화되어 있습니다.

## 왜 필요한가요?

일반적인 AI 코드 생성은 템플릿처럼 보이는 결과물을 만들기 쉽습니다. Vibe Coder는:
- AI 특유의 "제네릭" 패턴을 제거합니다
- 프리미엄 타이포그래피, 모션, 레이아웃을 강제합니다
- 완전한 HTML을 출력합니다 (잘림/생략 없음)
- 한국어 콘텐츠에 최적화되어 있습니다

## 무엇이 들어있나요?

| 파일 | 역할 |
|------|------|
| `CLAUDE.md` | Vibe Coder 시스템 프롬프트 - 디자인 원칙, 설정 파라미터, 워크플로우 |
| `settings.json` | Context7, Icons8, SVGMaker MCP 연결 설정 |
| `manifest.yaml` | Supanova 4개 스킬 + 라이브러리 스킬 목록 |
| `README.md` | 이 안내서 |

## Supanova 스킬 구성

| 스킬 | 용도 |
|------|------|
| supanova-design-engine | 코어 디자인 엔진. Tailwind + Pretendard + Iconify 기반 랜딩 페이지 |
| supanova-redesign-engine | 기존 페이지 감사 후 점진적 개선 |
| supanova-premium-aesthetic | 프리미엄 미학 - 글래스 모피즘, 더블 베젤, 마이크로 모션 |
| supanova-full-output | HTML 출력 잘림 방지. 플레이스홀더 패턴 차단 |

## 설정 파라미터

| 파라미터 | 범위 | 기본값 | 설명 |
|----------|------|--------|------|
| DESIGN_VARIANCE | 1-10 | 7 | 레이아웃 실험성 |
| MOTION_INTENSITY | 1-10 | 6 | 애니메이션 수준 |
| VISUAL_DENSITY | 1-10 | 5 | 화면당 콘텐츠 밀도 |
| LANDING_PURPOSE | enum | conversion | 페이지 목적 |

## 어떻게 사용하나요?

### 방법 1: 프로젝트에 적용 (권장)
```bash
/library workflow-use vibe-coder
```

### 방법 2: 글로벌 적용
```bash
/library workflow-use vibe-coder --global
```

### 방법 3: 수동 복사
```bash
cp workflow/vibe-coder/CLAUDE.md .claude/CLAUDE.md
cp workflow/vibe-coder/settings.json .claude/settings.local.json
```

## 사용 예시

```
"SaaS 제품 랜딩 페이지 만들어줘 - AI 기반 코드 리뷰 도구"
"이 페이지 리디자인해줘 - 더 프리미엄하게"
"포트폴리오 페이지, DESIGN_VARIANCE=9, MOTION_INTENSITY=8로"
```

## 주의사항

- SVGMaker MCP를 사용하려면 `SVGMAKER_API_KEY` 환경변수가 필요합니다
- Supanova 스킬이 설치되지 않은 경우 `/library use supanova-design-engine` 등으로 개별 설치하세요
- 출처: [uxjoseph/supanova-design-skill](https://github.com/uxjoseph/supanova-design-skill)

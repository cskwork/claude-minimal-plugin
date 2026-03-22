---
name: korean-frontend-defaults
description: 한국 시장 대상 프론트엔드 프로젝트의 공통 로컬라이제이션 오버라이드. Pretendard 폰트, word-break keep-all, 한국어 콘텐츠 패턴, standalone HTML 출력. taste-skill 계열 디자인 skill과 함께 적용.
metadata:
  related-skills: taste-skill, redesign-skill, minimalist-skill, brutalist-skill, soft-skill, stitch-skill, output-skill
---

# 한국 프론트엔드 기본 설정 (Korean Frontend Defaults)

이 스킬은 taste-skill 계열 디자인 스킬과 함께 적용되어, 한국 시장을 대상으로 하는 프론트엔드 결과물의 로컬라이제이션 기본값을 강제합니다. 디자인 스킬의 시각적 지침은 그대로 유지하되, 출력 형식·폰트·콘텐츠·UI 패턴을 한국 시장에 맞게 오버라이드합니다.

## 1. 출력 형식 - Standalone HTML

### 프레임워크 금지 규칙
React, Next.js, Vue, Svelte 등 모든 프레임워크 사용을 금지합니다. 모든 결과물은 **단일 HTML 파일**로 출력합니다.

### 필수 HTML 구조 템플릿

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>페이지 제목</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Pretendard 폰트 CDN -->
    <link rel="stylesheet" as="style" crossorigin
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.min.css" />

    <!-- Tailwind 설정 -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Pretendard Variable', 'Pretendard', '-apple-system', 'BlinkMacSystemFont', 'system-ui', 'Roboto', 'Helvetica Neue', 'Segoe UI', 'Apple SD Gothic Neo', 'Noto Sans KR', 'Malgun Gothic', 'sans-serif'],
                        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
                    },
                },
            },
        }
    </script>

    <!-- 한국어 타이포그래피 기본 스타일 -->
    <style>
        body {
            word-break: keep-all;
            overflow-wrap: break-word;
        }
        p, li, dd, td, th, label, span {
            letter-spacing: -0.01em;
        }
        h1, h2, h3, h4, h5, h6 {
            letter-spacing: -0.03em;
        }
    </style>
</head>
<body class="font-sans antialiased">
    <!-- 콘텐츠 -->
</body>
</html>
```

### 엄격한 출력 규칙
* **JSX 금지:** `useState`, `useEffect`, `useRef` 등 React 훅 사용 불가.
* **npm install 금지:** 패키지 매니저로 설치하는 의존성 사용 불가.
* **인터랙션:** 순수 Vanilla JavaScript로 구현. `Alpine.js` CDN은 허용.
* **단일 파일 출력:** HTML, CSS, JS 모두 하나의 `.html` 파일에 포함.
* **CDN만 허용:** 외부 라이브러리가 필요하면 반드시 CDN 링크로 포함.

## 2. 한국어 타이포그래피

### 기본 폰트: Pretendard
Pretendard를 주 폰트로 사용합니다. `Noto Sans KR` 단독 사용은 금지합니다. Pretendard가 이미 Apple SD Gothic Neo, Noto Sans KR 등을 폴백으로 포함하므로 별도 설정이 불필요합니다.

### word-break 설정
한국어는 음절 단위가 아닌 **어절 단위** 줄바꿈이 자연스럽습니다:
```css
body {
    word-break: keep-all;
    overflow-wrap: break-word;
}
```
* `word-break: keep-all` — 한국어 텍스트가 단어 중간에서 끊기지 않도록 방지.
* `overflow-wrap: break-word` — 매우 긴 단어(URL 등)가 컨테이너를 넘지 않도록 보장.

### 자간(Letter Spacing) 보정
한국어 글꼴은 영문보다 글자 간격이 넓어 보이므로, 미세 보정이 필요합니다:
* **본문:** `letter-spacing: -0.01em`
* **제목/헤딩:** `letter-spacing: -0.03em`
* **단어 간격:** `word-spacing: -0.05em` (미세 조정)

### 행간(Line Height) 설정
한국어 본문은 영문보다 더 넓은 행간이 필요합니다:
* **본문:** `line-height: 1.7` ~ `line-height: 1.8`
* **제목:** `line-height: 1.3` ~ `line-height: 1.4`

### 제목 텍스트 래핑
```css
h1, h2, h3 {
    text-wrap: balance;
}
```
* `text-wrap: pretty` 또는 `text-wrap: balance`를 사용하여 제목의 줄바꿈을 시각적으로 균형 있게 배분합니다.

### 글자 크기 보정
한국어는 같은 `font-size`에서 영문보다 시각적으로 작게 보입니다. 다음을 준수하세요:
* CTA 버튼 텍스트는 최소 `text-base` (16px) 이상 사용.
* 본문 텍스트는 `text-base` 이상 권장.
* 캡션/보조 텍스트도 `text-xs` (12px) 미만으로 줄이지 않기.

### Tailwind 적용 예시
```html
<!-- 제목 -->
<h1 class="text-4xl md:text-6xl font-bold tracking-tighter leading-tight">
    팀 협업의 새로운 기준
</h1>

<!-- 본문 -->
<p class="text-base text-gray-600 leading-relaxed tracking-tight max-w-[65ch]"
   style="letter-spacing: -0.01em; line-height: 1.75;">
    복잡한 프로젝트도 한눈에 파악하고, 팀원들과 실시간으로 소통하세요.
</p>

<!-- CTA 버튼 -->
<button class="text-base px-6 py-3 font-medium">
    무료로 시작하기
</button>
```

## 3. 한국 시장 콘텐츠 규칙

### 한국어 사용자 이름
"John Doe", "Jane Smith" 등 영문 이름을 **절대 사용하지 않습니다.** 반드시 아래 한국식 이름을 사용하세요:

| 이름 | 성별 | 용도 예시 |
|------|------|-----------|
| 김서연 | 여 | 사용자 프로필, 리뷰 |
| 이준혁 | 남 | 팀원 카드, 대시보드 |
| 박하은 | 여 | 고객 후기, 댓글 |
| 최민수 | 남 | 관리자, 매니저 역할 |
| 정다은 | 여 | 블로그 작성자, 에디터 |
| 강지호 | 남 | 개발자, 엔지니어 역할 |
| 윤서아 | 여 | 디자이너, 크리에이터 |
| 임태현 | 남 | 팀 리더, CEO |
| 한소율 | 여 | 마케터, 기획자 |
| 오재윤 | 남 | 데이터 분석가, PM |

### 한국어 기업명
"Acme Corp", "Nexus Inc" 등 영문 가상 기업명을 **절대 사용하지 않습니다.** 반드시 아래 한국식 기업명을 사용하세요:

| 기업명 | 용도 예시 |
|--------|-----------|
| 넥스트랩 | SaaS, B2B 소프트웨어 |
| 블루밍크 | 디자인, 크리에이티브 |
| 텀블벅 | 크라우드펀딩, 커머스 |
| 리멤버 | 네트워킹, 비즈니스 |
| 그린랩스 | 농업, 환경, 테크 |
| 와디즈 | 투자, 펀딩 |
| 스푼라디오 | 미디어, 오디오 |
| 클래스101 | 교육, 온라인 강의 |

### CTA 텍스트 변환 테이블
영문 CTA를 그대로 번역하지 말고, 한국 시장에 맞는 자연스러운 표현을 사용하세요:

| 영문 CTA | 한국어 CTA |
|----------|------------|
| Get Started | 시작하기 |
| Sign Up Free | 무료로 시작하기 |
| Learn More | 자세히 보기 |
| Try It Now | 지금 체험하기 |
| Book a Demo | 데모 신청하기 |
| Contact Us | 문의하기 |
| Download | 다운로드 |
| Subscribe | 구독하기 |

### 금지 카피 패턴 (한국어 AI 슬롭)
다음 표현은 과도하게 사용된 마케팅 클리셰입니다. **절대 사용하지 마세요:**

* "혁신적인"
* "차별화된"
* "최적화된"
* "원스톱"
* "올인원"
* "새로운 패러다임"
* "게임 체인저"
* "넥스트 레벨"
* "완벽한 솔루션"
* "맞춤형 서비스"
* "~의 시대가 열리다"
* "~를 재정의하다"

### 좋은 한국어 카피 원칙
**구체적이고 평이한 언어**를 사용하세요. 사용자가 얻는 실질적 가치를 명확하게 전달합니다:

| 판정 | 예시 |
|------|------|
| O (좋음) | "팀 업무를 한곳에서 관리하세요" |
| X (나쁨) | "혁신적인 올인원 업무 솔루션" |
| O (좋음) | "매출 데이터를 실시간으로 확인하세요" |
| X (나쁨) | "차별화된 데이터 인사이트 플랫폼" |
| O (좋음) | "3분 만에 온라인 스토어를 만드세요" |
| X (나쁨) | "새로운 패러다임의 커머스 솔루션" |

### 한국어 전화번호 형식
```
010-3847-1928    (휴대전화)
02-6388-5100     (서울 유선)
```

### 한국 원화 표기
```
월 29,000원
연 348,000원
19,900원/월 (부가세 별도)
```

### 한국어 날짜/시간 형식
```
2026년 3월 21일
오후 2:30
3일 전
2026.03.21
```

## 4. 한국어 UI 패턴

### 네비게이션 라벨
한국어 서비스의 표준 네비게이션 구조입니다:

```html
<nav>
    <a href="#">홈</a>
    <a href="#">서비스</a>
    <a href="#">가격</a>
    <a href="#">소개</a>
    <a href="#">문의</a>
    <div class="auth">
        <a href="#">로그인</a>
        <a href="#">회원가입</a>
    </div>
</nav>
```

### 폼 라벨 및 플레이스홀더

```html
<!-- 회원가입 폼 예시 -->
<form>
    <label for="name">이름</label>
    <input id="name" type="text" placeholder="홍길동" />

    <label for="email">이메일</label>
    <input id="email" type="email" placeholder="example@email.com" />

    <label for="phone">휴대전화</label>
    <input id="phone" type="tel" placeholder="010-0000-0000" />

    <label for="company">회사명 (선택)</label>
    <input id="company" type="text" placeholder="회사명을 입력하세요" />

    <label for="password">비밀번호</label>
    <input id="password" type="password" placeholder="8자 이상 입력하세요" />

    <button type="submit">가입하기</button>
</form>
```

### 폼 에러 메시지

| 상황 | 에러 메시지 |
|------|------------|
| 필수 항목 미입력 | "필수 입력 항목입니다" |
| 이메일 형식 오류 | "올바른 이메일 주소를 입력해주세요" |
| 비밀번호 규칙 미달 | "비밀번호는 8자 이상이어야 합니다" |
| 전화번호 형식 오류 | "올바른 전화번호를 입력해주세요" |
| 중복 가입 | "이미 가입된 이메일입니다" |
| 로그인 실패 | "이메일 또는 비밀번호를 확인해주세요" |
| 네트워크 오류 | "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요" |

### 푸터 구조
한국 서비스의 푸터에는 사업자 정보 표기가 법적으로 필요합니다:

```html
<footer>
    <!-- 회사 정보 -->
    <div class="company-info">
        <p>주식회사 넥스트랩</p>
        <p>대표자명: 임태현</p>
        <p>사업자등록번호: 123-45-67890</p>
        <p>통신판매업신고번호: 제2026-서울강남-01234호</p>
        <p>주소: 서울특별시 강남구 테헤란로 123, 4층</p>
        <p>고객센터: 02-6388-5100 (평일 09:00~18:00)</p>
        <p>이메일: support@nextlab.kr</p>
    </div>

    <!-- 법적 링크 -->
    <div class="legal-links">
        <a href="#">개인정보처리방침</a>
        <a href="#">이용약관</a>
        <a href="#">고객센터</a>
    </div>

    <p class="copyright">Copyright 2026 NextLab Inc. All rights reserved.</p>
</footer>
```

### 푸터 필수 요소 체크리스트
* **사업자등록번호:** `000-00-00000` 형식.
* **대표자명:** 반드시 표기.
* **통신판매업신고번호:** 온라인 거래 서비스라면 필수.
* **법적 링크:** "개인정보처리방침"은 반드시 별도 링크로 분리. "이용약관"과 함께 푸터 하단에 배치.
* **고객센터:** 전화번호 + 운영시간 또는 이메일 주소.

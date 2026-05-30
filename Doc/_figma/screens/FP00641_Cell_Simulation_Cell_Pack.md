> ⚠️ **이 파일은 이관되었습니다 (2026-05-30).** 진실 source 는 다음 파일입니다:
> `C:\Projects\NSCM\Doc\_figma\screens\FP00641_Cell_Simulation_Cell_Pack.md`
> 본 파일은 분석서 호환성을 위해 유지됨.
# FP00641_Cell_Simulation_Cell_Pack.UIL — Figma 디자인 링크

> **이 파일의 역할**: Figma 디자인 파일·프레임의 링크를 명시. 사용자(이규철님)가 Figma 작성 후 채웁니다. 클로드 코드는 이 파일에서 디자인 명세를 가져옵니다.

작성일: 2026-05-08 (자동) | 매핑된 As-Is: FP00641_Cell_Simulation_Cell_Pack.UIL

---

## 1. Figma 링크

| 항목 | 링크 / 값 |
|---|---|
| Figma 파일 | (예: https://www.figma.com/file/XXXX/LGES-GSCM-ToBe) |
| 화면 프레임 | (예: https://www.figma.com/file/XXXX/...?node-id=YYYY) |
| Components 라이브러리 | (예: https://www.figma.com/file/ZZZZ/LGES-Design-System) |
| Wireframe (저밀도) | (옵션) |
| High-fidelity Mockup | (옵션) |
| Prototype (인터랙션) | (옵션) |

## 2. 디자인 명세 발췌

### 2.1 색상 토큰 (디자인 시스템)
- Primary: `#XXXXXX`
- Secondary: `#XXXXXX`
- Success / Warning / Error: `#XXXXXX` / `#XXXXXX` / `#XXXXXX`

### 2.2 타이포그래피
- Heading 1: 24px / Bold
- Body: 14px / Regular
- Caption: 12px / Regular

### 2.3 간격 (Spacing)
- Section: 32px
- Component: 16px
- Inline: 8px

### 2.4 컴포넌트 변형
- Button: Primary / Secondary / Tertiary / Danger
- Input: Default / Disabled / Error / Success

(상세는 `_figma/` 디자인 시스템 문서 참조)

## 3. 화면별 디자인 결정 사항

### 3.1 레이아웃
- Filter Bar 위치: (상단 / 좌측 / 우측 토글 가능)
- Grid Frozen 컬럼: (없음 / 2개 / 3개)
- Footer Toolbar: (sticky / static)

### 3.2 인터랙션
- 검색 트리거: Enter / 자동 (입력 0.5초 debounce)
- 그리드 편집: 더블클릭 / 단일클릭+Enter
- 저장 confirm: 모달 / 토스트만

### 3.3 반응형 동작
- ≥ 1280px: 풀 레이아웃
- 768~1280px: Filter Bar 접기
- < 768px: 모바일 미지원 (또는 별도 화면)

## 4. 미정 (사용자 작성 시 채움)

- [ ] Figma 파일 링크
- [ ] 화면 프레임 링크
- [ ] 디자인 시스템 토큰 확정
- [ ] Prototype 링크

## 5. 참고

- To-Be 설계: [`tobe_design.md`](./tobe_design.md)
- 컴포넌트 매핑: [`web_components.md`](./web_components.md)
- Figma 폴더: [`/Doc/_figma/`](../../../_figma/)


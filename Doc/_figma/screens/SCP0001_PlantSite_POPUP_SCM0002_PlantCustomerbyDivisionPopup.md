> ⚠️ **이 파일은 이관되었습니다 (2026-05-30).** 진실 source 는 다음 파일입니다:
> `C:\Projects\NSCM\Doc\_figma\screens\SCP0001_PlantSite_POPUP_SCM0002_PlantCustomerbyDivisionPopup.md`
> 본 파일은 분석서 호환성을 위해 유지됨.
# SCP0001_PlantSite_POPUP_SCM0002_PlantCustomerbyDivisionPopup — Figma 디자인 링크 (Common SCM POPUP)

> **이 파일의 역할**: Figma 디자인 파일·프레임의 링크를 명시. 사용자(이규철님)가 Figma 작성 후 채웁니다. 클로드 코드는 이 파일에서 디자인 명세를 가져옵니다.

작성일: 2026-05-22 | 매핑된 As-Is: SCP0001_PlantSite_POPUP_SCM0002_PlantCustomerbyDivisionPopup (POPUP)

---

## 1. Figma 링크

| 항목 | 링크 / 값 |
|---|---|
| Figma 파일 | (예: https://www.figma.com/file/XXXX/LGES-GSCM-ToBe) |
| 화면 프레임 | (예: https://www.figma.com/file/XXXX/...?node-id=YYYY) |
| Components 라이브러리 | (예: https://www.figma.com/file/ZZZZ/LGES-Design-System) |
| 부모 화면 프레임 | SCP0001_PlantSite (광범위한 공통 SCM Popup) |

## 2. 디자인 명세 (공통 SCM POPUP — 다수 화면 공유)

### 2.1 색상 토큰
- Primary: `#XXXXXX`
- Dialog 헤더 배경: `#F5F7FA`

### 2.2 타이포그래피
- Dialog Title: 18px / Bold
- Body: 14px / Regular

### 2.3 간격
- Dialog padding: 24px
- Section gap: 16px

### 2.4 컴포넌트 변형 (POPUP)
- Dialog: MUI `<Dialog maxWidth="md">` (~850px)
- Search bar: MUI `<TextField>` + `<Button>` (Find)
- Result Grid: Wijmo `<FlexGrid>` (single selection)

## 3. 화면별 디자인 결정 사항

### 3.1 레이아웃 (As-Is 850 x 400)
- 상단: Filter (검색어 입력)
- 중단: Grid (검색 결과)
- 하단: Apply / Close (sticky)

### 3.2 인터랙션
- 검색: Enter 키 또는 Find 버튼
- 선택: 단일 행 클릭 + Enter 또는 더블클릭
- Apply: 부모 화면 행에 결과값 채움

### 3.3 반응형
- ≥ 768px: 모달 유지
- < 768px: fullscreen 모달

## 4. 미정 (사용자 작성 시 채움)

- [ ] Figma 파일 링크
- [ ] 화면 프레임 링크
- [ ] 디자인 토큰 확정

## 5. 참고

- To-Be 설계: [`tobe_design.md`](./tobe_design.md)
- 컴포넌트 매핑: [`web_components.md`](./web_components.md)
- 부모 화면: SCP0001_PlantSite (광범위한 공통 SCM Popup)


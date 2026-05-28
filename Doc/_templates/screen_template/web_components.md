# [SCREEN_ID] — Web 컴포넌트 매핑

> **이 파일의 역할**: WinForms 컨트롤별로 To-Be Web 컴포넌트가 무엇이 될지 매핑. 라이브러리 미확정 상태에서는 "일반 Web 의미"로 적고, 결정 후 구체 라이브러리 컴포넌트명을 채웁니다.

작성일: YYYY-MM-DD | 매핑된 As-Is: [SCREEN_ID]

---

## 매핑 표

| As-Is (WinForms) | 컨트롤명 | To-Be (Web 일반) | 결정 후 (라이브러리 컴포넌트) | 비고 |
|---|---|---|---|---|
| TextBox | txtKeyword | `<input type="text">` 또는 SearchInput | (예: MUI `<TextField>`) | placeholder 활용 |
| GrapeCity DropDown | cmbDivision | Select 컴포넌트 | (예: MUI `<Autocomplete>`, AntD `<Select>`) | async 옵션 로드 |
| FarPoint Spread (메인) | spMain | DataGrid (편집 가능) | (예: AG-Grid `<AgGridReact>`, SpreadJS `<SpreadSheets>`) | ⚑ 그리드 라이브러리 결정 직접 영향 |
| FarPoint Spread (조회용) | spReport | DataGrid (read-only) | (예: AG-Grid Community / MUI DataGrid) | 페이지네이션·내보내기 |
| DevExpress XtraEditors.SimpleButton | btnSearch | `<button type="submit">` | (예: MUI `<Button variant="contained">`) | Primary action |
| DevExpress XtraLayout (LayoutControl) | layoutMain | Flex/Grid CSS layout | (CSS Grid 또는 라이브러리 Grid 컴포넌트) | 반응형 |
| DevExpress XtraNavBar | navMenu | Sidebar Menu | (예: MUI `<Drawer>` + `<List>`) | 화면 안 메뉴면 사용 |
| GrapeCity PluginCalendar | dtpFrom / dtpTo | DatePicker / DateRangePicker | (예: MUI `<DatePicker>`, react-day-picker) | 한국어 로케일 |
| GrapeCity PluginInputMan | numQty | NumberInput (포맷팅) | (예: react-number-format) | 천단위, 소숫점 |
| MessageBox.Show | (코드 호출) | Toast/Modal | (예: react-toastify, MUI `<Snackbar>`) | 비차단 vs 차단 구분 |
| OpenFileDialog | (코드 호출) | File Upload | (예: react-dropzone, native input[type=file]) | 다중 파일 |
| SaveFileDialog | (코드 호출) | File Download | (브라우저 download 속성) | Blob URL |
| Custom Popup Form | popupXxx | Modal/Dialog | (예: MUI `<Dialog>`, AntD `<Modal>`) | 라우터 통합 |
| Office2016 Theme | (전체) | 디자인 시스템 | (Material 3 / 사내 DS) | 토큰 기반 |

## SCM.Popup (마스터 코드 팝업) 매핑 — 핵심

LG GSCM의 모든 화면이 `GSCM.SCM.Popup.UIL` (in-degree 168)을 통해 마스터 코드(사업부/품목/조직 등)를 팝업으로 선택합니다. 이는 To-Be에서 다음 중 하나로 통합:

| 옵션 | 설명 | 적합 상황 |
|---|---|---|
| **Modal Picker** | 버튼 클릭 → Modal에서 검색·선택 → 본 화면 입력란에 값 채움 | 복잡한 검색이 필요한 마스터 (품목, BOM) |
| **Autocomplete** | 입력란에 직접 검색하면서 결과 드롭다운 | 단순 코드 (사업부, 통화) |
| **Master Data Service** | 단일 상태 관리(React Query) + Modal/Autocomplete 공유 | 모든 화면 공통 |

**권고**: Master Data Service 패턴으로 마스터 데이터를 서비스화하여, 모든 화면이 동일한 hook/component를 호출.

## 그리드 매핑 (FarPoint Spread → Web 그리드)

FarPoint Spread는 GSCM 메인 그리드로 **288 csproj**가 의존합니다. 다음 기능이 To-Be에서 보존되어야 합니다.

| FarPoint 기능 | Web 그리드 후보 | 우선순위 |
|---|---|---|
| 인라인 셀 편집 | AG-Grid Enterprise / SpreadJS / Handsontable | High |
| 컬럼 그룹 헤더 (다단) | AG-Grid / SpreadJS | High |
| Frozen columns/rows | 모두 | High |
| 셀 병합 | SpreadJS / Handsontable | Med |
| 수식 (CalcEngine) | SpreadJS (Excel 호환) | Med |
| 셀 단위 검증 (CellChanged) | 모두 | High |
| Excel 내보내기 (FarPoint.Excel) | AG-Grid CSV/Excel / SpreadJS native | High |
| Chart 통합 (FarPoint.Win.Chart) | 별도 차트 라이브러리 | Med |
| PDF 출력 (FarPoint.PDF) | jsPDF + html2canvas | Low |
| Drag·Drop 행 이동 | AG-Grid Enterprise | Med |
| 풍부한 필터 헤더 | AG-Grid / MUI DataGrid Pro | Med |

**라이브러리 비교 (라이선스·가격 결정 시)**:

| 라이브러리 | 라이선스 | 강점 | 약점 |
|---|---|---|---|
| AG-Grid Community/Enterprise | MIT / Commercial | 가장 완전, 성능 우수 | Enterprise 라이선스 필요 |
| SpreadJS | Commercial (GrapeCity) | Excel 호환·수식 | 라이선스 비용 큼 |
| Handsontable | Commercial / 비상업 무료 | Excel 시트 느낌 | 상업용 라이선스 |
| MUI DataGrid (Pro) | MIT / Commercial | MUI 통합 | 편집 기능 제한 |

## 미확정 사항 (라이브러리 결정 후 채움)

- [ ] 컴포넌트 라이브러리: (Material UI / Ant Design / Chakra / 자체)
- [ ] 그리드: (AG-Grid / SpreadJS / Handsontable / MUI DataGrid)
- [ ] 폼: (React Hook Form / Formik)
- [ ] 차트: (Recharts / Chart.js / ECharts / D3)
- [ ] 모달: (라이브러리 내장 vs 자체 wrapper)

라이브러리 결정 후 본 표의 "결정 후 (라이브러리 컴포넌트)" 컬럼을 채웁니다.

## 참고

- 표준 컴포넌트 카탈로그: [`/Doc/_dev_rules/12_GRID_COMMON.md`](../../../_dev_rules/12_GRID_COMMON.md) (Grid) + [`/Doc/_dev_rules/03_FE_RULES.md`](../../../_dev_rules/03_FE_RULES.md) (Form/UI). 구 `_vibe_coding/web_component_library.md` 는 `_archive/_vibe_coding/` 로 이관
- As-Is 분석: [`analysis.md`](./analysis.md)
- To-Be 설계: [`tobe_design.md`](./tobe_design.md)

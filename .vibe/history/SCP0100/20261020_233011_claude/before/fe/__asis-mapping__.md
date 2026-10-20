# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `__asis-mapping__.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CA-101 | §1 [원문 무번호] AS-IS / TO-BE | — | 표 헤더 행(실제 항목 아님) | 해당없음 |
| CA-102 | §1 [원문 무번호] FindButton / `hotkeyConfig.search = handleSearch` | `GlobalPsiReport.tsx:173-182` hotkeyConfig.search | | 구현 |
| CA-103 | §1 [원문 무번호] ExcelButton / SubTitle 내장 EXCEL | `GlobalPsiReport.tsx` SubTitle 내장 EXCEL(표준 컴포넌트 승계) | | 구현 |
| CA-104 | §1 [원문 무번호] SaveButton/InsertButton/DeleteButton/ManualButton/UploadButton / 미배선(`false`) | `GlobalPsiReport.tsx:173-182` hotkeyConfig insert/save/delete/manual/upload=false | read-only 리포트 — 표준버튼 명시적 false 배선(숨김 아님) | 구현 |
| CA-105 | §1 [원문 무번호] usrButton1 / 미이관(dead control) | — | AS-IS designer 실측: EventName=null·Controls.Add 미등록·codeBehind 참조 0건(design 01_layout.md §1) → dead control, 포팅 제외 | 제외 |
| CB-101 | §2 [원문 무번호] AS-IS 컨트롤 / TO-BE searchCondition | — | 표 헤더 행(실제 항목 아님) | 해당없음 |
| CB-102 | §2 [원문 무번호] cboDivision / `divisionId` | `components/GlobalPsiReportForm.tsx:304-309` single(LBL.DIVISION) | | 구현 |
| CB-103 | §2 [원문 무번호] dtpFrom / `fromYyyymmdd` | `components/GlobalPsiReportForm.tsx:336` textField('From (YYYYMMDD)') | | 구현 |
| CB-104 | §2 [원문 무번호] dtpTo / `toYyyymmdd` | `components/GlobalPsiReportForm.tsx:337` textField('To (YYYYMMDD)') | | 구현 |
| CB-105 | §2 [원문 무번호] cboPlanDate / `planStartYyyymmdd` | `components/GlobalPsiReportForm.tsx:323-330` single(LBL.PLAN_DATE) | | 구현 |
| CB-106 | §2 [원문 무번호] cboPlanType / `planType` | `components/GlobalPsiReportForm.tsx:381-386` single(LBL.PLAN_TYPE) | | 구현 |
| CB-107 | §2 [원문 무번호] cboBucket / `bucket` | `components/GlobalPsiReportForm.tsx:333-335` single(LBL.BUCKET) | | 구현 |
| CB-108 | §2 [원문 무번호] cboDisplay / `display` | `components/GlobalPsiReportForm.tsx:357-363` single(LBL.DISPLAY) | | 구현 |
| CB-109 | §2 [원문 무번호] cboSearchLevel / `searchLevel` | `components/GlobalPsiReportForm.tsx:371-380` single(LBL.SEARCH_LEVEL, R4 disable) | | 구현 |
| CB-110 | §2 [원문 무번호] cboFromSite / `fromSite` | `components/GlobalPsiReportForm.tsx:311-316` multi(LBL.FROM_SITE) | | 구현 |
| CB-111 | §2 [원문 무번호] cboToSite / `toSite` | `components/GlobalPsiReportForm.tsx:317-322` multi(LBL.TO_SITE) | | 구현 |
| CB-112 | §2 [원문 무번호] txtItemId / `itemId` | `components/GlobalPsiReportForm.tsx:395-400` popupField('Item ID', onItemSearch) | | 구현 |
| CB-113 | §2 [원문 무번호] txtNickName / `nickName` | `components/GlobalPsiReportForm.tsx:407` textField(LBL.NICK_NAME) | | 구현 |
| CB-114 | §2 [원문 무번호] txtProject / `project` | `components/GlobalPsiReportForm.tsx:401-406` popupField(LBL.PROJECT, onProjectSearch) | | 구현 |
| CB-115 | §2 [원문 무번호] (CELL_GROUP) / `cellGroup` | `components/GlobalPsiReportForm.tsx:393` textField(LBL.CELL_GROUP) | | 구현 |
| CB-116 | §2 [원문 무번호] chkCellQty / `chkCellQty` | `components/GlobalPsiReportForm.tsx:420-428` Checkbox(LBL.CELL_QTY) | | 구현 |
| CB-117 | §2 [원문 무번호] chkAS / `chkAs` | `components/GlobalPsiReportForm.tsx:413-419` Checkbox('AS 포함') | | 구현 |
| CB-118 | §2 [원문 무번호] (세션) / — | `useGlobalPsiReportStore.ts:177,184` userId/debugMode | | 구현 |
| CB-119 | §2 [원문 무번호] CboGraphType / 미배선 | — | AS-IS 핸들러 본문 공백(NO-OP, screen-analysis.json events) + LBL 미등록(design 02 부록 B-5) → 의도적 미구현 | 제외 |
| CC-101 | §3 [원문 무번호] AS-IS FpSpread / TO-BE SHEETS | — | 표 헤더 행(실제 항목 아님) | 해당없음 |
| CC-102 | §3 [원문 무번호] spdDetail / REPORT | `global-psi-report.constants.ts:15` SHEETS.REPORT | | 구현 |
| CC-103 | §3 [원문 무번호] spdSearchLevel / SEARCH_LEVEL | `global-psi-report.constants.ts:16` SHEETS.SEARCH_LEVEL | | 구현 |
| CC-104 | §3 [원문 무번호] spdSearchLevelDetail / SEARCH_LEVEL_DETAIL | `global-psi-report.constants.ts:17` SHEETS.SEARCH_LEVEL_DETAIL | | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:GlobalPsiReportModals | FE 실존 모달 (components/GlobalPsiReportModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `components/GlobalPsiReportModals.tsx` ColumnLayoutModal/MeasureSelectModal | AS-IS SCM0002_TitleSetForm_Popup(컬럼/measure 개인화) 대응. hasButton('COLUMN_SETUP'/'MEASURE_SELECT') 게이트, saveTitleSet 후 fetchStaticColumns/Measures+invalidateQueries 재조회(design 02 §4.6 B3/B4) | 구현 |
| MODAL:ItemByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | `GlobalPsiReport.tsx` ItemByDivisionModal(resultProps ItemID→itemId) | | 구현 |
| MODAL:ProjectByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | `GlobalPsiReport.tsx` ProjectByDivisionModal(resultProps ProjectCode→project) | | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — Insert 기능 없음(read-only 리포트, AS-IS 저장류 SP 없음) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음(read-only 리포트) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `components/GlobalPsiReportModals.tsx:70-91,106-117` ColumnLayoutModal/MeasureSelectModal onSave → invalidateQueries([MENU_ID]) + fetchStaticColumns/fetchStaticMeasures |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 저장 없음(titleSet 개인화 저장은 공용 모달 saveTitleSet 경로) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | SubTitle 내장 EXCEL(공용 gridAction dataMap 승계) | 셀 콤보 0건(design 03_grid-columns.md §0 "CELL_COMBO_DATA_TYPE 전건 공란 실측") — 코드 그대로가 원장 값, 매핑 대상 컬럼 없음 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | `components/GlobalPsiReportForm.tsx` textField/popupField(cellGroup/itemId/project/nickName) — `onChange={e => onChange(e.target.value)}` raw passthrough, FE 분해·제한 없음(raw 전달 계약 유지) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `components/GlobalPsiReportGrid.tsx:167` DataGrid(공용 컴포넌트 소비, FlexGridFilter) | rebindFilterColumns 는 공용 DataGrid 내장 — 화면 배선 불요 | 구현 |

## 1. 화면 성격 / 툴바

| AS-IS | TO-BE | 비고 |
|---|---|---|
| FindButton | `hotkeyConfig.search = handleSearch` | 조회는 무해 → 항상 허용(design 01 B1) |
| ExcelButton | SubTitle 내장 EXCEL | design 01 B2 |
| SaveButton/InsertButton/DeleteButton/ManualButton/UploadButton | 미배선(`false`) | read-only 리포트 — 표준버튼 hasButton 미노출 |
| usrButton1 | 미이관(dead control) | design 01 §2 — 본문 무의미, 포팅 제외 |

## 2. 조회조건 (영역2) — 16조건 + 팝업 4 (design 02)

| AS-IS 컨트롤 | TO-BE searchCondition | SP 파라미터 | 비고 |
|---|---|---|---|
| cboDivision | `divisionId` | P_DIVISION_ID | Division_SCP 공유콤보 + FE 3중 제외(EE/'40'/'82', design 02 §2.7) |
| dtpFrom | `fromYyyymmdd` | P_FROM_YYYYMMDD | dStart>dPlan 검증(design 02 §4.4) |
| dtpTo | `toYyyymmdd` | P_TO_YYYYMMDD | |
| cboPlanDate | `planStartYyyymmdd` | P_PLAN_START_YYYYMMDD | SP P_SCP0100_GET_PLAN_DATE (division·bucket cascade) |
| cboPlanType | `planType` | P_PLAN_TYPE | lookup PLAN_TYPE, 기본 'FN'. 자동재조회는 NO-OP(design 01 §2) |
| cboBucket | `bucket` | P_BUCKET | MONTHLY 기본. M_/W_ pivot visible 토글(design 03 §2.5) |
| cboDisplay | `display` | (레이아웃 전용) | lookup STOCK_TREND_DISPLAY, 기본 GRID. D1~D4(design 01) |
| cboSearchLevel | `searchLevel` | P_SEARCH_LEVEL | lookup PRODUCT_LEVEL, idx0=CELL_GROUP |
| cboFromSite | `fromSite` | P_FROM_SITE | SP P_SCP0100_GET_SITE load-once (cascade 아님, design 02 §2.2) |
| cboToSite | `toSite` | P_TO_SITE | SP P_SCP0100_GET_SITE load-once |
| txtItemId | `itemId` | P_ITEM_ID | btnItemId → ItemByDivisionModal |
| txtNickName | `nickName` | P_NICK_NAME | |
| txtProject | `project` | P_PROJECT | btnProject → ProjectByDivisionModal |
| (CELL_GROUP) | `cellGroup` | P_CELL_GROUP | |
| chkCellQty | `chkCellQty` | P_CHK_CELL_QTY | AS-IS NO-OP(design 01 §2) |
| chkAS | `chkAs` | P_CHK_AS | AS-IS NO-OP(design 01 §2) |
| (세션) | — | P_USER_ID / DEBUG_MODE | session.userId / 'N' 고정 |
| CboGraphType | 미배선 | — | AS-IS NO-OP(design 01 §2). LBL 미등록 |

메인 GET SP: `PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT` (17 IN + O_RC1 + O_RESULT_CURSOR).
dispatcher: MONTHLY→_MM_DATAONLY / WEEKLY→_WW_DATAONLY (design 03 §4.2).

## 3. 그리드 (영역3) — 3시트 (design 03)

| AS-IS FpSpread | TO-BE SHEETS | 고정컬럼 | 노출 조건(design 01 R1~R3) |
|---|---|---|---|
| spdDetail | REPORT | 15 | searchMode=DETAIL |
| spdSearchLevel | SEARCH_LEVEL | 9 | searchMode=SEARCH & searchLevel≠CELL_GROUP_DETAIL |
| spdSearchLevelDetail | SEARCH_LEVEL_DETAIL | 9 | searchMode=SEARCH & searchLevel=CELL_GROUP_DETAIL |

- 컬럼 메타: admin `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID='SCP0100') 3시트 동적 fetch(`fetchStaticColumns`).
- measure 메타: `SCM_MST_SHEET_MEASURE` sheetNm='Global PSI New' 36행(`fetchStaticMeasures`).
  주의(design 03 §6.2): 메인 데이터 SP sheetName='Global PSI Report' 지만 SHEET_MEASURE 는 'Global PSI New' — 표기 상이.
- 동적 pivot 기간칼럼: `PKG_SCP0100.GET_SHEET_CALENDAR_3SPAN`. M_(월)/W_(주) 표시, B_(BOH 보조) 숨김(width0).
- 3행 헤더 span: 월/주/Qty 3단 병합. plan_start 월 Red, 주 A/B Blue.
- measure 배경 8그룹: MEASURE_NAME 스위치(design 03 §3-B). 색상 메타 컬럼 부재 → 코드 스위치 재현.
- 셀콤보 0(신규행 콤보 없음).

## 4. 특이 로직

- 영역1 동적 레이아웃: rgrpSearchLevel + cboSearchLevel 조합으로 3그리드 show/hide, cboDisplay → SplitContainer 비율.
- Division 권한 0 → 조회영역 disable + MSG00097 (design 01 A1). USER_GR_MNU_MPG_M 2행 등록으로 실발동 안 함(부록 B-6).
- Unit(Qty) 로컬 표시배율: `unitScaleIndex` (design 02 §2.5). 서버 재조회 없이 그리드 클라 나눗셈.

## 5. validation / expressions 매핑

- dStart > dPlan alert → `MSG.PLAN_DATE_RANGE`(design 02 §4.4). 확인필요: 정확 MSG_ID 미실측 — 비카탈로그 key.
- Division 권한 0 → `MSG.NO_DIVISION_AUTH`(MSG00097). 코드 보존(실발동 안 함).
- expressions: measure 배경색 8그룹(design 03 §3-B), pivot 컬럼 색상(plan_start Red / week A·B Blue).

## 6. 미해결 / 확인필요

- (design 01 §5-1) admin 버튼 메타(SCM_ADM_MNU_BTN_MPG_M) — 05_register.sql 에서 SEARCH/EXCEL 버튼정의·권한 멱등 등록(Task#5).
- Graph Type 라벨 LBL 미등록(design 02 부록 B-5) — 05_register 에서 신규 채번 검토.

## §1 컨트롤 (2026-10-20 하네스 대사 — check.js G04 · As-is controls.csv 26종)

> 위치 약어: Form=`components/GlobalPsiReportForm.tsx` · Page=`GlobalPsiReport.tsx` · Grid=`components/GlobalPsiReportGrid.tsx` · Modals=`components/GlobalPsiReportModals.tsx` · Store=`useGlobalPsiReportStore.ts` · Const=`global-psi-report.constants.ts` · Cols=`utils/globalPsiReportColumns.ts`. As-is = `SCP0100_Global_PSI_Report.cs`.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrButton1 / UsrButton | — | designer 실측 EventName=null·Controls.Add 미등록·codeBehind 참조 0건 = dead control(CA-105 동일) | 제외 |
| D00-1-002 | §1 rgrpSearchLevel / RadioGroup (Search Level / Detail) | Form:392-397 single('Search Mode', SEARCH_MODE_OPTIONS) · Store:188-191 setSearchMode | 공용 RadioGroup 카탈로그 부재 → 2지선다 CustomDropdown 대체(값·동작 동일) | 구현 |
| D00-1-003 | §1 chkCellQty / UsrCheckBox | Form:468-472 Checkbox(LBL.CELL_QTY) → Store:215 chkCellQty 'Y'/'N' |  | 구현 |
| D00-1-004 | §1 cboPlanDate / UsrCombo (setListBox CODE/NAME, OnShown idx0) | Form:132-138 planDateQuery(planDate 시트) · Form:186-190 첫 항목 기본값 · Form:355-367 single(LBL.PLAN_DATE) |  | 구현 |
| D00-1-005 | §1 cboBucketType / UsrCombo (ControlValues=Monthly .cs:606) | Form:370-380 single(LBL.BUCKET) · Const:114 BUCKET_DEFAULT=MONTHLY · Store:97 |  | 구현 |
| D00-1-006 | §1 dCalendar / UsrDateRangePicker3 (조회기간 From:To) | Form:382-383 textField From/To(YYYYMMDD) → Store:201-202 · 초기값 Form:192-210 seedCalendar(D00-2-019) | 초기값(SetCalendar)은 D00-2-019 별도 행 | 구현 |
| D00-1-007 | §1 cboGraphType / UsrCombo | — | 핸들러 본문 공백(.cs:1773 NO-OP) + 차트 미이관 + LBL 미등록(부록 B-5) — CB-119 동일 | 제외 |
| D00-1-008 | §1 btnItemId / UsrButton | Form:441-446 popupField(onItemSearch) → Page:265-271 ItemByDivisionModal |  | 구현 |
| D00-1-009 | §1 btnMeasure / UsrButton | Page:205-215 customButtons hasButton('MEASURE_SELECT') → Modals:97 MeasureSelectModal |  | 구현 |
| D00-1-010 | §1 txtItemId / UsrTextBox | Form:441-446 popupField · Store:204 itemId |  | 구현 |
| D00-1-011 | §1 cboDisplay / UsrCombo (lookup STOCK_TREND_DISPLAY, DefineProperty idx2) | Form:406-412 single(LBL.DISPLAY) · Store:98 DISPLAY_CODE.GRID | 콤보·기본값 구현. Chart/All 레이아웃 전환은 D00-2-007(제외 — 빈 차트 영역만 드러냄) | 구현 |
| D00-1-012 | §1 txtProject / UsrTextBox | Form:447-452 popupField · Store:213 project |  | 구현 |
| D00-1-013 | §1 clbFromSite / UsrCheckedList2 (GetSiteList FROM_SITE) | Form:108-114 fromSiteQuery(site 시트) · Form:343-348 multi(LBL.FROM_SITE) · Store:138-143 siteParam |  | 구현 |
| D00-1-014 | §1 clbToSite / UsrCheckedList2 (GetSiteList TO_SITE) | Form:119-125 toSiteQuery(site 시트) · Form:349-354 multi(LBL.TO_SITE) · Store:138-143 siteParam |  | 구현 |
| D00-1-015 | §1 txtCellGroup / UsrTextBox | Form:435-439 textField(LBL.CELL_GROUP) · Store:212 cellGroup |  | 구현 |
| D00-1-016 | §1 btnProject / UsrButton | Form:447-452 popupField(onProjectSearch) → Page:276-291 ProjectByDivisionModal |  | 구현 |
| D00-1-017 | §1 cboPlanType / UsrCombo (lookup PLAN_TYPE, SelectedValue='FN' .cs:628) | Form:427-432 single(LBL.PLAN_TYPE) · Const:105 PLAN_TYPE_DEFAULT · Store:96 |  | 구현 |
| D00-1-018 | §1 btnColumn / UsrButton | Page:194-203 customButtons hasButton('COLUMN_SETUP') → Modals:62 ColumnLayoutModal |  | 구현 |
| D00-1-019 | §1 cboSearchLevel / UsrCombo (lookup PRODUCT_LEVEL, idx0 .cs:621) | Form:413-426 single(LBL.SEARCH_LEVEL, Detail 시 disable) · Store:99 CELL_GROUP |  | 구현 |
| D00-1-020 | §1 chkAS / UsrCheckBox | Form:459-463 Checkbox('AS 포함') → Store:216 chkAs 'Y'/'N' |  | 구현 |
| D00-1-021 | §1 cboUnitQty / UsrCombo (ScpUtils.GetUnitQty) | Form:399-405 single(LBL.UNIT_QTY, UNIT_QTY_OPTIONS) · Const:137 UNIT_QTY_SCALE |  | 구현 |
| D00-1-022 | §1 clbDivision / UsrCheckedList2 (dtMyDivision, 권한 0건 SetDivisionAuthCheck .cs:583) | Form:93 useTabComboQueries(Division_SCP) · Form:140-148 3중 제외 · Form:166-176 권한 0건 alert · Form:330-342 single(LBL.DIVISION) | As-is CheckedList 이나 To-Be 는 단일 Division(design 02 §2.7 · SP P_DIVISION_ID 단일값) | 구현 |
| D00-1-023 | §1 chartMain / ChartControl (splitContainer1.Panel1) | — | As-is 원문 실측(2026-10-20): designer.cs:1445 `DataBindings = null` · 디자이너 기본 Series 1개(점 0)만 있고 .cs 본문의 chartMain 참조 0건 · 유일한 데이터 주입 후보 `SetCalculating_chart()` 는 주석(.cs:1870) → 데이터가 한 번도 바인딩되지 않는 빈 차트(사실상 dead control, usrButton1 D00-1-001 과 같은 판정). 또한 차트 컴포넌트가 프레임워크 카탈로그·map_control.csv 에 없어 도입 금지(new_screen.md) → GEN_NOTES '룰 보완 후보' 등록 | 제외 |
| D00-1-024 | §1 spdSearchLevel / FpSpread | Const:16 SHEETS.SEARCH_LEVEL · Page:76-82 levelQuery · Grid:167 DataGrid |  | 구현 |
| D00-1-025 | §1 spdDetail / FpSpread | Const:15 SHEETS.REPORT · Page:69-75 reportQuery · Grid:167 DataGrid |  | 구현 |
| D00-1-026 | §1 spdSearchLevelDetail / FpSpread | Const:17 SHEETS.SEARCH_LEVEL_DETAIL · Page:83-89 levelDetailQuery · Grid:167 DataGrid |  | 구현 |

## §2 이벤트 (2026-10-20 하네스 대사 — check.js G03 · As-is events.csv 18건 + 프레임워크 유틸 1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load → Form_Load(.cs:511) InitForm·InitControls(.cs:575 권한 Division·PlanDate·Bucket Monthly·UnitQty)·CreateSpread·InitEvent | Page:144-151 mount(복원·메타 fetch) · Form:93,132,186-190 · Store:90-108 makeInitSearch | InitControls 의 SetCalendar(.cs:600) 는 D00-2-019(구현) | 구현 |
| D00-2-002 | §2 this / Shown → SCP0100_Global_PSI_Report_Shown(.cs:528) InitControlsAfter(SearchLevel idx0·PlanType FN·From/To Site·Display)+DefineProperty(Display idx2·rgrp 0)+OnShown PlanDate idx0(.cs:524) | Form:96-98 lookup · Form:108-125 Site · Form:186-190 PlanDate 첫 항목 · Store:96-99,122 기본값 |  | 구현 |
| D00-2-003 | §2 clbDivision / SelectedIndexChanged → RefreshPlant + SetVisibleColumnDivision(본문 공백 .cs:1311) + ClearDataSource(.cs:1769) | Form:335-341 confirmIfDirtyKey → Store:177-187 setDivision(filters={} 그리드 초기화) | RefreshPlant 결과 dtPlant 는 화면 내 소비처 없음(조회 파라미터 미사용) | 구현 |
| D00-2-004 | §2 cboGraphType / SelectedIndexChanged (.cs:1773 본문 공백) | — | NO-OP — 살아있는 동작 없음 | 제외 |
| D00-2-005 | §2 cboPlanDate / SelectedIndexChanged (.cs:1784) SetCalendar + InitSpread + SetGridClear | Form:355-367 set(planStartYyyymmdd)+clearFilters() · Form:205-210 seedCalendar(Plan Date 변경 감지) | 그리드 초기화 + SetCalendar(D00-2-019) 모두 구현 | 구현 |
| D00-2-006 | §2 cboBucketType / SelectedIndexChanged (.cs:1798) SetSpreadColumn + SetGridClear + FindData(:1812) | Form:370-380 set(bucket)+onSearch() · Cols:69-73 M_/W_ 가시성 | EditButton(.cs:1809)은 read-only 리포트라 대상 없음 | 구현 |
| D00-2-007 | §2 cboDisplay / SelectedIndexChanged (.cs:1824) splitContainer Panel1(차트)/Panel2(그리드) 비율 전환 | Form:406-412 display 값 보존 · Store:98 기본 GRID(idx2 = SplitterDistance 0, 차트 영역 숨김과 같은 화면) | 핸들러가 바꾸는 것은 Panel1MinSize/SplitterDistance(0/750/270)뿐이고 Panel1 의 유일한 내용물 chartMain 은 데이터가 한 번도 바인딩되지 않는 빈 차트(D00-1-023 제외 근거) → Chart/All 은 빈 영역만 넓혀 그리드를 줄이는 효과. 기본값 Grid 화면은 동일. 빈 패널 재현 여부는 사용자 결정 항목(GEN_NOTES) | 제외 |
| D00-2-008 | §2 cboSearchLevel / SelectedIndexChanged (.cs:1853) VisibleSheet + SetLayout + SetGridClear + FindData(isLoadFinish) | Form:413-426 set(searchLevel)+onSearch() · Page:63-67 activeSheet · Store:219-227 활성 시트만 filter |  | 구현 |
| D00-2-009 | §2 cboUnitQty / SelectedIndexChanged (.cs:1864) SetCalculating(로컬 배율) | Form:399-405 setUnitScaleIndex · Grid:88-89,143-151 pivot 셀 값/배율 | 서버 재조회 없음(As-is 동일) | 구현 |
| D00-2-010 | §2 rgrpSearchLevel / SelectedIndexChanged (.cs:1900) EnableSearchLevel + VisibleSheet + InitSpread + SetLayout | Form:392-397 setSearchMode · Form:424-425 Detail 시 SearchLevel disable · Page:63-67 activeSheet | 자동조회 없음(As-is 동일) | 구현 |
| D00-2-011 | §2 btnItemId / Click (.cs:1932) SCM0002_ItembyDivisionPopup(division, itemId) → txtItemId | Page:265-271 ItemByDivisionModal(preSearchParams divisionId·itemId) |  | 구현 |
| D00-2-012 | §2 btnMeasure / Click (.cs:1951) SCM0002_TitleSetForm_Popup('SCP0100','Global PSI New',false) → InitSpread | Page:205-215 · Modals:97 MeasureSelectModal(MEASURE_SHEET_NAME) → fetchStaticMeasures |  | 구현 |
| D00-2-013 | §2 btnProject / Click (.cs:1967) SCM0002_ProjectbyDivisionPopup(division, project) → txtProject | Page:276-291 ProjectByDivisionModal |  | 구현 |
| D00-2-014 | §2 cboPlanType / SelectedIndexChanged (.cs:1985 본문 공백) | — | NO-OP — 살아있는 동작 없음 | 제외 |
| D00-2-015 | §2 btnColumn / Click (.cs:1990) SCM0002_TitleSetForm_Popup('SCP0100', ActiveSheet, true) → InitSpread+SetLayout | Page:194-203 · Modals:62 ColumnLayoutModal(activeSheet) → fetchStaticColumns |  | 구현 |
| D00-2-016 | §2 dCalendar / ValueChanged (.cs:2006) 시작일>Plan 시작일 경고 + plan_start:end 복원 + InitSpread | Page:156-169 validatePlanDateRange(handleSearch:172 선행) · Page:119-133 calendarQuery(기간 변경 시 헤더 재조회) | 텍스트 입력 키 단위 경고를 피하려 판정 시점을 조회 직전으로 둠 — 위반 시 조회 미발사 + 시작일 복원(결과 동일) | 구현 |
| D00-2-017 | §2 chkCellQty / CheckedChanged (.cs:1915 본문 전부 주석) | — | 주석 처리 코드(commented_calls) 이식 금지 — 살아있는 동작 없음 | 제외 |
| D00-2-018 | §2 chkAS / CheckedChanged (.cs:1924 본문 전부 주석) | — | 주석 처리 코드(commented_calls) 이식 금지 — 살아있는 동작 없음 | 제외 |
| D00-2-019 | §2 SetCalendar / GetDayRange(.cs:1317·1384 MONTH) 조회기간 초기값 = PlanDate YYYYMM01 : GetPlanEndDate(.cs:2029 biz CommonData PLAN_END_DATE, division '81' 고정·WEEKLY) — Load·PlanDate 변경 시 | Form:192-210 planEndFilters·useTabComboQueries(SCPPlanPeriod_SCP)·seedCalendar effect · Store:235-243 seedCalendar · utils/globalPsiReportCalendar.ts:6-14 planDayRange(YYYYMM+'01' : HORIZON_END_DATE, 빈 값이면 null=기간 유지) · Store:60-62 calendarSeedPlan 가드 · Const:33-45 PLAN_END_* · __tests__/GlobalPsiReport.spec.ts TC-SCP0100-001~004 | 종료일 원천 = 기존 등록 콤보 SCPPlanPeriod_SCP 재사용(D00-4-004) — 신규 DB 객체 불필요. 시드 후 calendar(3SPAN) 헤더 조회가 기간 값으로 자동 발사(Page:123-133) | 구현 |

## §4 엔드포인트 (2026-10-20 하네스 대사 — check.js G02 · 사내 배선 proc_meta.csv 2026-10-20 실측)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-4-001 | SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN (GetSpdTitle .cs:1322 p_start/p_end_yyyymmdd) | Page:119-137 useTabProcQuery(AUX_SHEET.CALENDAR, startYyyymmdd/endYyyymmdd) | 사내 배선 calendar/SEARCH → P_SCP0100_CALENDAR_GET → PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN | 구현 |
| D00-4-002 | SCP.SCP0100_GET_SITE (GetSiteList .cs:1335 p_site_tpye/p_division_id/p_bucket) | Form:104-125 useTabProcQuery(AUX_SHEET.SITE, pSiteTpye FROM_SITE/TO_SITE) | 사내 배선 site/SEARCH → P_SCP0100_SITE_GET → PKG_SCP0100.P_SCP0100_GET_SITE | 구현 |
| D00-4-003 | SCP.SCP0100_GET_PLAN_DATE (GetPlanDate .cs:1357 p_program_id='SCP0100') | Form:128-138 useTabProcQuery(AUX_SHEET.PLAN_DATE, programId=PLAN_DATE_PROGRAM_ID) | 사내 배선 planDate/SEARCH → P_SCP0100_PLAN_DATE_GET → PKG_SCP0100.P_SCP0100_GET_PLAN_DATE | 구현 |
| D00-4-004 | biz:CommonData.CommonDataList_REPORT (GetPlanEndDate .cs:2035 PLAN_END_DATE) | Form:196-204 useTabComboQueries({comboId:'SCPPlanPeriod_SCP', planName, divisionId:'81'}) · Const:41-45 | As-is 원문(MSSQL dbo.UP_FX_GetCommonDataList_REPORT, 2026-10-20 직접 조회) `SELECT TOP 1 HORIZON_END_DATE FROM SCM_MST_PLAN WHERE DIVISION_ID=@param1 AND PLAN_NAME=@param2 AND PLAN_CYCLE=@param3` ↔ 사내 SCM_ADM_CMBO_SQL_M 'SCPPlanPeriod_SCP' 같은 표·같은 3조건(PLAN_CYCLE='WEEKLY' 고정 = As-is 호출값). 사내 (DIVISION_ID,PLAN_NAME,PLAN_CYCLE) 중복 0건 → 첫 행 = TOP 1. allowed_gaps `^biz:CommonData` → useTabComboQueries 규칙 그대로 | 구현 |
| D00-4-005 | 메인 GET PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT (FindData — QueryDics, 17 IN) | Page:69-90 useTabProcQuery 3시트 · Store:197-229 setFilter(IN 17 = proc_params COL_NM) | 사내 배선 report/searchLevel/searchLevelDetail SEARCH → P_SCP0100_GET (DoD B22 17개 일치) | 구현 |

## §6 동적 컬럼 (2026-10-20 — 타이틀 SP · As-is DB루프 컬럼 생성, check.js M08/M09 · DoD B26/B27)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-6-001 | GetSpdTitle / 1322 (타이틀 SP SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN — dsSpdTitle) | Page:119-137 calendarQuery · Grid:74-77 toCalendarCols(o_rc1: COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME) | 응답 키 o_rc1 = proc_params OUT COL_NM(DoD B26) | 구현 |
| D00-6-002 | InitSpreadDateColumn / 755 (DB루프 컬럼 생성 ← 타이틀 SP — `IndexOf("B_") > 0` 이면 AddTextColumn 폭 0 숨김) | Cols:69-73 isColVisibleForBucket(B_ 숨김) | 사내 3SPAN 원문(PKG_SCP0100 BODY L416~ · 2026-10-20 ALL_SOURCE)은 'W_'·'M_' 두 블록만 생성, B_ 이름 없음 → 분기 도달 불가(동등) | 구현 |
| D00-6-003 | InitSpreadDateColumn / 760 (DB루프 컬럼 생성 ← 타이틀 SP — AddNumColumn 폭 70 visible) | Cols:79-127 buildPivotColumns(leaf width 70, n0) · Grid:79-82 dynamicColumns |  | 구현 |
| D00-6-004 | InitSpreadDateColumn / 767·774·778 (헤더 ForeColor — M_ & plan_start 월 Red / W_ 라벨 A·B Blue) | Grid:100-117 formatItem ColumnHeader | As-is 는 라벨(sColumnLabelname) A/B 포함 판정, To-Be 는 바인딩 끝자리 A/B 판정(W_202405A 형식 — 원문 L1209 주석) | 구현 |
| D00-6-005 | InitSpreadDateColumn / 787·794 (ColumnHeaderSpan 3단 — Large 월 / Small 주 / Qty) | Cols:100-126 large>small>leaf 그룹 헤더 · Grid:174-175 allowMerging·headerRowHeight |  | 구현 |

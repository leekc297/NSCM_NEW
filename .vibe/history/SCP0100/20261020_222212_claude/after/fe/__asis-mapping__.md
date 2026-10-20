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

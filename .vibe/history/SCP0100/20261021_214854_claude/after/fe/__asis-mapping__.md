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
| CB-102 | §2 [원문 무번호] cboDivision / `divisionId` | `components/GlobalPsiReportForm.tsx:362-375` multi(LBL.DIVISION, 다중+ALL, required) · `useGlobalPsiReportStore.ts:89-93,140-145` 기본 ''(ALL)·divisionParam | 2026-10-21 정정: AS-IS clbDivision=UsrCheckedList2 다중(체크 0건=ALL→'' .cs:464-471) · 카탈로그 Div.=선택·다중+ALL버튼 — 기존 단일 콤보는 근거 불일치 | 구현 |
| CB-103 | §2 [원문 무번호] dtpFrom / `fromYyyymmdd` | `components/GlobalPsiReportForm.tsx:403-409` PeriodField(start, LBL.PERIOD) · `:221-232` changePeriod | 2026-10-21 정정: AS-IS 는 dCalendar(UsrDateRangePicker3 "Period*" designer:1262) 1개 — 텍스트 2칸·리터럴 라벨을 공용 PeriodField 로 교체(자매 global-psi/elec 동일) | 구현 |
| CB-104 | §2 [원문 무번호] dtpTo / `toYyyymmdd` | `components/GlobalPsiReportForm.tsx:403-409` PeriodField(end) | CB-103 과 같은 dCalendar(Text2) | 구현 |
| CB-105 | §2 [원문 무번호] cboPlanDate / `planStartYyyymmdd` | `components/GlobalPsiReportForm.tsx:323-330` single(LBL.PLAN_DATE) | | 구현 |
| CB-106 | §2 [원문 무번호] cboPlanType / `planType` | `components/GlobalPsiReportForm.tsx:449-457` single(LBL.PLAN_TYPE, disabled) | AS-IS PlanType.Enabled=false(designer:1159) · 카탈로그 비고 "비활성화_Final Plan" → 'FN' 고정 비활성(2026-10-21) | 구현 |
| CB-107 | §2 [원문 무번호] cboBucket / `bucket` | `components/GlobalPsiReportForm.tsx:333-335` single(LBL.BUCKET) | | 구현 |
| CB-108 | §2 [원문 무번호] cboDisplay / `display` | `useGlobalPsiReportStore.ts:96` display=GRID 기본값만 보존 · Form 미렌더 | AS-IS layDisplay.Visibility=Never(designer:1180) → 화면 미노출(2026-10-21 정정, 기존 노출은 근거 불일치) | 구현 |
| CB-109 | §2 [원문 무번호] cboSearchLevel / `searchLevel` | `components/GlobalPsiReportForm.tsx:435-447` single(LBL.SEARCH_LEVEL, R4 disable) · `useGlobalPsiReportStore.ts:216-218` Detail 이면 'DETAIL' | | 구현 |
| CB-110 | §2 [원문 무번호] cboFromSite / `fromSite` | `components/GlobalPsiReportForm.tsx:376-381` multi(LBL.FROM_SITE) · `:110-121` fromSiteQuery | | 구현 |
| CB-111 | §2 [원문 무번호] cboToSite / `toSite` | `components/GlobalPsiReportForm.tsx:382-387` multi(LBL.TO_SITE) · `:122-133` toSiteQuery | | 구현 |
| CB-112 | §2 [원문 무번호] txtItemId / `itemId` | `components/GlobalPsiReportForm.tsx:472-478` popupField(LBL.MODEL_NICKNAME, onItemSearch) · `GlobalPsiReport.tsx:265-275` MaterialByDivisionModal | 2026-10-21 정정: AS-IS layModel "Model / Nick Name"(designer:1055-1060) · 카탈로그 Model/Nickname·메1(Material by Division) — 라벨 'Item ID'·ItemByDivisionModal 교체 | 구현 |
| CB-113 | §2 [원문 무번호] txtNickName / `nickName` | `useGlobalPsiReportStore.ts:208` setFilter nickName='' 고정 | 2026-10-21 정정: AS-IS 에 txtNickName 컨트롤 없음(designer 실측) · FindDataMain p_nick_name=""(.cs:1245) → 별도 Nick Name 입력칸 제거, P_NICK_NAME '' 전송이 AS-IS 동작 | 구현 |
| CB-114 | §2 [원문 무번호] txtProject / `project` | `components/GlobalPsiReportForm.tsx:479-484` popupField(LBL.PROJECT='PJT', onProjectSearch) · `GlobalPsiReport.tsx:280-295` ProjectByDivisionModal | 카탈로그 Project→PJT(LBL00012) | 구현 |
| CB-115 | §2 [원문 무번호] (CELL_GROUP) / `cellGroup` | `components/GlobalPsiReportForm.tsx:467-471` textField(LBL.CELL_GROUP) | | 구현 |
| CB-116 | §2 [원문 무번호] chkCellQty / `chkCellQty` | `components/GlobalPsiReportForm.tsx:495-503` Checkbox(LBL.CELL_QTY) · `useGlobalPsiReportStore.ts:105` 기본 true | 기본 체크 = designer:248 Checked=true(2026-10-21 정정) | 구현 |
| CB-117 | §2 [원문 무번호] chkAS / `chkAs` | `components/GlobalPsiReportForm.tsx:486-494` Checkbox(LBL.AS='A/S' LBL01167) | 라벨 = AS-IS chkAS.Text "A/S"(designer:927) — 리터럴 'AS 포함' 교체(2026-10-21) | 구현 |
| CB-118 | §2 [원문 무번호] (세션) / — | `useGlobalPsiReportStore.ts:177,184` userId/debugMode | | 구현 |
| CB-119 | §2 [원문 무번호] CboGraphType / 미배선 | — | AS-IS 핸들러 본문 공백(NO-OP, screen-analysis.json events) + LBL 미등록(design 02 부록 B-5) → 의도적 미구현 | 제외 |
| CC-101 | §3 [원문 무번호] AS-IS FpSpread / TO-BE SHEETS | — | 표 헤더 행(실제 항목 아님) | 해당없음 |
| CC-102 | §3 [원문 무번호] spdDetail / REPORT | `global-psi-report.constants.ts:15` SHEETS.REPORT | | 구현 |
| CC-103 | §3 [원문 무번호] spdSearchLevel / SEARCH_LEVEL | `global-psi-report.constants.ts:16` SHEETS.SEARCH_LEVEL | | 구현 |
| CC-104 | §3 [원문 무번호] spdSearchLevelDetail / SEARCH_LEVEL_DETAIL | `global-psi-report.constants.ts:17` SHEETS.SEARCH_LEVEL_DETAIL | | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:GlobalPsiReportModals | FE 실존 모달 (components/GlobalPsiReportModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `components/GlobalPsiReportModals.tsx` ColumnLayoutModal(Modals:64, fallbackColumns 71-78)/MeasureSelectModal(Modals:107) | AS-IS SCM0002_TitleSetForm_Popup(컬럼/measure 개인화) 대응. hasButton('COLUMN_SETUP'/'MEASURE_SELECT') 게이트, saveTitleSet 후 fetchStaticColumns/Measures+invalidateQueries 재조회(design 02 §4.6 B3/B4) ⚠ 2026-10-21 실측 정정: 버튼 클릭 시 titleset 0행·/column 9행 수신인데 모달 목록 'No Column' — 공용 ColumnLayoutModal 은 titleSet 이 없으면 fallbackColumns 로 목록을 만드는데 미전달. 처리 지침: GlobalPsiReportModals.tsx ColumnLayoutModal 에 fallbackColumns={staticColumns[RESPONSE_SET.MAIN].map(c => ({ key: c.colNm, header: c.colLblNm, width: c.width }))} 추가(SalesPlanModals 패턴) — 게이트 check.js H02 → 2026-10-21 보완: Modals:71-78 fallbackColumns=staticColumns[activeSheet](colNm/colLblNm/colWth/display/personalizable, SalesPlanModals 동형) — H02 해소(런타임 모달 목록은 미검증) | 구현  |
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
| clbDivision | `divisionId` | P_DIVISION_ID | Division_SCP 공유콤보 + FE 3중 제외(EE/'40'/'82', design 02 §2.7). 다중 CSV·미선택=ALL('') — UsrCheckedList2(2026-10-21 정정) |
| dCalendar(Text1) | `fromYyyymmdd` | P_FROM_YYYYMMDD | dStart>dPlan 검증(.cs:2006) — PeriodField |
| dCalendar(Text2) | `toYyyymmdd` | P_TO_YYYYMMDD | PeriodField |
| cboPlanDate | `planStartYyyymmdd` | P_PLAN_START_YYYYMMDD | SP P_SCP0100_GET_PLAN_DATE (division·bucket cascade) |
| cboPlanType | `planType` | P_PLAN_TYPE | lookup PLAN_TYPE, 기본 'FN'. 비활성(PlanType.Enabled=false designer:1159). 자동재조회는 NO-OP |
| cboBucket | `bucket` | P_BUCKET | MONTHLY 기본. M_/W_ pivot visible 토글(design 03 §2.5) |
| cboDisplay | `display` | (레이아웃 전용) | 기본 GRID. AS-IS layDisplay.Visibility=Never → 화면 미노출(2026-10-21 정정) |
| cboSearchLevel | `searchLevel` | P_SEARCH_LEVEL | lookup PRODUCT_LEVEL, idx0=CELL_GROUP |
| cboFromSite | `fromSite` | P_FROM_SITE | SP P_SCP0100_GET_SITE load-once (cascade 아님, design 02 §2.2) |
| cboToSite | `toSite` | P_TO_SITE | SP P_SCP0100_GET_SITE load-once |
| txtItemId | `itemId` | P_ITEM_ID | 라벨 Model/Nickname(layModel). btnItemId → MaterialByDivisionModal(카탈로그 메1) |
| (컨트롤 없음) | — | P_NICK_NAME | AS-IS FindDataMain 고정 ""(.cs:1245) — 2026-10-21 정정(이전 'txtNickName' 서술은 근거 없음) |
| txtProject | `project` | P_PROJECT | 라벨 PJT(카탈로그). btnProject → ProjectByDivisionModal |
| (CELL_GROUP) | `cellGroup` | P_CELL_GROUP | |
| chkCellQty | `chkCellQty` | P_CHK_CELL_QTY | 기본 체크(designer:248). 변경 핸들러 NO-OP |
| chkAS | `chkAs` | P_CHK_AS | 라벨 A/S. 변경 핸들러 NO-OP |
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
- (2026-10-21 보완 — 사람 판단 대기. As-is 동작은 D00-1-002/003/020 에 구현돼 있고, 아래는 To-Be 카탈로그·MSG 원장 결정 사항이라 대사 행이 아닌 확인필요로 둔다)
- [D00-7-015] 카탈로그 'Global PSI New' NoName(Search Level/Detail 라디오) = 조회조건 삭제 — 사람 판단 필요: 카탈로그(2026-01-22 v0.4)는 삭제 지시이나, 삭제하면 Detail(REPORT 시트) 진입 경로가 사라짐 — 이후 REPORT 시트 SHEET_COLUMNS 15행·btn_auth 'report' 시트 등록(2026-09-24)이 기능 유지 근거. hook #112 §4-1 '최신 지시 우선·충돌 보고' (현행: Form:431-464 RadioGroup 복원(2026-10-21)) → **사용자 결정 2026-10-21: 유지** — 라디오(RadioGroup)+Search Level 콤보를 한 그룹으로, Search Level 선택 시 콤보 활성·Detail 선택 시 비활성(D00-7-018 지침).
- [D00-7-016] 카탈로그 Cell Qty·A/S 체크박스 = 공통기능화 검토(조회영역 승계 금지, 임의 삭제도 금지) — 사용자 확인 필요: hook #112 §2.5 — 재배치(표시 옵션/공통버튼 등)는 확정 스펙 아님. P_CHK_CELL_QTY/P_CHK_AS 는 SP 파라미터라 위치만 결정 대상 (현행: Form:501-519 한 칸 customCheckbox 로 묶음(D00-7-017, 2026-10-21))
- [D00-7-017] MSG01186 KO 문구('조회 시작일은 Plan Date보다 크거나 같아야 합니다.')가 EN·AS-IS 규칙과 반대 의미 — 사용자 결정 필요: 기존 MSG 문구 UPDATE 는 #140(MSG 원장 INSERT 전용) 범위 밖 — KO 사용자에게 반대 안내가 나감 (현행: Const:166-171 주석)

## §1 컨트롤 (2026-10-20 하네스 대사 — check.js G04 · As-is controls.csv 26종)

> 위치 약어: Form=`components/GlobalPsiReportForm.tsx` · Page=`GlobalPsiReport.tsx` · Grid=`components/GlobalPsiReportGrid.tsx` · Modals=`components/GlobalPsiReportModals.tsx` · Store=`useGlobalPsiReportStore.ts` · Const=`global-psi-report.constants.ts` · Cols=`utils/globalPsiReportColumns.ts`. As-is = `SCP0100_Global_PSI_Report.cs`.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrButton1 / UsrButton | — | designer 실측 EventName=null·Controls.Add 미등록·codeBehind 참조 0건 = dead control(CA-105 동일) | 제외 |
| D00-1-002 | §1 rgrpSearchLevel / RadioGroup (Search Level / Detail) | Form:431-464 Grid size=6 [RadioGroup row(Radio LBL00050/LBL00316) + FormItem Search Level 콤보] 한 묶음 · Store:190-193 setSearchMode · Store:216-218 Detail→P_SEARCH_LEVEL 'DETAIL' | 공용 RadioGroup 카탈로그 부재 → 2지선다 CustomDropdown 대체(값·동작 동일). AS-IS 라벨 없음(layoutControlItem3.TextVisible=false designer:1365) → 라벨 공란. ⚠ 카탈로그는 이 행을 '조회조건 삭제'로 표기 — D00-7-015 사람 판단 ⚠ 2026-10-21 규칙 정정: @shared/lges 에 RadioGroup·Radio 가 있어 '공용 부재' 전제가 틀림 — D00-7-018 처리 지침대로 RadioGroup 복원 — 사용자 결정 2026-10-21 유지(D00-7-018) → 2026-10-21 보완: Form:431-464 @shared/lges RadioGroup+Radio(LBL00050/LBL00316)로 복원, Search Level 콤보와 한 묶음 — H04 해소 | 구현  |
| D00-1-003 | §1 chkCellQty / UsrCheckBox | Form:512-516 Checkbox(LBL.CELL_QTY) → Store:221 chkCellQty 'Y'/'N' · Store:105 기본 true |  | 구현 |
| D00-1-004 | §1 cboPlanDate / UsrCombo (setListBox CODE/NAME, OnShown idx0) | Form:136-148 planDateQuery(planDate 시트, division '') · Form:193-197 첫 항목 기본값 · Form:388-401 single(LBL.PLAN_DATE) |  | 구현 |
| D00-1-005 | §1 cboBucketType / UsrCombo (ControlValues=Monthly .cs:606) | Form:410-420 single(LBL.BUCKET) · Const:132 BUCKET_DEFAULT=MONTHLY · Store:95 |  | 구현 |
| D00-1-006 | §1 dCalendar / UsrDateRangePicker3 (조회기간 From:To) | Form:403-409 PeriodField(LBL.PERIOD) → Store:93-94 · 초기값 Form:203-217 seedCalendar(D00-2-019) | 2026-10-21 텍스트 2칸 → 공용 PeriodField(카탈로그 Period·달력). 초기값(SetCalendar)은 D00-2-019 별도 행 | 구현 |
| D00-1-007 | §1 cboGraphType / UsrCombo | — | 핸들러 본문 공백(.cs:1773 NO-OP) + 차트 미이관 + LBL 미등록(부록 B-5) — CB-119 동일 | 제외 |
| D00-1-008 | §1 btnItemId / UsrButton | Form:489-494 popupField(onItemSearch) → Page:265-275 MaterialByDivisionModal | 카탈로그 Model/Nickname 팝업 = 메1(Material by Division) — 2026-10-21 ItemByDivisionModal 교체 | 구현 |
| D00-1-009 | §1 btnMeasure / UsrButton | Page:205-215 customButtons hasButton('MEASURE_SELECT') → Modals:107 MeasureSelectModal |  | 구현 |
| D00-1-010 | §1 txtItemId / UsrTextBox | Form:489-494 popupField(LBL.MODEL_NICKNAME) · Store:102 itemId |  | 구현 |
| D00-1-011 | §1 cboDisplay / UsrCombo (lookup STOCK_TREND_DISPLAY, DefineProperty idx2) | Store:96 DISPLAY_CODE.GRID 기본값 보존 · Form 미렌더 | AS-IS layDisplay.Visibility=Never(designer:1180) = 숨김 콤보 → To-Be 도 미노출(2026-10-21 정정). Chart/All 전환은 D00-2-007(제외) | 구현 |
| D00-1-012 | §1 txtProject / UsrTextBox | Form:495-500 popupField(LBL.PROJECT='PJT') · Store:103 project |  | 구현 |
| D00-1-013 | §1 clbFromSite / UsrCheckedList2 (GetSiteList FROM_SITE) | Form:110-121 fromSiteQuery(site 시트, enabled) · Form:376-381 multi(LBL.FROM_SITE) · Store:137-143 siteParam |  | 구현 |
| D00-1-014 | §1 clbToSite / UsrCheckedList2 (GetSiteList TO_SITE) | Form:122-133 toSiteQuery(site 시트, enabled) · Form:382-387 multi(LBL.TO_SITE) · Store:137-143 siteParam |  | 구현 |
| D00-1-015 | §1 txtCellGroup / UsrTextBox | Form:483-487 textField(LBL.CELL_GROUP) · Store:104 cellGroup |  | 구현 |
| D00-1-016 | §1 btnProject / UsrButton | Form:495-500 popupField(onProjectSearch) → Page:280-295 ProjectByDivisionModal |  | 구현 |
| D00-1-017 | §1 cboPlanType / UsrCombo (lookup PLAN_TYPE, SelectedValue='FN' .cs:628) | Form:465-473 single(LBL.PLAN_TYPE, disabled) · Const:123 PLAN_TYPE_DEFAULT · Store:94 | PlanType.Enabled=false(designer:1159) 비활성 반영(2026-10-21) | 구현 |
| D00-1-018 | §1 btnColumn / UsrButton | Page:190-200 customButtons hasButton('COLUMN_SETUP') → Modals:64 ColumnLayoutModal | ⚠ 2026-10-21 실측 정정: 버튼 클릭 시 titleset 0행·/column 9행 수신인데 모달 목록 'No Column' — 공용 ColumnLayoutModal 은 titleSet 이 없으면 fallbackColumns 로 목록을 만드는데 미전달. 처리 지침: GlobalPsiReportModals.tsx ColumnLayoutModal 에 fallbackColumns={staticColumns[RESPONSE_SET.MAIN].map(c => ({ key: c.colNm, header: c.colLblNm, width: c.width }))} 추가(SalesPlanModals 패턴) — 게이트 check.js H02 → 2026-10-21 보완: Modals:64·71-78 ColumnLayoutModal fallbackColumns 전달 — H02 해소 | 구현  |
| D00-1-019 | §1 cboSearchLevel / UsrCombo (lookup PRODUCT_LEVEL, idx0 .cs:621) | Form:442-462 single(LBL.SEARCH_LEVEL, Detail 시 disable) · Store:97 CELL_GROUP |  | 구현 |
| D00-1-020 | §1 chkAS / UsrCheckBox | Form:507-511 Checkbox(LBL.AS 'A/S') → Store:222 chkAs 'Y'/'N' |  | 구현 |
| D00-1-021 | §1 cboUnitQty / UsrCombo (ScpUtils.GetUnitQty) | Form:100-103 useTabLookupQueries(LOOKUP.UNIT_QTY='SCP_UNIT_QTY') · Form:234-239,474-480 single(LBL.UNIT) index→배율 · Const:156 UNIT_QTY_SCALE | 2026-10-21 정정: 옵션 원천 = 룩업 SCP_UNIT_QTY(SheetUtils.cs:1856, 사내 4건) — 하드코딩 옵션 제거. 명칭 카탈로그 Unit | 구현 |
| D00-1-022 | §1 clbDivision / UsrCheckedList2 (dtMyDivision, 권한 0건 SetDivisionAuthCheck .cs:583) | Form:97 useTabComboQueries(Division_SCP) · Form:150-159 3중 제외 · Form:178-191 권한 0건 alert · Form:362-375 multi(LBL.DIVISION) | 2026-10-21 정정: 다중선택(UsrCheckedList2 csv · SP FN_SPLITSTRING) — 기존 '단일 Division' 사유는 근거 불일치 | 구현 |
| D00-1-023 | §1 chartMain / ChartControl (splitContainer1.Panel1) | — | As-is 원문 실측(2026-10-20): designer.cs:1445 `DataBindings = null` · 디자이너 기본 Series 1개(점 0)만 있고 .cs 본문의 chartMain 참조 0건 · 유일한 데이터 주입 후보 `SetCalculating_chart()` 는 주석(.cs:1870) → 데이터가 한 번도 바인딩되지 않는 빈 차트(사실상 dead control, usrButton1 D00-1-001 과 같은 판정). 또한 차트 컴포넌트가 프레임워크 카탈로그·map_control.csv 에 없어 도입 금지(new_screen.md) → GEN_NOTES '룰 보완 후보' 등록 | 제외 |
| D00-1-024 | §1 spdSearchLevel / FpSpread | Const:16 SHEETS.SEARCH_LEVEL · Page:77-83 levelQuery · Grid:239 DataGrid |  | 구현 |
| D00-1-025 | §1 spdDetail / FpSpread | Const:15 SHEETS.REPORT · Page:70-76 reportQuery · Grid:239 DataGrid |  | 구현 |
| D00-1-026 | §1 spdSearchLevelDetail / FpSpread | Const:17 SHEETS.SEARCH_LEVEL_DETAIL · Page:84-90 levelDetailQuery · Grid:239 DataGrid |  | 구현 |

## §2 이벤트 (2026-10-20 하네스 대사 — check.js G03 · As-is events.csv 18건 + 프레임워크 유틸 1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load → Form_Load(.cs:511) InitForm·InitControls(.cs:575 권한 Division·PlanDate·Bucket Monthly·UnitQty)·CreateSpread·InitEvent | Page:144-151 mount(복원·메타 fetch) · Form:93,132,186-190 · Store:90-108 makeInitSearch | InitControls 의 SetCalendar(.cs:600) 는 D00-2-019(구현) | 구현 |
| D00-2-002 | §2 this / Shown → SCP0100_Global_PSI_Report_Shown(.cs:528) InitControlsAfter(SearchLevel idx0·PlanType FN·From/To Site·Display)+DefineProperty(Display idx2·rgrp 0)+OnShown PlanDate idx0(.cs:524) | Form:96-98 lookup · Form:108-125 Site · Form:186-190 PlanDate 첫 항목 · Store:96-99,122 기본값 |  | 구현 |
| D00-2-003 | §2 clbDivision / SelectedIndexChanged → RefreshPlant + SetVisibleColumnDivision(본문 공백 .cs:1311) + ClearDataSource(.cs:1769) | Form:362-375 confirmIfDirtyKey → Store:179-189 setDivision(filters={} 그리드 초기화) | RefreshPlant 결과 dtPlant 는 화면 내 소비처 없음(조회 파라미터 미사용) | 구현 |
| D00-2-004 | §2 cboGraphType / SelectedIndexChanged (.cs:1773 본문 공백) | — | NO-OP — 살아있는 동작 없음 | 제외 |
| D00-2-005 | §2 cboPlanDate / SelectedIndexChanged (.cs:1784) SetCalendar + InitSpread + SetGridClear | Form:388-401 set(planStartYyyymmdd)+clearFilters() · Form:203-217 seedCalendar(Plan Date 변경 감지) | 그리드 초기화 + SetCalendar(D00-2-019) 모두 구현 | 구현 |
| D00-2-006 | §2 cboBucketType / SelectedIndexChanged (.cs:1798) SetSpreadColumn + SetGridClear + FindData(:1812) | Form:410-420 set(bucket)+onSearch() · Cols:113-118 M_/W_ 가시성 | EditButton(.cs:1809)은 read-only 리포트라 대상 없음 | 구현 |
| D00-2-007 | §2 cboDisplay / SelectedIndexChanged (.cs:1824) splitContainer Panel1(차트)/Panel2(그리드) 비율 전환 | Form:406-412 display 값 보존 · Store:98 기본 GRID(idx2 = SplitterDistance 0, 차트 영역 숨김과 같은 화면) | 핸들러가 바꾸는 것은 Panel1MinSize/SplitterDistance(0/750/270)뿐이고 Panel1 의 유일한 내용물 chartMain 은 데이터가 한 번도 바인딩되지 않는 빈 차트(D00-1-023 제외 근거) → Chart/All 은 빈 영역만 넓혀 그리드를 줄이는 효과. 기본값 Grid 화면은 동일. 빈 패널 재현 여부는 사용자 결정 항목(GEN_NOTES) | 제외 |
| D00-2-008 | §2 cboSearchLevel / SelectedIndexChanged (.cs:1853) VisibleSheet + SetLayout + SetGridClear + FindData(isLoadFinish) | Form:442-462 set(searchLevel)+onSearch() · Page:64-68 activeSheet · Grid:86-89 applySearchLevelLayout(SetLayout) · Store:224-233 활성 시트만 filter |  | 구현 |
| D00-2-009 | §2 cboUnitQty / SelectedIndexChanged (.cs:1864) SetCalculating(로컬 배율) | Form:234-239 pickUnitQty → Store setUnitScaleIndex · Grid:183-188 pivot 셀 값/배율 | 서버 재조회 없음(As-is 동일) | 구현 |
| D00-2-010 | §2 rgrpSearchLevel / SelectedIndexChanged (.cs:1900) EnableSearchLevel + VisibleSheet + InitSpread + SetLayout | Form:433-441 setSearchMode · Form:453 Detail 시 SearchLevel disable · Page:64-68 activeSheet · Grid:86-89 applySearchLevelLayout | 자동조회 없음(As-is 동일) | 구현 |
| D00-2-011 | §2 btnItemId / Click (.cs:1932) SCM0002_ItembyDivisionPopup(division, itemId) → txtItemId | Page:265-275 MaterialByDivisionModal(preSearchParams divisionId·scpModuleType·itemId) | 카탈로그 팝업 메1(Material by Division) 적용 — AS-IS 팝업 클래스와 다름(카탈로그 To-Be 변경) | 구현 |
| D00-2-012 | §2 btnMeasure / Click (.cs:1951) SCM0002_TitleSetForm_Popup('SCP0100','Global PSI New',false) → InitSpread | Page:201-211 · Modals:107 MeasureSelectModal(MEASURE_SHEET_NAME) → fetchStaticMeasures |  | 구현 |
| D00-2-013 | §2 btnProject / Click (.cs:1967) SCM0002_ProjectbyDivisionPopup(division, project) → txtProject | Page:280-295 ProjectByDivisionModal |  | 구현 |
| D00-2-014 | §2 cboPlanType / SelectedIndexChanged (.cs:1985 본문 공백) | — | NO-OP — 살아있는 동작 없음 | 제외 |
| D00-2-015 | §2 btnColumn / Click (.cs:1990) SCM0002_TitleSetForm_Popup('SCP0100', ActiveSheet, true) → InitSpread+SetLayout | Page:190-200 · Modals:64 ColumnLayoutModal(activeSheet) → fetchStaticColumns | ⚠ 2026-10-21 실측 정정: 버튼 클릭 시 titleset 0행·/column 9행 수신인데 모달 목록 'No Column' — 공용 ColumnLayoutModal 은 titleSet 이 없으면 fallbackColumns 로 목록을 만드는데 미전달. 처리 지침: GlobalPsiReportModals.tsx ColumnLayoutModal 에 fallbackColumns={staticColumns[RESPONSE_SET.MAIN].map(c => ({ key: c.colNm, header: c.colLblNm, width: c.width }))} 추가(SalesPlanModals 패턴) — 게이트 check.js H02 → 2026-10-21 보완: Modals:64·71-78 fallbackColumns 전달 — H02 해소 | 구현  |
| D00-2-016 | §2 dCalendar / ValueChanged (.cs:2006) 시작일>Plan 시작일 경고 + plan_start:end 복원 + InitSpread | Form:221-232 changePeriod(PeriodField onChange — AS-IS 와 같은 변경 시점) · Page:157-167 validatePlanDateRange(조회 직전 재확인) · Page:124-134 calendarQuery(기간 변경 시 헤더 재조회) · utils/globalPsiReportCalendar.ts:18-22 isStartAfterPlan | 메시지 = MSG01186(사내 MSG_M 역조회, EN 동일 규칙) — 2026-10-21 비카탈로그 키 교체. KO 문구 반대 의미는 D00-7-017 | 구현 |
| D00-2-017 | §2 chkCellQty / CheckedChanged (.cs:1915 본문 전부 주석) | — | 주석 처리 코드(commented_calls) 이식 금지 — 살아있는 동작 없음 | 제외 |
| D00-2-018 | §2 chkAS / CheckedChanged (.cs:1924 본문 전부 주석) | — | 주석 처리 코드(commented_calls) 이식 금지 — 살아있는 동작 없음 | 제외 |
| D00-2-019 | §2 SetCalendar / GetDayRange(.cs:1317·1384 MONTH) 조회기간 초기값 = PlanDate YYYYMM01 : GetPlanEndDate(.cs:2029 biz CommonData PLAN_END_DATE, division '81' 고정·WEEKLY) — Load·PlanDate 변경 시 | Form:203-217 planEndFilters·useTabComboQueries(SCPPlanPeriod_SCP)·seedCalendar effect · Store:242-249 seedCalendar · utils/globalPsiReportCalendar.ts:6-14 planDayRange(YYYYMM+'01' : HORIZON_END_DATE, 빈 값이면 null=기간 유지) · Store:62 calendarSeedPlan 가드 · Const:33-45 PLAN_END_* · __tests__/GlobalPsiReport.spec.ts TC-SCP0100-001~004 | 종료일 원천 = 기존 등록 콤보 SCPPlanPeriod_SCP 재사용(D00-4-004) — 신규 DB 객체 불필요. 시드 후 calendar(3SPAN) 헤더 조회가 기간 값으로 자동 발사(Page:124-134) | 구현 |

## §4 엔드포인트 (2026-10-20 하네스 대사 — check.js G02 · 사내 배선 proc_meta.csv 2026-10-20 실측)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-4-001 | SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN (GetSpdTitle .cs:1322 p_start/p_end_yyyymmdd) | Page:124-138 useTabProcQuery(AUX_SHEET.CALENDAR, startYyyymmdd/endYyyymmdd) | 사내 배선 calendar/SEARCH → P_SCP0100_CALENDAR_GET → PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN | 구현 |
| D00-4-002 | SCP.SCP0100_GET_SITE (GetSiteList .cs:1335 p_site_tpye/p_division_id/p_bucket) | Form:107-133 useTabProcQuery(AUX_SHEET.SITE, pSiteTpye FROM_SITE/TO_SITE, divisionId=divisionParam, enabled) | 사내 배선 site/SEARCH → P_SCP0100_SITE_GET → PKG_SCP0100.P_SCP0100_GET_SITE. Division 미선택('')도 조회(AS-IS Shown 시점 _division='') | 구현 |
| D00-4-003 | SCP.SCP0100_GET_PLAN_DATE (GetPlanDate .cs:1357 p_program_id='SCP0100') | Form:134-148 useTabProcQuery(AUX_SHEET.PLAN_DATE, divisionId='', programId=PLAN_DATE_PROGRAM_ID, enabled) | 사내 배선 planDate/SEARCH → P_SCP0100_PLAN_DATE_GET → PKG_SCP0100.P_SCP0100_GET_PLAN_DATE. AS-IS 는 InitControls(.cs:592-597) 1회 _division='' 호출 → division '' 고정(2026-10-21 정정, SP A.DIVISION_ID 단일 등호라 다중값 불가) | 구현 |
| D00-4-004 | biz:CommonData.CommonDataList_REPORT (GetPlanEndDate .cs:2035 PLAN_END_DATE) | Form:203-212 useTabComboQueries({comboId:'SCPPlanPeriod_SCP', planName, divisionId:'81'}) · Const:41-45 | As-is 원문(MSSQL dbo.UP_FX_GetCommonDataList_REPORT, 2026-10-20 직접 조회) `SELECT TOP 1 HORIZON_END_DATE FROM SCM_MST_PLAN WHERE DIVISION_ID=@param1 AND PLAN_NAME=@param2 AND PLAN_CYCLE=@param3` ↔ 사내 SCM_ADM_CMBO_SQL_M 'SCPPlanPeriod_SCP' 같은 표·같은 3조건(PLAN_CYCLE='WEEKLY' 고정 = As-is 호출값). 사내 (DIVISION_ID,PLAN_NAME,PLAN_CYCLE) 중복 0건 → 첫 행 = TOP 1. allowed_gaps `^biz:CommonData` → useTabComboQueries 규칙 그대로 | 구현 |
| D00-4-005 | 메인 GET PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT (FindData — QueryDics, 17 IN) | Page:70-90 useTabProcQuery 3시트 · Store:199-233 setFilter(IN 17 = proc_params COL_NM) | 사내 배선 report/searchLevel/searchLevelDetail SEARCH → P_SCP0100_GET (DoD B22 17개 일치). P_SEARCH_LEVEL Detail='DETAIL'·P_NICK_NAME='' 는 D00-7-007/008 | 구현 |

## §6 동적 컬럼 (2026-10-20 — 타이틀 SP · As-is DB루프 컬럼 생성, check.js M08/M09 · DoD B26/B27)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-6-001 | GetSpdTitle / 1322 (타이틀 SP SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN — dsSpdTitle) | Page:124-138 calendarQuery · Grid:92-95 toCalendarCols(o_rc1: COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE) | 응답 키 o_rc1 = proc_params OUT COL_NM(DoD B26) | 구현 |
| D00-6-002 | InitSpreadDateColumn / 755 (DB루프 컬럼 생성 ← 타이틀 SP — `IndexOf("B_") > 0` 이면 AddTextColumn 폭 0 숨김) | Cols:113-118 isColVisibleForBucket(B_ 숨김) | 사내 3SPAN 원문(PKG_SCP0100 BODY L416~ · 2026-10-20 ALL_SOURCE)은 'W_'·'M_' 두 블록만 생성, B_ 이름 없음 → 분기 도달 불가(동등) | 구현 |
| D00-6-003 | InitSpreadDateColumn / 760 (DB루프 컬럼 생성 ← 타이틀 SP — AddNumColumn 폭 70 visible) | Cols:124-174 buildPivotColumns(leaf width 70, n0) · Grid:97-100 dynamicColumns · Grid:180-181 음수 빨간색(SetReNumerCellType NegativeRed) |  | 구현 |
| D00-6-004 | InitSpreadDateColumn / 767·774·778 (헤더 ForeColor — M_ & plan_start 월 Red / W_ 라벨 A·B Blue) | Grid:118-137 formatItem ColumnHeader | As-is 는 라벨(sColumnLabelname) A/B 포함 판정, To-Be 는 바인딩 끝자리 A/B 판정(W_202405A 형식 — 원문 L1209 주석) | 구현 |
| D00-6-005 | InitSpreadDateColumn / 787·794 (ColumnHeaderSpan 3단 — Large 월 / Small 주 / Qty) | Cols:110 PIVOT_LEAF_HEADER='Qty' · Cols:114-137 PIVOT_HEADER_HEIGHT(그룹 20 / Qty 40·30)·headerRowHeights · Cols:144-203 buildPivotColumns(WEEKLY 월>주>Qty / MONTHLY 월>Qty, 그룹 allowMerging·allowSorting=false·height) · utils/globalPsiReportMerge.ts 기간칼럼 헤더 = 컬럼그룹 범위 병합 · Grid:206-240 updatedLayout 행별 높이 재적용 · Grid:243·254 mergeManager prop · __tests__ TC-SCP0100-006·016·017 | ⚠ 2026-10-21 실측 정정(사용자 확인 요청): 라이브 헤더가 144px 한 칸으로 병합되고 'Qty' 행이 없음 · As-is = 3행(SetSheetHeaderColumn 3) 20/20/20~30px, 0행 LARGE(월) · 1행 SMALL(주)/'Qty' · 2행 'Qty'. 처리 지침 ① utils/globalPsiReportColumns.ts leafOf header 를 'Qty' 고정(As-is ColumnHeaderSpan 이 1~2행을 'Qty' 로 덮음 — COLUMN_LABEL_NAME 사용 금지) ② 행 높이: 공용 DataGrid 는 initialized 1회만 적용하므로 Grid 의 DataGrid initialized 에서 grid.updatedLayout.addHandler(() => { const r = grid.columnHeaders.rows; if (Math.round(r.defaultSize) !== HEADER_ROW_HEIGHT) r.defaultSize = HEADER_ROW_HEIGHT; }) 등록(공용 변경 없음) — 게이트 check.js H01 · E2E smoke 'header' 어노테이션(행 3·리터럴 Qty·높이 ≤32×3)으로 확인 → 2026-10-21 보완: ①leaf 'Qty' 고정(Cols:110·134) ②Grid:202-236 updatedLayout 헤더 행 높이 재적용(공용 변경 없음) — H01 해소. 라이브 헤더 행 수·높이는 런타임 미검증 ⚠ 2026-10-21 18:5x 규칙 정정(사용자 실측 지적): 라이브 = 월 칸 h48(행 0~1 병합) / Qty 행 h24 · Qty 가 전 월에 걸쳐 **1칸(w910)으로 가로 병합** — As-is 와 반대(월 행 20 / Qty 1~2행 병합 40~50, 월마다 Qty 분리). 처리 지침 ① **Qty 칸 분리**: 헤더 가로 병합을 끈다 — DataGrid allowMerging 을 AllowMerging.Cells(본문 병합만) 로 넘기거나 mergeManager 가 ColumnHeader 패널은 건너뛰게(동일 문구 인접 셀 자동 병합 금지). 상단 월 칸이 분리돼 있으면 하단 Qty 도 월마다 자동 분리돼야 한다 ② **행 높이 역전**: 그룹(월/주) 행 = 20px, leaf(Qty) 행 = 40px(As-is 1~2행 병합). applyHeaderHeight 를 행 인덱스별 높이로(마지막 행 40, 나머지 20). 월간은 헤더 2행(월/Qty)이어야 한다 — 현재 3행이 생기는 원인(숨긴 주간 그룹 깊이) 제거 ③ 주간 = 월 20 / 주 20 / Qty 30. 검증 = E2E smoke header 어노테이션(리터럴 칸 수·leaf 행 높이 ≥ 상단 행) → 2026-10-21 수선(E2E smoke header 행 2=72+24 · 18:5x 지침): ①Qty 월마다 분리 + 1·2행 세로 병합 해소 = 화면 전용 GlobalPsiReportMergeManager(기간칼럼 헤더만 Wijmo 기본 컬럼그룹 범위, 고정 컬럼·본문은 공용 CustomMergeManager 위임 — 공용 변경 없음, H05 해소) ②행 높이 = 그룹 20 / Qty 40(월간)·30(주간) 행별 재적용 ③월간 2행(M_ 의 SMALL 라벨로 중간 그룹 생성 안 함). 라이브 헤더는 런타임 미검증 ⚠ 2026-10-21 19:5x 런타임 사고: 수선 1 이 넣은 utils/globalPsiReportMerge.ts 의 `private inner: CustomMergeManager | null = null` 필드 때문에 DataGrid mergeManager prop 전달 시 Wijmo copy() 가 'Unknown property "inner"' 단언 → 화면 열면 그리드 생성 실패(E2E smoke 라벨 0/15). 처리: 필드 제거 — 위임 인스턴스는 모듈 `WeakMap<FlexGrid, CustomMergeManager>` 에 보관(getMergedRange 에서 panel.grid 키로 조회) · 수정 뒤 화면을 열어 콘솔 단언 0 확인 → 2026-10-21 회귀 정정(H06): 위 MergeManager 의 인스턴스 필드 inner 가 Wijmo copy() 'Unknown property' 단언으로 화면 생성 실패(19:22 smoke 오류 화면) → utils/globalPsiReportMerge.ts:17-25 모듈 WeakMap<FlexGrid,CustomMergeManager> 로 이동, 클래스는 메서드만(:27-40) | 구현  |

## §7 보완 (2026-10-21 — As-is 원문·designer·PKG·조회조건 카탈로그 재대조, check.js/gap 미검출분)

> 근거 = As-is `SCP0100_Global_PSI_Report.cs`/`.designer.cs` 원문 · 프레임워크 원문(CString/SpreadInfo/UsrCheckedList2/SheetUtils) · 사내 ZIOUI1 PKG_SCP0100 BODY(LAST_DDL 2026-10-16 09:42 재조회) · SCM_MST_SHEET_MEASURE/SCM_ADM_LOOKUP_MASTER_DETAIL/SCM_ADM_MSG_M 실측 · `_rules_v2/_mapping/search_conditions_scp_dm.md` 'Global PSI New' 17행.
> 카탈로그 대조(hook #112 [필수 5]): 17행 중 승계 12 / 조회조건 삭제 1(NoName 라디오) / 공통기능화 검토 4(Cell Qty·A/S 체크박스, Measure·Column 버튼). 승계 12 전부 구현(명칭 Div.·PJT·Model/Nickname·Unit, 유형 Div. 다중·Period 달력). Measure·Column 버튼은 SubTitle customButtons(조회영역 밖). 삭제 1·체크박스 2 는 D00-7-015/016(사람 판단).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-7-001 | SetLayout / 1490-1542 Search Level 별 Product Level1~3 표시(case1 L1·L2 / case2 L1 / case3 L2 / case4 L1·L2·L3 / default 숨김, Detail 미적용) | Cols:44-57 applySearchLevelLayout · Const:110-120 PRODUCT_LEVEL_VISIBLE · Grid:86-89 · __tests__ TC-SCP0100-010~012 | AS-IS 는 대상 컬럼을 VisibleColumns(true) 로 켜지만 To-Be 는 admin/개인화 visible 보존 규약상 숨김 방향만 적용 | 구현 |
| D00-7-002 | SetBackColor / 854-856·922-940 measure 배경 8그룹 — 적용 열 = MEASURE_UI 열-2 ~ 끝, 키 = MEASURE_NAME 정확 일치 | Grid:155-160 · Const:233-252 MEASURE_NAME_BG(VMI Inventory·Char. Available·Form. Progress·Cell Inventory(Pack) 정정) · __tests__ TC-SCP0100-013 | 기존 키 4건 철자 불일치(VMI/Char.Available/Form.Progress, Cell Inventory(Pack) 누락)로 해당 measure 무색 — SHEET_MEASURE 실측 명칭으로 정정 | 구현 |
| D00-7-003 | SetBackColor / 877-904·947-954 Measure Group 이 바뀌는 행 상단 DarkGray 2px 경계 | Grid:146-152 borderTop · Const:228 MEASURE_GROUP_BORDER_TOP | 'AS Sales PSI' Black 경계는 적용 직전 Clear(.cs:955)라 실효 없음 → 미이식(동등) | 구현 |
| D00-7-004 | SetBackColor / 968-1023 과거구간 회색 — MONTHLY plan_start 월 이전 M_ · WEEKLY plan_start 주 이전 W_ | Grid:162-176 · Cols:59-70 planStartWeekBinding · __tests__ TC-SCP0100-009 | 기존은 MONTHLY 만. WEEKLY 기준주 = DAY_CODE=Plan 시작일 W_ 행(AS-IS FindDataValue 는 첫 일치 행이라 M_ 행이 먼저 잡히면 범위가 깨짐 — 의도 기준 적용) | 구현 |
| D00-7-005 | SetBackColor / 1026-1071 WEEKLY 과거 W_..A × 재고 measure 7종 = Silver | Grid:172-176 · Const:255-263 PAST_INVENTORY_MEASURES · __tests__ TC-SCP0100-014 | AS-IS 원문은 Cells[j, colArrayWeekA[j]] 로 행 인덱스에 열 순번 j 를 써서(.cs:1066) 대각선 셀만 칠하는 결함 — 의도(재고 measure 행 × 과거 A주)로 구현. 기존 To-Be 는 AS Inventory·Cell Inventory(Pack) 포함·미래 A주까지 칠함(정정) | 구현 |
| D00-7-006 | SetReNumerCellType(SpreadInfo.cs:13815) 기간 숫자 셀 NegativeRed=true · DecimalPlaces=0 | Grid:178-181 NEGATIVE_FORE · Cols:124-174 format n0 |  | 구현 |
| D00-7-007 | getSearchLevel / 414-417 Detail 모드 P_SEARCH_LEVEL='DETAIL' (PKG BODY L849·L1493 DETAIL 분기) | Store:216-218 · Const:105-108 SEARCH_LEVEL_CODE.DETAIL | 기존은 Detail 에서도 콤보값(CELL_GROUP 등) 전송 → REPORT 시트가 집계 데이터를 받던 결함 | 구현 |
| D00-7-008 | FindDataMain / 1245 p_nick_name = "" 고정 | Store:208 nickName '' | 입력 컨트롤 없음(CB-113) | 구현 |
| D00-7-009 | GetUnitQty(SheetUtils.cs:1856) = LookupCommon 'SCP_UNIT_QTY' 옵션 / SetUnitQty(.cs:1697) SelectedIndex 배율 | Form:100-103,234-239,458-463 · Const:86-91 LOOKUP.UNIT_QTY | 사내 룩업 4건(Q1/Q1000/Q1000000/Q100000000) 실측 | 구현 |
| D00-7-010 | designer:248 chkCellQty.Checked=true (진입 기본 체크) | Store:105 | 기존 false(근거 없음) 정정 | 구현 |
| D00-7-011 | designer:1180 layDisplay.Visibility=Never / designer:1253 lblGraphType.Visibility=Never | Form 미렌더(Display·Graph) · Store:96 display GRID | 숨김 콤보 — 값은 DefineProperty idx2(GRID) 유지 | 구현 |
| D00-7-012 | designer:1159 PlanType.Enabled=false (카탈로그 비고 '비활성화_Final Plan') | Form:465-473 disabled | | 구현 |
| D00-7-013 | DCalendar_ValueChanged / 2006-2021 변경 즉시 검증 + 시작일 복원 + 헤더 재조회 | Form:221-232 · Page:157-167 · utils/globalPsiReportCalendar.ts:16-22 · __tests__ TC-SCP0100-015 | 메시지 MSG01186(EN 'Begin Date is early or equal to Plan Date.') | 구현 |
| D00-7-014 | GetPlanDate / 592-597 Load 1회 _division=''(체크 0건) 호출 · clbDivision 다중(CString.GetCheckedListValue .cs:584-600 ALL→'') | Form:134-148 planDate division '' · Form:362-375 Div. 다중 · Store:140-145 divisionParam(Site·메인·컬럼/measure 메타·팝업 공통) | 컬럼 메타 PR_GET_SHEET_COLUMN_LIST 는 DIVISION_ID 공란 행 = 전 Division 공통(SCP0100 3시트 전건 공란) → '' 전송 안전 | 구현 |
| D00-7-017 | To-Be 배치 결정(2026-10-21 사용자): 체크박스 Cell Qty·A/S 는 각각이 아니라 **한 영역**에 모아 표기 | Form:501-519 Grid size=3 customGrid > customCheckbox > Stack row [A/S, Cell Qty] | 처리 지침(사용자 2026-10-21 추가): 체크박스는 **Label 영역이 아니라 Box 영역**에 둔다 — 한 칸의 FormItem(label 공란)의 control 슬롯(customCheckbox 컨테이너) 안에 Cell Qty·A/S 두 Checkbox 를 나란히. 카탈로그 '공통기능화 검토' 결론 나면 공용 규칙으로 승격 → 2026-10-21 보완: Form:501-519 한 Grid 칸 customCheckbox > Stack row 에 A/S·Cell Qty — H03 해소 | 구현  |
| D00-7-018 | 라디오 디자인 룰(2026-10-21 사용자): As-is rgrpSearchLevel(RadioGroup Search Level/Detail)은 To-Be 도 라디오 — @shared/lges RadioGroup+Radio(labelText) 로 구현. 드롭다운 대체는 룰 위반 | Form:431-464 RadioGroup+Radio(①) · 라디오 왼쪽·Search Level 콤보 오른쪽 같은 Grid 칸(②) · Form:453 Detail 시 콤보 disabled(③) | 사용자 결정(2026-10-21): **유지**. 처리 지침: ① 라디오(Search Level / Detail)를 @shared/lges RadioGroup+Radio(labelText=LBL00050/LBL00316)로 구현 ② 배치(사용자 2026-10-21 추가): 조회조건 칸 = Label 영역 + Box 영역. **라디오(Search Level/Detail)는 첫 칸의 Box 영역**(FormItem label 공란, RadioGroup row 가로)에, **그 다음 칸에 'Search Level' Label + Dropdown Box** 를 둔다(두 칸이 하나의 그룹 — 라디오가 콤보 활성/비활성을 결정) ③ Search Level 선택 = 콤보 활성, Detail 선택 = 콤보 비활성(As-is EnableSearchLevel .cs:1900, 현재 Form:453 disable 로직 유지) ④ 카탈로그 '조회조건 삭제' 표기는 이 결정으로 대체(D00-7-015 글머리 갱신). 게이트 check.js H04 → 2026-10-21 보완: ①RadioGroup+Radio ②같은 Grid 칸 라디오 왼쪽·콤보 오른쪽 ③Form:453 Detail 시 콤보 disabled ④D00-7-015 글머리 갱신 — H04 해소 | 구현  |

# SCP0100 Global PSI Report — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM.SCP.Forms.UIL/Report/SCP0100_Global_PSI_Report.cs` (2,056줄, C#.NET WinForms)
TO-BE: `nscm-fe/features/supply/src/pages/global-psi-report/`
설계 근거: `.atlas/gscm-design/SCP0100/design/00_checklist.md ~ 03_grid-columns.md` (DB 실측 PASS)

read-only Global PSI 조회 리포트. 저장/입력 없음 — 툴바 override 는 FindButton(SEARCH) + ExcelButton(EXCEL) 2종뿐.

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

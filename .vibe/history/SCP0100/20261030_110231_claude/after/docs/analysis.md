# SCP0100 Global PSI Report — As-is 분석

> 근거: AsisFacts 정적 추출 사실 묶음(Fact Pack)만 사용했습니다. 사실 묶음에 없는 내용은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0100 |
| 클래스 | `SCP0100_Global_PSI_Report` |
| 도메인 | SCP (경로 `06.UIL\GSCM.SCP.Forms.UIL\Report\`) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\SCP0100_Global_PSI_Report.csproj` |
| 화면 구성 | 조회조건 패널(`usrConditionPanel1`, Dock=Top) + `splitContainer1`(Panel1 = 차트 `chartMain`, Panel2 = Spread 3개 `spdSearchLevel` / `spdDetail` / `spdSearchLevelDetail`) |
| 저장 기능 | 추출된 저장 계열 엔드포인트 0건. 조회 전용 리포트인지는 **확인 필요** |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0100_Global_PSI_Report\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0100_Global_PSI_Report\SCP0100_Global_PSI_Report.cs` | 2056 |
| current | `...\SCP0100_Global_PSI_Report\SCP0100_Global_PSI_Report.designer.cs` | 1682 |
| shared | 없음 (사실 묶음에 shared 파일 없음) | - |
| legacy | 없음 (사실 묶음 본문에 legacy 행 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| `this.Load` (`Form_Load`) | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| `this.Load` (`Form_Load`) | Form_Load > InitControls > GetPlanDate | 1365 | `SCP.SCP0100_GET_PLAN_DATE` | MATCH | SCP0100_GET_PLAN_DATE |
| `this.Load` (`Form_Load`) | Form_Load > InitControls > SetCalendar > GetDayRange > GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | - |
| `this.Shown` (`SCP0100_Global_PSI_Report_Shown`) | SCP0100_Global_PSI_Report_Shown > InitControlsAfter > RefreshToSite > GetSiteList | 1342 | `SCP.SCP0100_GET_SITE` | MATCH | SCP0100_GET_SITE |
| `cboPlanDate.SelectedIndexChanged` (`CboPlanDate_SelectedIndexChanged`) | CboPlanDate_SelectedIndexChanged > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| `cboPlanDate.SelectedIndexChanged` (`CboPlanDate_SelectedIndexChanged`) | CboPlanDate_SelectedIndexChanged > SetCalendar > GetDayRange > GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | - |
| `dCalendar.ValueChanged` (`DCalendar_ValueChanged`) | DCalendar_ValueChanged > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| `rgrpSearchLevel.SelectedIndexChanged` (`rgrpSearchLevel_SelectedIndexChanged`) | rgrpSearchLevel_SelectedIndexChanged > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| `this.btnColumn.Click` (`BtnColumn_Click`) | BtnColumn_Click > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| `this.btnMeasure.Click` (`btnMeasure_Click`) | btnMeasure_Click > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |

> ⚠ **메인 데이터(그리드·차트) 조회 엔드포인트가 추출되지 않았습니다.** 툴바 조회(Search) 처리 메서드와 그 SP는 사실 묶음에 없어 **확인 필요**입니다. BaseForm 오버라이드 방식이라 정적 추출에서 빠졌을 가능성이 있지만, 이것도 확인이 필요합니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (SP 내부 EXEC 전이 포함) |
|---|---|---:|---|---|
| `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0100_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0100_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |
| `SCP.SCP0100_GET_SITE` | MATCH | 1 | SCP0100_GET_SITE | EXEC:SCP0100_GET_SITE, SELECT:SCP_RPT_GLOBAL_PSI_MD_MM, REF:FN_SPLITSTRING, SELECT:SCP_RPT_GLOBAL_PSI_MD_WW |
| `SCP.SCP0100_GET_PLAN_DATE` | MATCH | 1 | SCP0100_GET_PLAN_DATE | EXEC:SCP0100_GET_PLAN_DATE, INSERT:#TMP_PLAN, REF:FN_CHAR_TO_DATE, SELECT:SCP_PLAN_VERSION_V, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_PLN_INTERFACE_YN, REF:FN_SPLITSTRING, SELECT:#TMP_PLAN, SELECT:SCP_RPT_GLOBAL_PSI_MD_MM, SELECT:SCP_RPT_GLOBAL_PSI_MD_WW |
| `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | 1 | - (via `Data_REPORT.CallBizCommonData`) | 사실 묶음에 없음 — **확인 필요** |

- 주석 처리된 호출(commented_calls): **0건**

## 4. 이벤트 배선 표

| # | 대상 | 이벤트 | 핸들러 | 배선 위치 | 추출된 엔드포인트 |
|---:|---|---|---|---|---|
| 1 | this | Load | `Form_Load` | .ctor:501 | GET_SHEET_CALENDAR_3SPAN, GET_PLAN_DATE, CommonDataList_REPORT |
| 2 | this | Shown | `SCP0100_Global_PSI_Report_Shown` | .ctor:502 | GET_SITE |
| 3 | clbDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitEvent:1127 | 추출 없음 (**확인 필요**) |
| 4 | cboGraphType | SelectedIndexChanged | `CboGraphType_SelectedIndexChanged` | InitEvent:1128 | 추출 없음 |
| 5 | cboPlanDate | SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitEvent:1129 | GET_SHEET_CALENDAR_3SPAN, CommonDataList_REPORT |
| 6 | cboBucketType | SelectedIndexChanged | `CboBucketType_SelectedIndexChanged` | InitEvent:1130 | 없음 — `SetSpreadColumn` 로컬 호출(1804, `if(_SI != null)`) |
| 7 | cboDisplay | SelectedIndexChanged | `CboDisplay_SelectedIndexChanged` | InitEvent:1131 | 없음 — `splitContainer1.SplitterDistance` 0 / 750 / 270 설정(1833/1841/1849) |
| 8 | cboSearchLevel | SelectedIndexChanged | `CboSearchLevel_SelectedIndexChanged` | InitEvent:1132 | 추출 없음 |
| 9 | cboUnitQty | SelectedIndexChanged | `CboUnitQty_SelectedIndexChanged` | InitEvent:1133 | 추출 없음 |
| 10 | rgrpSearchLevel | SelectedIndexChanged | `rgrpSearchLevel_SelectedIndexChanged` | InitEvent:1134 | GET_SHEET_CALENDAR_3SPAN |
| 11 | this.btnItemId | Click | `BtnItemId_Click` | InitEvent:1136 | 없음 — `txtItemId.Text = sItemId`(1947) |
| 12 | this.btnMeasure | Click | `btnMeasure_Click` | InitEvent:1137 | GET_SHEET_CALENDAR_3SPAN |
| 13 | this.btnProject | Click | `BtnProject_Click` | InitEvent:1139 | 없음 — `txtProject.Text = sProjectCode`(1981) |
| 14 | cboPlanType | SelectedIndexChanged | `CboPlanType_SelectedIndexChanged` | InitEvent:1140 | 추출 없음 |
| 15 | this.btnColumn | Click | `BtnColumn_Click` | InitEvent:1141 | GET_SHEET_CALENDAR_3SPAN |
| 16 | dCalendar | ValueChanged | `DCalendar_ValueChanged` | InitEvent:1143 | GET_SHEET_CALENDAR_3SPAN |
| 17 | chkCellQty | CheckedChanged | `ChkCellQty_CheckedChanged` | InitEvent:1144 | 추출 없음 |
| 18 | chkAS | CheckedChanged | `ChkAS_CheckedChanged` | InitEvent:1145 | 추출 없음 |

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

1. **시트 생성(코드)**: `CreateSpread` 684~686줄에서 `AddSheet`로 시트 3개를 만듭니다.
   - `spdSearchLevel` → `SEARCH_LEVEL` (헤더 3행, 1, 30)
   - `spdDetail` → `REPORT` (3, 1, 30)
   - `spdSearchLevelDetail` → `SEARCH_LEVEL_DETAIL` (3, 1, 30)
   - 688~690줄 `GetSheetInfo`, 692~693줄 `ChangeSheet`
2. **고정 컬럼(META)**: `InitSpread` 705줄 `SetSheetHeaderColumn(_SI, 3)`이 `SCM_MST_SHEET_COLUMNS` 메타(COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG, FIXED_FLAG …)로 컬럼을 생성합니다.
3. **기간 컬럼(DB루프)**: `InitSpread` 703줄 `GetSpdTitle` → SP `SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과(`dsSpdTitle`)를 `InitSpreadDateColumn`(706줄 호출)이 순회하며 생성합니다.
   - `COLUMN_NAME.IndexOf("B_") > 0` → `AddTextColumn`(폭 0, 숨김)(755줄)
   - 그 외 → `AddNumColumn`(폭 70, 표시)(760줄)
   - `M_`로 시작하고 `_plan_start_yyyymm` 포함 → 글자색 Red(767줄)
   - `W_`로 시작하고 라벨에 "A" 포함 → Blue(774줄), 라벨에 "B" 포함 → Blue(778줄)
   - 3단 헤더: 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, 2행 "Qty"(787~816줄 `ColumnHeaderSpan`)
4. **표시 변경(코드)**
   - `SetSpreadColumn`(708줄 / 1804줄 호출): `_bucket_type`이 MONTHLY면 `M_` 컬럼만 Visible=true, 나머지 false(1103/1107). WEEKLY면 `W_` 컬럼만 true, 나머지 false(1114/1118)
   - `SetVisibleColumnCycle`(1290줄): `D0`, `D1` 컬럼 숨김
   - `SetLayout`(1498~1538줄, `if(!_is_detail)`): `cboSearchLevel.SelectedIndex`에 따라 PRODUCT_LEVEL1~3 표시 여부가 바뀝니다(아래 표).

| cboSearchLevel.SelectedIndex | PRODUCT_LEVEL1 | PRODUCT_LEVEL2 | PRODUCT_LEVEL3 |
|---|---|---|---|
| 1 | 표시 | 표시 | 숨김 |
| 2 | 표시 | 숨김 | 숨김 |
| 3 | 숨김 | 표시 | 숨김 |
| 4 | 표시 | 표시 | 표시 |
| case 값 미추출(1536~1538, default 추정) | 숨김 | 숨김 | 숨김 |

5. **시트 전환(코드)**: `VisibleSheet`(1880~1896줄)가 `spdSearchLevel` / `spdSearchLevelDetail` / `spdDetail`의 Visible을 바꿉니다. `EnableSearchLevel`(1874줄)은 `lciSearchLevel.Enabled = !_is_detail`입니다.

### 5-1. Division별 차이

- 메타 규칙 기준: 전 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 같습니다.
  - REPORT 14/0, SEARCH_LEVEL 8/0, SEARCH_LEVEL_DETAIL 8/0
  - SCM_MST_SHEET_MEASURE `Global PSI New` 35/0
- 최종(grid_effective) 기준: REPORT 11 (?3), SEARCH_LEVEL 5 (?3), SEARCH_LEVEL_DETAIL 5 (?3). 모든 Division이 같습니다.
- 코드에 Division 변수를 비교하는 분기는 추출되지 않았습니다. Division별 Grid 변형은 **없음**입니다.
- `?3` = PRODUCT_LEVEL1~3입니다. 실행 시점의 `cboSearchLevel` 값으로 결정됩니다(런타임 분기).

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | 메인 조회(Search) 엔드포인트·SP와 차트 데이터 원천 | 추출된 엔드포인트 4개가 모두 초기화·헤더·콤보용 |
| 2 | `biz:CommonData.CommonDataList_REPORT` (code=PLAN_END_DATE)가 참조하는 테이블 | 사실 묶음에 SP·테이블 없음 |
| 3 | 엔드포인트가 추출되지 않은 핸들러 11종의 실제 동작 | ClbDivision, CboGraphType, CboSearchLevel, CboUnitQty, CboPlanType, ChkCellQty, ChkAS 등 |
| 4 | `SetSpreadColumn` 루프 시작 인덱스 | 0부터면 MONTHLY/WEEKLY 때 메타 고정 컬럼까지 숨겨짐. 실제 시작 열 확인 필요 |
| 5 | `SetLayout` 1536~1538줄 case 라벨 | 파서가 case 값을 추출하지 못함(default 여부) |
| 6 | `SetLayout`이 적용되는 시트 | sheet_hint 공란(`_SI` = 현재 활성 시트) |
| 7 | 권한(TB_FX_GroupMenuAuth 4행) 내용 | 행 수만 있고 값 없음 |
| 8 | TB_FX_SearchCondition 23행 내용 | 행 수만 있고 값 없음 |
| 9 | `splitContainer1` Orientation과 기본 SplitterDistance | props.csv가 잘림 |

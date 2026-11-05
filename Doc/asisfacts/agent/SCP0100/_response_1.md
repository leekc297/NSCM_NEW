=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SCP0100 소스 링크

기준 경로 `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\`
- CS = `SCP0100_Global_PSI_Report.cs`
- DS = `SCP0100_Global_PSI_Report.designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 호출(FoxQuery) |
| CS | GetSiteList | 1342 | `SCP.SCP0100_GET_SITE` 호출(FoxQuery) |
| CS | GetPlanDate | 1365 | `SCP.SCP0100_GET_PLAN_DATE` 호출(FoxQuery) |
| CS | GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] (via `Data_REPORT.CallBizCommonData`) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 501 | `this.Load += Form_Load` |
| CS | .ctor | 502 | `this.Shown += SCP0100_Global_PSI_Report_Shown` |
| CS | InitEvent | 1127 | `clbDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 1128 | `cboGraphType.SelectedIndexChanged += CboGraphType_SelectedIndexChanged` |
| CS | InitEvent | 1129 | `cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged` |
| CS | InitEvent | 1130 | `cboBucketType.SelectedIndexChanged += CboBucketType_SelectedIndexChanged` |
| CS | InitEvent | 1131 | `cboDisplay.SelectedIndexChanged += CboDisplay_SelectedIndexChanged` |
| CS | InitEvent | 1132 | `cboSearchLevel.SelectedIndexChanged += CboSearchLevel_SelectedIndexChanged` |
| CS | InitEvent | 1133 | `cboUnitQty.SelectedIndexChanged += CboUnitQty_SelectedIndexChanged` |
| CS | InitEvent | 1134 | `rgrpSearchLevel.SelectedIndexChanged += rgrpSearchLevel_SelectedIndexChanged` |
| CS | InitEvent | 1136 | `this.btnItemId.Click += BtnItemId_Click` |
| CS | InitEvent | 1137 | `this.btnMeasure.Click += btnMeasure_Click` |
| CS | InitEvent | 1139 | `this.btnProject.Click += BtnProject_Click` |
| CS | InitEvent | 1140 | `cboPlanType.SelectedIndexChanged += CboPlanType_SelectedIndexChanged` |
| CS | InitEvent | 1141 | `this.btnColumn.Click += BtnColumn_Click` |
| CS | InitEvent | 1143 | `dCalendar.ValueChanged += DCalendar_ValueChanged` |
| CS | InitEvent | 1144 | `chkCellQty.CheckedChanged += ChkCellQty_CheckedChanged` |
| CS | InitEvent | 1145 | `chkAS.CheckedChanged += ChkAS_CheckedChanged` |

## 3. 프레임워크 메타 소비 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | getPlanStartYYYYMMDD | 215 | `CString.GetCheckedListValue` (CODE) |
| CS | getFromSite | 306 | `GetCheckedListValue` (CODE) |
| CS | getToSite | 325 | `GetCheckedListValue` (CODE) |
| CS | getPlanType | 344 | `GetCheckedListValue` (CODE) |
| CS | getSearchLevel | 412 | `GetCheckedListValue` (CODE) |
| CS | getDivision | 466 | `GetCheckedListValue` (CODE) |
| CS | OnShown | 522 | `BaseForm.OnShown` (NowGroupID, USER_ID) |
| CS | InitSpread | 703 | `SpreadInfo.GetSpdTitle` (COLUMN_NAME, SORT_ORDER_NO) |
| CS | InitSpread | 705 | `SpreadInfo.SetSheetHeaderColumn(_SI, 3)` — 메타 컬럼 생성 |
| CS | InitSpread | 706 | `InitSpreadDateColumn(_SI, _SI.nIdxData)` — 화면 자체 정의(DB 루프) |

## 4. Grid 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 684 | `AddSheet` spdSearchLevel / SEARCH_LEVEL |
| CS | CreateSpread | 685 | `AddSheet` spdDetail / REPORT |
| CS | CreateSpread | 686 | `AddSheet` spdSearchLevelDetail / SEARCH_LEVEL_DETAIL |
| CS | CreateSpread | 688~690 | `GetSheetInfo` 시트 3개 |
| CS | CreateSpread | 692~693 | `ChangeSheet` |
| CS | InitSpread | 702 | `InitSheet(_SI.SheetName)` |
| CS | InitSpread | 708 | `SetSpreadColumn()` |
| CS | InitSpreadDateColumn | 755 | `AddTextColumn` (B_ 포함, 폭 0, 숨김) |
| CS | InitSpreadDateColumn | 760 | `AddNumColumn` (폭 70, 표시) |
| CS | InitSpreadDateColumn | 767 | ForeColor Red (M_ & `_plan_start_yyyymm`) |
| CS | InitSpreadDateColumn | 774 / 778 | ForeColor Blue (W_ & 라벨 "A" / "B") |
| CS | InitSpreadDateColumn | 787~816 | `ColumnHeaderSpan` 3단 헤더 (Large / Small / "Qty") |
| CS | SetSpreadColumn | 1103 / 1107 | MONTHLY: M_ 표시, 그 외 숨김 |
| CS | SetSpreadColumn | 1114 / 1118 | WEEKLY: W_ 표시, 그 외 숨김 |
| CS | SetVisibleColumnCycle | 1290 | D0, D1 숨김 |
| CS | SetLayout | 1498~1538 | cboSearchLevel별 PRODUCT_LEVEL1~3 표시 여부 |
| CS | CboBucketType_SelectedIndexChanged | 1804 | `SetSpreadColumn()` (if `_SI != null`) |

## 5. 화면 동작 속성

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CboDisplay_SelectedIndexChanged | 1833 | `splitContainer1.SplitterDistance = 0` |
| CS | CboDisplay_SelectedIndexChanged | 1841 | `SplitterDistance = 750` |
| CS | CboDisplay_SelectedIndexChanged | 1849 | `SplitterDistance = 270` |
| CS | EnableSearchLevel | 1874 | `lciSearchLevel.Enabled = !_is_detail` |
| CS | VisibleSheet | 1880~1882 | spdSearchLevel=false, spdSearchLevelDetail=false, spdDetail=true |
| CS | VisibleSheet | 1888~1889 | spdSearchLevelDetail=true, spdSearchLevel=false |
| CS | VisibleSheet | 1893~1896 | spdSearchLevelDetail=false, spdSearchLevel=true, spdDetail=false |
| CS | BtnItemId_Click | 1947 | `txtItemId.Text = sItemId` |
| CS | BtnProject_Click | 1981 | `txtProject.Text = sProjectCode` |
| DS | InitializeComponent | 192~197 | usrConditionPanel1 Dock=Top, Size(1784,102), HidePanel |
| DS | InitializeComponent | 248~284 | chkCellQty Checked=true, Text "Cell Qty", Visible=false |
| DS | InitializeComponent | 927~929 | chkAS Text "A/S", Visible=false |
| DS | InitializeComponent | 1159 | PlanType(LayoutControlItem) Enabled=false |

## 6. 컨트롤 선언 (designer)

| 파일 | 줄 | 컨트롤 |
|---|---:|---|
| DS | 36~59 | usrButton1, usrConditionPanel1, usrLayoutControl2, rgrpSearchLevel, chkCellQty, cboPlanDate, cboBucketType, dCalendar, cboGraphType, btnItemId, btnMeasure, txtItemId, cboDisplay, txtProject, clbFromSite, clbToSite, txtCellGroup, btnProject, cboPlanType, btnColumn, cboSearchLevel, chkAS, cboUnitQty, clbDivision |
| DS | 60~90 | layoutControlGroup2 및 LayoutControlItem / EmptySpaceItem |
| DS | 91~98 | splitContainer1, chartMain, spdSearchLevel, spdMain_Sheet, spdDetail, spdSearchLevel_Sheet, spdSearchLevelDetail, spdSearchLevelDetail_Sheet |

=== FILE: web_components.md ===
# SCP0100 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. props.csv가 잘려서 라벨을 못 찾은 항목은 **확인 필요**로 적었습니다.

| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| clbDivision | UsrCheckedList2 | 확인 필요 | 확인 필요 | Wijmo MultiSelect (공용 멀티선택 콤보) | Size(179,21) |
| clbFromSite | UsrCheckedList2 | From Site | layoutControlItem1 | Wijmo MultiSelect | Size(202,21) |
| clbToSite | UsrCheckedList2 | To Site | lblToSite | Wijmo MultiSelect | Size(214,21). 목록은 SCP0100_GET_SITE |
| cboPlanDate | UsrCombo | 확인 필요 (layoutPlanDate 추정) | 확인 필요 | Wijmo ComboBox | SCP0100_GET_PLAN_DATE 결과 |
| cboBucketType | UsrCombo | Bucket | lblBucket | Wijmo ComboBox | MONTHLY / WEEKLY |
| cboPlanType | UsrCombo | Plan-type | PlanType | Wijmo ComboBox | LayoutItem Enabled=false |
| cboGraphType | UsrCombo | Graph | lblGraphType | Wijmo ComboBox | |
| cboDisplay | UsrCombo | Display | layDisplay | Wijmo ComboBox | 분할 비율 전환 |
| cboSearchLevel | UsrCombo | 확인 필요 (lciSearchLevel 추정) | 확인 필요 | Wijmo ComboBox | PRODUCT_LEVEL 표시 제어 |
| cboUnitQty | UsrCombo | 확인 필요 (layUnit_qty 추정) | 확인 필요 | Wijmo ComboBox | |
| rgrpSearchLevel | RadioGroup | 확인 필요 | 확인 필요 | Radio 그룹 (hook #154 v2 방식) | Size(199,25) |
| dCalendar | UsrDateRangePicker3 | 확인 필요 (layPeriod 추정) | 확인 필요 | 기간 선택 (공용 DateRange) | Size(230,22) |
| txtItemId | UsrTextBox | Model / Nick Name | layModel | Input + 팝업 버튼 | |
| btnItemId | UsrButton | - | layoutbtnitem | 팝업 호출 버튼 | 결과를 txtItemId에 세팅 |
| txtProject | UsrTextBox | Project | lblCellGroup | Input + 팝업 버튼 | |
| btnProject | UsrButton | - | layoutControlItem2 | 팝업 호출 버튼 | 결과를 txtProject에 세팅 |
| txtCellGroup | UsrTextBox | Cell Group | lblCellGroup1 | Input | Size(111,25) |
| btnMeasure | UsrButton | 확인 필요 (layMeasure 추정) | 확인 필요 | 버튼 → 헤더 재구성 | |
| btnColumn | UsrButton | 확인 필요 (layoutBtnColumn 추정) | 확인 필요 | 버튼 → 헤더 재구성 | |
| chkCellQty | UsrCheckBox | Cell Qty | 확인 필요 | CheckBox | Checked=true, Visible=false |
| chkAS | UsrCheckBox | A/S | layAS 추정 | CheckBox | Visible=false |
| usrButton1 | UsrButton | 확인 필요 | - | 확인 필요 | Size(75,23), parent 없음 |
| chartMain | ChartControl | - | - | Wijmo FlexChart | splitContainer1.Panel1 |
| spdSearchLevel | FpSpread | - | - | Wijmo FlexGrid (SEARCH_LEVEL) | Panel2 |
| spdDetail | FpSpread | - | - | Wijmo FlexGrid (REPORT) | Panel2 |
| spdSearchLevelDetail | FpSpread | - | - | Wijmo FlexGrid (SEARCH_LEVEL_DETAIL) | Panel2 |
| layCategoryCC, layoutControlItem3, layoutControlItem4 | LayoutControlItem | 확인 필요 | - | 확인 필요 | 연결 컨트롤 미추출 |

## 2. 화면 배치

| 영역 | 근거 | 내용 |
|---|---|---|
| 조회조건 | usrConditionPanel1 Dock=Top, Size(1784,102), UsrPanelType=HidePanel | 상단 고정 조건 패널(접기 가능 패널로 추정 — 확인 필요) |
| 본문 | splitContainer1 (Panel1 = chartMain, Panel2 = Spread 3개) | 차트와 그리드 분할 |
| 분할 방향 | Orientation 값이 props.csv 잘린 부분에 있음 | **확인 필요** (상/하 또는 좌/우) |
| 분할 비율 | `CboDisplay_SelectedIndexChanged`: SplitterDistance 0 / 750 / 270 | 0 = 차트 영역 0(그리드 위주), 750 / 270 = 차트 영역 크기. 각 값과 cboDisplay 항목의 대응, 전체 Size는 **확인 필요** |
| 그리드 전환 | `VisibleSheet` | Panel2에서 시트 1개만 보이게 전환(detail ↔ search level ↔ search level detail) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

전 Division(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC)이 같습니다. Division별 표시 차이는 **없음**입니다.

### 3-1. REPORT (spdDetail) — 최종 11 (?3)

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| CELL_CF | Cell Qty | META | 기본 |
| CELL_GROUP | Cell Group | META | 기본 |
| DIVISION_ID | Div | META | 기본 |
| FROM_SITE | From Site | META | 기본 |
| TO_SITE | To Site | META | 기본 |
| INCOTERMS | INCOTERMS | META | 기본 |
| ITEM_ID | Model | META | 기본 |
| MEASURE_GROUP | Measure Group | META | 기본 |
| MEASURE_NAME | Measure Name | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| OPERATION_ID | Operation | META | 기본 |
| VARIOUS_KEY | Trans Mode or Line or Project | META | 기본 |
| PRODUCT_LEVEL1 | Product Level1 | META + 코드 | 기본 → SetLayout 런타임(?) |
| PRODUCT_LEVEL2 | Product Level2 | META + 코드 | 기본 → SetLayout 런타임(?) |
| PRODUCT_LEVEL3 | Product Level3 | META + 코드 | 기본 → SetLayout 런타임(?) |
| D0, D1 | - | CODE_ONLY_CHANGE | → 숨김 (SetVisibleColumnCycle) |
| (기간 컬럼 M_* / W_* / *B_*) | SP 결과 COLUMN_LABEL_NAME | DB루프 (SCP0100_GET_SHEET_CALENDAR_3SPAN) | Bucket에 따라 M_ 또는 W_만 표시. B_ 포함 열은 숨김 |

### 3-2. SEARCH_LEVEL (spdSearchLevel) — 최종 5 (?3)

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| CELL_GROUP | Cell Group | META | 기본 |
| DIVISION_ID | Div | META | 기본 |
| MEASURE_GROUP | Measure Group | META | 기본 |
| MEASURE_NAME | Measure Name | META | 기본 |
| OPERATION_GROUP | Operation Group | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | META + 코드 | 기본 → SetLayout 런타임(?) |
| D0, D1 | - | CODE_ONLY_CHANGE | → 숨김 |
| (기간 컬럼) | SP 결과 | DB루프 | REPORT와 같은 규칙 |

### 3-3. SEARCH_LEVEL_DETAIL (spdSearchLevelDetail) — 최종 5 (?3)

컬럼과 표시 규칙은 SEARCH_LEVEL과 같습니다: CELL_GROUP, DIVISION_ID, MEASURE_GROUP, MEASURE_NAME, OPERATION_GROUP = 기본 / MEASURE_UI = 숨김 / PRODUCT_LEVEL1~3 = 런타임 / D0·D1 = 숨김 / 기간 컬럼 = DB 루프.

### 3-4. 공통 코드 규칙 (세 시트 공통)

- 3단 헤더: 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, 2행 "Qty"
- Num 컬럼 폭 70
- M_ 컬럼 중 계획 시작월(`_plan_start_yyyymm`) 포함 열 = 글자색 Red
- W_ 컬럼 중 라벨에 "A" 또는 "B" 포함 열 = 글자색 Blue
- PRODUCT_LEVEL 표시(`!_is_detail`일 때만)

| cboSearchLevel | L1 | L2 | L3 |
|---|---|---|---|
| 1 | O | O | X |
| 2 | O | X | X |
| 3 | X | O | X |
| 4 | O | O | O |
| case 미추출 | X | X | X |

- 메시지 차원 메타: SCM_MST_SHEET_MEASURE 시트 `Global PSI New` 35행(전 Division 35/0). 시트와의 연결 방식은 **확인 필요**

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| REPORT | META+코드연결 | 메타 시트를 코드가 AddSheet / ChangeSheet로 사용 |
| SEARCH_LEVEL | META+코드연결 | 같음 |
| SEARCH_LEVEL_DETAIL | META+코드연결 | 같음 |

- 시트 사이 전환은 `VisibleSheet`가 `_is_detail` 등 상태에 따라 수행합니다. 전환 조건값은 **확인 필요**입니다.
- 그리드 행 ↔ 차트 연동 여부는 사실 묶음에 없어 **확인 필요**입니다.

=== FILE: oracle_migration.md ===
# SCP0100 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 메서드(줄) | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| SCP0100_GET_SHEET_CALENDAR_3SPAN | SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle(1326) | SELECT: SCM_SYS_CALENDAR_M | 자기 자신만 (하위 EXEC 없음) |
| SCP0100_GET_SITE | SCP.SCP0100_GET_SITE | GetSiteList(1342) | SELECT: SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF: FN_SPLITSTRING | 자기 자신만 |
| SCP0100_GET_PLAN_DATE | SCP.SCP0100_GET_PLAN_DATE | GetPlanDate(1365) | INSERT/SELECT: #TMP_PLAN / SELECT: SCP_PLAN_VERSION_V, SCM_SYS_CALENDAR_M, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF: FN_CHAR_TO_DATE, FN_SPLITSTRING | 자기 자신만 |

- 참조 테이블과 뷰를 합친 목록(중복 제거): SCM_SYS_CALENDAR_M, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW, SCP_PLAN_VERSION_V, SCP_PLN_INTERFACE_YN
- 참조 함수: FN_SPLITSTRING, FN_CHAR_TO_DATE
- 임시 테이블: #TMP_PLAN (SCP0100_GET_PLAN_DATE)

## 2. 공통코드 분기

| 호출 | code | 대상 테이블 |
|---|---|---|
| `biz:CommonData.CommonDataList_REPORT` (via `Data_REPORT.CallBizCommonData`) | `{?Data_REPORT.Type.PLAN_END_DATE}` | **확인 필요** — 사실 묶음에 SP·테이블 정보 없음 |

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 미등록 SP: 사실 묶음 기준 **0건**. 3개 모두 MATCH입니다.
- 직접 SQL 호출: **0건**
- Biz 경유 호출 1건: CommonDataList_REPORT. 내부 SP는 **확인 필요**입니다.
- 주석 처리된 호출: **0건**
- 메인 리포트 데이터 조회 SP: 추출되지 않았습니다(**확인 필요**). 아래 사실로 미루어 메인 조회 SP가 따로 있을 가능성이 높지만, SP명은 사실 묶음에 없습니다.
  - 리포트 원천 테이블 SCP_RPT_GLOBAL_PSI_MD_MM / _WW가 SITE·PLAN_DATE SP에서 참조됨
  - 기간 컬럼명 M_ / W_ 규칙이 있음

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 사실 | 확인 포인트 |
|---:|---|---|---|
| 1 | SCP0100_GET_PLAN_DATE | `#TMP_PLAN` INSERT 후 SELECT | MSSQL 로컬 임시테이블 → Oracle GTT(ON COMMIT 옵션) 또는 CTE/서브쿼리로 바꿈. GTT 쓰면 DDL 자급(배포 패키지 동봉) 필요 |
| 2 | SCP0100_GET_PLAN_DATE | REF: FN_CHAR_TO_DATE | Oracle 동등 함수(또는 TO_DATE) 존재 여부와 포맷 인자 확인 |
| 3 | SCP0100_GET_SITE, SCP0100_GET_PLAN_DATE | REF: FN_SPLITSTRING | 멀티선택 파라미터(Division·Site 등 `GetCheckedListValue` 결과) 분해 함수. Oracle 버전 존재 여부와 VARCHAR2 길이 한도 확인 |
| 4 | SCP0100_GET_SHEET_CALENDAR_3SPAN | SELECT: SCM_SYS_CALENDAR_M | 반환 컬럼 COLUMN_NAME, COLUMN_LABEL_NAME, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME, DAY_CODE, SORT_ORDER_NO(프레임워크 소비 컬럼)를 Oracle 결과셋 컬럼명(대문자)과 맞춰야 함. 컬럼명 접두 M_ / W_ / B_ 규칙 유지 필요 |
| 5 | 전 SP | 결과셋 반환 | MSSQL SELECT 결과셋 → Oracle SYS_REFCURSOR OUT 변환 |
| 6 | SCP_PLAN_VERSION_V | 뷰 | Oracle 측 뷰 존재와 정의 확인 |
| 7 | 정렬 | SORT_ORDER_NO 소비 | 그리드 조회 SP에 ORDER BY 명시 여부 확인 |
| 8 | CommonDataList_REPORT (PLAN_END_DATE) | Biz 경유 | TO-BE 공통 콤보/코드 SP로 대체할 대상 확인 |

## 5. 난이도 (사실 근거)

| SP | 난이도 | 근거 |
|---|---|---|
| SCP0100_GET_SHEET_CALENDAR_3SPAN | 낮음 | 참조 테이블 1개(SCM_SYS_CALENDAR_M), 임시테이블·함수 참조 없음 |
| SCP0100_GET_SITE | 중간 | 테이블 2개 + FN_SPLITSTRING 의존 |
| SCP0100_GET_PLAN_DATE | 중간~높음 | #TMP_PLAN 임시테이블, 함수 2종(FN_CHAR_TO_DATE, FN_SPLITSTRING), 테이블·뷰 5종 참조 |

> SP 본문 원문은 사실 묶음에 없습니다. MSSQL 키워드(DATEADD, ISNULL 등)가 남아 있는지는 원문을 확보한 뒤 **확인 필요**입니다.

=== FILE: tobe_design.md ===
# SCP0100 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순서 | 조건 | As-is 컨트롤 | 라벨(원문) | 값 원천 | 비고 |
|---:|---|---|---|---|---|
| 1 | Division | clbDivision (멀티) | 확인 필요 | 확인 필요 | `getDivision`(466) GetCheckedListValue |
| 2 | Plan Date | cboPlanDate | 확인 필요 | SCP0100_GET_PLAN_DATE | 변경 시 기간과 헤더를 다시 만듦 |
| 3 | 기간 | dCalendar (DateRange) | 확인 필요 | GetPlanEndDate(CommonDataList_REPORT, PLAN_END_DATE) | 변경 시 헤더 재구성 |
| 4 | Bucket | cboBucketType | Bucket | 확인 필요 | MONTHLY / WEEKLY 컬럼 표시 전환 |
| 5 | Plan-type | cboPlanType | Plan-type | 확인 필요 | LayoutItem Enabled=false. `getPlanType`(344) |
| 6 | From Site | clbFromSite (멀티) | From Site | 확인 필요 | `getFromSite`(306) |
| 7 | To Site | clbToSite (멀티) | To Site | SCP0100_GET_SITE | `getToSite`(325) |
| 8 | Model | txtItemId + btnItemId | Model / Nick Name | 팝업 | |
| 9 | Project | txtProject + btnProject | Project | 팝업 | |
| 10 | Cell Group | txtCellGroup | Cell Group | 직접 입력 | |
| 11 | Search Level | cboSearchLevel / rgrpSearchLevel | 확인 필요 | 확인 필요 | `getSearchLevel`(412). PRODUCT_LEVEL 표시 제어 |
| 12 | Unit Qty | cboUnitQty | 확인 필요 | 확인 필요 | |
| 13 | Graph | cboGraphType | Graph | 확인 필요 | 차트 유형 |
| 14 | Display | cboDisplay | Display | 확인 필요 | 차트/그리드 분할 0 / 750 / 270 |
| 15 | Measure / Column | btnMeasure / btnColumn | 확인 필요 | - | 헤더 재구성 |
| - | Cell Qty | chkCellQty | Cell Qty | - | Visible=false, Checked=true |
| - | A/S | chkAS | A/S | - | Visible=false |

> 조회조건 순서와 라벨은 SCP 기준표(search_cond.csv, CR-071)를 우선해야 합니다. 사실 묶음에는 기준표가 없어 **확인 필요**입니다. TB_FX_SearchCondition 23행도 내용 확인이 필요합니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러 | 호출 API 후보 | 동작 |
|---|---|---|---|
| 화면 로드 | `Form_Load` | `SCP0100_GET_PLAN_DATE`, `SCP0100_GET_SHEET_CALENDAR_3SPAN`, 공통 PLAN_END_DATE | 콤보·기간 초기화, 그리드 헤더 생성 |
| 화면 표시 후 | `SCP0100_Global_PSI_Report_Shown` | `SCP0100_GET_SITE` | To Site 목록 |
| Plan Date 변경 | `CboPlanDate_SelectedIndexChanged` | `SCP0100_GET_SHEET_CALENDAR_3SPAN`, PLAN_END_DATE | 기간·헤더 재구성 |
| 기간 변경 | `DCalendar_ValueChanged` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Search Level 라디오 변경 | `rgrpSearchLevel_SelectedIndexChanged` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Measure 버튼 | `btnMeasure_Click` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Column 버튼 | `BtnColumn_Click` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Bucket 변경 | `CboBucketType_SelectedIndexChanged` | 없음(FE) | M_ / W_ 컬럼 표시 전환 |
| Display 변경 | `CboDisplay_SelectedIndexChanged` | 없음(FE) | 분할 비율 변경 |
| Model 팝업 | `BtnItemId_Click` | 팝업 API 확인 필요 | txtItemId 세팅 |
| Project 팝업 | `BtnProject_Click` | 팝업 API 확인 필요 | txtProject 세팅 |
| Division 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | |
| Graph 변경 | `CboGraphType_SelectedIndexChanged` | 확인 필요 | |
| Search Level 콤보 | `CboSearchLevel_SelectedIndexChanged` | 확인 필요 | PRODUCT_LEVEL 표시(SetLayout) 관련 추정 |
| Unit Qty | `CboUnitQty_SelectedIndexChanged` | 확인 필요 | |
| Plan-type | `CboPlanType_SelectedIndexChanged` | 확인 필요 | |
| Cell Qty 체크 | `ChkCellQty_CheckedChanged` | 확인 필요 | 컨트롤 Visible=false |
| A/S 체크 | `ChkAS_CheckedChanged` | 확인 필요 | 컨트롤 Visible=false |
| 조회(Search) | 미추출 | **확인 필요** (메인 리포트 SP) | 그리드·차트 데이터 |

## 3. Division별 Grid 변형 요약

- 변형 **없음**: 전 Division 14종의 메타·최종 컬럼 수가 같고, 코드에 Division 비교 분기도 없습니다.
- 최종 표시 컬럼 수: REPORT 11 (+런타임 PRODUCT_LEVEL 3), SEARCH_LEVEL 5 (+3), SEARCH_LEVEL_DETAIL 5 (+3)
- 동적 요소(전 Division 공통):
  - 기간 컬럼 DB 루프(SCP0100_GET_SHEET_CALENDAR_3SPAN)
  - Bucket별 M_ / W_ 표시
  - D0·D1 숨김
  - 계획 시작월 Red, W_ 라벨 A·B Blue
  - 3단 헤더

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴·프로그램 등록 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 |
| 그룹 메뉴 권한 | TB_FX_GroupMenuAuth 4행 — C/R/U/D 값은 사실 묶음에 없음, **확인 필요** |
| 즐겨찾기 | TB_FX_Favorite 2행 |
| 세션 정보 | `BaseForm.OnShown`(522)에서 NowGroupID, USER_ID 소비 |
| 저장 / 삭제 | 추출된 저장 계열 엔드포인트 없음 |

## 5. 미확정 사항

1. 메인 조회 SP와 차트 데이터 SP
2. CommonDataList_REPORT(PLAN_END_DATE)의 원천과 TO-BE 대체 API
3. 엔드포인트가 추출되지 않은 핸들러 11종의 실제 로직
4. `SetSpreadColumn` 루프 시작 인덱스(고정 컬럼까지 숨기는지 여부)
5. `SetLayout` 마지막 case 라벨과 적용 대상 시트
6. `VisibleSheet` 전환 조건(`_is_detail` 결정 지점)
7. splitContainer1 Orientation, 그리고 cboDisplay 항목과 SplitterDistance(0 / 750 / 270)의 대응
8. 라벨을 찾지 못한 LayoutControlItem의 Text: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layAS, layCategoryCC, layoutControlItem3·4, layoutPlanDate
9. SCM_MST_SHEET_MEASURE `Global PSI New` 35행과 시트·차트 사이의 연결 방식
10. TB_FX_SearchCondition 23행 내용과 SCP 조회조건 기준표 대조

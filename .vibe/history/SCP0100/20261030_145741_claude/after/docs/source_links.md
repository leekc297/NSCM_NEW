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

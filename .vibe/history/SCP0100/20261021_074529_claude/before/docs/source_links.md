# SCP0100 소스 링크 표

기준 경로: `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\`
- `.cs` = `SCP0100_Global_PSI_Report.cs`
- `.designer.cs` = `SCP0100_Global_PSI_Report.designer.cs`

## 1. 엔드포인트 호출 지점 (전수 4건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0100_Global_PSI_Report.cs | GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 호출 (fox) |
| SCP0100_Global_PSI_Report.cs | GetSiteList | 1342 | `SCP.SCP0100_GET_SITE` 호출 (fox) |
| SCP0100_Global_PSI_Report.cs | GetPlanDate | 1365 | `SCP.SCP0100_GET_PLAN_DATE` 호출 (fox) |
| SCP0100_Global_PSI_Report.cs | GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] (via Data_REPORT.CallBizCommonData) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | .ctor | 501 | `this.Load += Form_Load` |
| .cs | .ctor | 502 | `this.Shown += SCP0100_Global_PSI_Report_Shown` |
| .cs | InitEvent | 1127 | `clbDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| .cs | InitEvent | 1128 | `cboGraphType.SelectedIndexChanged += CboGraphType_SelectedIndexChanged` |
| .cs | InitEvent | 1129 | `cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged` |
| .cs | InitEvent | 1130 | `cboBucketType.SelectedIndexChanged += CboBucketType_SelectedIndexChanged` |
| .cs | InitEvent | 1131 | `cboDisplay.SelectedIndexChanged += CboDisplay_SelectedIndexChanged` |
| .cs | InitEvent | 1132 | `cboSearchLevel.SelectedIndexChanged += CboSearchLevel_SelectedIndexChanged` |
| .cs | InitEvent | 1133 | `cboUnitQty.SelectedIndexChanged += CboUnitQty_SelectedIndexChanged` |
| .cs | InitEvent | 1134 | `rgrpSearchLevel.SelectedIndexChanged += rgrpSearchLevel_SelectedIndexChanged` |
| .cs | InitEvent | 1136 | `this.btnItemId.Click += BtnItemId_Click` |
| .cs | InitEvent | 1137 | `this.btnMeasure.Click += btnMeasure_Click` |
| .cs | InitEvent | 1139 | `this.btnProject.Click += BtnProject_Click` |
| .cs | InitEvent | 1140 | `cboPlanType.SelectedIndexChanged += CboPlanType_SelectedIndexChanged` |
| .cs | InitEvent | 1141 | `this.btnColumn.Click += BtnColumn_Click` |
| .cs | InitEvent | 1143 | `dCalendar.ValueChanged += DCalendar_ValueChanged` |
| .cs | InitEvent | 1144 | `chkCellQty.CheckedChanged += ChkCellQty_CheckedChanged` |
| .cs | InitEvent | 1145 | `chkAS.CheckedChanged += ChkAS_CheckedChanged` |

## 3. 조회조건 값 수집 (GetCheckedListValue → CODE)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | getPlanStartYYYYMMDD | 215 | CString.GetCheckedListValue |
| .cs | getFromSite | 306 | CString.GetCheckedListValue |
| .cs | getToSite | 325 | CString.GetCheckedListValue |
| .cs | getPlanType | 344 | CString.GetCheckedListValue |
| .cs | getSearchLevel | 412 | CString.GetCheckedListValue |
| .cs | getDivision | 466 | CString.GetCheckedListValue |
| .cs | OnShown | 522 | BaseForm.OnShown (NowGroupID, USER_ID) |

## 4. Grid 구성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | CreateSpread | 684 | AddSheet spdSearchLevel → `SEARCH_LEVEL` (3 ¦ 1 ¦ 30) |
| .cs | CreateSpread | 685 | AddSheet spdDetail → `REPORT` (3 ¦ 1 ¦ 30) |
| .cs | CreateSpread | 686 | AddSheet spdSearchLevelDetail → `SEARCH_LEVEL_DETAIL` (3 ¦ 1 ¦ 30) |
| .cs | CreateSpread | 688~690 | GetSheetInfo(spdSearchLevel / spdDetail / spdSearchLevelDetail, 0) |
| .cs | CreateSpread | 692, 693 | ChangeSheet |
| .cs | InitSpread | 702 | InitSheet(_SI.SheetName) |
| .cs | InitSpread | 703 | GetSpdTitle |
| .cs | InitSpread | 705 | SetSheetHeaderColumn(_SI, 3) — 메타 컬럼 생성 |
| .cs | InitSpread | 706 | InitSpreadDateColumn(_SI, _SI.nIdxData) |
| .cs | InitSpread | 708 | SetSpreadColumn() |
| .cs | InitSpreadDateColumn | 755 | AddTextColumn (`B_` 포함, 폭 0, 숨김) |
| .cs | InitSpreadDateColumn | 760 | AddNumColumn (폭 70, 표시) |
| .cs | InitSpreadDateColumn | 767 | ForeColor = Red (`M_` + `_plan_start_yyyymm` 포함) |
| .cs | InitSpreadDateColumn | 774 | ForeColor = Blue (`W_` + 라벨 "A") |
| .cs | InitSpreadDateColumn | 778 | ForeColor = Blue (`W_` + 라벨 "B") |
| .cs | InitSpreadDateColumn | 787~816 | ColumnHeaderSpan (LARGE / SMALL_CLASS_LABEL_NAME, "Qty") |
| .cs | SetSpreadColumn | 1103 / 1107 | MONTHLY: `M_` 표시 / 그 외 숨김 |
| .cs | SetSpreadColumn | 1114 / 1118 | WEEKLY: `W_` 표시 / 그 외 숨김 |
| .cs | SetVisibleColumnCycle | 1290 | D0, D1 숨김 |
| .cs | SetLayout | 1498~1538 | PRODUCT_LEVEL1~3 표시·숨김 (cboSearchLevel.SelectedIndex) |
| .cs | CboBucketType_SelectedIndexChanged | 1804 | `if(_SI != null)` SetSpreadColumn |

## 5. 화면 동작 코드 (props)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | CboDisplay_SelectedIndexChanged | 1833 | splitContainer1.SplitterDistance = 0 |
| .cs | CboDisplay_SelectedIndexChanged | 1841 | splitContainer1.SplitterDistance = 750 |
| .cs | CboDisplay_SelectedIndexChanged | 1849 | splitContainer1.SplitterDistance = 270 |
| .cs | EnableSearchLevel | 1874 | lciSearchLevel.Enabled = !_is_detail |
| .cs | VisibleSheet | 1880~1882 | spdSearchLevel=false, spdSearchLevelDetail=false, spdDetail=true |
| .cs | VisibleSheet | 1888~1889 | spdSearchLevelDetail=true, spdSearchLevel=false |
| .cs | VisibleSheet | 1893~1896 | spdSearchLevelDetail=false, spdSearchLevel=true, spdDetail=false |
| .cs | BtnItemId_Click | 1947 | txtItemId.Text = sItemId |
| .cs | BtnProject_Click | 1981 | txtProject.Text = sProjectCode |

## 6. 디자이너 (컨트롤 선언 범위)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .designer.cs | (선언부) | 36~98 | 컨트롤 63개 선언 |
| .designer.cs | InitializeComponent | 192~197 | usrConditionPanel1: Dock=Top, 1784×102, HidePanel |
| .designer.cs | InitializeComponent | 248~284 | chkCellQty: Checked=true, Text "Cell Qty", Visible=false |
| .designer.cs | InitializeComponent | 927~929 | chkAS: Text "A/S", Visible=false |
| .designer.cs | InitializeComponent | 1055~1176 | LayoutControlItem의 Control·Text 매핑 (web_components.md §1) |
| .designer.cs | InitializeComponent | 1159 | PlanType(LayoutControlItem): Enabled=false |

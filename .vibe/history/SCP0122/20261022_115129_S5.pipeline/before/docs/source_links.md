# SCP0122 소스 링크

기준 경로: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\`

## 1. 엔드포인트 호출 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L47) | `<field:dtProcessCdAll>` | 47 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common → Data.CallBizCommonData) |
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L155) | GetPlanGroupByUserID | 155 | `SCP.SCP0121_GET_SEARCH_INFO` |
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L321) | FindData_Main | 321 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` |
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L480) | Save_Data | 480 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0122_PlanActivityMgmt.cs | .ctor | 98 | `this.Load += Form_Load` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 217 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 218 | `cboPlanGroup.SelectedIndexChanged += CboPlanGroup_SelectedIndexChanged` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 220 | `this.spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 221 | `this.spdMain.CellClick += spdMain_CellClick` |

## 3. Grid / 메타 / 기타

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0122_PlanActivityMgmt.cs | GetPlanGroupByUserID | 143 | `FoxUserInfoContext.Current` → `NowGroupID` |
| SCP0122_PlanActivityMgmt.cs | RefreshPlanGroupByDivision | 171 | `GetCheckedListValue` (CODE) |
| SCP0122_PlanActivityMgmt.cs | CreateSpread | 185 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)` → "Plan Activity Mgmt" |
| SCP0122_PlanActivityMgmt.cs | CreateSpread | 186 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| SCP0122_PlanActivityMgmt.cs | CreateSpread | 188 | `ChangeSheet` |
| SCP0122_PlanActivityMgmt.cs | InitSpread | 197 | `ChangeSheet(0)` |
| SCP0122_PlanActivityMgmt.cs | InitSpread | 198 | `ChangeActiveSheet(SpdSheet.shtMain)` |
| SCP0122_PlanActivityMgmt.cs | SetSpreadInit | 205 | `ChangeSheet(0)` — `if(sheetName.Equals("Plan Activity Mgmt"))` |
| SCP0122_PlanActivityMgmt.cs | SetSpreadInit | 206 | `InitSheet(0)` — 같은 분기 |
| SCP0122_PlanActivityMgmt.cs | SetSpreadInit | 212 | `SetSheetHeaderColumnSCP(siObj, 1, false, "")` (메타 컬럼 생성) |
| SCP0122_PlanActivityMgmt.cs | EditButton | 275 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` — `if(spdMain != null)` |
| SCP0122_PlanActivityMgmt.cs | FindData_Main | 306 | `ChangeSheet(SpdSheet.shtMain)` |
| SCP0122_PlanActivityMgmt.cs | FindData_Main | 308 / 309 / 310 | `GetCheckedListValue` (CODE) ×3 |
| SCP0122_PlanActivityMgmt.cs | Insert_Row | 367 | `GetCheckedListValue` (CODE) |
| SCP0122_PlanActivityMgmt.cs | SpdMain_ClipboardPasted | 574 | `dtPlanGroup` NAME → CODE 변환 |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 252~255 | ColumnHeader 스타일 (HorizontalAlignment / NoteIndicatorColor / Parent / VerticalAlignment) |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 199 | layoutControlItem2.Text = "Process" |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 210 | layoutControlItem9.Text = "Plan Group" |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 293 | this.Text = "SCP0122_PlanActivityMgmt" |

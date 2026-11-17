# SSP0017 소스 링크 표

> 기준 경로: AS-IS GSCM 소스 루트 아래 `06.UIL\GSCM.SSP.Plan.UIL\`

## 1. 엔드포인트 호출 지점 (활성 전부)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `<field:dtInventoryStatus>` | 49 | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] (`Data.Common` → `Data.CallBizCommonData`) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitControls` | 179 | `biz:CommonData.CommonDataList` [code=LookupCommon] (`Data.Common` → `Data.CallBizCommonData`) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `SetChangedControl` | 365 | `biz:CommonData.CommonDataList` [code=PlanDateShip] (`Data.Common` → `Data.CallBizCommonData`) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `FindData_Main` | 405 | `SSP.SSP0017_GET_INVENTORY_RAW` → SP `SSP0017_GET_INVENTORY_RAW` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `GetDivision` | 478 | `SCM.SCM0001_GET_DIVISION` → SP `SCM0001_GET_DIVISION` (진입점 미연결) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `GetDayRange` | 514 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` → SP `SCM0001_GET_SCP_DAY_PERIOD` (진입점 미연결) |

## 2. 주석 처리된 호출 (현행 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | 513 | 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | 531 | 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | 532 | 주석 처리됨: `SCP.SCM0001_GET_SCP_PERIOD` |

## 3. 이벤트 등록

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `.ctor` | 122 | `this.Load += Form_Load` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 243 | `spdMain.TopChange += SpdMain_TopChange` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 244 | `this.btnItemId.Click += btnItemId_Click` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 245 | `this.btnMeasure.Click += btnMeasure_Click` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 247 | `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |

## 4. Grid / 컨트롤 초기화 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `<field:dtMyDivision>` | 46 | `UserInfoContext.Current` → `NowGroupID` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitControls` | 176 | `clbDivision.Enabled = false` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `CreateSpread` | 188 | `AddSheet(spdMain, SpdSheet.shtMain, "Inventory Raw(Mobility & IT)", 1, 1, 30)` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `CreateSpread` | 189 | `GetSheetInfo(spdMain.Name, 0)` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `CreateSpread` | 191 | `ChangeSheet` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitSpread` | 200 | `InitSheet` — `if(spdInfo.SheetName == "Inventory Raw(Mobility & IT)")` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitSpread` | 202 | `SetSheetHeaderColumn(spdInfo, 1)` (메타 컬럼 생성) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitSpreadFooterSum` | 217 | `siMain.ActiveSheet.ColumnFooter.Visible = true` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `btnItemId_Click` | 301 | `txtItemId.Text = sItemId` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `SetChangedControl` | 350 | `GetCheckedListValue` (CODE) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `FindData_Main` | 386, 387, 389, 390 | `GetCheckedListValue` (CODE) × 4 |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs` | `InitializeComponent` | 555~558 | `ColumnHeaderDefaultEnhanced` 스타일(HorizontalAlignment / NoteIndicatorColor=Red / Parent / VerticalAlignment) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs` | `InitializeComponent` | 589 | `this.Text = "Inventory Raw(Small)"` |

## 5. 컨트롤 선언 (Designer.cs)

| 줄 | 컨트롤 | 유형 | 부모 |
|---:|---|---|---|
| 32 | `usrButton1` | UsrButton | — |
| 33 | `usrConditionPanel1` | UsrConditionPanel | this |
| 34 | `usrLayoutControl2` | UsrLayoutControl | usrConditionPanel1 |
| 35 | `cboPlanDate` | UsrCombo | usrLayoutControl2 |
| 36 | `btnMeasure` | UsrButton | usrLayoutControl2 |
| 37 | `btnItemId` | UsrButton | usrLayoutControl2 |
| 38 | `clbPlantSite` | UsrCheckedList | usrLayoutControl2 |
| 39 | `txtItemId` | UsrMultiLineEditor | usrLayoutControl2 |
| 40 | `cboInventoryType` | UsrCombo | usrLayoutControl2 |
| 41 | `clbDivision` | UsrCheckedList | usrLayoutControl2 |
| 42~51 | `layoutControlGroup2`, `emptySpaceItem3`, `layoutControlItem7`, `lblItemId`, `layoutControlItem2`, `PlanDate`, `layoutControlItem10`, `emptySpaceItem1`, `lcDivision`, `lblInventoryType` | Layout 계열 | — |
| 52 | `imageList1` | ImageList | — |
| 53 | `panel1` | Panel | this |
| 54 | `spdMain` | FpSpread | panel1 |
| 55 | `spdMain_Sheet1` | SheetView | — |

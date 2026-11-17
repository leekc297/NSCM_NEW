# SSP0012 소스 링크

> 기준 경로: AS-IS GSCM 소스 루트 기준 상대 경로. 줄 번호는 Fact Pack 추출값입니다.

- **CS** = `06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs`
- **DS** = `06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtFcstType>` | 56 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common > Data.CallBizCommonData) |
| CS | `<field:dtBaseDay>` | 57 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common > Data.CallBizCommonData) |
| CS | `FindData_Main` | 418 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` → SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| CS | `SetChangedPeriod` | 542 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (Data.CallBizCommonData) |
| CS | `GetDayRange` | 596 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` → SP `SCM0001_GET_SCP_DAY_PERIOD` |
| CS | (주석) | 595 | `SCP.GET_DATE_RANGE_1MONTH`: **주석 처리됨** (현행 아님) |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `.ctor` | 186 | `this.Load += Form_Load` |
| CS | `InitEvent` | 277 | `this.spdMain.TopChange += SpdMain_TopChange` |
| CS | `InitEvent` | 278 | `this.btnItemId.Click += btnItemId_Click` |
| CS | `InitEvent` | 280 | `this.spdMain.CellClick += SpdMain_CellClick` |
| CS | `InitEvent` | 282 | `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| CS | `InitEvent` | 284 | `this.btnColumn.Click += BtnColumn_Click` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `CreateSpread` | 253 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30)`: 시트 `Shipment Plan Confirm Detail` |
| CS | `CreateSpread` | 254 | `GetSheetInfo(spdMain.Name, 0)` |
| CS | `CreateSpread` | 256 | `ChangeSheet` |
| CS | `InitSpread` | 264 | `InitSheet(SpdSheet.shtMain)`, 조건 `spdInfo.SheetName == "Shipment Plan Confirm Detail"` |
| CS | `InitSpread` | 266 | `SetSheetHeaderColumn(spdInfo, 2)`: 메타 컬럼 생성 |
| CS | `InitSpread` | 270 | `INCOTERMS` CellType = `cellTypeImage` |
| CS | `InitSpread` | 271 | `CHANGE_REQ_NO` CellType = `cellTypeImage` |

## 4. 메타/데이터 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtMyDivision>` | 48 | `UserInfoContext.Current` → `NowGroupID` |
| CS | `InitControls` | 237 | `c["CODE"]` |
| CS | `btnItemId_Click` | 341 | `txtItemId.Text = sItemId` |
| CS | `SetChangedControl` | 366 | `CString.GetCheckedListValue` (CODE) |
| CS | `FindData_Main` | 398 | `CString.GetCheckedListValue` (CODE) |
| CS | `FindData_Main` | 399 | `CString.GetCheckedListValue` (CODE) |
| CS | `SetChangedPeriod` | 549 | `dt.Rows[0]["FROM_VALUE"]` |
| CS | `SetChangedPeriod` | 550 | `dt.Rows[0]["TO_VALUE"]` |

## 5. 컨트롤 선언 (Designer)

| 파일 | 컨트롤 | 줄 | 유형 |
|---|---|---:|---|
| DS | usrButton1 | 33 | UsrButton |
| DS | usrConditionPanel1 | 34 | UsrConditionPanel |
| DS | usrLayoutControl2 | 35 | UsrLayoutControl |
| DS | btnItemId | 36 | UsrButton |
| DS | clbPlantSite | 37 | UsrCheckedList |
| DS | drpPeriod | 38 | UsrDateRangePicker |
| DS | txtItemId | 39 | UsrMultiLineEditor |
| DS | clbDivision | 40 | UsrCheckedList |
| DS | txtSoldToParty | 41 | TextBox |
| DS | txtShipToParty | 42 | TextBox |
| DS | btnColumn | 43 | UsrButton |
| DS | layoutControlGroup2 | 44 | LayoutControlGroup |
| DS | emptySpaceItem3 | 45 | EmptySpaceItem |
| DS | layoutControlItem7 | 46 | LayoutControlItem |
| DS | lblItemId | 47 | LayoutControlItem |
| DS | layoutControlItem2 | 48 | LayoutControlItem |
| DS | layoutControlItem6 | 49 | LayoutControlItem |
| DS | emptySpaceItem1 | 50 | EmptySpaceItem |
| DS | lcDivision | 51 | LayoutControlItem |
| DS | layoutControlItem1 | 52 | LayoutControlItem |
| DS | layoutControlItem3 | 53 | LayoutControlItem |
| DS | layoutControlItem5 | 54 | LayoutControlItem |
| DS | spdMain | 55 | FpSpread |
| DS | spdMain_Sheet1 | 56 | SheetView |
| DS | imageList1 | 57 | ImageList |

## 6. 레이아웃 라벨 (Designer InitializeComponent)

| 파일 | 대상 | 줄 | 내용 |
|---|---|---:|---|
| DS | layoutControlItem7 | 415 | Text `From Site` (Control: clbPlantSite, 411) |
| DS | lblItemId | 427 | Text `Model` (Control: txtItemId, 422) |
| DS | layoutControlItem6 | 453 | Text `Period*` (Control: drpPeriod, 446) |
| DS | lcDivision | 473 | Text `Division` (Control: clbDivision, 468) |
| DS | layoutControlItem1 | 485 | Text `Sold To Party` (Control: txtSoldToParty, 480) |
| DS | layoutControlItem3 | 497 | Text `Ship To Party` (Control: txtShipToParty, 492) |
| DS | spdMain | 518 / 523 | Dock Fill / Size(1192, 576) |
| DS | this | 545 | Text `Shipment Plan Confirm` |

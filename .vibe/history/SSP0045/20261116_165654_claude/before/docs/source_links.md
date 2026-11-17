# SSP0045 소스 링크 (파일·줄 기준)

> 경로 기준: AS-IS 소스 루트 하위 상대경로. `.cs` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs`, `Designer.cs` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | SetChangedControl | 268 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] (Data.Common → Data.CallBizCommonData) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | GetBucketType | 279 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 299 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | CboBizType_SelectedIndexChanged | 413 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | FindData_Main | 587 | `SSP.SSP0045_GET_SHIPMENT_REQUEST` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | GetDayRange | 647 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | SaveData | 944 | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | GetSpdTitle | 1115 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | (주석) | 834 | `SSP.PR_SCM_SYS_LOG_BATCH` — **주석 처리됨** |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | InsertRow | 772 | `Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, …)` → ITEM_ID 콤보 (엔드포인트 미해석, 확인 필요) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | InsertRow2 | 803 | 동일 (BODItemProjectRoute) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `…\SSP0045_ShipmentRequest.Designer.cs` | InitializeComponent | 177 | `chkSum.CheckedChanged += chkSum_CheckedChanged` |
| `…\SSP0045_ShipmentRequest.cs` | .ctor | 148 | `this.Load += Form_Load` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 400 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 401 | `btnItem_Id.Click += BtnItem_Id_Click` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 402 | `cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 403 | `cboBizType.SelectedIndexChanged += CboBizType_SelectedIndexChanged` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 405 | `spdMain.TopChange += SpdMain_TopChange` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 406 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 407 | `spdMain.CellClick += SpdMain_CellClick` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 408 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| `…\SSP0045_ShipmentRequest.cs` | SpdMain_CellClick | 1252 | `spdMain.ComboSelChange -= SpdMain_ComboSelChange` |
| `…\SSP0045_ShipmentRequest.cs` | SpdMain_CellClick | 1334 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |

## 3. Grid 정의 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `…\SSP0045_ShipmentRequest.cs` | CreateSpread | 286 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35)` |
| `…\SSP0045_ShipmentRequest.cs` | CreateSpread | 287~288 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)`, `ChangeSheet` |
| `…\SSP0045_ShipmentRequest.cs` | CreateSpread | 291 | `drpPeriod.Enabled = false` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 297 | `InitSheet(siMain.SheetName)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 302~303 | `drRow[CODE]`, `drRow[NAME]` (PlantSiteByDivision 결과) |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 310 | `GetSpdTitle` 호출 |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 313 | `SetSheetHeaderColumn(siMain, 3)` (메타) |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 316 | `InitSpreadDateColumn(spdInfo, spdInfo.nIdxData)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 318 | `SetSpreadColumn(spdInfo)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 354 | `AddTextColumn(label, name, None, 0, false)` — `B_` 컬럼 |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 358 | `AddNumColumn(label, name, None, 70, true)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 362 | SAT=Blue / SUN=Red ForeColor |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 368~396 | `ColumnHeaderSpan` (대분류/소분류/"SUM") |
| `…\SSP0045_ShipmentRequest.cs` | EditButton | 449 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` (if fps.Name=="spdMain") |
| `…\SSP0045_ShipmentRequest.cs` | cboBucketType_SelectedIndexChanged | 1125 | `SetSpreadColumn(siMain)` |
| `…\SSP0045_ShipmentRequest.cs` | chkSum_CheckedChanged | 1130 | `SetSpreadColumn(siMain)` |
| `…\SSP0045_ShipmentRequest.cs` | SetSpreadColumn | 1140~1164 | 버킷/Sum 별 Columns[iCol].Visible |
| `…\SSP0045_ShipmentRequest.Designer.cs` | InitializeComponent | 580~583 | ColumnHeader 기본 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 데이터/메타 접근 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `…\SSP0045_ShipmentRequest.cs` | SetChangeControl | 169~170 | `Filter[GROUP_ID]`, `UserInfoContext.Current.NowGroupID`, `Filter[USER_ID]` |
| `…\SSP0045_ShipmentRequest.cs` | SetChangeControl | 176 | `GetSSPInnerTable` |
| `…\SSP0045_ShipmentRequest.cs` | InitControls | 199, 201 | `FP_Log2` |
| `…\SSP0045_ShipmentRequest.cs` | SetChangedControl | 264 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | SaveButton | 527 | `SaveData` 호출 |
| `…\SSP0045_ShipmentRequest.cs` | FindData_Main | 565, 568, 570 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | Set_SumValues | 660 | `dsBinding.Tables[0].Columns["MEASURE"]` |
| `…\SSP0045_ShipmentRequest.cs` | InsertRow / InsertRow2 | 755 / 786 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | BtnItem_Id_Click | 1198 | `txtItem_Id.Text = sItemId` |
| `…\SSP0045_ShipmentRequest.cs` | SpdMain_CellClick | 1227, 1228 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | checkValidN0 | 1396~1405 | `dr[p_division_id … p_fcst_type]` (p_user_id 포함) |
| `…\SSP0045_ShipmentRequest.cs` | checkValidN0 | 1413~1421 | `dr.Field<>(p_* )` |
| `…\SSP0045_ShipmentRequest.cs` | checkValidN0 | 1428~1436 | `cpDr.Field<>(p_* )` |

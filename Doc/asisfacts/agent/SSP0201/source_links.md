# SSP0201 소스 링크 표

> 기준 경로(AS-IS 소스 루트 이하, 루트 위치는 **확인 필요**)
> - CS = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.cs`
> - DS = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.Designer.cs`
> - legacy 사본: `06.UIL\GSCM.SSP.Plan.UIL\SSP0201_ShipmentChangeRequest.cs` / `.Designer.cs` (참고용, 줄 번호는 current 기준)

## 1. 엔드포인트 호출 지점 (endpoints.csv 22건 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | CS | SaveButton | 780 | `SSP.SSP0201_GET_CHANGE_REQ_NO` (fox, MATCH) |
| 2 | CS | SaveButton | 936 | `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` (fox, MATCH) |
| 3 | CS | FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` (fox, MATCH) |
| 4 | CS | FindData_Main_Nonasync | 1417 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` (fox, MATCH) |
| 5 | CS | FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 6 | CS | SaveDataDrafting | 2222 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` (fox, MATCH) |
| 7 | CS | DeleteDataDrafting | 2379 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 8 | CS | InsertRow | 2455 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] (Data.Common → Data.CallBizCommonData) |
| 9 | CS | GetDayRange | 2721 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` (fox, MATCH) |
| 10 | CS | BtnNew_Click | 2996 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 11 | CS | GetShipmentStatusChk | 3571 | `SSP.SSP0201_GET_SHIPMENT_STATUS` (fox, MATCH) |
| 12 | CS | GetErpSoNoCnt | 3636 | `SSP.SSP0201_GET_ERP_SO_NO_CNT` (fox, MATCH) |
| 13 | CS | NewNonSoNo | 3768 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 14 | CS | NonSoNo | 3939 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 15 | CS | SoNo | 4163 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 16 | CS | GetErpIFCheck | 4276 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH, 진입점 미연결) |
| 17 | CS | SpdMain_CellClick | 4677 | `biz:CommonData.CommonDataList` [code=TransMode] |
| 18 | CS | SpdMain_CellClick | 4691 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 19 | CS | SpdMain_ComboSelChange | 4815 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 20 | CS | SpdMain_ClipboardPasted | 5143 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 21 | CS | FindData_BOD | 5840 | `SSP.SSP0026_GET_BOD_ITEM` (fox, MATCH) |
| 22 | CS | FindData_BOD | 5860 | `biz:CommonData.CommonDataList` [code=TransMode] |

## 2. 주석 처리된 호출 (주석 처리됨 — 현행 기능 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| CS | 1179 | 주석 처리됨: `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` |
| CS | 1561 | 주석 처리됨: `SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING` |
| CS | 1937 | 주석 처리됨: `SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| CS | 2720 | 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` |

## 3. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 288 | `this.Load += Form_Load` |
| CS | InitEvent | 360 | `clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged` |
| CS | InitEvent | 361 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 362 | `btnApprovalUser.Click += BtnApprovalUser_Click` |
| CS | InitEvent | 365 | `dsdm.Changed += shtMain_Change` |
| CS | InitEvent | 370 | `btnSave.Click += BtnSave_Click` |
| CS | InitEvent | 371 | `btnChangeRe.Click += BtnChangeRe_Click` |
| CS | InitEvent | 372 | `btnChangeRe2.Click += BtnChangeRe_Click` |
| CS | InitEvent | 375 | `btnCancel.Click += BtnCancel_Click` |
| CS | InitEvent | 376 | `btnNew.Click += BtnNew_Click` |
| CS | InitEvent | 378 | `this.spdMain.CellClick += SpdMain_CellClick` |
| CS | InitEvent | 379 | `this.spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 380 | `this.spdMain.EditChange += SpdMain_EditChange` |
| CS | InitEvent | 381 | `this.spdMain.ClipboardPasted += SpdMain_ClipboardPasted` |
| CS | InitEvent | 382 | `this.spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| CS | InitEvent | 383 | `this.btnItemId.Click += btnItemId_Click` |
| CS | InitEvent | 385 | `cboChangeType.SelectedIndexChanged += CboChangeType_SelectedIndexChanged` |
| CS | InitEvent | 387 | `spdMain.CursorChanged += SpdMain_CursorChanged` |

## 4. Grid 생성·메타·코드 변경 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 523 | `AddSheet` spdMain, SpdSheet.shtMain = "Shipment Change Request" (1, 1, 30) |
| CS | CreateSpread | 524 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| CS | CreateSpread | 527 | `AddSheet` spdSub, SpdSheet.shtSub = "Change Request" (2, 1, 30) |
| CS | CreateSpread | 528 | `GetSheetInfo(spdSub.Name, SpdSheet.shtSub)` |
| CS | CreateSpread | 537 | `ChangeSheet` |
| CS | InitSpread | 544 / 546 | `InitSheet`, `SetSheetHeaderColumn(spreadInfo, 1)` — Shipment Change Request |
| CS | InitSpread | 554, 555 | ChangeType "P": ERP_SO_NO, CONFIRM_ID Width=0 |
| CS | InitSpread | 567 | ChangeType ≠ "P": CONFIRM_ID Width=120 |
| CS | InitSpread | 578~580 | Div 40/EE: END_CUSTOMER 표시, PROJECT_CODE/PROJECT_NAME 숨김 |
| CS | InitSpread | 585~587 | 그 외 Div: END_CUSTOMER 숨김, PROJECT_CODE/PROJECT_NAME 표시 |
| CS | InitSpread | 596 / 599 | `InitSheet`, `SetSheetHeaderColumn(spreadInfo, 2)` — Change Request |
| CS | InitSpread | 608~610 | CHK CellType=체크박스, Value=false, Border=bevel |
| CS | InitSpread | 619 | REMARKS Width=0 |
| CS | InitSpread | 624 / 626~641 | "P": ERP_SO_NO 숨김, ColumnHeaderSpan "Plan"/"Confirm" + 2행 헤더 |
| CS | InitSpread | 646 / 648~663 | ≠"P": ERP_SO_NO 표시, ColumnHeaderSpan "Confirmed"/"Change" + 2행 헤더 |
| CS | EditButton | 701 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` (fps.Name=="spdMain" 이고 siSub 행이 0일 때) |
| CS | SetChangeRequestSOGrid | 2035 | `GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex)` |
| CS | SetChangeRequestSOGrid | 2042 | `CAppSetting.StringAction` 컬럼 Visible=false |
| CS | SetChangeRequestSOGrid | 2061 | CHK Visible=false (sShipStatus≠"R" 이고 sSearchType=="Exist") |
| CS | InsertRow | 2457 | SetCellTypeCombo TO_SITE_SHIPTO_CODE ← ShipToCodeByDivision (`clbDivision_ID.ControlValues == "40"`) |
| CS | InsertRow | 2488 | SetCellTypeCombo FROM_SITE_DESCRIPTION ← Data.UserPlantSiteByDivisionOspPack |
| CS | InsertRow | 2489 | SetCellTypeCombo TO_SITE_DESCRIPTION ← Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP) |
| CS | InsertRow | 2521 | SetCellTypeCombo DIVISION_ID ← GetSSPInnerTable("MyDivision"), CODE≠"EE" |
| CS | BtnNew_Click | 2969, 2998, 3000, 3001, 3007 | SetCellTypeCombo DIVISION_ID / TO_SITE_SHIPTO_CODE / FROM_SITE_DESCRIPTION / TO_SITE_DESCRIPTION / DIVISION_ID |
| CS | SpdMain_CellClick | 4679 | SetCellTypeCombo TRANSPORT_MODE ← Data.Common(TransMode) |
| CS | SpdMain_CellClick | 4693 | SetCellTypeCombo TO_SITE_SHIPTO_CODE ← ShipToCodeByDivision |
| CS | SpdMain_CellClick | 4705, 4740, 4744 | 헤더 체크박스 Value 토글 |
| CS | SpdMain_ComboSelChange | 4817 | SetCellTypeCombo TO_SITE_SHIPTO_CODE (TO_SITE_DESCRIPTION 변경이고 sItemId가 있을 때) |
| CS | SpdMain_ComboSelChange | 4852 | SetCellTypeCombo FROM_SITE_DESCRIPTION (DIVISION_ID 변경 시) |
| CS | SpdMain_ComboSelChange | 4870~4872, 4879~4881 | 행 Div 40/EE 여부에 따른 END_CUSTOMER / PROJECT_CODE / PROJECT_NAME 표시 전환 |

## 5. 메타·데이터 컬럼 읽기 지점 (주요)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 312, 313 | Filter GROUP_ID ← UserInfoContext NowGroupID, Filter USER_ID |
| CS | SetChangeControl | 319, 324, 329, 334, 339, 344, 349 | `DataService.GetSSPInnerTable` 호출 7회 |
| CS | InitControls | 419, 428 | `DataService.FP_Log2` |
| CS | InitControls | 445 | `c["CODE"]` |
| CS | InitControls | 490~493 | dtShipmentInputPeriod.Rows[0/1] VALUE, Diff_VALUE |
| CS | SetChangedControl | 503 / 506, 507 | GetCheckedListValue / NowGroupID |
| CS | SaveButton | 795 | GetCheckedListValue |
| CS | FindData_Main | 1303~1307 | GetCheckedListValue 5회 |
| CS | FindData_Main_Nonasync | 1395 | GetCheckedListValue |
| CS | FindData_Sub_Draft | 1841~1851 | ds.Tables[1].Rows[0] USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN |
| CS | SetChangeRequestInfo | 1986~1997 | dt.Rows[0] CHANGE_REQ_NO ~ APPROVAL_DEPT_NAME (12개 컬럼) |
| CS | SaveDataDrafting | 2280 | NowGroupID |
| CS | InsertRow | 2477 | NowGroupID |
| CS | chkERPIFBlockYn | 2542, 2551 | dtERPBlockYnIF BLOCK_YN, PERIOD |
| CS | BtnNew_Click | 2977 | NowGroupID |
| CS | SSP_Main_Validation | 3188~3195, 3238~3244, 3315~3321 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS(첫 블록만), remarks2, remarks, TO_SITE_SHIPTO_CODE |
| CS | GetShipmentStatusChk | 3585, 3599, 3614 | ds.Tables[0/1/2] CONFIRM_ID |
| CS | GetErpSoNoCnt | 3646 | ds.Tables[0].Rows[0] CNT |
| CS | SpdMain_ComboSelChange | 4840, 4992~5009 | NowGroupID, CODE, ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL |
| CS | setEndCustomer | 5788 | dtEndCustomer.Rows[0] CODE (drRow CODE, NAME — 줄 번호는 Fact Pack에서 잘림, **확인 필요**) |

## 6. Designer 주요 지점

| 파일 | 줄 | 내용 |
|---|---:|---|
| DS | 32~111 | 컨트롤 선언 80개 |
| DS | 176, 180, 191, 192 | splitContainer1 Dock=Fill, Orientation=Horizontal, Size=1192×649, SplitterDistance=253 |
| DS | 198, 203 | spdMain Dock=Fill, Size=1192×184 |
| DS | 249, 252, 254 | usrConditionPanel1 Dock=Top, Size=1192×69, UsrPanelType=HidePanel |
| DS | 474 | btnChangeRe Text="Request Complete" |
| DS | 688 | btnNew Text="NEW" |
| DS | 882, 887 | spdSub Dock=Fill, Size=1192×213 |
| DS | 934, 937 | panel3 Dock=Top, Size=1192×179 |
| DS | 1002, 1011, 1021~1022, 1032~1033, 1044 | btnDel "Delete" / btnCancel "Cancel" / btnSave "Save Draft"(Visible=false) / btnAdd "Add Date"(Visible=false) / btnChangeRe2 "Request Complete" |

# SSP0023 소스 링크 표

> 기준 경로 접두어
> - `CS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.cs`
> - `DS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.Designer.cs`

## 1. 엔드포인트 호출 지점 (24곳 전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SaveData_Detail | 2435 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` 호출 (1차) |
| CS | SaveData_Detail | 2643 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` 호출 (2차) |
| CS | GetERPInterface | 3278 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` 호출 |
| CS | GetERPInterface | 3319 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` 호출 |
| CS | GetShipmentStatusChk | 3459 | `SSP.SSP0023_GET_SHIPMENT_STATUS` 호출 |
| CS | GetErpSoNoCnt | 3524 | `SSP.SSP0023_GET_ERP_SO_NO_CNT` 호출 |
| CS | NewNonSoNo | 3645 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` 호출 (unreached) |
| CS | NonSoNo | 3846 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` 호출 |
| CS | SoNo | 4081 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` 호출 |
| CS | GetErpIFCheckNew_ | 4195 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` 호출 (unreached) |
| CS | GetErpIFCheck | 4251 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` 호출 (unreached) |
| CS | GetErpIFCheckNew | 4329 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` 호출 |
| CS | GetErpIFCheckNew | 4355 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` 호출 (1차) |
| CS | GetErpIFCheckNew | 4385 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` 호출 (2차) |
| CS | GetBucketType | 4656 | `DM.DM0003_GET_BUCKET_TYPE_CODE` 호출 |
| CS | FindData_Main | 4732 | `SSP.SSP0023_GET_SHIPMENT_PLAN` 호출 |
| CS | FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` 호출 |
| CS | FindData_Stock_Detail | 5468 | `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` 호출 |
| CS | FindData_ShipmentResult | 5585 | `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` 호출 |
| CS | GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 호출 |
| CS | Simulation | 6027 | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` 호출 |
| CS | FindData_Plan_Detail_DownLoad | 6505 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` 호출 |
| CS | ChkConfirmChangeTime | 6779 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` 호출 |
| CS | GetSSPUserCheck | 6805 | `SSP.SSP0002_GET_USER_INFO_LIST` 호출 |

## 2. 이벤트 배선 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| DS | InitializeComponent | 299 | formDown.Click += btnExcelFormDownload_Click |
| DS | InitializeComponent | 339 | btnExcelUpload.Click += btnExcelUpload_Click |
| CS | .ctor | 310 | this.Load += Form_Load |
| CS | InitEvent | 786 | spdMain.TopChange += SpdMain_TopChange |
| CS | InitEvent | 787 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| CS | InitEvent | 788 | rdButton1.CheckedChanged += rdButton_Changed |
| CS | InitEvent | 789 | rdButton2.CheckedChanged += rdButton_Changed |
| CS | InitEvent | 790 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| CS | InitEvent | 792 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| CS | InitEvent | 793 | spdMain.Change += SpdMain_Change |
| CS | InitEvent | 794 | spdMain.ClipboardPasted += spdMain_ClipboardPasted |
| CS | InitEvent | 796 | btnMeasure.Click += BtnMeasure_Click |
| CS | InitEvent | 797 | btnItemId.Click += btnItemId_Click |
| CS | InitEvent | 798 | btnItemId2.Click += BtnMaterialId2_Click |
| CS | InitEvent | 799 | btnSearch.Click += BtnSearch_Click |
| CS | InitEvent | 800 | btnRequestor.Click += BtnRequestor_Click |
| CS | InitEvent | 801 | btnSimulation.Click += BtnSimulation_Click |
| CS | InitEvent | 803 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| CS | InitEvent | 804 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| CS | InitEvent | 805 | spdDetail.CellClick += SpdDetail_CellClick |
| CS | InitEvent | 806 | spdDetail.ComboSelChange += SpdDetail_ComboSelChange |
| CS | InitEvent | 807 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| CS | InitEvent | 808 | spdDetail.EditChange += SpdDetail_EditChange |
| CS | InitEvent | 809 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| CS | InitEvent | 811 | clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged |
| CS | InitEvent | 812 | clbCompany_ID.SelectedIndexChanged += clbCompanyID_SelectedIndexChanged |
| CS | InitEvent | 813 | cboPlanDate.SelectedIndexChanged += cboPlanDate_SelectedIndexChanged |
| CS | InitEvent | 815 | chkPastPeriod.CheckedChanged += chkPastPeriod_CheckedChanged |
| CS | InitEvent | 818 | dsdm.Changed += shtPlanDetail_Change |
| CS | clbCompanyID_SelectedIndexChanged | 5776 | cboPlanDate.SelectedIndexChanged -= (일시 해제) |
| CS | clbCompanyID_SelectedIndexChanged | 5780 | cboPlanDate.SelectedIndexChanged += (재연결) |

## 3. Grid 정의 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 544 | AddSheet spdMain "Shipment Plan(Electrode)" (인자 3 ¦ 1 ¦ 35) |
| CS | CreateSpread | 550 | AddSheet spdDetail "Shipment Plan Detail" (1 ¦ 1 ¦ 35) |
| CS | CreateSpread | 551 | AddSheet spdDetail "Stock Detail" (3 ¦ 1 ¦ 60) |
| CS | CreateSpread | 552 | AddSheet spdDetail "Shipment Result" (1 ¦ 1 ¦ 35) |
| CS | CreateSpread | 553 | AddSheet spdSub "Shipment Plan Detail Excel" (1 ¦ 1 ¦ 35) |
| CS | CreateSpread | 555–574 | GetSheetInfo / ChangeSheet 각 시트 초기화 |
| CS | InitSpread | 580 | GetSpdTitle 호출 |
| CS | InitSpread | 583–591 | Shipment Plan(Electrode): InitSheet, SetSheetHeaderColumn(3단 헤더), InitSpreadDateColumn, SetSpreadColumn |
| CS | InitSpread | 597–629 | rdButton1/2/3에 따라 BOH 컬럼 Visible 설정 |
| CS | InitSpread | 634–636 | Shipment Plan Detail: SetSheetHeaderColumn(1단) |
| CS | InitSpread | 652–659 | drRow/dr/drAllRow CODE·NAME 읽기 (콤보 데이터 구성으로 보이며 확인 필요) |
| CS | InitSpread | 672–674 | Shipment Plan Detail Excel: SetSheetHeaderColumn(1단) |
| CS | InitSpread | 682–684 | Stock Detail: SetSheetHeaderColumn(3단) |
| CS | InitSpread | 693–695 | Shipment Result: SetSheetHeaderColumn(1단) |
| CS | InitSpreadDateColumn | 738 | DB루프 AddTextColumn (`B_` 포함 컬럼, 숨김) |
| CS | InitSpreadDateColumn | 744 | DB루프 AddNumColumn (폭 100, Right, 소수 3) |
| CS | InitSpreadDateColumn | 747 | SAT 파랑 / SUN 빨강 ForeColor |
| CS | InitSpreadDateColumn | 754–781 | ColumnHeaderSpan (LARGE/SMALL 라벨 + "SUM") |
| CS | SpdDetail_SheetTabClick | 903–914 | 탭 0/1/2 → Plan Detail / Stock Detail / Shipment Result 전환 |
| CS | SpdDetail_CellClick | 1718 | FACTORY_ID 셀 콤보(dtBuildingForCell) 설정 |
| CS | SpdDetail_CellClick | 1727–1759 | 헤더 CheckBox 전체 선택/해제 |
| CS | SpdMain_CellDoubleClick | 1798–1799 | MEASURE = "P_SHIP_CONFIRM_ETD"인 행의 날짜 셀 더블클릭 → Shipment Plan Detail로 전환 |
| CS | EditButton | 2086 / 2270 | spdMain / spdDetail 시트 정보 읽기 |
| CS | cboBucketType_SelectedIndexChanged | 4413 | SetSpreadColumn 호출 |
| CS | rdButton_Changed | 4420–4452 | BOH 컬럼 Visible 전환 |
| CS | SetSpreadColumn | 4479–4625 | X_/Y_/Z_ × D_/W_/M_ 컬럼 Visible |
| CS | SetSpreadColumn | 4642 | chkPastPeriod가 꺼져 있으면 과거 날짜 컬럼 숨김 |
| CS | ExportExcel | 6668 / 6710 | 엑셀 내보내기 시 Formula / 헤더 스타일 처리 |

## 4. 검증·메타 읽기 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 341–342 | Filter GROUP_ID / USER_ID, NowGroupID |
| CS | SetChangeControl | 348–383 | GetSSPInnerTable 8회 호출 |
| CS | DefineProperty | 420–421 | drAllRow CODE / NAME |
| CS | InitControls | 429, 445 | FP_Log2 (로그) |
| CS | InitControls | 462–509 | NowGroupID, dtShipmentInputPeriod VALUE/Diff_VALUE, dtCompany CODE |
| CS | SetChangedControl | 527–537 | CODE, DIVISION_ID, dtMyCompany NAME |
| CS | spdMain_ClipboardPasted | 1219–1225 | DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID |
| CS | SpdDetail_ClipboardPasted | 1427 | CODE |
| CS | SpdDetail_CellClick | 1691 / 1707–1714 | GetCheckedListValue / CODE·NAME |
| CS | EditButton | 2138 | GetCheckedListValue |
| CS | SaveData_Detail | 2337 | GetCheckedListValue |
| CS | chkERPIFBlockYn | 2772 / 2781 | BLOCK_YN / PERIOD |
| CS | ChangeData_Check | 2808–2815 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type |
| CS | ChangeNotSendERP_Check | 2851–2885 | 위와 같은 항목 + SONoValidationdr |
| CS | Validation_Check | 2969–2977 | 위 항목 + dom_exp |
| CS | Validation_Check | 3067–3069~ | SONoValidationdr (이후 줄은 Fact Pack에서 잘림, 확인 필요) |
| CS | FindData_Main | 4683–4686 | GetCheckedListValue 4회 |
| CS | cboPlanDate_SelectedIndexChanged | 5825 | GetSpdTitle |

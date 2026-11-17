# SSP0015 소스 링크 (파일·줄 기준)

경로 약어:
- **[S]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.cs`
- **[SD]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.Designer.cs`
- **[P]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSICommentsPopup.cs`
- **[PD]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSICommentsPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (63곳, endpoints.csv 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | [S] | InitControls | 568 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 2 | [S] | SpdMain_ActiveSheetChanged | 1400 | biz:CommonData.CommonDataList [code=LookupCommon] |
| 3 | [S] | SpdMain_ActiveSheetChanged | 1452 | biz:CommonData.CommonDataList [code=LookupCommon] |
| 4 | [S] | EditButton | 1753 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 5 | [S] | EditButton | 1757 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 6 | [S] | GetBucketType | 2162 | DM.DM0003_GET_BUCKET_TYPE_CODE |
| 7 | [S] | SetChangedControl | 2202 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 8 | [S] | SetChangedControl | 2210 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 9 | [S] | SetChangedControl | 2218 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 10 | [S] | FindData_Main_Packer_Past | 2293 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| 11 | [S] | FindData_Main_Packer | 2412 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER |
| 12 | [S] | FindData_Main | 2536 | SSP.SSP0015_GET_SHIPMENT_PSI |
| 13 | [S] | GetNERPCode | 2904 | SSP.SSP0002_GET_NERP_CODE |
| 14 | [S] | FindData_Detail | 3165 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| 15 | [S] | FindData_Detail | 3303 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| 16 | [S] | FindData_Detail_Packer_btnSearch | 3439 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| 17 | [S] | FindData_Detail_btnSearch | 3705 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| 18 | [S] | FindData_WHstock | 3850 | SSP.SSP0015_GET_WH_STOCK |
| 19 | [S] | FindData_mes_stock | 3966 | SSP.SSP0015_GET_MES_STOCK |
| 20 | [S] | FindData_block_stock | 4070 | SSP.SSP0015_GET_BLOCK_STOCK |
| 21 | [S] | FindData_BolckStockDetail_btnSearch | 4193 | SSP.SSP0015_GET_BLOCK_STOCK |
| 22 | [S] | FindData_shtStockLocationDetail_btnSearch | 4337 | SSP.SSP0015_GET_STOCK_LOCATION_DETAIL |
| 23 | [S] | FindData_ScsStock_btnSearch | 4437 | SSP.SSP0015_GET_SCS_STOCK |
| 24 | [S] | FindData_MesStock_btnSearch | 4528 | SSP.SSP0015_GET_MES_STOCK |
| 25 | [S] | FindData_Request_Detail | 4640 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK |
| 26 | [S] | FindData_WHinPlanDetail_btnSearch | 4723 | SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| 27 | [S] | FindData_ShipmentSCSResult_btnSearch | 4832 | SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER |
| 28 | [S] | FindData_ShipmentResult_btnSearch | 4944 | SSP.SSP0015_GET_SHIPMENT_RESULT |
| 29 | [S] | SaveData_Main | 5412 | SSP.SSP0015_SAVE_SHIPMENT_PSI |
| 30 | [S] | SaveData_Detail_Packer | 5602 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| 31 | [S] | SaveData_Detail | 5841 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| 32 | [S] | SaveData_Detail | 6011 | SSP.SSP0015_SAVE_BLOCK_STOCK_DATA |
| 33 | [S] | SaveData_Detail | 6112 | SSP.SSP0015_SAVE_MES_STOCK |
| 34 | [S] | SaveData_Detail | 6219 | SSP.SSP0015_SAVE_MES_STOCK |
| 35 | [S] | GetERPInterface | 6665 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| 36 | [S] | GetERPInterface | 6706 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| 37 | [S] | NonSoNo | 6843 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 38 | [S] | NonSoNo | 6847 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| 39 | [S] | SoNo | 7076 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 40 | [S] | SoNo | 7080 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| 41 | [S] | GetErpSoNoCnt | 7185 | SSP.SSP0015_GET_ERP_SO_NO_CNT |
| 42 | [S] | GetShipmentStatusChk | 7210 | SSP.SSP0015_GET_SHIPMENT_STATUS |
| 43 | [S] | GetErpIFCheck (unreached) | 7285 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| 44 | [S] | GetErpIFCheckNew | 7363 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| 45 | [S] | GetErpIFCheckNew | 7389 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| 46 | [S] | GetErpIFCheckNew | 7419 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| 47 | [S] | SCM_SYS_LOG_BATCH (unreached) | 7876 | SCP.PR_SCM_SYS_LOG_BATCH |
| 48 | [S] | EngProcessingChk | 7903 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| 49 | [S] | SpdDetail_CellClick | 8583 | biz:CommonData.CommonDataList [code=TransMode] |
| 50 | [S] | SpdDetail_CellClick | 8604 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] |
| 51 | [S] | SpdDetail_ClipboardPasted | 8954 | biz:CommonData.CommonDataList [code=TransMode] |
| 52 | [S] | GetDivision (unreached) | 9192 | SCM.SCM0001_GET_DIVISION |
| 53 | [S] | SetChangedPeriod (unreached) | 9207 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] |
| 54 | [S] | SetChangedPeriod (unreached) | 9211 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] |
| 55 | [S] | GetSpdTitle | 9247 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| 56 | [S] | GetDayRange | 9289 | SCP.SCM0001_GET_SCP_DAY_PERIOD |
| 57 | [S] | NewNonSoNo (unreached) | 9611 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 58 | [S] | NewNonSoNo (unreached) | 9615 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| 59 | [S] | GetErpIFCheckNew_ (unreached) | 9731 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| 60 | [S] | chkSaveYN | 9821 | SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| 61 | [S] | ChkConfirmChangeTime | 9875 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| 62 | [S] | GetSSPUserCheck | 9901 | SSP.SSP0002_GET_USER_INFO_LIST |
| 63 | [P] | SaveData | 333 | SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

## 2. 주석 처리된 호출 (집계 제외)

| 파일 | 줄 | 내용 |
|---|---:|---|
| [S] | 3573 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER — 주석 처리됨 |
| [S] | 9288 | SCP.GET_DATE_RANGE_1MONTH — 주석 처리됨 |
| [S] | 9308 | SCP.GET_DATE_RANGE_1MONTH — 주석 처리됨 |
| [S] | 9309 | SCP.SCM0001_GET_SCP_PERIOD — 주석 처리됨 |

## 3. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [SD] | InitializeComponent | 906 | spdMain.TextTipFetch += spdMain_TextTipFetch |
| [S] | .ctor | 422 | Load += Form_Load |
| [S] | InitEvent | 1159 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [S] | InitEvent | 1161 | spdMain.TopChange += SpdMain_TopChange |
| [S] | InitEvent | 1162 | spdDetail.TopChange += SpdDetail_TopChange |
| [S] | InitEvent | 1164 | btnMeasure.Click += btnMeasure_Click |
| [S] | InitEvent | 1165 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| [S] | InitEvent | 1166 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| [S] | InitEvent | 1167 | btnItemId.Click += btnItemId_Click |
| [S] | InitEvent | 1168 | btnItemID2.Click += BtnItemID2_Click |
| [S] | InitEvent | 1169 | btnSearch.Click += BtnSearch_Click |
| [S] | InitEvent | 1170 | btnRequestor.Click += BtnRequestor_Click |
| [S] | InitEvent | 1172 | spdDetail.CellClick += SpdDetail_CellClick |
| [S] | InitEvent | 1173 | spdDetail.ComboSelChange += spdDetail_ComboSelChange |
| [S] | InitEvent | 1174 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| [S] | InitEvent | 1175 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| [S] | InitEvent | 1177 | spdMain.ActiveSheetChanged += SpdMain_ActiveSheetChanged |
| [S] | InitEvent | 1179 | clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged |
| [S] | InitEvent | 1180 | cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged |
| [S] | InitEvent | 1181 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| [S] | InitEvent | 1182 | spdDetail.EditChange += SpdDetail_EditChange |
| [S] | InitEvent | 1183 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| [S] | InitEvent | 1186 | spdMain.EditModeOn += SpdMain_EditModeOn |
| [S] | InitEvent | 1187 | spdMain.CellClick += SpdMain_CellClick |
| [S] | InitEvent | 1190 | dsdm.Changed += shtDetail_Change |
| [PD] | InitializeComponent | 192 | txtGap_Qty.TextChanged |
| [PD] | InitializeComponent | 227 | txtBefore_Qty.TextChanged |
| [PD] | InitializeComponent | 262 | txtProd_Qty.TextChanged |
| [PD] | InitializeComponent | 297 | txtWHin_Qty.TextChanged |
| [PD] | InitializeComponent | 474 | txtCurrent_Qty.TextChanged |
| [PD] | InitializeComponent | 509 | txtChange_Qty.TextChanged |
| [PD] | InitializeComponent | 510 | txtChange_Qty.KeyPress |
| [PD] | InitializeComponent | 657 | btnButtonList.UsrButtonList_Click_Detected |
| [P] | .ctor | 207 | Load += Form_Load |

## 4. 프레임워크 메타 소비 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---|---|
| [S] | SetChangeControl | 456, 461, 466, 471, 476, 481, 486, 491 | DataService.GetSSPInnerTable |
| [S] | InitControls | 534, 545 | DataService.FP_Log2 |
| [S] | InitSpread | 753 | SpreadInfo.GetSpdTitle |
| [S] | InitSpread | 759, 786, 811, 826, 853, 866, 879, 892, 905, 918 (grid_code.csv: 941, 967, 978) | SpreadInfo.SetSheetHeaderColumn |
| [S] | InitSpread | 766, 793 | InitSpreadDateColumn (화면에서 직접 정의) |
| [S] | SpdMain_ActiveSheetChanged:1357, EditButton:1749/1761/1805/1842, SetChangedControl:2188, FindData_Main_Packer_Past:2253/2255 | – | CString.GetCheckedListValue |
| [S] / [P] | SaveButton:271 / btnButtonList_UsrButtonList_Click_Detected:430 | – | SaveData (PersonalSettingPopup.SaveData로 해석됨, 확인 필요) |

## 5. Grid 코드 정의 주요 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [S] | CreateSpread | 656, 660 | spdMain AddSheet: Shipment PSI(Mobility & IT), Shipment PSI(Packer) |
| [S] | CreateSpread | 665~683 | spdDetail AddSheet 11개 (WH In Plan Detail은 680줄 `if(drPgmAuthId != null)`) |
| [S] | InitSpreadDateColumn | 1110 / 1114 / 1118 | 날짜 컬럼 DB루프 / 토·일 색상 |
| [S] | SetSpreadColumn | 2116~2148 | Bucket과 Sum에 따른 컬럼 표시 |
| [S] | FindData_ShipmentResult_btnSearch | 4991 / 4992 | SHIP_TO / SHIPTO_DESCRIPTION 숨김 |
| [S] | SpdDetail_CellClick | 8618 / 8653 / 8657 | 헤더 체크박스 전체 선택 토글 |
| [S] | SetSoNoColumnVisible | 9778~9793 | Width 80 또는 0 |

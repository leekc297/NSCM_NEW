# SSP0015 소스 링크 표

경로 약어:
- **M** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.cs`
- **MD** = `…\SSP0015_ShipmentPSI.Designer.cs`
- **P** = `…\SSP0015_ShipmentPSICommentsPopup.cs`
- **PD** = `…\SSP0015_ShipmentPSICommentsPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (endpoints.csv 전수, current)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | InitControls | 568 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | SpdMain_ActiveSheetChanged | 1400 | biz:CommonData.CommonDataList [code=LookupCommon] |
| M | SpdMain_ActiveSheetChanged | 1452 | biz:CommonData.CommonDataList [code=LookupCommon] |
| M | EditButton | 1753 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | EditButton | 1757 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | GetBucketType | 2162 | DM.DM0003_GET_BUCKET_TYPE_CODE |
| M | SetChangedControl | 2202 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | SetChangedControl | 2210 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | SetChangedControl | 2218 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | FindData_Main_Packer_Past | 2293 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| M | FindData_Main_Packer | 2412 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER |
| M | FindData_Main | 2536 | SSP.SSP0015_GET_SHIPMENT_PSI |
| M | GetNERPCode | 2904 | SSP.SSP0002_GET_NERP_CODE |
| M | FindData_Detail | 3165 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| M | FindData_Detail | 3303 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| M | FindData_Detail_Packer_btnSearch | 3439 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| M | FindData_Detail_btnSearch | 3705 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| M | FindData_WHstock | 3850 | SSP.SSP0015_GET_WH_STOCK |
| M | FindData_mes_stock | 3966 | SSP.SSP0015_GET_MES_STOCK |
| M | FindData_block_stock | 4070 | SSP.SSP0015_GET_BLOCK_STOCK |
| M | FindData_BolckStockDetail_btnSearch | 4193 | SSP.SSP0015_GET_BLOCK_STOCK |
| M | FindData_shtStockLocationDetail_btnSearch | 4337 | SSP.SSP0015_GET_STOCK_LOCATION_DETAIL |
| M | FindData_ScsStock_btnSearch | 4437 | SSP.SSP0015_GET_SCS_STOCK |
| M | FindData_MesStock_btnSearch | 4528 | SSP.SSP0015_GET_MES_STOCK |
| M | FindData_Request_Detail | 4640 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK |
| M | FindData_WHinPlanDetail_btnSearch | 4723 | SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| M | FindData_ShipmentSCSResult_btnSearch | 4832 | SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER |
| M | FindData_ShipmentResult_btnSearch | 4944 | SSP.SSP0015_GET_SHIPMENT_RESULT |
| M | SaveData_Main | 5412 | SSP.SSP0015_SAVE_SHIPMENT_PSI |
| M | SaveData_Detail_Packer | 5602 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| M | SaveData_Detail | 5841 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| M | SaveData_Detail | 6011 | SSP.SSP0015_SAVE_BLOCK_STOCK_DATA |
| M | SaveData_Detail | 6112 | SSP.SSP0015_SAVE_MES_STOCK |
| M | SaveData_Detail | 6219 | SSP.SSP0015_SAVE_MES_STOCK |
| M | GetERPInterface | 6665 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| M | GetERPInterface | 6706 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| M | NonSoNo | 6843 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| M | NonSoNo | 6847 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| M | SoNo | 7076 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| M | SoNo | 7080 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| M | GetErpSoNoCnt | 7185 | SSP.SSP0015_GET_ERP_SO_NO_CNT |
| M | GetShipmentStatusChk | 7210 | SSP.SSP0015_GET_SHIPMENT_STATUS |
| M | GetErpIFCheck | 7285 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING (진입점 미연결) |
| M | GetErpIFCheckNew | 7363 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| M | GetErpIFCheckNew | 7389 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| M | GetErpIFCheckNew | 7419 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| M | SCM_SYS_LOG_BATCH | 7876 | SCP.PR_SCM_SYS_LOG_BATCH (진입점 미연결) |
| M | EngProcessingChk | 7903 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| M | SpdDetail_CellClick | 8583 | biz:CommonData.CommonDataList [code=TransMode] |
| M | SpdDetail_CellClick | 8604 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] |
| M | SpdDetail_ClipboardPasted | 8954 | biz:CommonData.CommonDataList [code=TransMode] |
| M | GetDivision | 9192 | SCM.SCM0001_GET_DIVISION (진입점 미연결) |
| M | SetChangedPeriod | 9207 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] (진입점 미연결) |
| M | SetChangedPeriod | 9211 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] (진입점 미연결) |
| M | GetSpdTitle | 9247 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| M | GetDayRange | 9289 | SCP.SCM0001_GET_SCP_DAY_PERIOD |
| M | NewNonSoNo | 9611 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING (진입점 미연결) |
| M | NewNonSoNo | 9615 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER (진입점 미연결) |
| M | GetErpIFCheckNew_ | 9731 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING (진입점 미연결) |
| M | chkSaveYN | 9821 | SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| M | ChkConfirmChangeTime | 9875 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| M | GetSSPUserCheck | 9901 | SSP.SSP0002_GET_USER_INFO_LIST |
| P | SaveData | 333 | SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

## 2. 주석 처리된 호출 지점
| 파일 | 줄 | 내용 |
|---|---:|---|
| M | 3573 | 주석 처리됨: SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| M | 9288 | 주석 처리됨: SCP.GET_DATE_RANGE_1MONTH |
| M | 9308 | 주석 처리됨: SCP.GET_DATE_RANGE_1MONTH |
| M | 9309 | 주석 처리됨: SCP.SCM0001_GET_SCP_PERIOD |

## 3. 이벤트 배선 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| MD | InitializeComponent | 906 | spdMain.TextTipFetch += spdMain_TextTipFetch |
| M | .ctor | 422 | this.Load += Form_Load |
| M | InitEvent | 1159 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| M | InitEvent | 1161 | spdMain.TopChange += SpdMain_TopChange |
| M | InitEvent | 1162 | spdDetail.TopChange += SpdDetail_TopChange |
| M | InitEvent | 1164 | btnMeasure.Click += btnMeasure_Click |
| M | InitEvent | 1165 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| M | InitEvent | 1166 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| M | InitEvent | 1167 | btnItemId.Click += btnItemId_Click |
| M | InitEvent | 1168 | btnItemID2.Click += BtnItemID2_Click |
| M | InitEvent | 1169 | btnSearch.Click += BtnSearch_Click |
| M | InitEvent | 1170 | btnRequestor.Click += BtnRequestor_Click |
| M | InitEvent | 1172 | spdDetail.CellClick += SpdDetail_CellClick |
| M | InitEvent | 1173 | spdDetail.ComboSelChange += spdDetail_ComboSelChange |
| M | InitEvent | 1174 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| M | InitEvent | 1175 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| M | InitEvent | 1177 | spdMain.ActiveSheetChanged += SpdMain_ActiveSheetChanged |
| M | InitEvent | 1179 | clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged |
| M | InitEvent | 1180 | cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged |
| M | InitEvent | 1181 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| M | InitEvent | 1182 | spdDetail.EditChange += SpdDetail_EditChange |
| M | InitEvent | 1183 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| M | InitEvent | 1186 | spdMain.EditModeOn += SpdMain_EditModeOn |
| M | InitEvent | 1187 | spdMain.CellClick += SpdMain_CellClick |
| M | InitEvent | 1190 | dsdm.Changed += shtDetail_Change |
| PD | InitializeComponent | 192 | txtGap_Qty.TextChanged += txtGap_Qty_TextChanged |
| PD | InitializeComponent | 227 | txtBefore_Qty.TextChanged += txtBefore_Qty_TextChanged |
| PD | InitializeComponent | 262 | txtProd_Qty.TextChanged += txtProd_Qty_TextChanged |
| PD | InitializeComponent | 297 | txtWHin_Qty.TextChanged += txtWHin_Qty_TextChanged |
| PD | InitializeComponent | 474 | txtCurrent_Qty.TextChanged += txtCurrent_Qty_TextChanged |
| PD | InitializeComponent | 509 | txtChange_Qty.TextChanged += txtChange_Qty_TextChanged |
| PD | InitializeComponent | 510 | txtChange_Qty.KeyPress += txtChange_Qty_KeyPress |
| PD | InitializeComponent | 657 | btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected |
| P | .ctor | 207 | this.Load += Form_Load |

## 4. Grid 정의 지점 (주요)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | CreateSpread | 656 / 660 | spdMain AddSheet: Shipment PSI(Mobility & IT), Shipment PSI(Packer) (헤더 3행, 고정 1, 행높이 35) |
| M | CreateSpread | 665~683 | spdDetail AddSheet 11종 (Shipment Request Detail만 행높이 60) |
| M | CreateSpread | 680 / 731 / 732 | WH In Plan Detail: `if(drPgmAuthId != null)`일 때만 생성 |
| M | InitSpread | 753 | GetSpdTitle |
| M | InitSpread | 759 / 786 | SetSheetHeaderColumn(spdInfo, 3) — Main/Packer |
| M | InitSpread | 766 / 793 | InitSpreadDateColumn |
| M | InitSpread | 770 / 797 | SetSpreadColumn |
| M | InitSpread | 776, 778, 803, 805 | MergePolicy.Always |
| M | InitSpread | 811, 826, 853, 866, 879, 892, 905, 918, 941, 967, 978 | SetSheetHeaderColumn(…, 1) — Detail 시트 |
| M | InitSpreadDateColumn | 1110 / 1114 / 1118 | B_ 텍스트(숨김) / 숫자 컬럼 / 토·일 색상 |
| M | InitSpreadDateColumn | 1125~1154 | ColumnHeaderSpan (LARGE/SMALL/SUM) |
| M | SetSpreadColumn | 2116~2148 | Bucket DAILY/WEEKLY/MONTHLY · chkSum Visible |
| M | FindData_Detail | 3218~3221, 3356~3359 | Visible=false |
| M | FindData_Detail_Packer_btnSearch | 3491~3493 | Visible=false |
| M | FindData_Detail_btnSearch | 3758~3761 | Visible=false |
| M | FindData_ShipmentResult_btnSearch | 4991 / 4992 | SHIP_TO / SHIPTO_DESCRIPTION Visible=false |
| M | SpdDetail_CellClick | 8618 / 8653 / 8657 | 헤더 CheckBox 토글 |
| M | SetSoNoColumnVisible | 9778 / 9782 / 9789 / 9793 | Width 80/0 |

## 5. 레이아웃 속성 지점
| 파일 | 줄 | 내용 |
|---|---:|---|
| MD | 178 / 181 | usrConditionPanel1 Dock Top, Size(1370, 79) |
| MD | 950 / 953 / 964 / 965 | splitContainer1 Dock Fill, Orientation Horizontal, Size(1370, 570), SplitterDistance 301 |
| MD | 897 / 902 | spdMain Dock Fill, Size(1370, 301) |
| MD | 971 / 976 | spdDetail Dock Fill, Size(1370, 225) |
| MD | 1031 / 1036 | usrLayoutControl3 Dock Top, Size(1370, 40) |

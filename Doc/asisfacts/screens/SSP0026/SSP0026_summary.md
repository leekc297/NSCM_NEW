# SSP0026 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.UIL.csproj | 4607 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.UIL.csproj | 1887 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_BodItemPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 416 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_BodItemPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 565 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_ItembyDivisionPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 402 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_ItembyDivisionPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 487 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0026_ShipmentRequestPack.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 4669 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0026_ShipmentRequestPack.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1887 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 242 | SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP | MATCH | SP SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| button:FindButton | FindButton > FindData | 254 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| button:FindButton | FindButton > FindData | 755 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 787 | SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK | MATCH | SP SSP0026_GET_SHIPMENT_REQUEST_PACK |
| button:FindButton | FindButton > FindData | 848 | SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL | MATCH | SP SSP0026_GET_SHIPMENT_REQUEST_CELL |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 755 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 787 | SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK | MATCH | SP SSP0026_GET_SHIPMENT_REQUEST_PACK |
| button:SaveButton | SaveButton > SaveData > FindData | 848 | SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL | MATCH | SP SSP0026_GET_SHIPMENT_REQUEST_CELL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 1071 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | SP SSP0026_GET_REQUEST_DETAIL_PACK |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 1115 | SSP.SSP0026_GET_REQUEST_DETAIL_CELL | MATCH | SP SSP0026_GET_REQUEST_DETAIL_CELL |
| button:SaveButton | SaveButton > SaveData | 1508 | SSP.SSP0026_SAVE_SHIP_REQ_PACK | MATCH | SP SSP0026_SAVE_SHIP_REQ_PACK |
| button:SaveButton | SaveButton > SaveData | 1580 | SSP.SSP0026_SAVE_SHIP_REQ_CELL | MATCH | SP SSP0026_SAVE_SHIP_REQ_CELL |
| button:SaveButton | SaveButton > SaveData_Detail | 1783 | SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK | MATCH | SP SSP0026_SAVE_SHIP_REQ_DETAIL_PACK |
| button:SaveButton | SaveButton > SaveData_Detail | 1860 | SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | MATCH | SP SSP0026_SAVE_SHIP_REQ_DETAIL_CELL |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 242 | SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP | MATCH | SP SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 254 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData | 755 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData | 787 | SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK | MATCH | SP SSP0026_GET_SHIPMENT_REQUEST_PACK |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData | 848 | SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL | MATCH | SP SSP0026_GET_SHIPMENT_REQUEST_CELL |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Detail | 1071 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | SP SSP0026_GET_REQUEST_DETAIL_PACK |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Detail | 1115 | SSP.SSP0026_GET_REQUEST_DETAIL_CELL | MATCH | SP SSP0026_GET_REQUEST_DETAIL_CELL |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Result_Detail | 969 | SSP.SSP0026_GET_RESULT_DETAIL | MATCH | SP SSP0026_GET_RESULT_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail | 1071 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | SP SSP0026_GET_REQUEST_DETAIL_PACK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail | 1115 | SSP.SSP0026_GET_REQUEST_DETAIL_CELL | MATCH | SP SSP0026_GET_REQUEST_DETAIL_CELL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Result_Detail > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Request_Detail_DownLoad | 4309 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | MATCH | SP SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN |
| event:this.Load | Form_Load > InitControls | 231 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 242 | SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP | MATCH | SP SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| event:this.Load | Form_Load > FindData | 254 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.Load | Form_Load > InitControls | 306 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDivision | 374 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDivision | 388 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDivisionbyScmSite | 402 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 3044 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted | 3464 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted | 3482 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted > FindData_BOD | 3982 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted > FindData_BOD | 4003 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.spdDetail.ComboSelChange | SpdDetail_ComboSelChange | 3191 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdDetail.ComboSelChange | SpdDetail_ComboSelChange > FindData_BOD | 3982 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.spdDetail.ComboSelChange | SpdDetail_ComboSelChange > FindData_BOD | 4003 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail_DblClick | 1232 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | SP SSP0026_GET_REQUEST_DETAIL_PACK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail_DblClick | 1274 | SSP.SSP0026_GET_REQUEST_DETAIL_CELL | MATCH | SP SSP0026_GET_REQUEST_DETAIL_CELL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail_DblClick > InitSpread > GetSpdTitle | 3027 | SSP.SSP0026_GET_SPREAD_TITLE | MATCH | SP SSP0026_GET_SPREAD_TITLE |
| event:this.spdMain.ClipboardPasted | SpdMain_ClipboardPasted > FindData_BOD_Main | 3930 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.spdMain.ClipboardPasted | SpdMain_ClipboardPasted > FindData_BOD_Main | 3951 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_BOD_Main | 3930 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_BOD_Main | 3951 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtPgmAuthId> | 60 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivisionbyScmSite | 388 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | spdMain_ComboSelChange | 2182 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | spdMain_Changed | 2499 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | spdMain_Changed | 2561 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 3056 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | BodValidChk_Main | 3794 | SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | SP SSP0002_GET_BOD_VALID_CHECK |
| unreached:(진입점 미연결) | BodValidChk | 3862 | SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | SP SSP0002_GET_BOD_VALID_CHECK |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_MEASURE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_CUSTOMER, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_CUSTOMER, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE |
| biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_MST_BOD_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 2 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | 2 | SP SSP0002_GET_BOD_VALID_CHECK | EXEC:SSP0002_GET_BOD_VALID_CHECK, SELECT:SCP_MST_BOD_N_V |  |
| SSP.SSP0026_GET_BOD_ITEM | MATCH | 3 | SP SSP0026_GET_BOD_ITEM | EXEC:SSP0026_GET_BOD_ITEM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, REF:STRING_SPLIT |  |
| SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP | MATCH | 1 | SP SSP0026_GET_ITEM_BY_DIVISION_POPUP | EXEC:SSP0026_GET_ITEM_BY_DIVISION_POPUP, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT, REF:STRING_SPLIT |  |
| SSP.SSP0026_GET_REQUEST_DETAIL_CELL | MATCH | 2 | SP SSP0026_GET_REQUEST_DETAIL_CELL | EXEC:SSP0026_GET_REQUEST_DETAIL_CELL | ⚠ DB에 SP 없음 |
| SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | 2 | SP SSP0026_GET_REQUEST_DETAIL_PACK | EXEC:SSP0026_GET_REQUEST_DETAIL_PACK, DYNAMIC@SSP0026_GET_REQUEST_DETAIL_PACK |  |
| SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | MATCH | 1 | SP SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | EXEC:SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN, REF:FN_GET_LOOKUP_VALUE, SELECT:SSP_MST_SHIP_CALENDAR, SELECT:SSP_ANL_SHIP_REQ_P, REF:STRING_SPLIT, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_MST_SITE, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0026_GET_RESULT_DETAIL | MATCH | 1 | SP SSP0026_GET_RESULT_DETAIL | EXEC:SSP0026_GET_RESULT_DETAIL, REF:FN_NEXT_DAY, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SSP0026_GET_RESULT_DETAIL |  |
| SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL | MATCH | 1 | SP SSP0026_GET_SHIPMENT_REQUEST_CELL | EXEC:SSP0026_GET_SHIPMENT_REQUEST_CELL, SELECT:SCM_MST_TITLESET_USER, INSERT:#TBLDYNAMICTITLEST_SSP0026, CREATE:#TMP_RESULT_TABLE, CREATE:#TMP_ROWDATA, CREATE:#Z, CREATE:#QTY, CREATE:#BOH, SELECT:SCP_PLAN_VERSION_V, SELECT:SSP_PLAN_VERSION_V, INSERT:#TBLDYNAMIC_SSP0026_40_STD, SELECT:SSP_ANL_SHIP_PLAN_40, INSERT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_PLN_SHIPMENT_PLAN, SELECT:SCP_PLN_SHIPMENT_PLAN_PEGGING, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, INSERT:#TMP_ROWDATA, SELECT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_MST_BOD_N_V, SELECT:DM_PLN_SHIPMENT_REQ, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_ITEM_SN, SELECT:SSP_DNM_FORMATION_POST_CELL, SELECT:#TBLDYNAMIC_SSP0026_40_STD, INSERT:#Z, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TMP_ROWDATA, INSERT:#QTY, INSERT:#BOH, SELECT:#QTY, SELECT:#Z, SELECT:#BOH, INSERT:#TMP_ROWDATA_RN, INSERT:#TMP_RESULT_TABLE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMIC_REQUESTOR, SELECT:#TMP_ROWDATA_RN, INSERT:#TMP_RESULT_PIVOT_TABLE_TEMP, SELECT:#TMP_RESULT_TABLE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, INSERT:#TMP_RESULT_PIVOT_TABLE, SELECT:#TMP_RESULT_PIVOT_TABLE_TEMP, DYNAMIC@SSP0026_GET_SHIPMENT_REQUEST_CELL |  |
| SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK | MATCH | 1 | SP SSP0026_GET_SHIPMENT_REQUEST_PACK | EXEC:SSP0026_GET_SHIPMENT_REQUEST_PACK, SELECT:SCM_MST_TITLESET_USER, INSERT:#TBLDYNAMICTITLEST_SSP0026, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#TMP_RESULT_TABLE, CREATE:#TMP_ROWDATA, CREATE:#Z, CREATE:#QTY, CREATE:#BOH, SELECT:SCP_PLAN_VERSION_V, INSERT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_PLN_SHIPMENT_PLAN, SELECT:SCP_PLN_SHIPMENT_PLAN_PEGGING, SELECT:SCM_MST_SITE, SELECT:SCP_MST_BOD_N_V, REF:STRING_SPLIT, INSERT:#TMP_ROWDATA, SELECT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SSP_ANL_SHIP_REQ_P, SELECT:SCM_DNM_SCS_SHIP_RESULT, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_DNM_SCS_PROD_PLAN, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TMP_ROWDATA, SELECT:SCM_DNM_SCS_STOCK, INSERT:#TMP_ROWDATA_RN, INSERT:#TMP_RESULT_TABLE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMIC_REQUESTOR, SELECT:#TMP_ROWDATA_RN, INSERT:#TMP_RESULT_PIVOT_TABLE_TEMP, SELECT:#TMP_RESULT_TABLE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, INSERT:#TMP_RESULT_PIVOT_TABLE, SELECT:#TMP_RESULT_PIVOT_TABLE_TEMP, DYNAMIC@SSP0026_GET_SHIPMENT_REQUEST_PACK |  |
| SSP.SSP0026_GET_SPREAD_TITLE | MATCH | 1 | SP SSP0026_GET_SPREAD_TITLE | EXEC:SSP0026_GET_SPREAD_TITLE, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0026_SAVE_SHIP_REQ_CELL | MATCH | 1 | SP SSP0026_SAVE_SHIP_REQ_CELL | EXEC:SSP0026_SAVE_SHIP_REQ_CELL, CREATE:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, EXEC:PR_SCP_SYS_LOG_BATCH, REF:FN_NEXT_DAY, SELECT:SCM_SYS_CALENDAR_M, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, SELECT:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, UPDATE:A, SELECT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ_H, INSERT:DM_PLN_SHIPMENT_REQ, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | MATCH | 1 | SP SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | EXEC:SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | ⚠ DB에 SP 없음 |
| SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK | MATCH | 1 | SP SSP0026_SAVE_SHIP_REQ_DETAIL_PACK | EXEC:SSP0026_SAVE_SHIP_REQ_DETAIL_PACK, CREATE:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, EXEC:PR_SCP_SYS_LOG_BATCH, REF:FN_NEXT_DAY, SELECT:SCM_SYS_CALENDAR_M, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, SELECT:SCM_MST_SITE, INSERT:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, SELECT:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, UPDATE:A, SELECT:SSP_ANL_SHIP_REQ_P, INSERT:SSP_ANL_SHIP_REQ_P_H, INSERT:XIF_SCS_PACK_SHIP_PLAN_S_SN, REF:FN_ZERO_LPAD, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SITE_CUSTOMER_INFO, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:NERP_CONV_MASTER, INSERT:SSP_ANL_SHIP_REQ_P, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_SSO_USER_INFO |  |
| SSP.SSP0026_SAVE_SHIP_REQ_PACK | MATCH | 1 | SP SSP0026_SAVE_SHIP_REQ_PACK | EXEC:SSP0026_SAVE_SHIP_REQ_PACK, CREATE:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, EXEC:PR_SCP_SYS_LOG_BATCH, REF:FN_NEXT_DAY, SELECT:SCM_SYS_CALENDAR_M, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, SELECT:#TBLDYNAMIC_SSP0026_SHPIMENTREQ, UPDATE:A, SELECT:SSP_ANL_SHIP_PLAN_PACK_REQ, SELECT:SCM_MST_SITE_CUSTOMER, INSERT:SSP_ANL_SHIP_REQ_P_H, REF:FN_GET_SITE_CUSTOMER_INFO, INSERT:XIF_SCS_PACK_SHIP_PLAN_S_SN, REF:FN_ZERO_LPAD, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:NERP_CONV_MASTER, INSERT:SSP_ANL_SHIP_PLAN_PACK_REQ, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SSO_USER_INFO |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE, NAME |
| InitControls | dr | FROM_DATE, FIRST_DATE, NAME, CONFIRM_DAY, TO_DATE |
| InsertRow | UserInfoContext.Current | NowGroupID |
| Re_Design | ro | SHIP_FROZEN, CONFIRM_DAY |
| Set_SumValues | dsBinding.Tables[0].Columns | MEASURE |
| ShowCell | ro | SHIP_FROZEN |
| SpdMain_ActiveSheetChanged | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:219 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:221, InitControls:245, InitControls:251, InitControls:255, FindData:760, FindData:761, FindData_Result_Detail:929, FindData_Result_Detail:930 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:379 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:386, InitSpread:398, InitSpread:407 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| CreateSheetHeaderColumn | InitSpread:413, InitSpread:425 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:739 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.formDown | Click | btnExcelFormDownload_Click | InitializeComponent:307 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:349 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:426 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitializeComponent:461 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:499 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:536 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:572 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:678 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:832 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:872 |
| this | Load | Form_Load | .ctor:203 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:586 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:587 |
| this.spdDetail | TopChange | SpdDetail_TopChange | InitEvent:588 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:589 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:590 |
| this.spdDetail | ComboSelChange | SpdDetail_ComboSelChange | InitEvent:591 |
| this.spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:592 |
| this.spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:593 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:594 |
| this.btnItemId | Click | BtnItemID_Click | InitEvent:595 |
| this.btnItemID2 | Click | BtnItemID2_Click | InitEvent:596 |
| this.btnRequestor | Click | BtnRequestor_Click | InitEvent:597 |
| this.chkPastPeriod | CheckedChanged | chkPastPeriod_CheckedChanged | InitEvent:598 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:599 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:601 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:193 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:286 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:422 |
| this | Load | Form_Load | .ctor:136 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:184 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:277 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:395 |
| this | Load | Form_Load | .ctor:126 |

## 6. 컨트롤 (112개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 39 | lblItemType, layoutControlItem5, layoutControlItem6, layoutControlItem2, layoutControlItem7, lblTeam, lblCustomer, Period, lblSalesSite, lblModel, lblProject, layoutControlItem3, layoutControlItem1, clbDivision, lblBucket … |
| UsrCheckedList | 9 | clbPlantSite, clbSalesSite, clbCustomer, clbTeam, clbDivision, clbFromSite, clbToSite, clbDivision, clbScmSite |
| UsrMultiLineEditor | 9 | txtProject, txtItemId, txtRequestor, txtItemld2, txtLotID, txtItemID, txtToSite, txtItemID, txtProject |
| UsrButton | 8 | formDown, btnExcelUpload, btnMeasure, btnColumn, btnProject, btnItemId, btnRequestor, btnItemID2 |
| EmptySpaceItem | 8 | emptySpaceItem8, emptySpaceItem1, emptySpaceItem12, emptySpaceItem2, emptySpaceItem3, emptySpaceItem6, emptySpaceItem4, emptySpaceItem1 |
| UsrLayoutControl | 7 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 7 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 5 | spdMain, spdDetail, spdSub, spdMain, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdDetail_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckBox | 2 | chkPastPeriod, chkSum |
| UsrCombo | 2 | cboDivision, cboBucketType |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod2 |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| ImageList | 1 | imageList1 |
| SplitContainer | 1 | splitContainer1 |
| TextBox | 1 | textNickName2 |
| SimpleButton | 1 | btnSearch |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 154 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 2 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 7 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 116 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 19 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 8 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 9 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 48 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 389 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 375 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0026 | Cell Biz | 13/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | SSP0026 | Pack Biz | 15/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | SSP0026 | Shipment Request Detail | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 |
| SCM_MST_SHEET_COLUMNS | SSP0026 | Shipment Request Detail Excel | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0026 | Shipment Request Detail_BACKUP | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | SSP0026 | Shipment Result Detail | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_MEASURE | SSP0026 | Cell Biz | 10/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | SSP0026 | Pack Biz | 8/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 84개 시트×division 비교, 차이 4178건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Pack Biz, Cell Biz, Shipment Request Detail, Shipment Result Detail, Shipment Request Detail Excel, Project
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:386, SetSheetHeaderColumn@InitSpread:398, SetSheetHeaderColumn@InitSpread:407, CreateSheetHeaderColumn@InitSpread:413, CreateSheetHeaderColumn@InitSpread:425
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 392 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?MergePolicy.None} |  | if(sSheetName == "Shipment Request Detail") |
| SetSpreadHeaderSpan |  | 531 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 542 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadColumn |  | 2909 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2914 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2921 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2925 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2930 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2937 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2941 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2960 | 표시/라벨 변경 | set:Visible | Visible = {?chkPastPeriod.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(!chkPastPeriod.Checked) ⟫ else!(siMain.ActiveSheet.ColumnHeader.Cells[2, iCol].Value.ToString() == "SUM") ⟫ if(date > colDate) |
| SpdMain_ActiveSheetChanged |  | 3592 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SHIPTO_CODE | if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") |
| SpdMain_ActiveSheetChanged |  | 3593 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SHIPTO_CODE | if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") |
| SpdMain_ActiveSheetChanged |  | 3594 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORDER_TYPE_DETAIL | if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") |
| SpdMain_ActiveSheetChanged |  | 3595 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FCST_TYPE | if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") |
| ExportExcel |  | 4501 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcel |  | 4543 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 1226 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1227 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1228 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1229 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1277 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1278 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1279 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1280 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1710 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1711 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1712 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1713 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 204 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread |  | 205 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME |  |
| InitSpread |  | 207 | 하드코딩 | AddTextColumn | Material | ITEM_ID |  |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Incoterms | INCOTERMS |  |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | Transport Mode | TRANSPORT_MODE |  |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | BOD ID | BOD_ID |  |
| InitializeComponent |  | 438 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 439 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 440 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 441 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 189 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread |  | 190 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME |  |
| InitSpread |  | 191 | 하드코딩 | AddTextColumn | Project Code | PROJECT_CODE |  |
| InitSpread |  | 192 | 하드코딩 | AddTextColumn | Project | PROJECT_NAME |  |
| InitSpread |  | 193 | 하드코딩 | AddTextColumn | SCM Site | SCM_SITE_ID |  |
| InitSpread |  | 194 | 하드코딩 | AddTextColumn | Site | SITE_DESCRIPTION |  |
| InitSpread |  | 195 | 하드코딩 | AddTextColumn | Model Code | ITEM_ID |  |
| InitSpread |  | 196 | 하드코딩 | AddTextColumn | Model | ITEM_NAME |  |
| InitSpread |  | 197 | 하드코딩 | AddTextColumn | Type | ITEM_TYPE |  |
| InitSpread |  | 198 | 하드코딩 | AddTextColumn | Nick Name | NICK_NAME |  |
| InitSpread |  | 199 | 하드코딩 | AddTextColumn | Class Name | ITEM_CLASS_NAME |  |
| InitializeComponent |  | 411 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 412 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 413 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 414 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Cell Biz | META+코드연결 | 13 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Pack Biz | META+코드연결 | 16 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| Project | 코드 하드코딩 전용(메타 없음) | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Shipment Request Detail | META+코드연결 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 |
| Shipment Request Detail Excel | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Shipment Request Detail_BACKUP | 메타 정의만, 코드 미참조(미사용 가능) | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Shipment Result Detail | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

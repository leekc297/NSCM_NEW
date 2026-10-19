# SSP0029 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0029_ShipmentPlanPackPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 447 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0029_ShipmentPlanPackPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 960 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0029_ShipmentPlanPack.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 9440 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0029_ShipmentPlanPack.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1654 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 8857 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl | 2051 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl > GetDayRange | 8857 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| button:EditButton | EditButton | 1642 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| button:EditButton | EditButton | 1646 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main_Packer_Past | 2123 | SSP.SSP0029_GET_SHIPMENT_PSI_PACKER_PAST | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData_Main_Packer | 2242 | SSP.SSP0029_GET_SHIPMENT_PSI_PACKER | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData_Main | 2366 | SSP.SSP0029_GET_SHIPMENT_PSI | MATCH | SP SSP0029_GET_SHIPMENT_PSI |
| button:FindButton | FindButton > FindData_Main_Packer_Past > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData | 333 | SSP.SSP0029_SAVE_SHIPMENT_PSI_COMMENTS | MATCH | SP SSP0029_SAVE_SHIPMENT_PSI_COMMENTS |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 2366 | SSP.SSP0029_GET_SHIPMENT_PSI | MATCH | SP SSP0029_GET_SHIPMENT_PSI |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 2959 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 3097 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch | 3233 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail_btnSearch | 3499 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_mes_stock | 3761 | SSP.SSP0029_GET_MES_STOCK | MATCH | SP SSP0029_GET_MES_STOCK |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_MesStock_btnSearch | 4322 | SSP.SSP0029_GET_MES_STOCK | MATCH | SP SSP0029_GET_MES_STOCK |
| button:SaveButton | SaveButton > SaveData_Main | 5206 | SSP.SSP0029_SAVE_SHIPMENT_PSI | MATCH | SP SSP0029_SAVE_SHIPMENT_PSI |
| button:SaveButton | SaveButton > SaveData_Detail_Packer | 5396 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData_Detail | 5614 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | SP SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| button:SaveButton | SaveButton > SaveData_Detail | 5780 | SSP.SSP0029_SAVE_BLOCK_STOCK_DATA | MATCH | SP SSP0029_SAVE_BLOCK_STOCK_DATA |
| button:SaveButton | SaveButton > SaveData_Detail | 5881 | SSP.SSP0029_SAVE_MES_STOCK | MATCH | SP SSP0029_SAVE_MES_STOCK |
| button:SaveButton | SaveButton > SaveData_Detail | 5988 | SSP.SSP0029_SAVE_MES_STOCK | MATCH | SP SSP0029_SAVE_MES_STOCK |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > NonSoNo | 6486 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > NonSoNo | 6490 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > SoNo | 6717 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > SoNo | 6721 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > GetErpSoNoCnt | 6824 | SSP.SSP0029_GET_ERP_SO_NO_CNT | MATCH | SP SSP0029_GET_ERP_SO_NO_CNT |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > GetShipmentStatusChk | 6849 | SSP.SSP0029_GET_SHIPMENT_STATUS | MATCH | SP SSP0029_GET_SHIPMENT_STATUS |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > GetERPInterface > SoNo > GetErpIFCheck | 6924 | SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > EngProcessingChk | 7427 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | MATCH | SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail_Packer > chkSaveYN | 9389 | SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK | MATCH | SP SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| event:spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted | 8522 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 333 | SSP.SSP0029_SAVE_SHIPMENT_PSI_COMMENTS | MATCH | SP SSP0029_SAVE_SHIPMENT_PSI_COMMENTS |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail_Packer_btnSearch | 3233 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | NOT_IN_FOXQUERY |  |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail_btnSearch | 3499 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_WHstock | 3644 | SSP.SSP0029_GET_WH_STOCK | MATCH | SP SSP0029_GET_WH_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_BolckStockDetail_btnSearch | 3988 | SSP.SSP0029_GET_BLOCK_STOCK | MATCH | SP SSP0029_GET_BLOCK_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_shtStockLocationDetail_btnSearch | 4131 | SSP.SSP0029_GET_STOCK_LOCATION_DETAIL | MATCH | SP SSP0029_GET_STOCK_LOCATION_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ScsStock_btnSearch | 4231 | SSP.SSP0029_GET_SCS_STOCK | MATCH | SP SSP0029_GET_SCS_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_MesStock_btnSearch | 4322 | SSP.SSP0029_GET_MES_STOCK | MATCH | SP SSP0029_GET_MES_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Request_Detail | 4434 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | SP SSP0026_GET_REQUEST_DETAIL_PACK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_WHinPlanDetail_btnSearch | 4517 | SSP.SSP0029_GET_SHIPMENT_PSI_COMMENTS | MATCH | SP SSP0029_GET_SHIPMENT_PSI_COMMENTS |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentSCSResult_btnSearch | 4626 | SSP.SSP0029_GET_SHIPMENT_RESULT_PACKER | NOT_IN_FOXQUERY |  |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentResult_btnSearch | 4738 | SSP.SSP0029_GET_SHIPMENT_RESULT | MATCH | SP SSP0029_GET_SHIPMENT_RESULT |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentSCSResult_btnSearch > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 466 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1995 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 2051 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 8857 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdDetail.CellClick | SpdDetail_CellClick | 8151 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.spdDetail.CellClick | SpdDetail_CellClick | 8172 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged | 1299 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged | 1351 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetChangedControl | 2051 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetChangedControl > GetDayRange | 8857 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Main | 2366 | SSP.SSP0029_GET_SHIPMENT_PSI | MATCH | SP SSP0029_GET_SHIPMENT_PSI |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 2959 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 3097 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_WHstock | 3644 | SSP.SSP0029_GET_WH_STOCK | MATCH | SP SSP0029_GET_WH_STOCK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_mes_stock | 3761 | SSP.SSP0029_GET_MES_STOCK | MATCH | SP SSP0029_GET_MES_STOCK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_block_stock | 3865 | SSP.SSP0029_GET_BLOCK_STOCK | MATCH | SP SSP0029_GET_BLOCK_STOCK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_shtStockLocationDetail_btnSearch | 4131 | SSP.SSP0029_GET_STOCK_LOCATION_DETAIL | MATCH | SP SSP0029_GET_STOCK_LOCATION_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_ScsStock_btnSearch | 4231 | SSP.SSP0029_GET_SCS_STOCK | MATCH | SP SSP0029_GET_SCS_STOCK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_shtStockLocationDetail_btnSearch > InitSpread > GetSpdTitle | 8815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtChangeReasonCode> | 69 | biz:CommonData.CommonDataList [code=CHANGE_REASON_CODE_ALL] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtFcstType> | 78 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyModelChk> | 79 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtStockStatus> | 81 | biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 82 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtResultType> | 84 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtPgmAuthId> | 85 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SCM_SYS_LOG_BATCH | 7400 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| unreached:(진입점 미연결) | GetDivision | 8760 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 8775 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 8779 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | NewNonSoNo | 9179 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | NewNonSoNo | 9183 | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | GetErpIFCheckNew | 9299 | SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CHANGE_REASON_CODE_ALL] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 7 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_CUSTOMER, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_CUSTOMER, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE |
| biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_MST_BOD_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | MATCH | 1 | SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | EXEC:SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_PLAN_DETAIL |  |
| SSP.SSP0026_GET_REQUEST_DETAIL_PACK | MATCH | 1 | SP SSP0026_GET_REQUEST_DETAIL_PACK | EXEC:SSP0026_GET_REQUEST_DETAIL_PACK, DYNAMIC@SSP0026_GET_REQUEST_DETAIL_PACK |  |
| SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 2 | SP SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0029_GET_BLOCK_STOCK | MATCH | 2 | SP SSP0029_GET_BLOCK_STOCK | EXEC:SSP0029_GET_BLOCK_STOCK, REF:FN_GET_IN_STR, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, REF:FN_CHAR_TO_DATE, SELECT:SSP_ANL_HOLD_STOCK, SELECT:TB_FX_USER, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, REF:FN_SCM_SPLIT, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0029_GET_ERP_SO_NO_CNT | MATCH | 1 | SP SSP0029_GET_ERP_SO_NO_CNT | EXEC:SSP0029_GET_ERP_SO_NO_CNT, SELECT:SSP_ANL_SHIP_CONFIRM |  |
| SSP.SSP0029_GET_MES_STOCK | MATCH | 2 | SP SSP0029_GET_MES_STOCK | EXEC:SSP0029_GET_MES_STOCK, REF:FN_GET_ITEM_NICKNAME, SELECT:SSP_ANL_MES_FCS_STOCK_40_C, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SSP_MST_MODEL_USER, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, SELECT:SSP_ANL_OWMS_STOCK_C, SELECT:SCM_MST_SLOC, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0029_GET_SCS_STOCK | MATCH | 1 | SP SSP0029_GET_SCS_STOCK | EXEC:SSP0029_GET_SCS_STOCK | ⚠ DB에 SP 없음 |
| SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | MATCH | 3 | SP SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | EXEC:SSP0029_GET_SHIPMENT_CONFIRM_DETAIL, REF:FN_GET_IN_STR, DYNAMIC@SSP0029_GET_SHIPMENT_CONFIRM_DETAIL, REF:FN_SCM_SPLIT |  |
| SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0029_GET_SHIPMENT_PSI | MATCH | 1 | SP SSP0029_GET_SHIPMENT_PSI | EXEC:SSP0029_GET_SHIPMENT_PSI, REF:FN_GET_LOOKUP_VALUE, SELECT:SCM_MST_TITLESET_USER, SELECT:SSP_PLAN_VERSION_V, CREATE:#TMP_ROWDATA, INSERT:#TBLDYNAMICTITLEST_SSP0029, INSERT:#TMP_ROWDATA, SELECT:SSP_ANL_SHIP_PLAN_40, SELECT:SCM_MST_SITE, SELECT:SSP_MST_MODEL_USER, SELECT:SSP_MST_DELEGATE, SELECT:DM_PLN_SHIPMENT_REQ, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_ANL_SHIP_CONFIRM, REF:FN_GET_SSP_ANL_SHIP_FROZEN, SELECT:SSP_ANL_MES_FCS_STOCK_40_C, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_ANL_OWMS_STOCK_C, SELECT:#TMP_ROWDATA, SELECT:SSP_ANL_HOLD_STOCK, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SHEET_MEASURE, DYNAMIC@SSP0029_GET_SHIPMENT_PSI, EXEC:SSP0029_GET_SHIPMENT_PSI_COMMENTS, SELECT:SCM_CODE_LOOKUP_VALUE, REF:FN_GET_IN_STR, DYNAMIC@SSP0029_GET_SHIPMENT_PSI_COMMENTS, REF:FN_SCM_SPLIT |  |
| SSP.SSP0029_GET_SHIPMENT_PSI_COMMENTS | MATCH | 1 | SP SSP0029_GET_SHIPMENT_PSI_COMMENTS | EXEC:SSP0029_GET_SHIPMENT_PSI_COMMENTS, REF:FN_GET_IN_STR, DYNAMIC@SSP0029_GET_SHIPMENT_PSI_COMMENTS, REF:FN_SCM_SPLIT |  |
| SSP.SSP0029_GET_SHIPMENT_PSI_PACKER | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0029_GET_SHIPMENT_PSI_PACKER_PAST | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0029_GET_SHIPMENT_RESULT | MATCH | 1 | SP SSP0029_GET_SHIPMENT_RESULT | EXEC:SSP0029_GET_SHIPMENT_RESULT, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:PLAN_SSP, SELECT:RESULT_OWMS, SELECT:RETURN_OWMS, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCP_MST_FINAL_ITEM, REF:FN_LIST_LOOKUP_VALUE, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_ANL_SHIP_PLAN_ALL, SELECT:SSP_DNM_SHIP_RESULT_OWMS, SELECT:SSP_DNM_SHIP_RETURN_OWMS, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0029_GET_SHIPMENT_RESULT_PACKER | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0029_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0029_GET_SHIPMENT_STATUS | EXEC:SSP0029_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |
| SSP.SSP0029_GET_STOCK_LOCATION_DETAIL | MATCH | 1 | SP SSP0029_GET_STOCK_LOCATION_DETAIL | EXEC:SSP0029_GET_STOCK_LOCATION_DETAIL | ⚠ DB에 SP 없음 |
| SSP.SSP0029_GET_WH_STOCK | MATCH | 1 | SP SSP0029_GET_WH_STOCK | EXEC:SSP0029_GET_WH_STOCK, REF:FN_GET_IN_STR, REF:FN_GET_ITEM_NICKNAME, SELECT:SSP_ANL_OWMS_STOCK_C, SELECT:SCM_MST_SLOC, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, REF:FN_SCM_SPLIT, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0029_SAVE_BLOCK_STOCK_DATA | MATCH | 1 | SP SSP0029_SAVE_BLOCK_STOCK_DATA | EXEC:SSP0029_SAVE_BLOCK_STOCK_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_HOLD_STOCK, UPDATE:SSP_ANL_HOLD_STOCK, INSERT:SSP_ANL_HOLD_STOCK, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0029_SAVE_MES_STOCK | MATCH | 2 | SP SSP0029_SAVE_MES_STOCK | EXEC:SSP0029_SAVE_MES_STOCK, CREATE:#TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP, MERGE:SSP_ANL_MES_FCS_STOCK_40_C, SELECT:#TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP, MERGE:SSP_ANL_SHIP_PLAN_40, SELECT:SSP_ANL_SHIP_PLAN_40, SELECT:SSP_ANL_MES_FCS_STOCK_40_C, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0029_SAVE_SHIPMENT_PSI | MATCH | 1 | SP SSP0029_SAVE_SHIPMENT_PSI | EXEC:SSP0029_SAVE_SHIPMENT_PSI, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_PLAN_40, INSERT:SSP_ANL_SHIP_PLAN_40_WH_IN_H, SELECT:SSP_ANL_SHIP_PLAN_40, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0029_SAVE_SHIPMENT_PSI_COMMENTS | MATCH | 1 | SP SSP0029_SAVE_SHIPMENT_PSI_COMMENTS | EXEC:SSP0029_SAVE_SHIPMENT_PSI_COMMENTS, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_ANL_SHIP_PLAN_40, INSERT:SSP_ANL_SHIP_PLAN_40_WH_IN_H, SELECT:SSP_ANL_SHIP_PLAN_40, SELECT:SSP_ANL_SHIP_PLAN_40_WH_IN_CMT, UPDATE:SSP_ANL_SHIP_PLAN_40_WH_IN_CMT, INSERT:SSP_ANL_SHIP_PLAN_40_WH_IN_CMT, INSERT:SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | 1 | SP SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | EXEC:SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TBLDYNAMIC_SSP0029_40_STD, SELECT:SSP_ANL_SHIP_PLAN_40, SELECT:SCM_MST_SITE, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, REF:FN_GET_SSP_ETA_DATE, UPDATE:SSP_ANL_SHIP_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, INSERT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_SITE_ITEM_EE_V, INSERT:SSP_ANL_SHIP_CONFIRM_H, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:NERP_CONV_MASTER, EXEC:PR_DM_SSP_CONFIRM_SYNC, SELECT:#TBLDYNAMIC_SSP0029_40_STD, DELETE:SSP_ANL_SHIP_PLAN_40, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SSP_ANL_SHIP_PLAN_40, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, SELECT:SSP_MST_SEND_MAIL_REQ, INSERT:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_MST, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, CREATE:#T_CONFIRM_ID, CREATE:#T_SSP, CREATE:#T_SSP_SUM, CREATE:#T_MKT_RESULT, CREATE:#T_MKT_RESULT_SUM, CREATE:#TEMP_SALES_RESULT, INSERT:#T_CONFIRM_ID, DELETE:A, SELECT:DM_PLN_MKT_FCST_CONFIRM, SELECT:#T_CONFIRM_ID, INSERT:DM_PLN_MKT_FCST_CONFIRM, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:DM_MST_ITEM_SINGLE_V, UPDATE:A, INSERT:#TEMP_SHIP_RESULT, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:#TEMP_SHIP_RESULT, INSERT:#TEMP_SALES_RESULT, SELECT:DM_PLN_MKT_FCST_RESULT, REF:FN_SPLITSTRING, SELECT:#TEMP_SALES_RESULT, SELECT:XIF_ERP_SHIP_DOC_R_SN, INSERT:#TEMP_CONFRIM_MKT_FCST, INSERT:#T_SSP |  |
| SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 3 | SP SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY | 3 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK | MATCH | 1 | SP SSP0202_GET_SCS_CONFIRM_ID_CHECK | EXEC:SSP0202_GET_SCS_CONFIRM_ID_CHECK, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_IN_STR, DYNAMIC@SSP0202_GET_SCS_CONFIRM_ID_CHECK, REF:FN_SCM_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| CalculateSum | dr | measure |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| chkSaveYN | ds.Tables[0].Rows[0] | CNT |
| chkSaveYN | ds.Tables[1].Rows[0] | CNT |
| FindData_ShipmentResult_btnSearch | sv.Columns | SHIP_TO, SHIPTO_DESCRIPTION |
| GetErpSoNoCnt | ds.Tables[0].Rows[0] | CNT |
| GetShipmentStatusChk | ds.Tables[0].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[1].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[2].Rows[iRow] | CONFIRM_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE, NAME |
| InitControls | dtCompany.Rows[0] | COMPANY_ID |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |
| SetBalanceMinus | dr | DivisionID, FromSite, ItemID |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetNote_Display | row | DIVISION_ID, SITE, ITEM_ID, YYYYMMDD |
| SetNote_Display | Comments | COMMENTS |
| SetProdNote_Display | row | DIVISION_ID, SITE, ITEM_ID, YYYYMMDD |
| SetProdNote_Display | drProdQty | PRODUCT_QTY |
| SpdDetail_ClipboardPasted | c | CODE |
| SpdMain_ActiveSheetChanged | UserInfoContext.Current | NowGroupID |
| SpdMain_CellDoubleClick | row | DIVISION_ID, SITE, ITEM_ID, YYYYMMDD |
| SpdMain_CellDoubleClick | Comments | GAP, BEFORE_QTY, USER_ADD_QTY |
| TsmNotepad_Click | row | DIVISION_ID, SITE, ITEM_ID, YYYYMMDD |
| TsmNotepad_Click | Comments | GAP, BEFORE_QTY, USER_ADD_QTY |
| Validation_Check | row | confirm_id |
| Validation_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE |
| Validation_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:271, btnButtonList_UsrButtonList_Click_Detected:430 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetSpdTitle | InitSpread:652 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:658, InitSpread:685, InitSpread:710, InitSpread:725, InitSpread:752, InitSpread:765, InitSpread:778, InitSpread:791 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:665, InitSpread:692 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SpdMain_ActiveSheetChanged:1256, EditButton:1638, EditButton:1650, SetChangedControl:2021, FindData_Main_Packer_Past:2083, FindData_Main_Packer_Past:2085, FindData_Main_Packer_Past:2089, FindData_Main_Packer:2202 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.txtGap_Qty | TextChanged | txtGap_Qty_TextChanged | InitializeComponent:192 |
| this.txtBefore_Qty | TextChanged | txtBefore_Qty_TextChanged | InitializeComponent:227 |
| this.txtProd_Qty | TextChanged | txtProd_Qty_TextChanged | InitializeComponent:262 |
| this.txtWHin_Qty | TextChanged | txtWHin_Qty_TextChanged | InitializeComponent:297 |
| this.txtCurrent_Qty | TextChanged | txtCurrent_Qty_TextChanged | InitializeComponent:474 |
| this.txtChange_Qty | TextChanged | txtChange_Qty_TextChanged | InitializeComponent:509 |
| this.txtChange_Qty | KeyPress | txtChange_Qty_KeyPress | InitializeComponent:510 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:657 |
| this | Load | Form_Load | .ctor:207 |
| this.spdMain | TextTipFetch | spdMain_TextTipFetch | InitializeComponent:920 |
| this | Load | Form_Load | .ctor:404 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:1058 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:1060 |
| this.spdDetail | TopChange | SpdDetail_TopChange | InitEvent:1061 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:1063 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:1064 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:1065 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:1066 |
| this.btnItemID2 | Click | BtnItemID2_Click | InitEvent:1067 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:1068 |
| this.btnRequestor | Click | BtnRequestor_Click | InitEvent:1069 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:1071 |
| this.spdDetail | ComboSelChange | spdDetail_ComboSelChange | InitEvent:1072 |
| this.spdDetail | SheetTabClick | SpdDetail_SheetTabClick | InitEvent:1073 |
| this.spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:1074 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:1076 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:1078 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:1079 |
| spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:1080 |
| spdDetail | EditChange | SpdDetail_EditChange | InitEvent:1081 |
| spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:1082 |
| spdMain | EditModeOn | SpdMain_EditModeOn | InitEvent:1085 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:1086 |
| dsdm | Changed | shtDetail_Change | InitEvent:1089 |

## 6. 컨트롤 (100개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 37 | layoutControlItem5, layoutControlItem6, layoutControlItem8, layoutControlItem4, layoutControlItem12, layoutControlItem9, layoutControlItem10, layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem7, layoutControlItem13, layoutControlItem15, layoutControlItem14, layoutControlItem11 … |
| UsrTextBox | 13 | txtGap_Qty, txtBefore_Qty, txtProd_Qty, txtWHin_Qty, txtMeasure, txtFrom_Site, txtDivision_ID, txtCurrent_Qty, txtChange_Qty, txtDate, txtItem_ID, txtPlan_Date, txtRequestor |
| EmptySpaceItem | 7 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem5 |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup2, layoutControlGroup3 |
| UsrButton | 5 | usrButton1, btnMeasure, btnItemId, btnRequestor, btnItemID2 |
| UsrCheckBox | 5 | chkSum, chkMyModel, chkPartLeader, chkTeamLeader, chkDelegateeModel |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl2, usrLayoutControl3 |
| UsrCombo | 3 | cboPlanDate, cboBucketType, clbDivision |
| UsrDateRangePicker | 3 | drpPeriod, drpPeriod2, drpPeriod3 |
| UsrMultiLineEditor | 3 | txtItemId, txtModel2, txtLotID |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrCheckedList | 2 | clbPlantSite, clbResultType |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet1 |
| RichTextBox | 1 | rtxComments |
| UsrLabel | 1 | usrLabel1 |
| UsrButtonList | 1 | btnButtonList |
| SplitContainer | 1 | splitContainer1 |
| SimpleButton | 1 | btnSearch |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2123 | FindData_Main_Packer_Past | SSP.SSP0029_GET_SHIPMENT_PSI_PACKER_PAST | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 2242 | FindData_Main_Packer | SSP.SSP0029_GET_SHIPMENT_PSI_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 3233 | FindData_Detail_Packer_btnSearch | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 4626 | FindData_ShipmentSCSResult_btnSearch | SSP.SSP0029_GET_SHIPMENT_RESULT_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5396 | SaveData_Detail_Packer | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 6490 | NonSoNo | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 6721 | SoNo | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 9183 | NewNonSoNo | SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 105 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 5 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 300 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 13 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 1 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 9 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 3367 | SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | commented:NOT_IN_FOXQUERY |
| 8856 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 8877 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 8876 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0029 | Hold stock | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Hold stock Detail | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | SCS Stock Detail | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Shipment Confirm Detail | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 | 38/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Shipment PSI(Mobility & IT) | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Shipment PSI(Packer) | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Shipment Request Detail | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Shipment Result | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Stock Detail | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | Stock Location Detail | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | W/H stock | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | W/H stock Detail | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_COLUMNS | SSP0029 | WH In Plan Detail | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_MEASURE | SSP0029 | Shipment PSI(Mobility & IT) | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment PSI(Mobility & IT), Shipment PSI(Packer), Shipment Confirm Detail, Shipment Request Detail, W/H stock, W/H stock Detail, Hold stock, Hold stock Detail, Stock Detail, SCS Stock Detail, Stock Location Detail, WH In Plan Detail, Shipment Result
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:658, SetSheetHeaderColumn@InitSpread:685, SetSheetHeaderColumn@InitSpread:710, SetSheetHeaderColumn@InitSpread:725, SetSheetHeaderColumn@InitSpread:752, SetSheetHeaderColumn@InitSpread:765, SetSheetHeaderColumn@InitSpread:778, SetSheetHeaderColumn@InitSpread:791, SetSheetHeaderColumn@InitSpread:804, SetSheetHeaderColumn@InitSpread:817
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment PSI(Mobility & IT) | 675 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?MergePolicy.Always} |  | if(spdInfo.SheetName == "Shipment PSI(Mobility & IT)") |
| InitSpread | Shipment PSI(Mobility & IT) | 677 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?MergePolicy.Always} |  | if(spdInfo.SheetName == "Shipment PSI(Mobility & IT)") |
| InitSpread | Shipment PSI(Packer) | 702 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?MergePolicy.Always} |  | else!(spdInfo.SheetName == "Shipment PSI(Mobility & IT)") ⟫ if(spdInfo.SheetName == "Shipment PSI(Packer)") |
| InitSpread | Shipment PSI(Packer) | 704 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?MergePolicy.Always} |  | else!(spdInfo.SheetName == "Shipment PSI(Mobility & IT)") ⟫ if(spdInfo.SheetName == "Shipment PSI(Packer)") |
| InitSpreadDateColumn |  | 1009 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 1013 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 1017 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1949 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1954 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1961 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1965 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1970 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1977 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1981 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| FindData_Detail |  | 3012 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3013 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3014 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3015 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3150 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3151 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3152 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail |  | 3153 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_Packer_btnSearch |  | 3285 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_Packer_btnSearch |  | 3286 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_Packer_btnSearch |  | 3287 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_btnSearch |  | 3552 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_btnSearch |  | 3553 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_btnSearch |  | 3554 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Detail_btnSearch |  | 3555 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_ShipmentResult_btnSearch |  | 4785 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SHIP_TO |  |
| FindData_ShipmentResult_btnSearch |  | 4786 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SHIPTO_DESCRIPTION |  |
| SpdDetail_CellClick |  | 8186 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) |
| SpdDetail_CellClick |  | 8221 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdDetail_CellClick |  | 8225 | 표시/라벨 변경 | set:Value | Value = {?true} |  | else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SetSoNoColumnVisible |  | 9346 | 표시/라벨 변경 | set:Width | Width = 80 |  | if(ichkbtn == 1) ⟫ if(sSheetName == "Shipment PSI(Packer)") |
| SetSoNoColumnVisible |  | 9350 | 표시/라벨 변경 | set:Width | Width = 0 |  | if(ichkbtn == 1) ⟫ else!(sSheetName == "Shipment PSI(Packer)") |
| SetSoNoColumnVisible |  | 9357 | 표시/라벨 변경 | set:Width | Width = 0 |  | else!(ichkbtn == 1) ⟫ if(sSheetName == "Shipment PSI(Packer)") |
| SetSoNoColumnVisible |  | 9361 | 표시/라벨 변경 | set:Width | Width = 80 |  | else!(ichkbtn == 1) ⟫ else!(sSheetName == "Shipment PSI(Packer)") |
| InitializeComponent |  | 936 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 937 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 938 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 939 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1010 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1011 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1012 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1013 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hold stock | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Hold stock Detail | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| SCS Stock Detail | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| Shipment Confirm Detail | META+코드연결 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 | 38 |
| Shipment PSI(Mobility & IT) | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Shipment PSI(Packer) | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Shipment Request Detail | META+코드연결 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 |
| Shipment Result | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| Stock Detail | META+코드연결 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |
| Stock Location Detail | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |
| W/H stock | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| W/H stock Detail | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| WH In Plan Detail | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

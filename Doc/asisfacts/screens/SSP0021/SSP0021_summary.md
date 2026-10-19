# SSP0021 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.UIL.csproj | 6583 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.UIL.csproj | 1566 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0021_ShipmentPlan.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 6577 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0021_ShipmentPlan.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1564 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged | 5916 | SSP.SSP0021_GET_SHIPMENT_FROM_SITE | NOT_IN_FOXQUERY |  |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:EditButton | EditButton > GetSSPUserCheck | 5850 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| button:FindButton | FindButton > FindData_Main | 4598 | SSP.SSP0021_GET_SHIPMENT_PLAN | MATCH | SP SSP0021_GET_SHIPMENT_PLAN |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail | 2664 | SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail | 2822 | SSP.SSP0021_SAVE_HOLD_STOCK_DATA | MATCH | SP SSP0021_SAVE_HOLD_STOCK_DATA |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3352 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3393 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > NonSoNo | 3521 | SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo | 3742 | SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetErpSoNoCnt | 3843 | SSP.SSP0021_GET_ERP_SO_NO_CNT | MATCH | SP SSP0021_GET_ERP_SO_NO_CNT |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetShipmentStatusChk | 3868 | SSP.SSP0021_GET_SHIPMENT_STATUS | MATCH | SP SSP0021_GET_SHIPMENT_STATUS |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4019 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4045 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4075 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 4598 | SSP.SSP0021_GET_SHIPMENT_PLAN | MATCH | SP SSP0021_GET_SHIPMENT_PLAN |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 4877 | SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0021_GET_SHIPMENT_PLAN_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_hold_stock | 5283 | SSP.SSP0021_GET_HOLD_STOCK | MATCH | SP SSP0021_GET_HOLD_STOCK |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_hold_stock > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > ChkConfirmChangeTime | 6561 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | MATCH | SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail | 4877 | SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0021_GET_SHIPMENT_PLAN_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Stock_Detail | 4990 | SSP.SSP0021_GET_STOCK_LOCATION_DETAIL | MATCH | SP SSP0021_GET_STOCK_LOCATION_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_oWMS_Detail | 5087 | SSP.SSP0021_GET_OWMS_DETAIL | MATCH | SP SSP0021_GET_OWMS_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Result | 5180 | SSP.SSP0021_GET_SHIPMENT_RESULT | MATCH | SP SSP0021_GET_SHIPMENT_RESULT |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_MES_stock | 5382 | SSP.SSP0021_GET_MES_STOCK | MATCH | SP SSP0021_GET_MES_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_MES_stock_Detail | 5482 | SSP.SSP0021_GET_MES_STOCK_DETAIL | MATCH | SP SSP0021_GET_MES_STOCK_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Result > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 493 | SSP.SSP0021_GET_SHIPMENT_DIVISION | MATCH | SP SSP0021_GET_SHIPMENT_DIVISION |
| event:this.Load | Form_Load > InitControls > GetBucketType | 4513 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 4877 | SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0021_GET_SHIPMENT_PLAN_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Stock_Detail | 4990 | SSP.SSP0021_GET_STOCK_LOCATION_DETAIL | MATCH | SP SSP0021_GET_STOCK_LOCATION_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_oWMS_Detail | 5087 | SSP.SSP0021_GET_OWMS_DETAIL | MATCH | SP SSP0021_GET_OWMS_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_hold_stock | 5283 | SSP.SSP0021_GET_HOLD_STOCK | MATCH | SP SSP0021_GET_HOLD_STOCK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_MES_stock | 5382 | SSP.SSP0021_GET_MES_STOCK | MATCH | SP SSP0021_GET_MES_STOCK |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_MES_stock_Detail | 5482 | SSP.SSP0021_GET_MES_STOCK_DETAIL | MATCH | SP SSP0021_GET_MES_STOCK_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_MES_stock > InitSpread > GetSpdTitle | 6063 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | GetErpIFCheck | 3941 | SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | NewNonSoNo | 4290 | SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | GetErpIFCheckNew_ | 4404 | SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | 2 | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | 1 | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | EXEC:SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | MATCH | 1 | SP SCM_SSP_CHECK_CONFIRM_CHANGETIME | EXEC:SCM_SSP_CHECK_CONFIRM_CHANGETIME, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | 2 | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | EXEC:SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, CREATE:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, DELETE:SSP_ANL_SHIP_CONFIRM, INSERT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0002_GET_USER_INFO_LIST | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 2 | SP SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0021_GET_ERP_SO_NO_CNT | MATCH | 1 | SP SSP0021_GET_ERP_SO_NO_CNT | EXEC:SSP0021_GET_ERP_SO_NO_CNT, SELECT:SSP_ANL_SHIP_CONFIRM |  |
| SSP.SSP0021_GET_HOLD_STOCK | MATCH | 1 | SP SSP0021_GET_HOLD_STOCK | EXEC:SSP0021_GET_HOLD_STOCK, REF:FN_GET_IN_STR, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, REF:FN_CHAR_TO_DATE, SELECT:SSP_ANL_HOLD_STOCK, SELECT:TB_FX_USER, SELECT:SSP_MST_MODEL_USER, REF:STRING_SPLIT, REF:FN_SCM_SPLIT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0021_GET_MES_STOCK | MATCH | 1 | SP SSP0021_GET_MES_STOCK | EXEC:SSP0021_GET_MES_STOCK, REF:FN_GET_IN_STR, SELECT:SSP_DNM_GMES_STOCK_81_82, REF:STRING_SPLIT, REF:FN_SCM_SPLIT |  |
| SSP.SSP0021_GET_MES_STOCK_DETAIL | MATCH | 1 | SP SSP0021_GET_MES_STOCK_DETAIL | EXEC:SSP0021_GET_MES_STOCK_DETAIL, REF:FN_GET_IN_STR, SELECT:SSP_DNM_GMES_STOCK_81_82, REF:STRING_SPLIT, REF:FN_SCM_SPLIT |  |
| SSP.SSP0021_GET_OWMS_DETAIL | MATCH | 1 | SP SSP0021_GET_OWMS_DETAIL | EXEC:SSP0021_GET_OWMS_DETAIL, REF:FN_GET_IN_STR, REF:FN_GET_ITEM_NICKNAME, SELECT:SSP_ANL_OWMS_STOCK_C2, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SLOC, SELECT:SSP_MST_MODEL_USER, REF:STRING_SPLIT, REF:FN_SCM_SPLIT, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0021_GET_SHIPMENT_DIVISION | MATCH | 1 | SP SSP0021_GET_SHIPMENT_DIVISION | EXEC:SSP0021_GET_SHIPMENT_DIVISION, REF:FN_GET_LOOKUP_VALUE, INSERT:#RETURNTABLE, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE, SELECT:#RETURNTABLE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0021_GET_SHIPMENT_FROM_SITE | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SSP.SSP0021_GET_SHIPMENT_PLAN | MATCH | 1 | SP SSP0021_GET_SHIPMENT_PLAN | EXEC:SSP0021_GET_SHIPMENT_PLAN, SELECT:SCM_MST_TITLESET_USER, INSERT:#TBLDYNAMICTITLEST_SSP0021, CREATE:#TMP_RESULT_TABLE, INSERT:#TMP_BOHDATA_STORAGE, SELECT:SSP_DNM_GMES_STOCK_81_82, REF:STRING_SPLIT, SELECT:SSP_ANL_OWMS_STOCK_C2, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:MST_STOCK, SELECT:MST_LOCATION, SELECT:PACKER_STOCK, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, SELECT:SSP_DNM_STOCK_C, SELECT:SSP_DNM_ESS_PACKER_STOCK_V, SELECT:SSP_MST_LOCATION_V, INSERT:#TMP_BOHDATA, SELECT:#TMP_BOHDATA_STORAGE, INSERT:#TMP_ROWDATA, REF:FN_GET_ANL_SHIP_FROZEN_DAY_CNT, SELECT:DM_PLN_SHIPMENT_REQ, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_DNM_FP_PLAN_FROZEN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_PLAN_VERSION_V, REF:FN_GET_SSP_ETA_DATE, REF:UF_FX_STRING_SPLIT, SELECT:SSP_DNM_FP_AMEND_SHIPAVAL, INSERT:#TMP_RESULT_TABLE, SELECT:#TMP_ROWDATA, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TMP_BOHDATA, SELECT:#TMP_RESULT_TABLE, SELECT:SCM_DNM_CELL_INHOUSE_PLAN_SN, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, UPDATE:C, MERGE:#TMP_RESULT_TABLE, REF:FN_LIST_LOOKUP_VALUE, INSERT:#TMP_RESULT_PIVOT_TABLE, DYNAMIC@SSP0021_GET_SHIPMENT_PLAN, INSERT:#TMP_RESULT_PIVOT_TABLE_OLD, SELECT:SSP_ANL_SHIP_PLAN_C, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL | MATCH | 1 | SP SSP0021_GET_SHIPMENT_PLAN_DETAIL | EXEC:SSP0021_GET_SHIPMENT_PLAN_DETAIL, REF:FN_GET_IN_STR, DYNAMIC@SSP0021_GET_SHIPMENT_PLAN_DETAIL, REF:FN_SCM_SPLIT |  |
| SSP.SSP0021_GET_SHIPMENT_RESULT | MATCH | 1 | SP SSP0021_GET_SHIPMENT_RESULT | EXEC:SSP0021_GET_SHIPMENT_RESULT, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_CHILD_QTY, SELECT:RESULT_ERP_C_NON, SELECT:PLAN_SSP, SELECT:RESULT_OWMS, SELECT:RETURN_OWMS, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_ITEM_CLASS_M_SN, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_ANL_SHIP_PLAN_ALL, SELECT:SSP_DNM_SHIP_RESULT_OWMS, SELECT:SSP_DNM_SHIP_RETURN_OWMS |  |
| SSP.SSP0021_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0021_GET_SHIPMENT_STATUS | EXEC:SSP0021_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |
| SSP.SSP0021_GET_STOCK_LOCATION_DETAIL | MATCH | 1 | SP SSP0021_GET_STOCK_LOCATION_DETAIL | EXEC:SSP0021_GET_STOCK_LOCATION_DETAIL, REF:FN_GET_IN_STR, SELECT:SSP_MST_LOCATION_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_SLOC, SELECT:SSP_DNM_STOCK_C, SELECT:SSP_DNM_ESS_PACKER_STOCK_V, REF:FN_SCM_SPLIT, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0021_SAVE_HOLD_STOCK_DATA | MATCH | 1 | SP SSP0021_SAVE_HOLD_STOCK_DATA | EXEC:SSP0021_SAVE_HOLD_STOCK_DATA | ⚠ DB에 SP 없음 |
| SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | 1 | SP SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC:SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, REF:FN_GET_SSP_ETA_DATE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, SELECT:SSP_MST_SEND_MAIL_REQ, INSERT:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_MST, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, INSERT:SSP_ANL_SHIP_CONFIRM, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_MST_SITE_ITEM_EE_V, INSERT:SSP_ANL_SHIP_CONFIRM_H, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, EXEC:PR_DM_SSP_CONFIRM_SYNC, SELECT:TB_FX_USER, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_PLN_FP_SHIP_TARGET_WA, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_SCS_PACK_SHIP_PLAN_S_SN, REF:FN_ZERO_LPAD, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SCM_MST_PROJECT, INSERT:#TBLSSPADJUSTMAILSEND, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, REF:FN_GET_USER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_MST_MODEL_USER_EE, SELECT:#TBLSSPADJUSTMAILSEND, UPDATE:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_SUB, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, REF:FN_WEEKOFDAY_DATE, REF:FN_GET_SSP_SITE_INFO, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, CREATE:#T_CONFIRM_ID, CREATE:#T_SSP, CREATE:#T_SSP_SUM, CREATE:#T_MKT_RESULT |  |
| SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 3 | SP SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| cboPlanDate_SelectedIndexChanged | row | CODE |
| cboPlanDate_SelectedIndexChanged | dr | FROM_DATE, TO_DATE |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| clbCompanyID_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_ID_SelectedIndexChanged | c | DIVISION_ID |
| clbDivision_ID_SelectedIndexChanged | dtDiv_Company_ID.Rows[0] | NAME |
| GetErpSoNoCnt | ds.Tables[0].Rows[0] | CNT |
| GetShipmentStatusChk | ds.Tables[0].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[1].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[2].Rows[iRow] | CONFIRM_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE, NAME |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| InitSpread | siDetail.ActiveSheet.Columns | CHILD_QTY |
| Plan_Current_Check | Tmp_dtPlanDate.Rows[0] | CODE, NAME, FROM_DATE, TO_DATE |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | c | DIVISION_ID |
| SetChangedControl | dtMyCompany.Rows[0] | NAME |
| Simulation | row | DIVISION_ID, FROM_SITE, ITEM_ID |
| Simulation | dr | Container_Qty |
| SpdDetail_ClipboardPasted | c | CODE |
| Validation_Check | row | confirm_id |
| Validation_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |
| Validation_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:345, SetChangeControl:350, SetChangeControl:355, SetChangeControl:360, SetChangeControl:365, SetChangeControl:370, SetChangeControl:375, SetChangeControl:380 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:408, InitControls:419 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:508, InitSpread:724, SaveData_Detail:2530, SaveData_Detail:2784, FindData_Main:4563, FindData_Main:4564, FindData_Main:4569, FindData_Main:4571 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:604, cboPlanDate_SelectedIndexChanged:5981 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:610, InitSpread:634, InitSpread:647, InitSpread:658, InitSpread:698, InitSpread:708, InitSpread:718 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:617, cboPlanDate_SelectedIndexChanged:5983 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:295 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:912 |
| this.spdDetail | TopChange | SpdDetail_TopChange | InitEvent:913 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:915 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:916 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:917 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:918 |
| this.btnItemID2 | Click | BtnItemID2_Click | InitEvent:919 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:920 |
| this.btnRequestor | Click | BtnRequestor_Click | InitEvent:921 |
| this.btnSimulation | Click | BtnSimulation_Click | InitEvent:922 |
| this.spdDetail | SheetTabClick | SpdDetail_SheetTabClick | InitEvent:924 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:925 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:926 |
| this.spdDetail | ComboSelChange | SpdDetail_ComboSelChange | InitEvent:927 |
| this.spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:928 |
| this.spdDetail | EditChange | SpdDetail_EditChange | InitEvent:929 |
| this.spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:930 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:932 |
| this.spdMain | Change | SpdMain_Change | InitEvent:933 |
| this.drpPeriod2 | ValueChanged | DrpPeriod2_ValueChanged | InitEvent:935 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:937 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:939 |
| clbCompany_ID | SelectedIndexChanged | clbCompanyID_SelectedIndexChanged | InitEvent:940 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | InitEvent:941 |
| dsdm | Changed | shtDetail_Change | InitEvent:944 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:5933 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:5937 |

## 6. 컨트롤 (58개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 21 | layoutControlItem7, layoutControlItem10, layoutControlItem8, lblCombo1, layoutControlItem2, lblItemId, layoutControlItem1, layoutControlItem6, PlanDate, layoutControlItem12, lblBucket, lblSql, layoutControlItem11, Requestor, layoutControlItem9 … |
| UsrButton | 6 | usrButton1, btnSimulation, btnMeasure, btnItemId, btnRequestor, btnItemID2 |
| UsrCombo | 4 | clbCompany_ID, clbDivision_ID, cboPlanDate, cboBucketType |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem2, emptySpaceItem5 |
| UsrDateRangePicker | 3 | drpPeriod, drpPeriod2, drpPeriod3 |
| UsrMultiLineEditor | 3 | txtItemId, txtModel2, txtBoxID |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| UsrCheckBox | 2 | chkSql, chkSum |
| UsrCheckedList | 2 | clbPlantSite, clbResultType |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| SplitContainer | 1 | splitContainer1 |
| UsrTextBox | 1 | txtRequestor |
| SimpleButton | 1 | btnSearch |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 5916 | clbCompanyID_SelectedIndexChanged | SSP.SSP0021_GET_SHIPMENT_FROM_SITE | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, SELECT:TB_FX_USERGROUPAUTHEXTENTION · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 459 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 191 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 9 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 58 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 133 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 556 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 320 | SSP.SSP0046_GET_BUCKET_TYPE_CODE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0021 | Hold stock | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | Hold stock Detail | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | MES Stock | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | MES Stock Detail | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | oWMS Detail | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | Shipment Plan | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | Shipment Plan Detail | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 | 42/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | Shipment Result | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |
| SCM_MST_SHEET_COLUMNS | SSP0021 | Stock Location Detail | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_MEASURE | SSP0021 | Shipment Plan | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan, Shipment Plan Detail, Stock Location Detail, oWMS Detail, MES Stock, MES Stock Detail, Shipment Result
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:610, SetSheetHeaderColumn@InitSpread:634, SetSheetHeaderColumn@InitSpread:647, SetSheetHeaderColumn@InitSpread:658, SetSheetHeaderColumn@InitSpread:698, SetSheetHeaderColumn@InitSpread:708, SetSheetHeaderColumn@InitSpread:718
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment Plan | 627 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?MergePolicy.Always} |  | if(spdInfo.SheetName == "Shipment Plan") |
| InitSpread | Shipment Plan | 727 | 표시/라벨 변경 | set:Width | Width = 75 | CHILD_QTY | else!(spdInfo.SheetName == "Shipment Plan") ⟫ else!(spdInfo.SheetName == "Shipment Plan Detail") ⟫ else!(spdInfo.SheetName == "Stock Location Detail") ⟫ else!(spdInfo.SheetName == "oWMS Detail") ⟫ else!(spdInfo.SheetName == "MES Stock") ⟫ else!(spdInfo.SheetName == "MES Stock Detail") ⟫ if(spdInfo.SheetName == "Shipment Result") ⟫ if(p_division_id.ToString().Trim() == "82") |
| InitSpreadDateColumn |  | 862 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 866 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 870 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SpdDetail_CellClick |  | 1802 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) |
| SpdDetail_CellClick |  | 1837 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdDetail_CellClick |  | 1841 | 표시/라벨 변경 | set:Value | Value = {?true} |  | else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SetSpreadColumn |  | 4469 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4474 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4481 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 4485 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4490 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 4497 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4501 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 858 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 859 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 860 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 861 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 930 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 931 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 932 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 933 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hold stock | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Hold stock Detail | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| MES Stock | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| MES Stock Detail | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| oWMS Detail | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| Shipment Plan | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Shipment Plan Detail | META+코드연결 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 |
| Shipment Result | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| Stock Location Detail | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

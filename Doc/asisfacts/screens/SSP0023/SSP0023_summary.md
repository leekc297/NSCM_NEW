# SSP0023 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.UIL.csproj | 6823 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.UIL.csproj | 2382 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0023_ShipmentPlanElectrode.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 6730 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0023_ShipmentPlanElectrode.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2382 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| button:EditButton | EditButton > GetSSPUserCheck | 6805 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| button:FindButton | FindButton > FindData_Main | 4732 | SSP.SSP0023_GET_SHIPMENT_PLAN | MATCH | SP SSP0023_GET_SHIPMENT_PLAN |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail | 2435 | SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail | 2643 | SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3278 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3319 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetShipmentStatusChk | 3459 | SSP.SSP0023_GET_SHIPMENT_STATUS | MATCH | SP SSP0023_GET_SHIPMENT_STATUS |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetErpSoNoCnt | 3524 | SSP.SSP0023_GET_ERP_SO_NO_CNT | MATCH | SP SSP0023_GET_ERP_SO_NO_CNT |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > NonSoNo | 3846 | SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo | 4081 | SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4329 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4355 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4385 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 4732 | SSP.SSP0023_GET_SHIPMENT_PLAN | MATCH | SP SSP0023_GET_SHIPMENT_PLAN |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 5357 | SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > ChkConfirmChangeTime | 6779 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | MATCH | SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main | 4732 | SSP.SSP0023_GET_SHIPMENT_PLAN | MATCH | SP SSP0023_GET_SHIPMENT_PLAN |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Detail | 5357 | SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail | 5357 | SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Stock_Detail | 5468 | SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentResult | 5585 | SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_RESULT |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentResult > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSimulation.Click | BtnSimulation_Click > Simulation > FindData_Main | 4732 | SSP.SSP0023_GET_SHIPMENT_PLAN | MATCH | SP SSP0023_GET_SHIPMENT_PLAN |
| event:this.btnSimulation.Click | BtnSimulation_Click > Simulation > FindData_Detail | 5357 | SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL |
| event:this.btnSimulation.Click | BtnSimulation_Click > Simulation > FindData_Detail > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSimulation.Click | BtnSimulation_Click > Simulation | 6027 | SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU | MATCH | SP SSP0023_SAVE_SHIPMENT_PLAN_SIMU |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Plan_Detail_DownLoad > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Plan_Detail_DownLoad | 6505 | SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL |
| event:this.Load | Form_Load > InitControls > GetBucketType | 4656 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 5357 | SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail > InitSpread > GetSpdTitle | 5921 | SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0023_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | NewNonSoNo | 3645 | SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | GetErpIFCheckNew_ | 4195 | SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | GetErpIFCheck | 4251 | SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | 2 | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | 1 | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | EXEC:SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | MATCH | 1 | SP SCM_SSP_CHECK_CONFIRM_CHANGETIME | EXEC:SCM_SSP_CHECK_CONFIRM_CHANGETIME, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | 2 | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | EXEC:SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, CREATE:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, DELETE:SSP_ANL_SHIP_CONFIRM, INSERT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0002_GET_USER_INFO_LIST | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 2 | SP SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0023_GET_ERP_SO_NO_CNT | MATCH | 1 | SP SSP0023_GET_ERP_SO_NO_CNT | EXEC:SSP0023_GET_ERP_SO_NO_CNT, SELECT:SSP_ANL_SHIP_CONFIRM |  |
| SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SSP0023_GET_SHEET_CALENDAR_3SPAN | EXEC:SSP0023_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0023_GET_SHIPMENT_PLAN | MATCH | 1 | SP SSP0023_GET_SHIPMENT_PLAN | EXEC:SSP0023_GET_SHIPMENT_PLAN, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TBLDYNAMICTITLEST_SSP0023, INSERT:#TMP_SSP0023_BOH_CUTOFF_EE, SELECT:SSP_ANL_BOH_CUTOFF_EE, REF:STRING_SPLIT, INSERT:#TMP_PLAN_ITEM_CUTOFF, SELECT:SSP_ANL_SHIP_PLAN_EE, SELECT:SSP_MST_MODEL_USER, SELECT:SSP_MST_DELEGATE, INSERT:#TMP_SSP0023_ROWDATA, SELECT:#TMP_PLAN_ITEM_CUTOFF, SELECT:SSP_ANL_SHIP_REQ_EE, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SSP_DNM_FP_MRP_INTRANSIT_SN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, SELECT:SSP_ANL_SHIP_CONFIRM, REF:FN_GET_ANL_SHIP_FROZEN_DAY_CNT, SELECT:SSP_DNM_SHIP_RESULT_OWMS_V, INSERT:#TMP_SSP0023_SIM, SELECT:#TMP_SSP0023_ROWDATA, SELECT:#TMP_SSP0023_BOH_CUTOFF_EE, SELECT:#TMP_SSP0023_SIM, INSERT:#TMP_SSP0023_CONFIRM, SELECT:#TMP_SSP0023_CONFIRM, INSERT:#TMP_SSP0023_RESULT_TABLE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TMP_SSP0023_RESULT_PIVOT_TABLE, SELECT:#TMP_SSP0023_RESULT_TABLE, DYNAMIC@SSP0023_GET_SHIPMENT_PLAN, INSERT:#TMP_SSP0023_ROWDATA_OLD, INSERT:#TMP_SSP0023_RESULT_TABLE_OLD, SELECT:#TMP_SSP0023_ROWDATA_OLD, INSERT:#TMP_SSP0023_RESULT_PIVOT_TABLE_OLD, SELECT:#TMP_SSP0023_RESULT_TABLE_OLD |  |
| SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL | MATCH | 1 | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL | EXEC:SSP0023_GET_SHIPMENT_PLAN_DETAIL, REF:FN_GET_IN_STR, DYNAMIC@SSP0023_GET_SHIPMENT_PLAN_DETAIL, REF:FN_SCM_SPLIT |  |
| SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL | MATCH | 1 | SP SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL | EXEC:SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL, REF:FN_GET_IN_STR, SELECT:SSP_MST_SHIP_CALENDAR, SELECT:SSP_ANL_SHIP_PLAN_EE, REF:STRING_SPLIT, REF:FN_SCM_SPLIT |  |
| SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT | MATCH | 1 | SP SSP0023_GET_SHIPMENT_PLAN_RESULT | EXEC:SSP0023_GET_SHIPMENT_PLAN_RESULT, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:PLAN_SSP, SELECT:RESULT_OWMS, SELECT:RETURN_OWMS, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, SELECT:SSP_MST_SITE_ITEM_EE_V, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_DNM_SHIP_RESULT_OWMS, SELECT:SSP_DNM_SHIP_RETURN_OWMS, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL | MATCH | 1 | SP SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL | EXEC:SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL, DYNAMIC@SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL |  |
| SSP.SSP0023_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0023_GET_SHIPMENT_STATUS | EXEC:SSP0023_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |
| SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU | MATCH | 1 | SP SSP0023_SAVE_SHIPMENT_PLAN_SIMU | EXEC:SSP0023_SAVE_SHIPMENT_PLAN_SIMU, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:SP_EXECUTESQL, INSERT:SSP_ANL_SHIP_PLAN_SIMU_EE, SELECT:SSP_ANL_SHIP_PLAN_EE, MERGE:SSP_ANL_SHIP_PLAN_EE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | 2 | SP SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC:SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, REF:FN_GET_SSP_ETA_DATE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, SELECT:SSP_MST_SEND_MAIL_REQ, INSERT:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_MST, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, INSERT:SSP_ANL_SHIP_CONFIRM, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, INSERT:SSP_ANL_SHIP_CONFIRM_H, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, SELECT:TB_FX_USER, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_DM_SSP_CONFIRM_SYNC, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:#TBLSSPADJUSTMAILSEND, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, REF:FN_GET_USER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_MST_MODEL_USER_EE, SELECT:#TBLSSPADJUSTMAILSEND, UPDATE:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_SUB, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, REF:FN_WEEKOFDAY_DATE, REF:FN_GET_SSP_SITE_INFO, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, CREATE:#T_CONFIRM_ID, CREATE:#T_SSP, CREATE:#T_SSP_SUM, CREATE:#T_MKT_RESULT, CREATE:#T_MKT_RESULT_SUM, CREATE:#TEMP_SALES_RESULT, INSERT:#T_CONFIRM_ID, DELETE:A, SELECT:DM_PLN_MKT_FCST_CONFIRM, SELECT:#T_CONFIRM_ID, INSERT:DM_PLN_MKT_FCST_CONFIRM |  |
| SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 3 | SP SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_MST_SITE_ITEM_EE_V, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboPlanDate_SelectedIndexChanged | row | CODE |
| cboPlanDate_SelectedIndexChanged | dr | CODE, FROM_DATE, TO_DATE |
| ChangeData_Check | row | confirm_id |
| ChangeData_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type |
| ChangeNotSendERP_Check | row | confirm_id |
| ChangeNotSendERP_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type |
| ChangeNotSendERP_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| clbDivision_ID_SelectedIndexChanged | c | DIVISION_ID |
| DefineProperty | drAllRow | CODE, NAME |
| GetErpSoNoCnt | ds.Tables[0].Rows[0] | CNT |
| GetShipmentStatusChk | ds.Tables[0].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[1].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[2].Rows[iRow] | CONFIRM_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE, NAME |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| InitControls | dtCompany.Rows[0] | CODE |
| InitSpread | drRow | CODE, NAME |
| InitSpread | dr | NAME, CODE |
| InitSpread | drAllRow | CODE, NAME |
| Plan_Current_Check | Tmp_dtPlanDate.Rows[0] | CODE, NAME, FROM_DATE, TO_DATE |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | c | CODE, DIVISION_ID |
| SetChangedControl | dtMyCompany.Rows[0] | NAME |
| SpdDetail_CellClick | drRow | CODE, NAME |
| SpdDetail_CellClick | dr | NAME, CODE |
| SpdDetail_CellClick | drAllRow | CODE, NAME |
| SpdDetail_ClipboardPasted | c | CODE |
| spdMain_ClipboardPasted | row | DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID |
| Validation_Check | row | confirm_id |
| Validation_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type, dom_exp |
| Validation_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:348, SetChangeControl:353, SetChangeControl:358, SetChangeControl:363, SetChangeControl:368, SetChangeControl:373, SetChangeControl:378, SetChangeControl:383 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:429, InitControls:445 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:531, SpdDetail_CellClick:1691, EditButton:2138, SaveData_Detail:2337, FindData_Main:4683, FindData_Main:4684, FindData_Main:4685, FindData_Main:4686 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:580, cboPlanDate_SelectedIndexChanged:5825 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:585, InitSpread:636, InitSpread:674, InitSpread:684, InitSpread:695 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:589 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.formDown | Click | btnExcelFormDownload_Click | InitializeComponent:299 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:339 |
| this | Load | Form_Load | .ctor:310 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:786 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:787 |
| this.rdButton1 | CheckedChanged | rdButton_Changed | InitEvent:788 |
| this.rdButton2 | CheckedChanged | rdButton_Changed | InitEvent:789 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:790 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:792 |
| this.spdMain | Change | SpdMain_Change | InitEvent:793 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitEvent:794 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:796 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:797 |
| this.btnItemId2 | Click | BtnMaterialId2_Click | InitEvent:798 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:799 |
| this.btnRequestor | Click | BtnRequestor_Click | InitEvent:800 |
| this.btnSimulation | Click | BtnSimulation_Click | InitEvent:801 |
| this.spdDetail | SheetTabClick | SpdDetail_SheetTabClick | InitEvent:803 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:804 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:805 |
| this.spdDetail | ComboSelChange | SpdDetail_ComboSelChange | InitEvent:806 |
| this.spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:807 |
| this.spdDetail | EditChange | SpdDetail_EditChange | InitEvent:808 |
| this.spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:809 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:811 |
| clbCompany_ID | SelectedIndexChanged | clbCompanyID_SelectedIndexChanged | InitEvent:812 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | InitEvent:813 |
| this.chkPastPeriod | CheckedChanged | chkPastPeriod_CheckedChanged | InitEvent:815 |
| dsdm | Changed | shtPlanDetail_Change | InitEvent:818 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:5776 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:5780 |

## 6. 컨트롤 (88개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 35 | layoutControlItem7, layoutControlItem10, layoutControlItem8, lblCombo1, lblItemId, layoutControlItem1, layoutControlItem6, PlanDate, lblBucket, layoutControlItem15, layoutControlItem16, layoutControlItem19, lblUOMType, layoutControlItem2, layoutControlItem18 … |
| UsrButton | 8 | usrButton1, formDown, btnExcelUpload, btnSimulation, btnMeasure, btnItemId, btnRequestor, btnItemId2 |
| UsrMultiLineEditor | 7 | textNickName, txtModelId, txtItemId, txtNickName2, txtItemId2, txtModel2, txtLotID |
| UsrCheckBox | 6 | chkDelegateeModel, chkTeamLeader, chkPartLeader, chkMyModel, chkPastPeriod, chkSum |
| UsrCombo | 4 | clbCompany_ID, clbDivision_ID, cboPlanDate, cboBucketType |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem4, emptySpaceItem1, emptySpaceItem5 |
| UsrRadio | 3 | rdButton3, rdButton1, rdButton2 |
| UsrDateRangePicker | 3 | drpPeriod, drpPeriod3, drpPeriod2 |
| FpSpread | 3 | spdMain, spdDetail, spdSub |
| SheetView | 3 | spdMain_Sheet1, spdDetail_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| UsrCheckedList | 2 | clbFromSite, clbResultType |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLabel | 1 | usrLabel1 |
| SplitContainer | 1 | splitContainer1 |
| UsrTextBox | 1 | txtRequestor |
| SimpleButton | 1 | btnSearch |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 302 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 3 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 148 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 11 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 22 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 378 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0023 | Shipment Plan Detail | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 |
| SCM_MST_SHEET_COLUMNS | SSP0023 | Shipment Plan Detail Excel | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_COLUMNS | SSP0023 | Shipment Plan(Electrode) | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | SSP0023 | Shipment Result | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |
| SCM_MST_SHEET_COLUMNS | SSP0023 | Stock Detail | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |
| SCM_MST_SHEET_MEASURE | SSP0023 | Shipment Plan(Electrode) | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan(Electrode), Shipment Plan Detail, Stock Detail, Shipment Result, Shipment Plan Detail Excel
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:585, SetSheetHeaderColumn@InitSpread:636, SetSheetHeaderColumn@InitSpread:674, SetSheetHeaderColumn@InitSpread:684, SetSheetHeaderColumn@InitSpread:695
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment Plan(Electrode) | 597 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 598 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 599 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 600 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 601 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 602 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 603 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 604 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 605 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 609 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 610 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 611 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 612 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 613 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 614 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 615 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 616 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 617 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 621 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 622 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 623 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 624 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 625 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 626 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 627 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 628 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Plan(Electrode) | 629 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(spdInfo.SheetName == "Shipment Plan(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpreadDateColumn |  | 738 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 744 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 747 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SpdDetail_CellClick |  | 1727 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) |
| SpdDetail_CellClick |  | 1755 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdDetail_CellClick |  | 1759 | 표시/라벨 변경 | set:Value | Value = {?true} |  | else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| rdButton_Changed |  | 4420 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4421 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4422 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4423 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4424 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4425 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4426 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4427 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4428 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 4432 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4433 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4434 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4435 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_CELL | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4436 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_CELL | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4437 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_CELL | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4438 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4439 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4440 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 4444 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_PCM | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4445 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_PCM | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4446 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_PCM | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4447 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4448 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4449 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4450 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4451 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 4452 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(rdButton3.Checked == true) |
| SetSpreadColumn |  | 4479 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) |
| SetSpreadColumn |  | 4483 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_") == 0) |
| SetSpreadColumn |  | 4491 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 4496 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 4503 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0) |
| SetSpreadColumn |  | 4507 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 4511 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_M_") == 0) |
| SetSpreadColumn |  | 4518 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 4522 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_M_") == 0) |
| SetSpreadColumn |  | 4530 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) |
| SetSpreadColumn |  | 4534 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 4541 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 4546 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 4553 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0) |
| SetSpreadColumn |  | 4557 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 4562 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_M_") == 0) |
| SetSpreadColumn |  | 4569 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 4573 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_M_") == 0) |
| SetSpreadColumn |  | 4581 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 4585 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) |
| SetSpreadColumn |  | 4593 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 4598 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 4605 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0) |
| SetSpreadColumn |  | 4609 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 4614 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_M_") == 0) |
| SetSpreadColumn |  | 4621 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 4625 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_M_") == 0) |
| SetSpreadColumn |  | 4642 | 표시/라벨 변경 | set:Visible | Visible = {?chkPastPeriod.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(!chkPastPeriod.Checked) ⟫ else!(siMain.ActiveSheet.ColumnHeader.Cells[2, iCol].Value.ToString() == "SUM") ⟫ if(date > colDate) |
| ExportExcel |  | 6668 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcel |  | 6710 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 1483 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1484 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1485 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1486 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1556 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1557 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1558 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1559 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2192 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2193 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2194 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2195 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan Detail | META+코드연결 | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) | 44 (?9) |
| Shipment Plan Detail Excel | META+코드연결 | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) | 9 (?9) |
| Shipment Plan(Electrode) | META+코드연결 | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) | 13 (?9) |
| Shipment Result | META+코드연결 | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) | 20 (?9) |
| Stock Detail | META+코드연결 | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:화면컨트롤값 2268 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 2268건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

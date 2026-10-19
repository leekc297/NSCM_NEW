# SSP0027 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0027_ShipmentPlanEss.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 6007 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0027_ShipmentPlanEss.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1722 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged > GetNERPCode | 5588 | SSP.SSP0002_GET_NERP_CODE | MATCH | SP SSP0002_GET_NERP_CODE |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main | 4549 | SSP.SSP0027_GET_SHIPMENT_PLAN | MATCH | SP SSP0027_GET_SHIPMENT_PLAN |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail | 2465 | SSP.SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail | 2631 | SSP.SSP0027_SAVE_SHIPMENT_REQUEST_ALLO | MATCH | SP SSP0027_SAVE_SHIPMENT_REQUEST_ALLO |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3127 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3168 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetShipmentStatusChk | 3408 | SSP.SSP0027_GET_SHIPMENT_STATUS | MATCH | SP SSP0027_GET_SHIPMENT_STATUS |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetErpSoNoCnt | 3473 | SSP.SSP0027_GET_ERP_SO_NO_CNT | MATCH | SP SSP0027_GET_ERP_SO_NO_CNT |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > NonSoNo | 3800 | SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo | 4035 | SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4283 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4309 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4339 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 4549 | SSP.SSP0027_GET_SHIPMENT_PLAN | MATCH | SP SSP0027_GET_SHIPMENT_PLAN |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 4853 | SSP.SSP0027_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0027_GET_SHIPMENT_PLAN_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_PO_PR_Detail | 5358 | SSP.SSP0027_GET_SHIPMENT_PR_PO_DETAIL | MATCH | SP SSP0027_GET_SHIPMENT_PR_PO_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_PO_PR_Detail > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnConfirm.Click | BtnConfirm_Click > ManualConfirm | 5742 | SSP.PR_SSP_ANL_ESS_SHIP_CONFIRM | MATCH | SP PR_SSP_ANL_ESS_SHIP_CONFIRM |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail | 4853 | SSP.SSP0027_GET_SHIPMENT_PLAN_DETAIL | MATCH | SP SSP0027_GET_SHIPMENT_PLAN_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Monthly | 4968 | SSP.SSP0027_GET_SHIPMENT_BOH_MONTHLY | MATCH | SP SSP0027_GET_SHIPMENT_BOH_MONTHLY |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Daily | 5052 | SSP.SSP0027_GET_SHIPMENT_BOH_DAILY | MATCH | SP SSP0027_GET_SHIPMENT_BOH_DAILY |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Result | 5142 | SSP.SSP0027_GET_SHIPMENT_RESULT | MATCH | SP SSP0027_GET_SHIPMENT_RESULT |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_NET_History | 5248 | SSP.SSP0027_GET_NETTING_HISTORY | MATCH | SP SSP0027_GET_NETTING_HISTORY |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_PO_PR_Detail | 5358 | SSP.SSP0027_GET_SHIPMENT_PR_PO_DETAIL | MATCH | SP SSP0027_GET_SHIPMENT_PR_PO_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Daily > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSimulation.Click | BtnSimulation_Click > Simulation | 5813 | SSP.PR_SSP_ANL_ESS_PLAN_CUTOFF | MATCH | SP PR_SSP_ANL_ESS_PLAN_CUTOFF |
| event:this.Load | Form_Load > InitControls > GetBucketType | 4487 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl > GetNERPCode | 5588 | SSP.SSP0002_GET_NERP_CODE | MATCH | SP SSP0002_GET_NERP_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Shipment_Monthly | 4968 | SSP.SSP0027_GET_SHIPMENT_BOH_MONTHLY | MATCH | SP SSP0027_GET_SHIPMENT_BOH_MONTHLY |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Shipment_Monthly > InitSpread > GetSpdTitle | 5716 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | ERP_PR_REQUEST_SEND | 3362 | SSP.SSP0027_GET_SHIPMENT_REQUEST_DRAFTING | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | NewNonSoNo | 3599 | SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | GetErpIFCheckNew_ | 4149 | SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING |
| unreached:(진입점 미연결) | GetErpIFCheck | 4205 | SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.PR_SSP_ANL_ESS_PLAN_CUTOFF | MATCH | 1 | SP PR_SSP_ANL_ESS_PLAN_CUTOFF | EXEC:PR_SSP_ANL_ESS_PLAN_CUTOFF, REF:FN_GET_LOOKUP_VALUE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:PR_SCP_SYS_LOG_BATCH, DELETE:SSP_ANL_ESS_STOCK, INSERT:SSP_ANL_ESS_STOCK, SELECT:SCM_DNM_STOCK_SN, SELECT:SCM_MST_ITEM_SN, CREATE:#TMP_SSP_ANL_ESS_PLAN, INSERT:#TMP_SSP_ANL_ESS_PLAN, SELECT:DM_PLN_MKT_FCST, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SSP_ANL_ESS_REQ, SELECT:SSP_ANL_ESS_PR, SELECT:SSP_ANL_ESS_PO, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TMP_SSP_ANL_ESS_PLAN, DELETE:SSP_ANL_ESS_PLAN, INSERT:SSP_ANL_ESS_PLAN, UPDATE:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_CODE_LOOKUP_VALUE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.PR_SSP_ANL_ESS_SHIP_CONFIRM | MATCH | 1 | SP PR_SSP_ANL_ESS_SHIP_CONFIRM | EXEC:PR_SSP_ANL_ESS_SHIP_CONFIRM, REF:FN_GET_LOOKUP_VALUE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:PR_SCP_SYS_LOG_BATCH, CREATE:#TMP_SSP_ANL_ESS_CONFIRM, SELECT:SCP_MST_BOD_V, SELECT:DM_PLN_MKT_FCST, REF:FN_MULTY_TIME, INSERT:#TMP_SSP_ANL_ESS_CONFIRM, REF:FN_GET_SSP_ETA_DATE, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_MST_SITE, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, SELECT:SSP_MST_PARTIAL_SEQ, REF:FN_GET_SSP_ANL_SHIP_FROZEN, INSERT:SSP_ANL_SHIP_CONFIRM, SELECT:#TMP_SSP_ANL_ESS_CONFIRM, INSERT:SSP_ANL_SHIP_CONFIRM_H, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:NERP_CONV_MASTER, UPDATE:R, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, EXEC:PR_SSP_MAIL_SEND_BOD_REGISTRATION, SELECT:SYSCURSORS, EXEC:SCM_ADM_SMS_SEND_BATCH, SELECT:SCM_CODE_LOOKUP_VALUE, INSERT:SCM_SYS_LOG_BATCH, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE_CUSTOMER, REF:UF_FX_STRING_SPLIT, MERGE:SSP_ANL_SHIP_CONFIRM_ROUTE, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD, CREATE:#TBLMAILSENDBATCH, REF:FN_SCM_ADM_GET_MAIL_SQL, INSERT:#TBLMAILSENDBATCH, DYNAMIC@PR_SSP_MAIL_SEND_BOD_REGISTRATION, SELECT:#TBLMAILSENDBATCH, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:SCM_ADM_MAIL_SEND, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SELECT:SYSOBJECTS, CREATE:#TBLSMSSENDBATCH, INSERT:#TBLSMSSENDBATCH, DYNAMIC@SCM_ADM_SMS_SEND_BATCH, SELECT:#TBLSMSSENDBATCH, INSERT:XIF_IFS_SMS_DATA_SN, SELECT:CTE_DATE, SELECT:SCM_ADM_RECIPIENT_LIST, EXEC:SP_SEND_DBMAIL, INSERT:SCM_ADM_SMS_MAIL_SEND_LOG |  |
| SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | MATCH | 2 | SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | 1 | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | EXEC:SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | 2 | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | EXEC:SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, CREATE:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, DELETE:SSP_ANL_SHIP_CONFIRM, INSERT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0002_GET_NERP_CODE | MATCH | 1 | SP SSP0002_GET_NERP_CODE | EXEC:SSP0002_GET_NERP_CODE, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 2 | SP SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0027_GET_ERP_SO_NO_CNT | MATCH | 1 | SP SSP0027_GET_ERP_SO_NO_CNT | EXEC:SSP0027_GET_ERP_SO_NO_CNT, SELECT:SSP_ANL_SHIP_CONFIRM |  |
| SSP.SSP0027_GET_NETTING_HISTORY | MATCH | 1 | SP SSP0027_GET_NETTING_HISTORY | EXEC:SSP0027_GET_NETTING_HISTORY, REF:FN_GET_LOOKUP_VALUE, SELECT:SSP_ANL_ESS_REQ_NET, SELECT:SSP_ANL_ESS_REQ, SELECT:SSP_ANL_ESS_STOCK, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0027_GET_SHIPMENT_BOH_DAILY | MATCH | 1 | SP SSP0027_GET_SHIPMENT_BOH_DAILY | EXEC:SSP0027_GET_SHIPMENT_BOH_DAILY, REF:FN_GET_IN_STR, SELECT:SCM_MST_SLOC, SELECT:SCM_DNM_STOCK_V, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, REF:FN_SCM_SPLIT |  |
| SSP.SSP0027_GET_SHIPMENT_BOH_MONTHLY | MATCH | 1 | SP SSP0027_GET_SHIPMENT_BOH_MONTHLY | EXEC:SSP0027_GET_SHIPMENT_BOH_MONTHLY, SELECT:SSP_ANL_ESS_STOCK, REF:STRING_SPLIT, INSERT:#TMP_STOCK_DATA, SELECT:SCM_MST_SLOC, SELECT:SCM_DNM_STOCK_V, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TMP_STOCK_DATA |  |
| SSP.SSP0027_GET_SHIPMENT_PLAN | MATCH | 1 | SP SSP0027_GET_SHIPMENT_PLAN | EXEC:SSP0027_GET_SHIPMENT_PLAN, REF:FN_GET_LOOKUP_VALUE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_TITLESET_USER, INSERT:#TBLDYNAMICTITLEST_SSP0027, CREATE:#TMP_RESULT_TABLE, INSERT:#TMP_BOHDATA_STORAGE, SELECT:MST_STOCK, SELECT:SSP_ANL_ESS_STOCK, REF:STRING_SPLIT, SELECT:SSP_ANL_ESS_PLAN, SELECT:SSP_ANL_ESS_REQ, SELECT:SSP_ANL_ESS_REQ_NET, INSERT:#TMP_ALLO_QTY_TABLE, INSERT:#TMP_ALLO_QTY_TABLE_OLD, INSERT:#TMP_BOHDATA, SELECT:#TMP_BOHDATA_STORAGE, INSERT:#TMP_ROWDATA, SELECT:DM_PLN_MKT_FCST, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SSP_ANL_ESS_PR, SELECT:SSP_ANL_ESS_PO, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, INSERT:#TMP_RESULT_TABLE, SELECT:#TMP_ROWDATA, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TMP_BOHDATA, SELECT:#TMP_RESULT_TABLE, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TMP_ALLO_QTY_TABLE, INSERT:#TMP_RESULT_PIVOT_TABLE, DYNAMIC@SSP0027_GET_SHIPMENT_PLAN, INSERT:#TMP_RESULT_PIVOT_TABLE_OLD, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0027_GET_SHIPMENT_PLAN_DETAIL | MATCH | 1 | SP SSP0027_GET_SHIPMENT_PLAN_DETAIL | EXEC:SSP0027_GET_SHIPMENT_PLAN_DETAIL, REF:FN_GET_LOOKUP_VALUE, REF:FN_GET_IN_STR, DYNAMIC@SSP0027_GET_SHIPMENT_PLAN_DETAIL, SELECT:SCM_CODE_LOOKUP_VALUE, REF:FN_SCM_SPLIT |  |
| SSP.SSP0027_GET_SHIPMENT_PR_PO_DETAIL | MATCH | 1 | SP SSP0027_GET_SHIPMENT_PR_PO_DETAIL | EXEC:SSP0027_GET_SHIPMENT_PR_PO_DETAIL, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER, SELECT:SSP_ANL_ESS_REQ, SELECT:SCM_MST_ITEM_SN, SELECT:SSP_ANL_ESS_PR, SELECT:SSP_ANL_ESS_PO, SELECT:SSP_ANL_ESS_PO_IN, SELECT:SSP_ANL_ESS_REQ_NET, SELECT:DM_PLN_PR_DETAIL, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT |  |
| SSP.SSP0027_GET_SHIPMENT_REQUEST_DRAFTING | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0027_GET_SHIPMENT_RESULT | MATCH | 1 | SP SSP0027_GET_SHIPMENT_RESULT | EXEC:SSP0027_GET_SHIPMENT_RESULT, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:PLAN_SSP, SELECT:RESULT_OWMS, SELECT:RETURN_OWMS, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, SELECT:SSP_MST_DELEGATE, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCP_MST_FINAL_ITEM, REF:FN_LIST_LOOKUP_VALUE, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, REF:FN_GET_SSP_ETD_DATE, REF:FN_GET_SSP_ETA_DATE, SELECT:SSP_ANL_ESS_PLAN, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_DNM_SHIP_RESULT_OWMS, SELECT:SSP_DNM_SHIP_RETURN_OWMS, SELECT:SCM_CODE_LOOKUP_VALUE, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0027_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0027_GET_SHIPMENT_STATUS | EXEC:SSP0027_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |
| SSP.SSP0027_SAVE_SHIPMENT_REQUEST_ALLO | MATCH | 1 | SP SSP0027_SAVE_SHIPMENT_REQUEST_ALLO | EXEC:SSP0027_SAVE_SHIPMENT_REQUEST_ALLO, REF:FN_GET_LOOKUP_VALUE, CREATE:#TMP_SSP_ANL_ESS_REQ_TEMP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_ESS_REQ, INSERT:#TMP_SSP_ANL_ESS_REQ_TEMP, INSERT:#TMP_MST_PR_COUNT, SELECT:MST_PR_COUNT, SELECT:#TMP_SSP_ANL_ESS_REQ_TEMP, SELECT:#TMP_MST_PR_COUNT, INSERT:#TMP_MST_STOCK, SELECT:MST_STOCK, SELECT:SSP_ANL_ESS_STOCK, SELECT:#TMP_MST_STOCK, MERGE:SSP_ANL_ESS_REQ, INSERT:#TMP_SSP_ANL_ESS_REQ, MERGE:SSP_ANL_ESS_PR, SELECT:#TMP_SSP_ANL_ESS_REQ, EXEC:PR_SSP_MAIL_SEND_PR_REQUEST, SELECT:SSP_ANL_ESS_PR, SELECT:XIF_ERP_PR_REQ_S_SN, INSERT:XIF_ERP_PR_REQ_S_SN, REF:FN_ZERO_LPAD, SELECT:NERP_CONV_MASTER, INSERT:SSP_ANL_ESS_REQ_H, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_CODE_LOOKUP_VALUE, SELECT:SYSOBJECTS, CREATE:#TBLMAILSENDBATCH, INSERT:#TBLMAILSENDBATCH, DYNAMIC@PR_SSP_MAIL_SEND_PR_REQUEST, SELECT:#TBLMAILSENDBATCH, SELECT:SCM_MST_SSO_USER_INFO, EXEC:SCM_ADM_MAIL_SEND, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, EXEC:SP_SEND_DBMAIL, INSERT:SCM_ADM_SMS_MAIL_SEND_LOG |  |
| SSP.SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | 1 | SP SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC:SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, REF:FN_GET_SSP_ETA_DATE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, SELECT:SSP_MST_SEND_MAIL_REQ, INSERT:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_MST, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, INSERT:SSP_ANL_SHIP_CONFIRM, INSERT:SSP_ANL_SHIP_CONFIRM_H, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:NERP_CONV_MASTER, EXEC:PR_DM_SSP_CONFIRM_SYNC, SELECT:TB_FX_USER, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:#TBLSSPADJUSTMAILSEND, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, REF:FN_GET_USER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_MST_MODEL_USER_EE, SELECT:#TBLSSPADJUSTMAILSEND, UPDATE:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_SUB, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, REF:FN_WEEKOFDAY_DATE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, CREATE:#T_CONFIRM_ID, CREATE:#T_SSP, CREATE:#T_SSP_SUM, CREATE:#T_MKT_RESULT, CREATE:#T_MKT_RESULT_SUM, CREATE:#TEMP_SALES_RESULT, INSERT:#T_CONFIRM_ID, DELETE:A, SELECT:DM_PLN_MKT_FCST_CONFIRM, SELECT:#T_CONFIRM_ID, INSERT:DM_PLN_MKT_FCST_CONFIRM, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:DM_MST_ITEM_SINGLE_V, UPDATE:A, INSERT:#TEMP_SHIP_RESULT |  |
| SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 3 | SP SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| BtnConfirm_Click | UserInfoContext.Current | NowGroupID |
| BtnSimulation_Click | UserInfoContext.Current | NowGroupID |
| cboPlanDate_SelectedIndexChanged | row | CODE |
| cboPlanDate_SelectedIndexChanged | dr | CODE, FROM_DATE, TO_DATE |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| clbCompanyID_SelectedIndexChanged | c | CODE |
| clbDivision_ID_SelectedIndexChanged | c | DIVISION_ID |
| EditButton | UserInfoContext.Current | NowGroupID |
| GetErpSoNoCnt | ds.Tables[0].Rows[0] | CNT |
| GetNERPCode | ds.Tables[0].Rows[0] | SEGMENT2 |
| GetShipmentStatusChk | ds.Tables[0].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[1].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[2].Rows[iRow] | CONFIRM_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE, NAME |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| Plan_Current_Check | Tmp_dtPlanDate.Rows[0] | CODE, NAME, FROM_DATE, TO_DATE |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | c | CODE, DIVISION_ID |
| SetChangedControl | dtMyCompany.Rows[0] | NAME |
| SpdDetail_CellClick | drRow | CODE, NAME |
| SpdDetail_CellClick | dr | NAME, CODE |
| SpdDetail_CellClick | drAllRow | CODE, NAME |
| SpdDetail_ClipboardPasted | c | CODE |
| Validation_Check | row | confirm_id |
| Validation_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |
| Validation_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:390, SetChangeControl:395, SetChangeControl:400, SetChangeControl:405, SetChangeControl:410, SetChangeControl:415, SetChangeControl:420, SetChangeControl:425 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:470, InitControls:487 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:560, SpdDetail_CellClick:1747, SaveData_Detail:2334, FindData_Main:4518, FindData_Main:4519, FindData_Main:4520, FindData_Main:4521, FindData_Detail:4829 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:623, cboPlanDate_SelectedIndexChanged:5631 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:629, InitSpread:644, InitSpread:657, InitSpread:668, InitSpread:677, InitSpread:686, InitSpread:695 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:633 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:352 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:785 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:786 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:787 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:789 |
| this.spdMain | Change | SpdMain_Change | InitEvent:790 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:792 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:793 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:795 |
| this.btnRequestor | Click | BtnRequestor_Click | InitEvent:796 |
| this.btnSimulation | Click | BtnSimulation_Click | InitEvent:797 |
| this.btnConfirm | Click | BtnConfirm_Click | InitEvent:798 |
| this.spdDetail | SheetTabClick | SpdDetail_SheetTabClick | InitEvent:800 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:801 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:802 |
| this.spdDetail | ComboSelChange | SpdDetail_ComboSelChange | InitEvent:803 |
| this.spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:804 |
| this.spdDetail | EditChange | SpdDetail_EditChange | InitEvent:805 |
| this.spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:806 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:808 |
| clbCompany_ID | SelectedIndexChanged | clbCompanyID_SelectedIndexChanged | InitEvent:809 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | InitEvent:810 |
| dsdm | Changed | shtPlanDetail_Change | InitEvent:813 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:5554 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:5561 |

## 6. 컨트롤 (64개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 24 | layoutControlItem7, layoutControlItem10, layoutControlItem8, lblCombo1, layoutControlItem2, lblItemId, layoutControlItem1, layoutControlItem6, PlanDate, layoutControlItem12, lblBucket, lblProject, layoutControlItem16, layoutControlItem11, Requestor … |
| UsrButton | 7 | usrButton1, btnConfirm, btnSimulation, btnMeasure, btnItemId, btnRequestor, btnItemID2 |
| UsrMultiLineEditor | 5 | txtProject, txtItemId, txtPrNo, txtModel2, txtProjectCode |
| UsrCombo | 5 | clbCompany_ID, clbDivision_ID, cboPlanDate, cboBucketType, cboPlanDate21 |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem5 |
| UsrCheckedList | 3 | clbPlantSite, clbStorageId, clbResultType |
| UsrLayoutControl | 2 | usrLayoutControl2, P |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod2 |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | chkSum |
| SplitContainer | 1 | splitContainer1 |
| UsrTextBox | 1 | txtRequestor |
| SimpleButton | 1 | btnSearch |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 3362 | ERP_PR_REQUEST_SEND | SSP.SSP0027_GET_SHIPMENT_REQUEST_DRAFTING | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 101 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 207 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 7 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 50 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 24 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 5786 | SSP.PR_SSP_ANL_ESS_PLAN_CUTOFF | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0027 | Daily(BOH) | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_COLUMNS | SSP0027 | MONTHLY(BOH) | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_COLUMNS | SSP0027 | Netting History | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0027 | PR PO Detail | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 | 40/0 |
| SCM_MST_SHEET_COLUMNS | SSP0027 | Purchasing PSI(ESS) | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | SSP0027 | Shipment Plan Detail | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 |
| SCM_MST_SHEET_COLUMNS | SSP0027 | Shipment Result | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_MEASURE | SSP0027 | Purchasing PSI(ESS) | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Purchasing PSI(ESS), Shipment Plan Detail, PR PO Detail, Netting History, Shipment Result, Monthly(BOH), Daily(BOH)
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:629, SetSheetHeaderColumn@InitSpread:644, SetSheetHeaderColumn@InitSpread:657, SetSheetHeaderColumn@InitSpread:668, SetSheetHeaderColumn@InitSpread:677, SetSheetHeaderColumn@InitSpread:686, SetSheetHeaderColumn@InitSpread:695
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 738 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 742 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 746 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SpdDetail_CellClick |  | 1783 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siDetail.ActiveSheet.SheetName == "PR PO Detail") ⟫ if(siDetail.ActiveSheet.SheetName == "Shipment Plan Detail") ⟫ if(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) |
| SpdDetail_CellClick |  | 1811 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siDetail.ActiveSheet.SheetName == "PR PO Detail") ⟫ if(siDetail.ActiveSheet.SheetName == "Shipment Plan Detail") ⟫ else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdDetail_CellClick |  | 1815 | 표시/라벨 변경 | set:Value | Value = {?true} |  | else!(siDetail.ActiveSheet.SheetName == "PR PO Detail") ⟫ if(siDetail.ActiveSheet.SheetName == "Shipment Plan Detail") ⟫ else!(siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ⟫ if(siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SetSpreadColumn |  | 4443 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4448 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4455 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 4459 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4464 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 4471 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4475 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 914 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 915 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 916 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 917 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 986 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 987 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 988 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 989 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Daily(BOH) | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| MONTHLY(BOH) | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| Netting History | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| PR PO Detail | META+코드연결 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 | 40 |
| Purchasing PSI(ESS) | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| Shipment Plan Detail | META+코드연결 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 | 37 |
| Shipment Result | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

# SSP0003 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.UIL.csproj | 2095 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.UIL.csproj | 1318 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0003_ShipmentChangeRequestConfirm.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2056 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0003_ShipmentChangeRequestConfirm.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1318 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnApproval.Click | BtnApproval_Click > SaveData > FindData_Main | 696 | SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | MATCH | SP SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM |
| event:btnApproval.Click | BtnApproval_Click > SaveDraftingData | 970 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM |
| event:btnApproval.Click | BtnApproval_Click > SaveData | 1207 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| event:btnApproval.Click | BtnApproval_Click > SaveData | 1207 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM |
| event:btnApproval.Click | BtnApproval_Click > GetErpIFCheck | 1337 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| event:btnApproval.Click | BtnApproval_Click > GetErpIFCheckNew | 1409 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| event:btnApproval.Click | BtnApproval_Click > GetErpIFCheckNew | 1458 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| event:btnApproval.Click | BtnApproval_Click > GetErpIFCheckNew | 1492 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| event:btnApproval.Click | BtnApproval_Click > GetErpIFCheckNew | 1541 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| event:btnApproval.Click | BtnApproval_Click > EngProcessingChk | 1619 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | MATCH | SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| event:btnApproval.Click | BtnApproval_Click > GetShipmentStatusChk | 1656 | SSP.SSP0200_GET_SHIPMENT_STATUS | MATCH | SP SSP0200_GET_SHIPMENT_STATUS |
| event:btnReject.Click | BtnReject_Click > SaveData > FindData_Main | 696 | SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | MATCH | SP SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM |
| event:btnReject.Click | BtnReject_Click > SaveDraftingData | 970 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM |
| event:btnReject.Click | BtnReject_Click > SaveData | 1207 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| event:btnReject.Click | BtnReject_Click > SaveData | 1207 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM |
| event:btnReject.Click | BtnReject_Click > GetErpIFCheck | 1337 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| event:btnSelfReject.Click | BtnSelfReject_Click > SaveData > FindData_Main | 696 | SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | MATCH | SP SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM |
| event:btnSelfReject.Click | BtnSelfReject_Click > SaveDraftingData | 970 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM |
| event:btnSelfReject.Click | BtnSelfReject_Click > SaveData | 1207 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| event:btnSelfReject.Click | BtnSelfReject_Click > SaveData | 1207 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM |
| event:btnSelfReject.Click | BtnSelfReject_Click > GetErpIFCheck | 1337 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | MATCH | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 369 | SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION | NOT_IN_FOXQUERY |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 386 | SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData_Main | 696 | SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | MATCH | SP SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM |
| event:this.Load | Form_Load > InitControls | 317 | SSP.SSP0200_GET_SHIPMENT_DIVISION | MATCH | SP SSP0200_GET_SHIPMENT_DIVISION |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 369 | SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 386 | SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1864 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 772 | SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | MATCH | SP SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > Delegate_Load | 1834 | SSP.SSP0003_GET_DELEGATEE_LOAD | MATCH | SP SSP0003_GET_DELEGATEE_LOAD |
| unreached:(진입점 미연결) | SetChangedPeriod | 1573 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | MATCH | 1 | SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | EXEC:SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | MATCH | 1 | SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | EXEC:SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, CREATE:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, DELETE:SSP_ANL_SHIP_CONFIRM, INSERT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0003_GET_DELEGATEE_LOAD | MATCH | 1 | SP SSP0003_GET_DELEGATEE_LOAD | EXEC:SSP0003_GET_DELEGATEE_LOAD, SELECT:SSP_MST_DELEGATE, SELECT:TB_FX_USER |  |
| SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | MATCH | 1 | SP SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | EXEC:SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM, REF:FN_GET_ITEM_NICKNAME, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:TB_FX_USER, SELECT:SSP_MST_DELEGATE, REF:STRING_SPLIT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | MATCH | 1 | SP SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | EXEC:SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING, REF:FN_GET_PROJECT_NAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER |  |
| SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | MATCH | 1 | SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | EXEC:SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_PLAN_DETAIL |  |
| SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | 1 | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC:SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_SITE_ITEM_EE_V, UPDATE:SSP_ANL_SHIP_CONFIRM, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, EXEC:SCM_SSP_MAIL_SEND, SELECT:SSP_MST_MODEL_USER, EXEC:SCM_SSP_MODEL_USER_MAIL_SEND, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:PR_SSP_PLN_FP_SHIP_TARGET_WA, EXEC:PR_DM_SSP_CONFIRM_SYNC, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SSP_ANL_SHIP_CONFIRM_H, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:TB_FX_USER, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_ASSIGN, INSERT:#TBLSSPAPPROVEDMAILSEND, REF:FN_GET_USER_NAME, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:#TBLSSPAPPROVEDMAILSEND, EXEC:SCM_ADM_MAIL_SEND, SELECT:SSP_MST_DELEGATE, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, INSERT:#TBLSSPAPPROVEDMAILSEND2, SELECT:#TBLSSPAPPROVEDMAILSEND2, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_SCS_PACK_SHIP_PLAN_S_SN, REF:FN_ZERO_LPAD, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SCM_MST_PROJECT, SELECT:NERP_CONV_MASTER, SELECT:SCP_PLN_INTERFACE_SEND_H, CREATE:#TMP_XIF_FP_SSP_SALES_EXFACTROY, INSERT:#TMP_XIF_FP_SSP_SALES_EXFACTROY, REF:FN_GET_SSP_DOM_EXP, SELECT:SSP_ANL_SHIP_REQ_EE, REF:FN_GET_SSP_ANL_SHIP_FROZEN, REF:FN_GET_SSP_SITE_INFO, SELECT:DM_PLN_SHIPMENT_REQ, REF:FN_GET_ANL_SHIP_FROZEN_DAY_CNT, SELECT:SCP_MST_FINAL_ITEM, INSERT:XIF_FP_SSP_SALES_EXFACTORY_S_SN, SELECT:#TMP_XIF_FP_SSP_SALES_EXFACTROY |  |
| SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | 1 | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | EXEC:SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:#TBLDYNAMIC_SSP0003_40_STD, SELECT:SSP_ANL_SHIP_PLAN_40, SELECT:SCM_MST_SITE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_SITE_ITEM_EE_V, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:#TBLDYNAMIC_SSP0003_40_STD, DELETE:SSP_ANL_SHIP_PLAN_40, INSERT:SSP_ANL_SHIP_PLAN_40, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, EXEC:SCM_SSP_MAIL_SEND, EXEC:PR_DM_SSP_CONFIRM_SYNC, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SSP_ANL_SHIP_CONFIRM_H, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:TB_FX_USER, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_ASSIGN, INSERT:#TBLSSPAPPROVEDMAILSEND, REF:FN_GET_USER_NAME, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:#TBLSSPAPPROVEDMAILSEND, EXEC:SCM_ADM_MAIL_SEND, SELECT:SSP_MST_DELEGATE, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, CREATE:#T_CONFIRM_ID, CREATE:#T_SSP, CREATE:#T_SSP_SUM, CREATE:#T_MKT_RESULT, CREATE:#T_MKT_RESULT_SUM, CREATE:#TEMP_SALES_RESULT, INSERT:#T_CONFIRM_ID, DELETE:A, SELECT:DM_PLN_MKT_FCST_CONFIRM, SELECT:#T_CONFIRM_ID, INSERT:DM_PLN_MKT_FCST_CONFIRM, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:DM_MST_ITEM_SINGLE_V, UPDATE:A, INSERT:#TEMP_SHIP_RESULT, SELECT:SCM_DNM_EXFACTORY_RESULT |  |
| SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | MATCH | 3 | SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | EXEC:SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, EXEC:PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, REF:SCM_ARR_SPL_CNT, SELECT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, UPDATE:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | MATCH | 1 | SP SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | EXEC:SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:A, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SSP.SSP0200_GET_SHIPMENT_DIVISION | MATCH | 1 | SP SSP0200_GET_SHIPMENT_DIVISION | EXEC:SSP0200_GET_SHIPMENT_DIVISION, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE |  |
| SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SSP.SSP0200_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0200_GET_SHIPMENT_STATUS | EXEC:SSP0200_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| GetErpIFCheck | ds.Tables[0].Rows[0] | result_code |
| GetErpIFCheckNew | ds.Tables[0].Rows[0] | result_code |
| GetShipmentStatusChk | ds.Tables[2].Rows[iRow] | CONFIRM_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetChangeRequestInfo | dt.Rows[0] | CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:234, SetChangeControl:239, SetChangeControl:244, SetChangeControl:249, SetChangeControl:254, SetChangeControl:259, SetChangeControl:264 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:293, InitControls:301 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:354, FindData_Main:675, FindData_Main:678, FindData_Main:683, FindData_Main:685 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:431, InitSpread:439 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | BtnSelfReject_Click:1921, BtnReject_Click:1993, BtnApproval_Click:2029, BtnApproval_Click:2061, BtnApproval_Click:2063 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:203 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:204 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:275 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:276 |
| btnApproval | Click | BtnApproval_Click | InitEvent:278 |
| btnReject | Click | BtnReject_Click | InitEvent:279 |
| btnSelfReject | Click | BtnSelfReject_Click | InitEvent:280 |
| btnRequestUser | Click | BtnRequestUser_Click | InitEvent:281 |
| btnItemId | Click | btnItemId_Click | InitEvent:282 |

## 6. 컨트롤 (62개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | lcDivision, lcSelfReject, layoutControlItem1, layoutControlItem7, PlanType, lcBtnReject, lcBtnApproval, layoutControlItem13, Requestor, Model, layoutControlItem2, PlanType1, layoutControlItem5, layoutControlItem4, layoutControlItem6 … |
| TextBox | 9 | txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtReasonDetail, txtChangeReason, txtRejectReason |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem8, emptySpaceItem4, emptySpaceItem2, emptySpaceItem5 |
| SimpleButton | 3 | btnSelfReject, btnReject, btnApproval |
| FpSpread | 2 | spdMain, txtApprovalDeptName |
| SheetView | 2 | spdMain_Sheet1, txtApprovalDeptName_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl3 |
| UsrCheckedList | 2 | clbDivision, clbFromSite |
| UsrCombo | 2 | cboStatus, cboChangeType |
| UsrButton | 2 | btnRequestUser, btnItemId |
| UsrMultiLineEditor | 2 | txtRequest, txtItemID |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup3 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | drpPeriod |
| Splitter | 1 | splitter1 |
| Panel | 1 | panel1 |
| UsrLabel | 1 | usrLabel2 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 369 | SetChangedControl | SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 386 | SetChangedControl | SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 66 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 76 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 131 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 15 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 4 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 4 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 471 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1209 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | commented:MATCH |
| 1863 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0003 | Shipment Change Request Confirm | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | SSP0003 | Shipment Change Request Confirm Detail | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 | 29/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Change Request Confirm, Shipment Change Request Confirm Detail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:431, SetSheetHeaderColumn@InitSpread:439

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 447 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spreadInfo.SheetName == "Shipment Change Request Confirm Detail") |
| InitSpread |  | 448 | 표시/라벨 변경 | set:Value | Value = {?true} | CHK | if(spreadInfo.SheetName == "Shipment Change Request Confirm Detail") |
| InitSpread |  | 449 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spreadInfo.SheetName == "Shipment Change Request Confirm Detail") |
| InitSpread |  | 475 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ERP_SO_NO | if(spreadInfo.SheetName == "Shipment Change Request Confirm Detail") ⟫ if(_sChangeType == "P") |
| InitSpread |  | 503 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ERP_SO_NO | if(spreadInfo.SheetName == "Shipment Change Request Confirm Detail") ⟫ else!(_sChangeType == "P") |
| FindData_Sub |  | 827 | 표시/라벨 변경 | VisibleColumns | 0 |  | else!(p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ⟫ else!(p_status.Equals("D") \|\| p_status.Equals("A")) ⟫ else!(p_status.Equals("P")) |
| InitializeComponent |  | 191 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 192 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 193 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 194 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 839 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 840 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 841 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 842 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Change Request Confirm | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Shipment Change Request Confirm Detail | META+코드연결 | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:호출파라미터 28 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 28건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

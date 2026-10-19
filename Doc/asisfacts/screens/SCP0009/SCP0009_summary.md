# SCP0009 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0009_Shipment_Plan_FG\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0009_Shipment_Plan_FG\SCP0009_Shipment_Plan_FG.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0009_Shipment_Plan_FG\SCP0009_Shipment_Plan_FG.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0009_Shipment_Plan_FG\SCP0009_Shipment_Plan_FG.csproj | 4749 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0009_Shipment_Plan_FG\SCP0009_Shipment_Plan_FG.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0009_Shipment_Plan_FG\SCP0009_Shipment_Plan_FG.csproj | 2005 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > GetLastRange | 4043 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 4057 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| button:FindButton | FindButton > FindData_Main | 1438 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| button:FindButton | FindButton > FindData_Main | 1486 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| button:FindButton | FindButton > FindData_Main | 1529 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1438 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1486 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1529 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| button:SaveButton | SaveButton > SaveData_Main | 3364 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGWeekly] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 3364 | SCP\Analysis\SCP0009_Shipment_Plan_FG#SaveShipmentPlanFGWeekly | MATCH_PATTERN | SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY |
| button:SaveButton | SaveButton > SaveData_Main > Get_IsSaveYn | 3682 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > SCM_SYS_LOG_BATCH | 4707 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main | 1438 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main | 1486 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main | 1529 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| event:this.btnFix.Click | BtnFix_Click > Get_IsSaveYn | 3682 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo | 4587 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGFix] | BIZ_MATCH |  |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo | 4587 | SCP\Analysis\SCP0009_Shipment_Plan_FG#SaveShipmentPlanFGFix | MATCH_PATTERN | SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 4707 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main | 1438 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main | 1486 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main | 1529 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| event:this.btnNew.Click | BtnNew_Click > Get_IsSaveYn | 3682 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main | 1438 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main | 1486 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main | 1529 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG |
| event:this.btnUnfix.Click | BtnUnfix_Click > Get_IsSaveYn | 3682 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo | 4587 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGFix] | BIZ_MATCH |  |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo | 4587 | SCP\Analysis\SCP0009_Shipment_Plan_FG#SaveShipmentPlanFGFix | MATCH_PATTERN | SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 4707 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnW26.Click | BtnW26_Click > GetDayRange | 4057 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnW52.Click | BtnW52_Click > GetDayRange | 4057 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnWLast.Click | BtnWLast_Click > GetDayRange | 4057 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 4740 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 4743 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 499 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 502 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 537 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 4043 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 4057 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PeggingInfo | 3832 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PlanProblem | 3900 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | MATCH | SP SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PlanProblem > InitSpread_2 > GetSpdTitle | 4011 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGFix] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGWeekly] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0009_GET_SHIPMENT_PLAN_FG | MATCH | 2 | SP SCP0009_GET_SHIPMENT_PLAN_FG | EXEC:SCP0009_GET_SHIPMENT_PLAN_FG, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TMP_SCP0009_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, CREATE:#TMP_SCP0009_STD, INSERT:#TMPSCP0009_RESULT_TEMP, SELECT:SCP_ANL_BOD_N_V_PLAN_H, INSERT:#TMP_SCP0009_STD, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:#TMP_SCP0009_MEASURE, SELECT:#TMPSCP0009_RESULT_TEMP, SELECT:HIST_SCP_ANL_SHIPMENT_PLAN_FG, CREATE:#TMP_SCP0009_FG_VALUE, INSERT:#TMP_SCP0009_FG_VALUE, SELECT:#TMP_SCP0009_STD, INSERT:#TMP_SCP0009_ADD_MEASURE, SELECT:#TMP_SCP0009_FG_VALUE, INSERT:#TMP_SCP0009_PLAN, SELECT:#TMP_SCP0009_ADD_MEASURE, SELECT:#TMP_SCP0009_PLAN, SELECT:SCM_ITEM_M_SN, INSERT:#TMP_SCP0009_RSLT_TMP, REF:FN_GET_ITEM_NICKNAME, SELECT:PLAN_SSP, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCM_DNM_SCS_SHIP_RESULT, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, INSERT:#TMP_SCP0009_RSLT, SELECT:#TMP_SCP0009_RSLT_TMP, REF:FN_GET_DIVISION_DIV, SELECT:#TMP_SCP0009_RSLT, INSERT:#TMP_SCP0009_FNL_RSLT_PLAN, UPDATE:A, SELECT:#TMP_SCP0009_FNL_RSLT_PLAN, REF:FN_SCM_GET_WHERE_SQL, DYNAMIC@SCP0009_GET_SHIPMENT_PLAN_FG, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_DIVISION, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | MATCH | 1 | SP SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | EXEC:SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SCP_ANL_PROBLEM_REPORT_PEGGING, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_SCM_SPLIT |  |
| SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | MATCH | 1 | SP SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | EXEC:SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM, SELECT:SCP_ANL_PROBLEM_REPORT_DESC, REF:FN_SCM_SPLIT |  |
| SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | 1 | SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | EXEC:SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, REF:FN_GET_DIVISION_DIV, INSERT:#TMP_SCP0009_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, CREATE:#TMP_SCP0009_STD, INSERT:#TMPSCP0009_RESULT_TEMP, SELECT:SCP_ANL_BOD_N_V_PLAN_H, INSERT:#TMP_SCP0009_STD, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:#TMP_SCP0009_MEASURE, SELECT:#TMPSCP0009_RESULT_TEMP, SELECT:HIST_SCP_ANL_SHIPMENT_PLAN_FG, INSERT:#TMP_SCP0009_ADD_MEASURE, SELECT:#TMP_SCP0009_STD, INSERT:#TMP_SCP0009_ADD_CALENDAR, SELECT:#TMP_SCP0009_ADD_MEASURE, SELECT:#TMP_SCP0009_ADD_CALENDAR, INSERT:#TMP_SCP0009_PLAN, INSERT:#TMP_SCP0009_RSLT_TMP, REF:FN_GET_ITEM_NICKNAME, SELECT:PLAN_SSP, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCM_DNM_SCS_SHIP_RESULT, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, INSERT:#TMP_SCP0009_RSLT_TMP2, SELECT:#TMP_SCP0009_RSLT_TMP, INSERT:#TMPSCP0009_RESULT_TEMP0, SELECT:#TMP_SCP0009_RSLT_TMP2, INSERT:#TMP_SCP0009_RSLT, SELECT:#TMPSCP0009_RESULT_TEMP0, SELECT:#TMP_SCP0009_RSLT, INSERT:#TMP_SCP0009_FNL_RSLT_PLAN, SELECT:#TMP_SCP0009_PLAN, REF:FN_SCM_GET_WHERE_SQL, DYNAMIC@SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_ITEM_SN, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | 1 | SP SCP0013_GET_PLAN_TYPE_SAVE_YN | EXEC:SCP0013_GET_PLAN_TYPE_SAVE_YN, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP\Analysis\SCP0009_Shipment_Plan_FG#SaveShipmentPlanFGFix | MATCH_PATTERN | 1 | SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET | EXEC:SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET, CREATE:#TBLDYNAMIC_SCP0009FIX, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TBLDYNAMIC_SCP0009FIX, UPDATE:X, SELECT:#TBLDYNAMIC_SCP0009FIX, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, UPDATE:#TBLDYNAMIC_SCP0009FIX, UPDATE:B, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX, UPDATE:A, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET, DELETE:A, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H |  |
| SCP\Analysis\SCP0009_Shipment_Plan_FG#SaveShipmentPlanFGWeekly | MATCH_PATTERN | 1 | SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY | EXEC:SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY, CREATE:#TBLDYNAMIC_SCP0009, CREATE:#LAST_INFO_TABLE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_MULTY_TIME, INSERT:#TBLDYNAMIC_SCP0009, SELECT:#TBLDYNAMIC_SCP0009, UPDATE:A, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, UPDATE:B, INSERT:SCP_ANL_SHIPMENT_PLAN_FG, DELETE:A, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST_DATASET, INSERT:#SHIPMENT_EXIST_DATA, SELECT:SCP_MST_BOD_N_V, INSERT:#SHIPMENT_EXIST_INFO, SELECT:#SHIPMENT_EXIST_DATA, SELECT:SCM_SYS_CALENDAR_M, SELECT:#SHIPMENT_EXIST_INFO, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, UPDATE:#SHIPMENT_EXIST_INFO, DYNAMIC@SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY, SELECT:#LAST_INFO_TABLE, INSERT:SCM_SYS_LOG_BATCH, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H, INSERT:SCP_ANL_SHIPMENT_PLAN_FG_H, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData_Main | dsBinding.Tables[1].Rows[0] | plan_start_date |
| GetIsEditable | dtEditable.Rows[0] | is_editable |
| GetIsEditable | dr | PLAN_STATUS |
| GetIsEditable | founded[0] | confirm_yn |
| InitControls | dataRow | CODE, NAME, SORT_ORDER |
| InitControls | dr | CODE, NAME |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | dr | division_id, BIZ_TYPE_NAME, ITEM_ID, NICK_NAME, ELECTRODE_TYPE, ORIGIN_TO_DIVISION_ID, BOH, PROJECT_CODE, ORIGIN_FROM_DIVISION_ID, MEASURE_LABEL, measure, key_idx, biz_type, MEASURE_ORDER_NO, plan_start_yyyymmdd, plan_type, seq, to_yyyymmdd |
| InsertRow | row | Measure, transport_mode, lt_day, division_id, BIZ_TYPE_NAME, ITEM_ID, NICK_NAME, ELECTRODE_TYPE, ORIGIN_TO_DIVISION_ID, BOH, PROJECT_CODE, ORIGIN_FROM_DIVISION_ID, MEASURE_LABEL, key_idx, biz_type, MEASURE_ORDER_NO, plan_start_yyyymmdd, plan_type, seq, to_yyyymmdd |
| RefreshTeam | UserInfoContext.Current | NowGroupID |
| SaveData_FixInfo | dr | p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_biz_type, p_item_id, p_to_site, p_from_site, p_project_code, p_incoterms, p_bod_id, p_yyyymmdd, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_fix_reason, p_bucket_type, p_created_by, p_last_updated_by, p_time_zone, debug_mode |
| SaveData_FixInfo | result.Rows[0] | result_code, result_cnt, err_message |
| SaveData_Main | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_biz_type, p_project_code, p_item_id, p_to_site, p_incoterms, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_created_by, p_last_updated_by, p_time_zone, p_bucket_type, p_trans_mode, debug_mode |
| SaveData_Main | dRow | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_biz_type, p_project_code, p_item_id, p_to_site, p_incoterms, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_created_by, p_last_updated_by, p_time_zone, debug_mode, p_bucket_type |
| SaveData_Main | saveDS.Tables[0].Rows[0] | p_first_row |
| SaveData_Main | saveDS.Tables[0].Rows[iCount - 1] | p_last_row |
| SaveData_Main | result.Rows[0] | result_code, result_cnt, err_message |
| Set_FixButtonEnabled | a | CODE |
| Set_FixCellColor | dr | yyyymmdd |
| Set_SumValues | dsBinding.Tables[0].Columns | to_yyyymmdd, measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | _division:331, _operationGroup:338, _planDate:345, _planType:352, InitControls:518, InitSpread_2:653, InitSpread_2:654, BtnNew_Click:1122 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:660 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:662, InitSpread_2:726, InitSpread_2:745 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:664 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:524 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:756 |
| this | Load | Form_Load | .ctor:295 |
| this.btnProject | Click | BtnProject_Click | InitEvent:950 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:951 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:952 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:953 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:954 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:957 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:958 |
| this.spdMain | KeyUp | SpdMain_KeyUp | InitEvent:959 |
| this.btnFix | Click | BtnFix_Click | InitEvent:962 |
| this.btnUnfix | Click | BtnUnfix_Click | InitEvent:963 |
| this.btnNew | Click | BtnNew_Click | InitEvent:965 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:968 |
| this.btnW26 | Click | BtnW26_Click | InitEvent:970 |
| this.btnW52 | Click | BtnW52_Click | InitEvent:971 |
| this.btnWLast | Click | BtnWLast_Click | InitEvent:972 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:974 |
| cboBizType | SelectedIndexChanged | CboBizType_SelectedIndexChanged | InitEvent:975 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:976 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:977 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:978 |

## 6. 컨트롤 (75개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 26 | lblProject, layoutControlItem9, lblCombo, lblCombo1, layoutControlItem2, lblItemId, PlanDate, PlanType, layoutControlItem4, lblBucket, layoutControlItem1, SEQ, layoutControlItem3, layoutControlItem5, layoutControlItem7 … |
| UsrButton | 11 | usrButton1, btnW52, btnW26, btnWLast, btnUnfix, btnFix, btnMeasure, btnProject, btnItem_Id, btnColumn, btnNew |
| EmptySpaceItem | 10 | emptySpaceItem5, emptySpaceItem8, emptySpaceItem9, emptySpaceItem2, emptySpaceItem1, emptySpaceItem10, emptySpaceItem11, emptySpaceItem3, emptySpaceItem6, emptySpaceItem7 |
| UsrCombo | 6 | cboBizType, cboPlanDate, cboPlanType, cboDivision, cboBucketType, cboPlanSeq |
| UsrCheckedList2 | 4 | clbCustomer, clbTeam, clbFromSite, clbToSite |
| UsrCheckBox | 3 | chkAll, chkSum, usrCheckBox1 |
| FpSpread | 3 | spdMain, spdPeggingInfo, spdPlanProblem |
| SheetView | 3 | spdMain_Sheet1, spdPeggingInfo_Sheet1, spdPlanProblem_Sheet1 |
| UsrMultiLineEditor | 2 | txtItem_Id, txtProject |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCheckedList | 1 | clbElecType |
| LayoutControlGroup | 1 | layoutControlGroup2 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 3364 | SaveData_Main | {?definition_path}#SaveShipmentPlanFGWeekly | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4587 | SaveData_FixInfo | {?definition_path}#SaveShipmentPlanFGFix | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 164 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 80 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 10 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 338 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 151 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 1595 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (6건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 595 | SCP.SCP0011_GET_LAST_PLAN_VERSION | commented:MATCH |
| 3409 |  | commented:EMPTY |
| 3899 | SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | commented:MATCH |
| 4025 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 4024 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 4638 | SCP.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0009 | Pegging Info | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0009 | Plan Problem | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SCP0009 | Shipment Request | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 |
| SCM_MST_SHEET_MEASURE | SCP0009 | Shipment Plan FG | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Request, Pegging Info, Plan Problem
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:662, SetSheetHeaderColumn@InitSpread_2:726, SetSheetHeaderColumn@InitSpread_2:745
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 | Shipment Request | 666 | 표시/라벨 변경 | set:Font | Font = {?new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold)} | from_site_name | if(spdInfo.SheetName == "Shipment Request") |
| InitSpread_2 | Shipment Request | 667 | 표시/라벨 변경 | set:Font | Font = {?new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold)} | transport_mode | if(spdInfo.SheetName == "Shipment Request") |
| InitSpread_2 | Shipment Request | 686 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Request | 687 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Request | 688 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Request | 692 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Request | 693 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Request | 694 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Request | 697 | 표시/라벨 변경 | set:Visible | Visible = {?(division == "40")} | EXTRA_SPEC | if(spdInfo.SheetName == "Shipment Request") |
| InitSpread_2 | Shipment Request | 701 | 표시/라벨 변경 | set:Visible | Visible = {?false} | product_group | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 702 | 표시/라벨 변경 | set:Visible | Visible = {?false} | cell_model | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 703 | 표시/라벨 변경 | set:Visible | Visible = {?false} | cell_pack_count | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 704 | 표시/라벨 변경 | set:Visible | Visible = {?false} | application | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 705 | 표시/라벨 변경 | set:Visible | Visible = {?false} | min_capacity | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 706 | 표시/라벨 변경 | set:Visible | Visible = {?false} | soldto_customer | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 707 | 표시/라벨 변경 | set:Visible | Visible = {?false} | model_spec | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 708 | 표시/라벨 변경 | set:Visible | Visible = {?false} | model_version | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 709 | 표시/라벨 변경 | set:Visible | Visible = {?false} | spec_version | if(spdInfo.SheetName == "Shipment Request") ⟫ if(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 713 | 표시/라벨 변경 | set:Visible | Visible = {?true} | product_group | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 714 | 표시/라벨 변경 | set:Visible | Visible = {?true} | cell_model | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 715 | 표시/라벨 변경 | set:Visible | Visible = {?true} | cell_pack_count | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 716 | 표시/라벨 변경 | set:Visible | Visible = {?true} | application | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 717 | 표시/라벨 변경 | set:Visible | Visible = {?true} | min_capacity | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 718 | 표시/라벨 변경 | set:Visible | Visible = {?true} | soldto_customer | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 719 | 표시/라벨 변경 | set:Visible | Visible = {?true} | model_spec | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 720 | 표시/라벨 변경 | set:Visible | Visible = {?true} | model_version | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Shipment Request | 721 | 표시/라벨 변경 | set:Visible | Visible = {?true} | spec_version | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(!division.Equals("40")) |
| InitSpread_2 | Pegging Info | 731 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Pegging Info | 732 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Pegging Info | 733 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Pegging Info | 737 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Pegging Info | 738 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Pegging Info | 739 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpreadDateColumn |  | 901 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 904 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 908 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 4091 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4095 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4100 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 4103 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4107 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 4112 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 4115 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 1696 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1697 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1698 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1699 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Pegging Info | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 22 | 22 | 22 | 22 | 22 | 22 |
| Plan Problem | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| Shipment Request | META+코드연결 | 27 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

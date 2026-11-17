# AS-IS 실측 요약 — FP00597

- 실행: 2026-11-12 21:52:41.381 ~ 2026-11-12 21:53:21.023 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(PreMix) (GSCM.FP.Planning.UIL.FP00597_PlanAmend_Model_PreMix)
- 조회 결과: Total : 43 · DB : 16.755s, UI : 0.388s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:52:41.775 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 35.52 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:52:41.778 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.09 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:52:41, END_TIME=2026-11-12 21:52:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215241_739, PA |
| 21:52:41.870 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00597 |
| 21:52:41.885 | load | GSCM.FP_Common | SELECT * | 351 | 10.56 | USER_ID= |
| 21:52:41.889 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:52:41.990 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.73 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:52:41.994 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.49 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:52:41, END_TIME=2026-11-12 21:52:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215241_983, PA |
| 21:52:42.056 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 16 | 5.75 | USER_ID=jaeuk.shin, MENU_ID=FP00597_Amend |
| 21:52:42.086 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.57 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:52:42.094 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.67 | p_program_id=FP00597, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:52:42.103 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.37 | p_program_id=FP00597, p_sheet_name=Amend |
| 21:52:42.131 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 9.91 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00597_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.170 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.45 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00597_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:52:42.390 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 184.61 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PMIX, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.415 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PMIX',@param2=N'Y',@param3=N'',@param4=N'', |
| 21:52:42.443 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.01 | p_code=FP00597_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.447 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00597_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 21:52:42.460 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.27 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.490 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 21:52:42.504 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.59 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.507 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 21:52:42.521 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.45 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.555 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 21:52:42.621 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 62.12 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:52:42.624 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:52:42, END_TIME=2026-11-12 21:52:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215242_558, PA |
| 21:52:42.748 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 110.55 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 21:52:42.764 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:52:42, END_TIME=2026-11-12 21:52:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215242_638, PA |
| 21:52:42.799 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 24.9 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param |
| 21:52:42.803 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:52:42, END_TIME=2026-11-12 21:52:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215242_774, PA |
| 21:52:42.863 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 45.87 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:42.905 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 21:52:42.977 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 60.19 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=N, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:43.018 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.39 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'N',@pa |
| 21:52:43.044 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 12.64 | p_code=FP00596_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=, param10=E0500, param11=Y, param12=, param13=, param14=Y, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:43.082 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@par |
| 21:52:43.094 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00597, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:52:43.102 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.15 | p_program_id=FP00597, p_sheet_name=Amend |
| 21:52:43.108 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.9 | p_program_id=FP00597, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:52:43.116 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 3.98 | p_program_id=FP00597, p_sheet_name=Amend |
| 21:52:43.195 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 57.31 | MenuID=Plan Amend by Model(PreMix), CnntCode=0104001, UserID=jaeuk.shin |
| 21:52:43.258 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00597 |
| 21:52:51.954 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 16.75 | p_code=FP00597_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:51.958 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00597_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20260919',@param3=N'',@param4=N'',@param |
| 21:52:51.984 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.21 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=PRE, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=,  |
| 21:52:52.029 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'PR |
| 21:52:52.118 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 74.5 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=N, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:52.186 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 66.79 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'N',@pa |
| 21:52:52.212 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 12.55 | p_code=FP00596_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=PRE, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=FP_E2P01,FP_E2P02,FP_EGM01_A, param10=E0500, param11=Y, param12=, param13=, param14=Y, param15=, param16=, |
| 21:52:52.249 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.7 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'PRE', |
| 21:52:52.264 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 3.92 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:52.269 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'',@param4 |
| 21:52:57.249 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 38.51 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.276 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.02 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 21:52:57.290 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 4.61 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.383 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 92.77 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 21:52:57.396 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.43 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=A001, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.438 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'A001',@param4=N |
| 21:52:57.488 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 42.45 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.518 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:52:57.530 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 4.36 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.585 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.2 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@para |
| 21:52:57.598 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 32 | 5.42 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.677 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:52:57.690 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.85 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00597_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:57.729 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.87 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00597_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:53:13.454 | find | GSCM.FP_Common | PR_UI_FP00597_AMEND_MODEL | 46 | 15711.32 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_E_PMIX, p_company_id=, p_division_id=40,81, p_site_id=A001, p_plant_id=HQ06,HQ07, p_factory_id=, p_line_id=FP_E2P01,FP_E2P02,FP_EGM01_A, p_operation_id=E0500, p_master_id=KR_E_PMIX, p_plan_date=20260919,  |
| 21:53:13.459 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00597_AMEND_MODEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00597_AMEND_MODEL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_E_PMIX',@p_compa |
| 21:53:13.531 | find | GSCM.FP_Common | PR_UI_FP00597_AMEND_MODEL | 1 | 56.87 | p_sys_type=SELECT, p_sys_flag=SELECT_TOTAL_VALUE, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_E_PMIX, p_company_id=, p_division_id=40,81, p_site_id=A001, p_plant_id=HQ06,HQ07, p_factory_id=, p_line_id=FP_E2P01,FP_E2P02,FP_EGM01_A, p_operation_id=E0500, p_master_id=KR_E_PMIX, p_plan_date=202 |
| 21:53:13.536 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00597_AMEND_MODEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00597_AMEND_MODEL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_TOTAL_VALUE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_E_PMIX',@ |
| 21:53:13.552 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 8.57 | p_code=FP00597_find_ListData, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=E0500, param4=FP_AMEND_DAILY_PLAN_R, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:53:13.590 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.57 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00597_find_ListData',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'E0500',@p |
| 21:53:13.633 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3068 | 33.86 | p_code=FP00596_find_UOMInfo, p_user_id=jaeuk.shin, param1=40,81, param2=A001, param3=HQ06,HQ07, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:53:13.682 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_UOMInfo',@p_user_id=N'jaeuk.shin',@param1=N'40,81',@param2=N'A001',@param3=N'HQ06,HQ07',@param4=N'',@param5= |
| 21:53:13.766 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 136 | 42.05 | p_code=FP00596_find_YieldInfo_Child, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=FP_AMEND_DAILY_BOR_R, param4=40,81, param5=A001, param6=HQ06,HQ07, param7=, param8=E0500, param9=FP_E2P01,FP_E2P02,FP_EGM01_A, param10=, param11=, param12=, param13=, param14=, param15=, |
| 21:53:13.790 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_YieldInfo_Child',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'FP |
| 21:53:14.144 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 6.18 | INSTANCE_ID=KR_E_PMIX, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:53:14.149 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.58 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 21:53:14.163 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 8.58 | INSTANCE_ID=KR_E_PMIX |
| 21:53:14.169 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.48 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 21:53:14.181 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 4.58 | USER_ID=jaeuk.shin |
| 21:53:14.219 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.78 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:53:14.230 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.44 | INSTANCE_ID=KR_E_PMIX |
| 21:53:14.235 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.58 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:53:14.317 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.19 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:53:14.336 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.7 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:53:14.352 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.53 | p_menu_id=FP00597, p_log_type=FIND, p_log_cnt=, p_db_time=16.755, p_ui_time=0.388, p_user_id=jaeuk.shin |
| 21:53:20.355 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.79 | MenuID=Plan Amend by Model(PreMix), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem9 | chk_Info |  |
| Operation | mcbo_operation |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem16 | chk_includeSubOp |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Amend: 행 43 · 컬럼 66(보임 57) · 헤더 2단 · 고정 컬럼 32

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

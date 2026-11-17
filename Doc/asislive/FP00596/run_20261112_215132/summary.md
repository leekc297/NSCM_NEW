# AS-IS 실측 요약 — FP00596

- 실행: 2026-11-12 21:51:32.454 ~ 2026-11-12 21:52:41.107 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(PreMix) (GSCM.FP.Planning.UIL.FP00596_PlanAmend_Line_PreMix)
- 조회 결과: Total : 14 · DB : 26.661s, UI : 0.57s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:51:32.788 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 10.31 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:51:32.969 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 181.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:51:32, END_TIME=2026-11-12 21:51:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215132_777, PA |
| 21:51:33.104 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.44 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00596 |
| 21:51:33.121 | load | GSCM.FP_Common | SELECT * | 351 | 11.09 | USER_ID= |
| 21:51:33.140 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.04 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:51:33.248 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.03 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:51:33.251 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.89 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:51:33, END_TIME=2026-11-12 21:51:33, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215133_241, PA |
| 21:51:33.305 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 30 | 38.36 | USER_ID=jaeuk.shin, MENU_ID=FP00617_Amend |
| 21:51:33.348 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.25 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:51:33.355 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.94 | p_program_id=FP00617, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:51:33.403 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 43.92 | p_program_id=FP00617, p_sheet_name=Amend |
| 21:51:33.433 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 17 | 9.47 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00596_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:33.462 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00596_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:51:33.672 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 174.83 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PMIX, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:33.698 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.43 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PMIX',@param2=N'Y',@param3=N'',@param4=N'', |
| 21:51:33.761 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 50.16 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:33.787 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.58 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 21:51:33.802 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 5.34 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:33.862 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 59.63 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 21:51:33.891 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.06 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:33.919 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.67 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 21:51:33.935 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.14 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:33.964 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 21:51:34.096 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 126.96 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:51:34.113 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.27 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:51:33, END_TIME=2026-11-12 21:51:34, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215133_969, PA |
| 21:51:34.213 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 89.51 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 21:51:34.216 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:51:34, END_TIME=2026-11-12 21:51:34, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215134_123, PA |
| 21:51:34.251 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 25.09 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param |
| 21:51:34.254 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:51:34, END_TIME=2026-11-12 21:51:34, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215134_225, PA |
| 21:51:34.287 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.5 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:34.328 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.25 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 21:51:34.420 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 80.83 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=N, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:34.463 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'N',@pa |
| 21:51:34.490 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 13.16 | p_code=FP00596_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=, param10=E0500, param11=Y, param12=, param13=, param14=Y, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:34.534 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@par |
| 21:51:52.524 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 17977.68 | p_code=FP00596_find_FPNickName, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=20261112, param4=, param5=, param6=40,81, param7=A001, param8=HQ06,HQ07, param9=, param10=FP_E2P01,FP_E2P02,FP_EGM01_A, param11=E0500, param12=, param13=FP_AMEND_DAILY_PLAN_R, param14=, param15=, param16=, param1 |
| 21:51:52.548 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_FPNickName',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'20261112',@param4=N'',@param |
| 21:51:52.563 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.09 | p_program_id=FP00596, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:51:52.598 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 30.68 | p_program_id=FP00596, p_sheet_name=Amend |
| 21:51:52.605 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.78 | p_program_id=FP00596, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:51:52.612 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 3.57 | p_program_id=FP00596, p_sheet_name=Amend |
| 21:51:52.727 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 87.89 | MenuID=Plan Amend by Line(PreMix), CnntCode=0104001, UserID=jaeuk.shin |
| 21:51:52.762 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00596 |
| 21:52:01.666 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 65.5 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:01.720 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20260919',@param3=N'',@param4=N'',@param |
| 21:52:01.780 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 46.56 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=PRE, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=,  |
| 21:52:01.821 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.75 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'PR |
| 21:52:01.907 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 70.45 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=N, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:01.963 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'N',@pa |
| 21:52:01.987 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 12.82 | p_code=FP00596_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=PRE, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=FP_E2P01,FP_E2P02,FP_EGM01_A, param10=E0500, param11=Y, param12=, param13=, param14=Y, param15=, param16=, |
| 21:52:02.020 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'PRE', |
| 21:52:02.117 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 85.23 | p_code=FP00596_find_FPNickName, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=20260919, param4=20260914, param5=20261011, param6=40,81, param7=A001, param8=HQ06,HQ07, param9=, param10=FP_E2P01,FP_E2P02,FP_EGM01_A, param11=E0500, param12=, param13=FP_AMEND_DAILY_PLAN_R, |
| 21:52:02.140 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_FPNickName',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'2026091 |
| 21:52:02.158 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.54 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:02.197 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'',@param4 |
| 21:52:07.259 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 160.37 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.283 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.67 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 21:52:07.296 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 5.24 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.301 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.24 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 21:52:07.321 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 11.53 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=A001, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.357 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.34 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'A001',@param4=N |
| 21:52:07.368 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.25 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.373 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:52:07.384 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 4.08 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.424 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.48 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@para |
| 21:52:07.435 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 32 | 4.6 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.476 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:52:07.490 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 17 | 5.1 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00596_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:07.518 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.59 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00596_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:52:32.968 | find | GSCM.FP_Common | PR_UI_FP00596_AMEND_LINE | 25 | 25440.16 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_E_PMIX, p_company_id=, p_division_id=40,81, p_site_id=A001, p_plant_id=HQ06,HQ07, p_factory_id=, p_line_id=FP_E2P01,FP_E2P02,FP_EGM01_A, p_operation_id=E0500, p_master_id=KR_E_PMIX, p_plan_date=20260919,  |
| 21:52:32.973 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00596_AMEND_LINE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00596_AMEND_LINE @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_E_PMIX',@p_company |
| 21:52:33.028 | find | GSCM.FP_Common | PR_UI_FP00596_AMEND_LINE | 1 | 40.99 | p_sys_type=SELECT, p_sys_flag=SELECT_TOTAL_VALUE, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_E_PMIX, p_company_id=, p_division_id=40,81, p_site_id=A001, p_plant_id=HQ06,HQ07, p_factory_id=, p_line_id=FP_E2P01,FP_E2P02,FP_EGM01_A, p_operation_id=E0500, p_master_id=KR_E_PMIX, p_plan_date=202 |
| 21:52:33.034 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.82 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00596_AMEND_LINE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00596_AMEND_LINE @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_TOTAL_VALUE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_E_PMIX',@p_ |
| 21:52:33.048 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 7.14 | p_code=FP00596_find_ListData, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=FP_AMEND_DAILY_PLAN_R, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:33.052 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_ListData',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'FP_AMEND_ |
| 21:52:33.373 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3068 | 312.91 | p_code=FP00596_find_UOMInfo, p_user_id=jaeuk.shin, param1=40,81, param2=A001, param3=HQ06,HQ07, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:33.378 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_UOMInfo',@p_user_id=N'jaeuk.shin',@param1=N'40,81',@param2=N'A001',@param3=N'HQ06,HQ07',@param4=N'',@param5= |
| 21:52:33.546 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 136 | 134.73 | p_code=FP00596_find_YieldInfo_Child, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=KR_E_PMIX-20260919-00, param3=FP_AMEND_DAILY_BOR_R, param4=40,81, param5=A001, param6=HQ06,HQ07, param7=, param8=E0500, param9=FP_E2P01,FP_E2P02,FP_EGM01_A, param10=, param11=, param12=, param13=, param14=, param15=, |
| 21:52:33.569 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.61 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_YieldInfo_Child',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'KR_E_PMIX-20260919-00',@param3=N'FP |
| 21:52:33.942 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 23.92 | p_program_id=FP00596, p_user_id=jaeuk.shin, p_sheet_name=Amend |
| 21:52:34.039 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 49.33 | INSTANCE_ID=KR_E_PMIX, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:52:34.043 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.48 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 21:52:34.091 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 38.84 | INSTANCE_ID=KR_E_PMIX |
| 21:52:34.096 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.38 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 21:52:34.108 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 4.9 | USER_ID=jaeuk.shin |
| 21:52:34.114 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.82 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:52:34.128 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.21 | INSTANCE_ID=KR_E_PMIX |
| 21:52:34.163 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.21 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:52:34.286 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 26.52 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:52:34.314 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:52:34.326 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.3 | p_menu_id=FP00596, p_log_type=FIND, p_log_cnt=, p_db_time=26.661, p_ui_time=0.57, p_user_id=jaeuk.shin |
| 21:52:40.445 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.78 | MenuID=Plan Amend by Line(PreMix), CnntCode=0104002, UserID=jaeuk.shin |

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
| Nick Name | txtNickName |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem16 | chk_includeSubOp |  |
| Material | txtItem |  |
| Nick Name List | mcbo_nicknamelt |  |

## 그리드

- spdMain / Amend: 행 14 · 컬럼 119(보임 108) · 헤더 3단 · 고정 컬럼 23

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

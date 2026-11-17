# AS-IS 실측 요약 — FP00626

- 실행: 2026-11-13 04:47:54.827 ~ 2026-11-13 04:51:29.429 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simulation(Assy) (GSCM.FP.Planning.UIL.FP00626_PancakeSimulation_Assy)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260918"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260917"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260916"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260915"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260914"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260913"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260912"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260911"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260910"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260909"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260908"}, {"name": "chk_release", "prop": "Checked", "value": "true"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:47:55.184 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 32.32 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:47:55.188 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.45 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:47:55, END_TIME=2026-11-13 04:47:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044755_151, PA |
| 04:47:55.269 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 04:47:55.286 | load | GSCM.FP_Common | SELECT * | 351 | 10.52 | USER_ID= |
| 04:47:55.292 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.73 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:47:55.527 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 133.13 | p_code=FP00626_findInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:55.564 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_CELL',@param2=N'',@param3=N'',@param4=N'', |
| 04:47:55.635 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.42 | p_code=FP00626_find_isPast, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:55.674 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_isPast',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 04:47:55.697 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.86 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:55.734 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 04:47:55.769 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 4.42 | p_code=FP00626_find_Unit, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:55.807 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_Unit',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@para |
| 04:47:55.868 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 5.48 | p_code=FP00626_find_cellType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:55.872 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.17 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_cellType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 04:47:55.944 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 4.68 | p_code=FP00626_find_pancakeType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:55.948 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_pancakeType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 04:47:55.996 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.24 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:56.004 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.48 | p_program_id=FP00626, p_sheet_name=Amend |
| 04:47:56.013 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.04 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:56.020 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 3.81 | p_program_id=FP00626, p_sheet_name=Amend |
| 04:47:56.034 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.29 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 04:47:56.040 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.69 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 04:47:56.048 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.85 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 04:47:56.054 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.65 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 04:47:56.080 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.19 | MenuID=Pancake Simulation(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 04:47:56.128 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 04:48:04.246 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.56 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:04.266 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.25 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260919',@param3=N'',@param4=N'',@param5= |
| 04:48:07.099 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.96 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260918, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:07.146 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.83 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260918',@param3=N'',@param4=N'',@param5= |
| 04:48:09.811 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.8 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260917, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:09.834 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.22 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260917',@param3=N'',@param4=N'',@param5= |
| 04:48:12.627 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.94 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260916, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:12.656 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260916',@param3=N'',@param4=N'',@param5= |
| 04:48:15.461 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.5 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260915, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:15.555 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 92.23 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260915',@param3=N'',@param4=N'',@param5= |
| 04:48:18.372 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 6.01 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260914, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:18.420 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.75 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260914',@param3=N'',@param4=N'',@param5= |
| 04:48:20.908 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.3 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260913, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:20.935 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.6 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260913',@param3=N'',@param4=N'',@param5= |
| 04:48:23.587 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 9.17 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260912, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:23.590 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260912',@param3=N'',@param4=N'',@param5= |
| 04:48:26.406 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.92 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260911, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:26.426 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.09 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260911',@param3=N'',@param4=N'',@param5= |
| 04:48:29.097 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.86 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260910, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:29.154 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.61 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260910',@param3=N'',@param4=N'',@param5= |
| 04:48:31.817 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.78 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260909, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:31.837 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.39 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260909',@param3=N'',@param4=N'',@param5= |
| 04:48:34.635 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 6.4 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260908, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:48:34.695 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.93 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260908',@param3=N'',@param4=N'',@param5= |
| 04:49:42.131 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.67 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=20260928, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:49:42.153 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.66 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'20260928',@param4=N'' |
| 04:49:42.172 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 3.76 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261112, param3=20260928, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:49:42.211 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.44 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261112',@param3=N'20260928',@param4=N'',@param5=N' |
| 04:49:42.223 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.33 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20260928, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:49:42.274 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260928',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:49:42.296 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.26 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20260928, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:49:42.301 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260928',@param3=N'',@param4=N'',@param5=N'',@para |
| 04:49:42.314 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.77 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261112, param2=20260928, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:49:42.354 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.56 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260928',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:49:42.368 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 4.8 | p_code=FP00626_find_measure, p_user_id=jaeuk.shin, param1=FP00626_Main, param2=jaeuk.shin, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:49:42.427 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.71 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00626_Main',@param2=N'jaeuk.shin',@param3=N'',@param4=N'',@par |
| 04:50:55.782 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 73332.49 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00626_PANCAKESIMULATION_ASSY, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^USER_ID^INSTANCE_ID^CONFIRM_AREA^SITE_ID^BUCKET_FROM^BUCKET_TO^CURR_DATE^UNIT^RELEASE_FLAG^CHK_PLANID^TOTAL_INCLUDE^CATE_INF |
| 04:50:55.789 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.53 | PROG_ID=PR_UI_FP00626_PANCAKESIMULATION_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR |
| 04:51:28.661 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.36 | MenuID=Pancake Simulation(Assy), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Instance Date | sCalendar_planday |  |
| Plan ID(Assy) | cbo_planid |  |
| Unit | cbo_unit |  |
| layoutControlItem2 | chktotalinclude |  |
| Nick Name | txtNickName |  |
| Material | txtItem |  |
| Model Nick Name | txtModelNickName |  |
| Model | txtModel |  |
| Pancake Type | cbo_pancaketype |  |
| layoutControlItem13 | chk_release |  |
| Cell Type | cbo_celltype |  |
| lblSql | btnSql |  |
| Plan Info | btnPlanInfo |  |
| Plan Group | cbo_plan_group |  |
| Plan Period | dCalendar_planrange |  |
| Coater Plan: | lblPlanID |  |

## 그리드

- spdSub / PlanInfo: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0
- spdMain / Amend: 행 0 · 컬럼 25(보임 11) · 헤더 2단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-13 04:48:38.513 [] The End date can not be later than the planned date. → default_button(id=1)

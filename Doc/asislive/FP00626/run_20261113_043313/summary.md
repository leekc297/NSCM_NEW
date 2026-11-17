# AS-IS 실측 요약 — FP00626

- 실행: 2026-11-13 04:33:13.108 ~ 2026-11-13 04:37:35.686 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simulation(Assy) (GSCM.FP.Planning.UIL.FP00626_PancakeSimulation_Assy)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260918"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260917"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260916"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260915"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260914"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260913"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260912"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260911"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260910"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260909"}, {"name": "sCalendar_planday", "prop": "DateTime", "value": "20260908"}, {"name": "chk_release", "prop": "Checked", "value": "true"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:33:13.561 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 26.53 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:33:13.564 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:33:13, END_TIME=2026-11-13 04:33:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043313_534, PA |
| 04:33:13.956 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 04:33:13.974 | load | GSCM.FP_Common | SELECT * | 351 | 9.67 | USER_ID= |
| 04:33:13.983 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 8.75 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:33:14.278 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 131.88 | p_code=FP00626_findInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:14.304 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_CELL',@param2=N'',@param3=N'',@param4=N'', |
| 04:33:14.347 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.41 | p_code=FP00626_find_isPast, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:14.396 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.31 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_isPast',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 04:33:14.411 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.37 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:14.446 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.06 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 04:33:14.464 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 5.47 | p_code=FP00626_find_Unit, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:14.495 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_Unit',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@para |
| 04:33:14.510 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 4.44 | p_code=FP00626_find_cellType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:14.514 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_cellType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 04:33:14.556 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 4.12 | p_code=FP00626_find_pancakeType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:14.560 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_pancakeType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 04:33:14.598 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.43 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:33:14.606 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.61 | p_program_id=FP00626, p_sheet_name=Amend |
| 04:33:14.612 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:33:14.622 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 3.65 | p_program_id=FP00626, p_sheet_name=Amend |
| 04:33:14.644 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 04:33:14.651 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.67 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 04:33:14.657 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 04:33:14.664 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.84 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 04:33:14.756 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.23 | MenuID=Pancake Simulation(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 04:33:14.830 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.68 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 04:33:22.772 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 44.4 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:22.817 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.58 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260919',@param3=N'',@param4=N'',@param5= |
| 04:33:25.514 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.07 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260918, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:25.558 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.25 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260918',@param3=N'',@param4=N'',@param5= |
| 04:33:28.054 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.88 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260917, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:28.098 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260917',@param3=N'',@param4=N'',@param5= |
| 04:33:30.759 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.95 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260916, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:30.798 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.92 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260916',@param3=N'',@param4=N'',@param5= |
| 04:33:33.623 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.19 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260915, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:33.659 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260915',@param3=N'',@param4=N'',@param5= |
| 04:33:36.179 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.66 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260914, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:36.217 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.04 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260914',@param3=N'',@param4=N'',@param5= |
| 04:33:38.721 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.88 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260913, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:38.765 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260913',@param3=N'',@param4=N'',@param5= |
| 04:33:41.436 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.36 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260912, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:41.442 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260912',@param3=N'',@param4=N'',@param5= |
| 04:33:44.177 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 19.81 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260911, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:44.218 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.16 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260911',@param3=N'',@param4=N'',@param5= |
| 04:33:46.892 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.68 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260910, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:46.935 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260910',@param3=N'',@param4=N'',@param5= |
| 04:33:49.582 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.66 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260909, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:49.628 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.25 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260909',@param3=N'',@param4=N'',@param5= |
| 04:33:52.309 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.68 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260908, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:33:52.358 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.93 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260908',@param3=N'',@param4=N'',@param5= |
| 04:34:59.490 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 6.57 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=20260928, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:34:59.529 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'20260928',@param4=N'' |
| 04:34:59.544 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.93 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261112, param3=20260928, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:34:59.548 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261112',@param3=N'20260928',@param4=N'',@param5=N' |
| 04:34:59.560 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.24 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20260928, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:34:59.594 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260928',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:34:59.607 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.75 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20260928, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:34:59.658 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.89 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260928',@param3=N'',@param4=N'',@param5=N'',@para |
| 04:34:59.680 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.64 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261112, param2=20260928, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:34:59.717 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260928',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:34:59.743 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 4.54 | p_code=FP00626_find_measure, p_user_id=jaeuk.shin, param1=FP00626_Main, param2=jaeuk.shin, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:34:59.812 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 68.51 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00626_Main',@param2=N'jaeuk.shin',@param3=N'',@param4=N'',@par |
| 04:37:05.906 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 126082.47 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00626_PANCAKESIMULATION_ASSY, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^USER_ID^INSTANCE_ID^CONFIRM_AREA^SITE_ID^BUCKET_FROM^BUCKET_TO^CURR_DATE^UNIT^RELEASE_FLAG^CHK_PLANID^TOTAL_INCLUDE^CATE_INF |
| 04:37:05.927 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.78 | PROG_ID=PR_UI_FP00626_PANCAKESIMULATION_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR |
| 04:37:35.006 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 22.95 | MenuID=Pancake Simulation(Assy), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-13 04:33:55.893 [] The End date can not be later than the planned date. → default_button(id=1)

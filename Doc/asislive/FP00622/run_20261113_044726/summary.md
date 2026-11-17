# AS-IS 실측 요약 — FP00622

- 실행: 2026-11-13 04:47:26.897 ~ 2026-11-13 04:47:54.726 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(NJ_Pouch) (GSCM.FP.Planning.UIL.FP00622_PlanAmend_Line_NJ_Pouch)
- 조회 결과: Total : 297 · DB : 6.177s, UI : 0.6s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:47:27.220 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 28.79 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:47:27.225 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:47:27, END_TIME=2026-11-13 04:47:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044727_19, PAR |
| 04:47:27.354 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00622 |
| 04:47:27.368 | load | GSCM.FP_Common | SELECT * | 351 | 9.25 | USER_ID= |
| 04:47:27.372 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:47:27.493 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.92 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:47:27.496 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.89 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:47:27, END_TIME=2026-11-13 04:47:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044727_485, PA |
| 04:47:27.523 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 32 | 4.2 | USER_ID=jaeuk.shin, MENU_ID=FP00622_Amend |
| 04:47:27.568 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.31 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 04:47:27.579 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.47 | p_program_id=FP00622, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:27.633 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 50.84 | p_program_id=FP00622, p_sheet_name=Amend |
| 04:47:27.832 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 108.77 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:27.853 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.74 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'', |
| 04:47:27.950 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 58.11 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=00010101, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:27.955 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'00010101',@param3=N'',@param4=N'',@para |
| 04:47:27.996 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 21.83 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20261113, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:28.036 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.09 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20261113',@param3=N'',@param4=N'',@para |
| 04:47:28.127 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.01 | LOGTYPE=SpeedUp, NOTE=FP00622
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 04:47:28.130 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.43 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 04:47:28.155 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.64 | LOGTYPE=SpeedUp, NOTE=FP00622
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 04:47:28.159 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 04:47:28.180 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 3.75 | USER_ID=jaeuk.shin |
| 04:47:28.202 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.53 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 04:47:28.236 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.76 | p_program_id=FP00622, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:28.242 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.74 | p_program_id=FP00622, p_sheet_name=Amend |
| 04:47:28.248 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.56 | p_program_id=FP00622, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:28.255 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.88 | p_program_id=FP00622, p_sheet_name=Amend |
| 04:47:28.330 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 52.87 | MenuID=Plan Amend by Line(NJ_Pouch), CnntCode=0104001, UserID=jaeuk.shin |
| 04:47:28.389 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00622 |
| 04:47:36.820 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 59.51 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:36.844 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.89 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20260919',@param3=N'',@param4=N'',@para |
| 04:47:41.686 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 25.48 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=CN_CELL_M2-20260919-00, param3=A002, param4=PLAN GROUP, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:41.738 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'CN_CELL_M2-20260919-00',@param3=N'A002',@param4 |
| 04:47:41.759 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 5.54 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:41.796 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 04:47:41.810 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.11 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:41.861 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:47:41.890 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 5.14 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:41.915 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.06 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@para |
| 04:47:41.933 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 32 | 5.21 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:41.973 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.78 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:47:42.027 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 31.84 | p_code=FP00594_find_ListData_BOH, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=CN_CELL_M2-20260919-00, param3=20260919, param4=FP_AMEND_CUTOFF_BOH_R , param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, p |
| 04:47:42.073 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.24 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_ListData_BOH',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'CN_CELL_M2-20260919-00',@param3=N'202 |
| 04:47:42.527 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 66 | 431.98 | p_code=FP00594_find_ListData, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=CN_CELL_M2-20260919-00, param3=A5000,A7000,A7100,A8000,A8100,A8200,A9000, param4=FP_AMEND_PLAN_CELL_R, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, para |
| 04:47:42.546 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.1 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_ListData',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'CN_CELL_M2-20260919-00',@param3=N'A5000,A |
| 04:47:42.589 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 46 | 11.14 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00622_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:42.627 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.92 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00622_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 04:47:42.801 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4931 | 148.08 | p_code=FP00594_find_YieldInfo, p_user_id=jaeuk.shin, param1=40, param2=A002, param3=NJ01, param4=M4,M6, param5=A5000,A7000,A7100,A8000,A8100,A8200,A9000, param6=M4T01,M4T02,M4T03,M4T04,M6L16,M6L17,M6L18,M6L20,M6L21,M6L22,M6L23,M6L24,M6L25,M6L26,M6L27,M6L28,M6L29,M6L30,M6L31,M6L32,M6L33,M6L34,M6L61,M |
| 04:47:42.808 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.76 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_YieldInfo',@p_user_id=N'jaeuk.shin',@param1=N'40',@param2=N'A002',@param3=N'NJ01',@param4=N'M4,M6',@param5=N |
| 04:47:47.729 | find | GSCM.FP_Common | PR_UI_FP00622_AMEND_LINE | 297 | 4881.63 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_CELL_M2, p_company_id=, p_division_id=40, p_site_id=A002, p_plant_id=NJ01, p_factory_id=M4,M6, p_line_id=M4T01,M4T02,M4T03,M4T04,M6L16,M6L17,M6L18,M6L20,M6L21,M6L22,M6L23,M6L24,M6L25,M6L26,M6L27,M6L28,M6L |
| 04:47:47.748 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.19 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00622_AMEND_LINE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00622_AMEND_LINE @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_CELL_M2',@p_compan |
| 04:47:47.944 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 87.04 | INSTANCE_ID=CN_CELL_M2, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 04:47:47.951 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.06 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 04:47:47.993 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 28.48 | INSTANCE_ID=CN_CELL_M2 |
| 04:47:48.001 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.86 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 04:47:48.046 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 29.06 | USER_ID=jaeuk.shin |
| 04:47:48.053 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.02 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 04:47:48.083 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.44 | INSTANCE_ID=CN_CELL_M2 |
| 04:47:48.089 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.88 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 04:47:48.334 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 36.78 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:48.384 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.65 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 04:47:48.430 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.96 | p_menu_id=FP00622, p_log_type=FIND, p_log_cnt=, p_db_time=6.177, p_ui_time=0.6, p_user_id=jaeuk.shin |
| 04:47:53.996 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.91 | MenuID=Plan Amend by Line(NJ_Pouch), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Material | txtItem |  |
| NickName List | mcbo_nickname |  |
| Model | txtModel |  |
| layoutControlItem9 | chk_Info |  |
| Simulation | btnCal |  |
| Prod Type | mcbo_prodtype |  |
| Plan Group | cbo_plan_group |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Amend: 행 297 · 컬럼 53(보임 52) · 헤더 2단 · 고정 컬럼 19

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

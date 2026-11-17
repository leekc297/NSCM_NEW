# AS-IS 실측 요약 — FP00619

- 실행: 2026-11-12 19:04:25.106 ~ 2026-11-12 19:04:49.009 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Line(Formation) (GSCM.FP.Planning.UIL.FP00619_PlanBy_Line_Formation)
- 조회 결과: Total :  · DB : 7.345s, UI : 0.065s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:04:25.467 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.01 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:25.491 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:25, END_TIME=2026-11-12 19:04:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190425_458, PA |
| 19:04:25.564 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00619 |
| 19:04:25.580 | load | GSCM.FP_Common | SELECT * | 351 | 9.44 | USER_ID= |
| 19:04:25.584 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:04:25.764 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.51 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:25.769 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:25, END_TIME=2026-11-12 19:04:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190425_756, PA |
| 19:04:25.798 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 33 | 6.22 | USER_ID=jaeuk.shin, MENU_ID=FP00619_Amend |
| 19:04:25.827 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.74 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:04:25.836 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.39 | p_program_id=FP00619, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:25.844 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 16 | 4.62 | p_program_id=FP00619, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:25.969 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 26.81 | LOGTYPE=SpeedUp, NOTE=FP00619
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:04:25.973 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.37 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:04:26.110 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 117.24 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:04:26.114 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:25, END_TIME=2026-11-12 19:04:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190425_992, PA |
| 19:04:26.133 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.14 | LOGTYPE=SpeedUp, NOTE=FP00619
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:04:26.137 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:04:26.222 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 30.79 | p_code=FP00619_find_Model_List, p_user_id=jaeuk.shin, param1=, param2=, param3=81,82, param4=A001, param5=HQ07,HQ08, param6=A1,A2,A9,S2, param7=A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A2A10,A2A11,A2A13,A2A14,A9A01,S2E01, param8=F6000, param9=, param10=, param11=, param12=, param13= |
| 19:04:26.227 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00619_find_Model_List',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'81,82',@param4=N'A001',@param5=N'HQ07 |
| 19:04:26.319 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 77.3 | p_code=FP00619_find_NickName_List, p_user_id=jaeuk.shin, param1=, param2=, param3=81,82, param4=A001, param5=HQ07,HQ08, param6=A1,A2,A9,S2, param7=A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A2A10,A2A11,A2A13,A2A14,A9A01,S2E01, param8=F6000, param9=, param10=, param11=, param12=, param |
| 19:04:26.340 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00619_find_NickName_List',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'81,82',@param4=N'A001',@param5=N'H |
| 19:04:26.366 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.3 | p_program_id=FP00619, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:26.375 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 16 | 4.09 | p_program_id=FP00619, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:26.383 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00619, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:26.391 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 16 | 4.09 | p_program_id=FP00619, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:26.519 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 74.96 | MenuID=Plan by Line(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 19:04:26.690 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00619 |
| 19:04:35.476 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 4.43 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.508 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.25 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@ |
| 19:04:35.530 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 12.56 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261109, param3=20270103, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.573 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.23 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261109',@param3=N'20270103',@param4=N |
| 19:04:35.590 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 5.17 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261109, param3=20270103, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.630 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261109',@param3=N'20270103',@param4=N'',@param5=N' |
| 19:04:35.644 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 4.96 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.695 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:04:35.708 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 4.16 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.750 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.27 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:04:35.763 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 4.73 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.809 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.21 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:04:35.829 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 23 | 9.89 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00619_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:35.863 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00619_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 19:04:42.692 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 6817.26 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00619_PLANBY_LINE_FORMATION, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^CONFIRM_AREA^INSTANCE_ID^USE_WOW_STATUS^IS_SAME_PLAN_ID^DIVISION_ID^SITE_ID^PLANT_ID^FACTORY_ID^O |
| 19:04:42.705 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.92 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:04:35, END_TIME=2026-11-12 19:04:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190435_873, P |
| 19:04:42.710 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.63 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:04:35, END_TIME=2026-11-12 19:04:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190435_873, P |
| 19:04:42.714 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.24 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:04:35, END_TIME=2026-11-12 19:04:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190435_873, P |
| 19:04:42.719 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:04:35, END_TIME=2026-11-12 19:04:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190435_873, P |
| 19:04:42.723 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=4, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:04:35, END_TIME=2026-11-12 19:04:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190435_873, P |
| 19:04:42.727 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_ |
| 19:04:42.732 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.46 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=12-06 (SUN.)#DAY_SEQ:1#!IS_PLAN:Y#D_VALUE:D28#_DATE:20261207#_WEEK:202650#_MONTH:12#_DATE_TXT:2026-12-07 (Mon.)#DAY_SEQ:2#!IS_PLAN:Y#D_VALUE:D29#_DATE:20261208#_WEEK:202650#_MO |
| 19:04:42.737 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.39 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=#_NAME:2026-11-13 (Fri)#_COUNT:1#_VALUE:D4#_DATE_SEQ:1#WEEK_SEQ:202646#_TYPE:D#!_DATE:20261114#_NAME:2026-11-14 (Sat)#_COUNT:1#_VALUE:D5#_DATE_SEQ:1#WEEK_SEQ:202646#_TYPE:D#!_D |
| 19:04:42.741 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=E:D#!_DATE:202652#_NAME:2026W52#_COUNT:7#_VALUE:W6#_DATE_SEQ:1#WEEK_SEQ:202652#_TYPE:W#!_DATE:20261221#_NAME:2026-12-21 (Mon)#_COUNT:1#_VALUE:D42#_DATE_SEQ:1#WEEK_SEQ:202652#_T |
| 19:04:42.796 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.55 | PROG_ID=PR_UI_FP00619_PLANBY_LINE_FORMATION, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=4, QUERY_VALUE=n#USER_ID:jaeuk.shin#!MEA_ID:chk_wpp_outqty_tot#MEA_NAME:WPP Plan(Out)#MEA_VALUE:TRUE#TYPE:CATEGORY#FLAG:#MENU_ID:FP00619_Main#USER_ID:jaeuk.shin#^', JOB_TYPE=read, START_TIME= |
| 19:04:42.877 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.27 | p_menu_id=FP00619, p_log_type=FIND, p_log_cnt=, p_db_time=7.345, p_ui_time=0.065, p_user_id=jaeuk.shin |
| 19:04:48.274 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 29.87 | MenuID=Plan by Line(Formation), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Period | dCalendar_planrange |  |
| lblSql | btnSql |  |
| Div | mcbo_division |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem2 | chkInAct |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| Site | cbo_site |  |
| Include | chk_IncludeSubOp |  |
| Model List | mcbo_model_lt |  |
| Pjt Group Nm | txtPjtGroupName |  |
| Model | txtModel |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |
| Nick Nm List | mcbo_nickname_lt |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 84(보임 76) · 헤더 2단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

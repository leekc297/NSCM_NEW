# AS-IS 실측 요약 — FP00606

- 실행: 2026-11-12 23:36:45.629 ~ 2026-11-12 23:39:47.517 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Model(Elec) (GSCM.FP.Planning.UIL.FP00606_PlanBy_Model_Electrode)
- 조회 결과: Total : 174 · DB : 161.15s, UI : 0.796s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:36:45.941 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.28 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:36:45.946 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.39 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:36:45, END_TIME=2026-11-12 23:36:45, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233645_934, PA |
| 23:36:46.047 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00606 |
| 23:36:46.064 | load | GSCM.FP_Common | SELECT * | 351 | 12.8 | USER_ID= |
| 23:36:46.098 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.03 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:36:46.206 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 10.95 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:36:46.210 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.75 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:36:46, END_TIME=2026-11-12 23:36:46, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233646_195, PA |
| 23:36:46.336 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 34 | 109.79 | USER_ID=jaeuk.shin, MENU_ID=FP00606_Amend |
| 23:36:46.362 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.71 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 23:36:46.371 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.75 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:36:46.431 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 56.82 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:36:46.534 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.96 | LOGTYPE=SpeedUp, NOTE=FP00606
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 23:36:46.539 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.59 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:36:47.809 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 1254.2 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 23:36:47.813 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:36:46, END_TIME=2026-11-12 23:36:47, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233646_555, PA |
| 23:36:47.970 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 145.1 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 23:36:47.982 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:36:47, END_TIME=2026-11-12 23:36:47, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233647_825, PA |
| 23:36:48.140 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 149.61 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 23:36:48.181 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.91 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:36:47, END_TIME=2026-11-12 23:36:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233647_99, PAR |
| 23:36:48.196 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.47 | LOGTYPE=SpeedUp, NOTE=FP00606
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 23:36:48.201 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.17 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:36:48.259 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 34.82 | USER_ID=jaeuk.shin |
| 23:36:48.285 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.19 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 23:36:48.315 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.98 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:36:48.325 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 5.44 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:36:48.333 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:36:48.342 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 5.55 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:36:48.443 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 76.45 | MenuID=Plan by Model(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 23:36:48.512 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00606 |
| 23:36:58.459 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 207.23 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:58.485 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.28 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@ |
| 23:36:58.779 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 286.82 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:58.785 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20260831',@param3=N'20261025',@param4= |
| 23:36:58.802 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 8.52 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:58.879 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 77.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260831',@param3=N'20261025',@param4=N'',@param5=N' |
| 23:36:58.975 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 83.49 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:59.022 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 23:36:59.041 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 11.95 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:59.047 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.76 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 23:36:59.121 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 66.46 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:59.170 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@para |
| 23:36:59.353 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 34 | 171.32 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00606_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:36:59.382 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00606_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 23:36:59.559 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 170.34 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT |
| 23:36:59.603 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.8 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE_COL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_ETC', |
| 23:39:39.304 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 183 | 159693.27 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00606_FIND_FP00606, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_I |
| 23:39:39.328 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.91 | PROG_ID=PR_UI_FP00606_FIND_FP00606, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0060 |
| 23:39:39.392 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.83 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:39:39.435 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 38.82 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:39:39.601 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 144.27 | INSTANCE_ID=KR_E_PRE_A, BUCKET_FROM=20260831, BUCKET_TO=20261025 |
| 23:39:39.607 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.18 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 23:39:39.622 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 6.97 | USER_ID=jaeuk.shin |
| 23:39:39.668 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.19 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 23:39:39.681 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.17 | INSTANCE_ID=KR_E_PRE_A |
| 23:39:39.725 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.37 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 23:39:39.889 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 5 | 4.26 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:39:39.915 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.81 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 23:39:40.160 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 6.48 | p_menu_id=FP00606, p_log_type=FIND, p_log_cnt=, p_db_time=161.15, p_ui_time=0.796, p_user_id=jaeuk.shin |
| 23:39:46.705 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 42.94 | MenuID=Plan by Model(Elec), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | mcbo_division |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem2 | chkInAct |  |
| layoutControlItem11 | chk_allLine |  |
| Site | cbo_site |  |
| Include | chk_IncludeSubOp |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |
| Prod. Type | mcbo_prod_type |  |
| Plan Group | cbo_plan_group |  |
| Plan Period | dCalendar_planrange |  |

## 그리드

- spdMain / Amend: 행 174 · 컬럼 99(보임 97) · 헤더 2단 · 고정 컬럼 24

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

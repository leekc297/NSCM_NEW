# AS-IS 실측 요약 — FP00605

- 실행: 2026-11-12 18:48:50.384 ~ 2026-11-12 18:49:19.090 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Model(Formation) (GSCM.FP.Planning.UIL.FP00605_PlanBy_Model_Formation)
- 조회 결과: Total :  · DB : 11.66s, UI : 0.093s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:48:50.742 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 27.17 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:48:50.745 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.75 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:48:50, END_TIME=2026-11-12 18:48:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184850_714, PA |
| 18:48:50.843 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00605 |
| 18:48:50.861 | load | GSCM.FP_Common | SELECT * | 351 | 9.8 | USER_ID= |
| 18:48:50.865 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.2 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:48:51.031 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.96 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:48:51.036 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:48:51, END_TIME=2026-11-12 18:48:51, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184851_024, PA |
| 18:48:51.060 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 30 | 4.19 | USER_ID=jaeuk.shin, MENU_ID=FP00605_Amend |
| 18:48:51.118 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 57.92 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:48:51.127 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:51.136 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 4.19 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:51.224 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.35 | LOGTYPE=SpeedUp, NOTE=FP00605
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:48:51.247 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.62 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:48:51.444 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 180.95 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 18:48:51.453 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 8.71 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:48:51, END_TIME=2026-11-12 18:48:51, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184851_263, PA |
| 18:48:51.471 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.39 | LOGTYPE=SpeedUp, NOTE=FP00605
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:48:51.476 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.27 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:48:51.537 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.69 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:51.555 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 11.83 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:51.565 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.89 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:51.575 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 6.01 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:51.855 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 221.26 | MenuID=Plan by Model(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 18:48:52.018 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00605 |
| 18:49:01.492 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 7.14 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.528 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.52 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@ |
| 18:49:01.559 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.16 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261109, param3=20270103, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.572 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261109',@param3=N'20270103',@param4=N |
| 18:49:01.590 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 6.89 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261109, param3=20270103, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.593 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.7 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261109',@param3=N'20270103',@param4=N'',@param5=N' |
| 18:49:01.611 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 7.5 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.631 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:49:01.647 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 7.23 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.669 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@para |
| 18:49:01.686 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 8.41 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.690 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:49:01.711 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 30 | 10.58 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00605_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:01.738 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.58 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00605_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 18:49:12.883 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 11133.91 | p_sys_type=SELECT, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00605_FIND_FP00605, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^DIVISION_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_I |
| 18:49:12.904 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.03 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:49:01, END_TIME=2026-11-12 18:49:12, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184901_748, PARAM_VALU |
| 18:49:12.915 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.13 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:49:01, END_TIME=2026-11-12 18:49:12, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184901_748, PARAM_VALU |
| 18:49:12.920 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.8 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:49:01, END_TIME=2026-11-12 18:49:12, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184901_748, PARAM_VALU |
| 18:49:12.925 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.18 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:49:01, END_TIME=2026-11-12 18:49:12, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184901_748, PARAM_VALU |
| 18:49:12.979 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.58 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=4, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:49:01, END_TIME=2026-11-12 18:49:12, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184901_748, PARAM_VALU |
| 18:49:13.009 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.92 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00605_FIND_FP00 |
| 18:49:13.014 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.3 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=12-06 (SUN.)#DAY_SEQ:1#!IS_PLAN:Y#D_VALUE:D28#_DATE:20261207#_WEEK:202650#_MONTH:12#_DATE_TXT:2026-12-07 (Mon.)#DAY_SEQ:2#!IS_PLAN:Y#D_VALUE:D29#_DATE:20261208#_WEEK:202650#_MONTH:12#_D |
| 18:49:13.019 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=#_NAME:2026-11-13 (Fri)#_COUNT:1#_VALUE:D4#_DATE_SEQ:1#WEEK_SEQ:202646#_TYPE:D#!_DATE:20261114#_NAME:2026-11-14 (Sat)#_COUNT:1#_VALUE:D5#_DATE_SEQ:1#WEEK_SEQ:202646#_TYPE:D#!_DATE:20261 |
| 18:49:13.024 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.41 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=E:D#!_DATE:202652#_NAME:2026W52#_COUNT:7#_VALUE:W6#_DATE_SEQ:1#WEEK_SEQ:202652#_TYPE:W#!_DATE:20261221#_NAME:2026-12-21 (Mon)#_COUNT:1#_VALUE:D42#_DATE_SEQ:1#WEEK_SEQ:202652#_TYPE:D#!_D |
| 18:49:13.053 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.04 | PROG_ID=PR_UI_FP00605_FIND_FP00605, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=4, QUERY_VALUE=_ID:FP00605_Amend#USER_ID:jaeuk.shin#!MEA_ID:chk_subTotal#MEA_NAME:Sub Total#MEA_VALUE:TRUE#TYPE:CATEGORY#FLAG:#MENU_ID:FP00605_Amend#USER_ID:jaeuk.shin#!MEA_ID:chk_total#MEA_NAME:Total |
| 18:49:13.144 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.16 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:13.154 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 6.2 | p_program_id=FP00605, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:13.237 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.07 | p_menu_id=FP00605, p_log_type=FIND, p_log_cnt=, p_db_time=11.66, p_ui_time=0.093, p_user_id=jaeuk.shin |
| 18:49:18.450 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 43.27 | MenuID=Plan by Model(Formation), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 87(보임 86) · 헤더 2단 · 고정 컬럼 20

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

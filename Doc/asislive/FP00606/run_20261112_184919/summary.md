# AS-IS 실측 요약 — FP00606

- 실행: 2026-11-12 18:49:19.197 ~ 2026-11-12 18:50:01.125 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Model(Elec) (GSCM.FP.Planning.UIL.FP00606_PlanBy_Model_Electrode)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:49:19.637 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 34.27 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:49:19.642 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:49:19, END_TIME=2026-11-12 18:49:19, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184919_603, PA |
| 18:49:19.721 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00606 |
| 18:49:19.737 | load | GSCM.FP_Common | SELECT * | 351 | 10.87 | USER_ID= |
| 18:49:19.741 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.46 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:49:19.906 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.31 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:49:19.909 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:49:19, END_TIME=2026-11-12 18:49:19, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184919_898, PA |
| 18:49:19.946 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 34 | 4.96 | USER_ID=jaeuk.shin, MENU_ID=FP00606_Amend |
| 18:49:19.978 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.2 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:49:19.987 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.35 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:20.061 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 70.06 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:20.192 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 23.94 | LOGTYPE=SpeedUp, NOTE=FP00606
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:49:20.196 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.01 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:49:20.374 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 162.49 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 18:49:20.387 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.09 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:49:20, END_TIME=2026-11-12 18:49:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184920_212, PA |
| 18:49:20.514 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 116.36 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 18:49:20.518 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.08 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:49:20, END_TIME=2026-11-12 18:49:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184920_398, PA |
| 18:49:20.659 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 131.09 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 18:49:20.665 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:49:20, END_TIME=2026-11-12 18:49:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184920_528, PA |
| 18:49:20.682 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.53 | LOGTYPE=SpeedUp, NOTE=FP00606
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:49:20.686 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:49:20.763 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.96 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:20.778 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 4.12 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:20.787 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.14 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:20.796 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 4.26 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:49:20.936 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 75.35 | MenuID=Plan by Model(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 18:49:21.128 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00606 |
| 18:49:29.872 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 6.69 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:29.928 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.2 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@ |
| 18:49:29.957 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 19.22 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:29.984 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20260831',@param3=N'20261025',@param4= |
| 18:49:30.002 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 6.23 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:30.035 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260831',@param3=N'20261025',@param4=N'',@param5=N' |
| 18:49:30.054 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 8.35 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:30.096 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.38 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:49:30.115 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 8.98 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:30.152 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.08 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:49:30.168 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 6.89 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:30.213 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@para |
| 18:49:30.230 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 34 | 9.66 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00606_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:49:30.277 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00606_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 18:49:30.491 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 204.72 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT |
| 18:49:30.504 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.09 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE_COL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_ETC', |

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

- spdMain / Amend: 행 0 · 컬럼 24(보임 22) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

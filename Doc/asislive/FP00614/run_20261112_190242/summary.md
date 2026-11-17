# AS-IS 실측 요약 — FP00614

- 실행: 2026-11-12 19:02:42.405 ~ 2026-11-12 19:03:27.874 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Line(Elec) (GSCM.FP.Planning.UIL.FP00614_PlanBy_Line_Electrode)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:02:42.780 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 31.33 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:02:42.783 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.12 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:02:42, END_TIME=2026-11-12 19:02:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190242_749, PA |
| 19:02:42.876 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00614 |
| 19:02:42.899 | load | GSCM.FP_Common | SELECT * | 351 | 16.64 | USER_ID= |
| 19:02:42.905 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.86 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:02:43.092 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.41 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:02:43.096 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:02:43, END_TIME=2026-11-12 19:02:43, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190243_083, PA |
| 19:02:43.122 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 35 | 4.83 | USER_ID=jaeuk.shin, MENU_ID=FP00614_Amend |
| 19:02:43.126 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.27 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:02:43.134 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.86 | p_program_id=FP00614, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:43.165 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 27.47 | p_program_id=FP00614, p_sheet_name=Amend |
| 19:02:43.324 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.98 | LOGTYPE=SpeedUp, NOTE=FP00614
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:02:43.328 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.8 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:02:43.457 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 114.68 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 19:02:43.477 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:02:43, END_TIME=2026-11-12 19:02:43, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190243_342, PA |
| 19:02:43.493 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.2 | LOGTYPE=SpeedUp, NOTE=FP00614
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:02:43.498 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.09 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:02:43.588 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.97 | p_program_id=FP00614, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:43.597 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 4.2 | p_program_id=FP00614, p_sheet_name=Amend |
| 19:02:43.606 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP00614, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:43.617 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 3.86 | p_program_id=FP00614, p_sheet_name=Amend |
| 19:02:43.766 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 91.91 | MenuID=Plan by Line(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 19:02:43.968 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00614 |
| 19:02:52.909 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 5.03 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:52.916 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@ |
| 19:02:52.937 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 13.0 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:52.941 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20260831',@param3=N'20261025',@param4= |
| 19:02:52.954 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 4.23 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:52.976 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.55 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260831',@param3=N'20261025',@param4=N'',@param5=N' |
| 19:02:53.004 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 16.44 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:53.039 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:02:53.056 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 4.05 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:53.098 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.39 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:02:53.114 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 4.77 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:53.158 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:02:53.177 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 35 | 10.03 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00614_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:02:53.215 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.14 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00614_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 19:02:53.240 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 17.79 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^DIVISION_ID^SITE_ID^PLANT_ID^PROD_TYPE^FACTORY_ |
| 19:02:53.244 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.46 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE_COL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_ETC', |
| 19:03:21.221 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 199 | 27968.79 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00614_FIND_FP00614, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^DIVISION_ID^SITE_ID^PLANT_ID^PROD_TYPE^F |
| 19:03:21.226 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.09 | PROG_ID=PR_UI_FP00614_FIND_FP00614, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0061 |
| 19:03:21.292 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.48 | p_program_id=FP00614, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:03:21.325 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 28.91 | p_program_id=FP00614, p_sheet_name=Amend |
| 19:03:21.409 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 48.9 | INSTANCE_ID=KR_E_PRE_A, BUCKET_FROM=20260831, BUCKET_TO=20261025 |
| 19:03:21.415 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.78 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 19:03:21.430 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 5.86 | USER_ID=jaeuk.shin |
| 19:03:21.467 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.61 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 19:03:21.480 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.23 | INSTANCE_ID=KR_E_PRE_A |
| 19:03:21.528 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.08 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 19:03:21.640 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 5 | 8.9 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:21.689 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 19:03:21.747 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 27.79 | p_menu_id=FP00614, p_log_type=FIND, p_log_cnt=, p_db_time=28.429, p_ui_time=0.445, p_user_id=jaeuk.shin |
| 19:03:27.208 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 69.45 | MenuID=Plan by Line(Elec), CnntCode=0104002, UserID=jaeuk.shin |

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
| Material | txtItem |  |
| Nick Nm List | mcbo_nickname_lt |  |
| Prod. Type | mcbo_prod_type |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Amend: 행 192 · 컬럼 96(보임 95) · 헤더 2단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

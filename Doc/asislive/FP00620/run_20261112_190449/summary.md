# AS-IS 실측 요약 — FP00620

- 실행: 2026-11-12 19:04:49.112 ~ 2026-11-12 19:05:08.321 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Line(Elec) Production (GSCM.FP.Planning.UIL.FP00620_PlanBy_Line_Electrode_Production)
- 조회 결과: Total :  · DB : 2.48s, UI : 0.129s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:04:49.409 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.23 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:49.413 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.2 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:49, END_TIME=2026-11-12 19:04:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190449_402, PA |
| 19:04:49.500 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.3 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00620 |
| 19:04:49.517 | load | GSCM.FP_Common | SELECT * | 351 | 9.49 | USER_ID= |
| 19:04:49.520 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.38 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:04:49.719 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.33 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:49.723 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:49, END_TIME=2026-11-12 19:04:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190449_709, PA |
| 19:04:49.752 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 19 | 4.15 | USER_ID=jaeuk.shin, MENU_ID=FP00620_Amend |
| 19:04:49.781 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.44 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:04:49.789 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.06 | p_program_id=FP00620, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:49.834 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 40.75 | p_program_id=FP00620, p_sheet_name=Amend |
| 19:04:49.998 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.75 | LOGTYPE=SpeedUp, NOTE=FP00620
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:04:50.002 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.79 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:04:50.169 | load | GSCM.FP_Common | SELECT B.TARGET_WEEK | 2 | 145.96 | INSTANCE_ID=KR_E_PRE_A |
| 19:04:50.188 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.38 | PROG_ID=find_PlanPeriod, QUERY_ID=FP\Planning\FP00620, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client |
| 19:04:50.326 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 112.48 | p_code=find_Block_End_Date, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20261112, param3=jaeuk.shin, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:50.370 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.92 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_Block_End_Date',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20261112',@param3=N'jaeuk.shin',@param4=N'' |
| 19:04:50.488 | load | GSCM.FP_Common | SELECT B.TARGET_WEEK | 2 | 112.25 | INSTANCE_ID=KR_E_PRE_A |
| 19:04:50.493 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=find_PlanPeriod, QUERY_ID=FP\Planning\FP00620, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client |
| 19:04:50.536 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 35.74 | LOGTYPE=SpeedUp, NOTE=FP00620
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:04:50.540 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.6 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:04:50.609 | load | GSCM.FP_Common | SELECT 	A.SEGMENT4 AS UI_COLOR, A.ATTRIBUTE2 AS UI_DESC | 5 | 5.78 | INSTANCE_ID=KR_E_PRE_A |
| 19:04:50.635 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.15 | PROG_ID=find_SetupColor_P, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check clie |
| 19:04:50.676 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.87 | p_program_id=FP00620, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:50.684 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 4.62 | p_program_id=FP00620, p_sheet_name=Amend |
| 19:04:50.693 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.0 | p_program_id=FP00620, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:50.705 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 7.01 | p_program_id=FP00620, p_sheet_name=Amend |
| 19:04:50.832 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 68.16 | MenuID=Plan by Line(Elec) Production, CnntCode=0104001, UserID=jaeuk.shin |
| 19:04:51.022 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00620 |
| 19:04:59.789 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 42.25 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=A001, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:59.820 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.6 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'A001',@param4=N'BUILDING',@param5=N |
| 19:04:59.852 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 19.24 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20261109, param3=20270103, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:59.880 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.04 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20261109',@param3=N'20270103',@param4= |
| 19:04:59.898 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 7.28 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261109, param3=20270103, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:59.937 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261109',@param3=N'20270103',@param4=N'',@param5=N' |
| 19:04:59.951 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 5.2 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:59.956 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.44 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:04:59.970 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 4.58 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:59.997 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.83 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:05:00.012 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 6.28 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261109, param2=20270103, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:05:00.061 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.1 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20270103',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:05:00.085 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 19 | 11.36 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00620_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:05:00.120 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.08 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00620_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 19:05:00.152 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 24.49 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT |
| 19:05:00.157 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.11 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE_COL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_ETC', |
| 19:05:02.136 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 1971.39 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00620_FIND_FP00620, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_I |
| 19:05:02.151 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.88 | PROG_ID=PR_UI_FP00620_FIND_FP00620, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0062 |
| 19:05:02.215 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.81 | p_program_id=FP00620, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:05:02.225 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 5.32 | p_program_id=FP00620, p_sheet_name=Amend |
| 19:05:02.303 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.49 | p_menu_id=FP00620, p_log_type=FIND, p_log_cnt=, p_db_time=2.48, p_ui_time=0.129, p_user_id=jaeuk.shin |
| 19:05:07.676 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.44 | MenuID=Plan by Line(Elec) Production, CnntCode=0104002, UserID=jaeuk.shin |

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
| Plan Period | dCalendar_planrange |  |
| Zoom | usrCombo_Zoom |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem4 | chk_totalBatch |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 96(보임 95) · 헤더 2단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

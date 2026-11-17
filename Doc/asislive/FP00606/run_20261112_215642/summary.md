# AS-IS 실측 요약 — FP00606

- 실행: 2026-11-12 21:56:42.377 ~ 2026-11-12 21:57:27.180 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Model(Elec) (GSCM.FP.Planning.UIL.FP00606_PlanBy_Model_Electrode)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:56:42.769 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.49 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:56:42.772 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:56:42, END_TIME=2026-11-12 21:56:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215642_762, PA |
| 21:56:42.840 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.54 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00606 |
| 21:56:42.855 | load | GSCM.FP_Common | SELECT * | 351 | 10.66 | USER_ID= |
| 21:56:42.860 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.34 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:56:42.950 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.3 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:56:42.954 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.44 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:56:42, END_TIME=2026-11-12 21:56:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215642_942, PA |
| 21:56:42.992 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 34 | 25.53 | USER_ID=jaeuk.shin, MENU_ID=FP00606_Amend |
| 21:56:43.027 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.27 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:56:43.035 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.43 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:43.099 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 61.16 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:43.185 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 21.88 | LOGTYPE=SpeedUp, NOTE=FP00606
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 21:56:43.189 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:56:44.411 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 1211.96 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 21:56:44.424 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.47 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:56:43, END_TIME=2026-11-12 21:56:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215643_198, PA |
| 21:56:44.571 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 138.66 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 21:56:44.587 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.32 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:56:44, END_TIME=2026-11-12 21:56:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215644_432, PA |
| 21:56:44.726 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 131.66 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 21:56:44.744 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:56:44, END_TIME=2026-11-12 21:56:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215644_594, PA |
| 21:56:44.757 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.58 | LOGTYPE=SpeedUp, NOTE=FP00606
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 21:56:44.762 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:56:44.798 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.0 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:44.807 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 5.69 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:44.817 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.18 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:44.827 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 7.51 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:44.920 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 67.88 | MenuID=Plan by Model(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 21:56:44.976 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00606 |
| 21:56:54.116 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 5.64 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.121 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@ |
| 21:56:54.145 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 18.49 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.174 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.44 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20260831',@param3=N'20261025',@param4= |
| 21:56:54.187 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 5.4 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260831, param3=20261025, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.191 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260831',@param3=N'20261025',@param4=N'',@param5=N' |
| 21:56:54.221 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 22.93 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.282 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:56:54.296 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 7.85 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.337 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.57 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:56:54.350 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 6.61 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260831, param2=20261025, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.354 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260831',@param2=N'20261025',@param3=N'',@param4=N'',@param5=N'',@para |
| 21:56:54.372 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 34 | 11.36 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00606_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:54.397 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.66 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00606_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 21:56:54.467 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 65.35 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT |
| 21:56:54.471 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.49 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
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

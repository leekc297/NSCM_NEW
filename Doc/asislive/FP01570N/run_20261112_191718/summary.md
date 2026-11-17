# AS-IS 실측 요약 — FP01570N

- 실행: 2026-11-12 19:17:18.832 ~ 2026-11-12 19:17:39.341 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan ID History (GSCM.FP.Master.UIL.FP01570_PlanID_History)
- 조회 결과: Total :  · DB : 1.337s, UI : 0.015s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:17:19.184 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.81 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:17:19.186 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.74 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:19, END_TIME=2026-11-12 19:17:19, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191719_176, PA |
| 19:17:19.330 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01570 |
| 19:17:19.347 | load | GSCM.FP_Common | SELECT * | 351 | 9.59 | USER_ID= |
| 19:17:19.352 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.97 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:17:19.666 | load | GSCM.FP_Common | UI_FP_COMMON | 61 | 132.98 | code=INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:17:19.670 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:19, END_TIME=2026-11-12 19:17:19, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191719_533, PA |
| 19:17:20.076 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 24.83 | code=LOOKUP_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PLAN_TYPE, param22=, param23=, param24=, |
| 19:17:20.094 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:20, END_TIME=2026-11-12 19:17:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191720_05, PAR |
| 19:17:20.792 | load | GSCM.FP_Common | UI_FP_COMMON | 60 | 634.44 | code=FP_PLAN_WEEK, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:17:20.795 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.96 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:20, END_TIME=2026-11-12 19:17:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191720_157, PA |
| 19:17:21.200 | load | GSCM.FP_Common | UI_FP_COMMON | 10 | 30.68 | code=WEEK_EXP, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=Y, param23=, param24=, param25=,  |
| 19:17:21.255 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.93 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:21, END_TIME=2026-11-12 19:17:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191721_169, PA |
| 19:17:21.273 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 6.81 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:17:21.277 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.32 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:21, END_TIME=2026-11-12 19:17:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191721_266, PA |
| 19:17:21.486 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 194.27 | code=FP_PLAN_INFO, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_E_POST, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24= |
| 19:17:21.489 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.72 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:21, END_TIME=2026-11-12 19:17:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191721_291, PA |
| 19:17:21.546 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.8 | p_program_id=FP01570, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:17:21.577 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 37 | 25.09 | p_program_id=FP01570, p_sheet_name=Main |
| 19:17:21.586 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.73 | p_program_id=FP01570, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:17:21.595 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 37 | 5.04 | p_program_id=FP01570, p_sheet_name=Main |
| 19:17:21.790 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.53 | MenuID=Plan ID History, CnntCode=0104001, UserID=jaeuk.shin |
| 19:17:21.922 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01570 |
| 19:17:31.472 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.41 | p_program_id=FP01570, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:17:31.482 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 37 | 5.86 | p_program_id=FP01570, p_sheet_name=Main |
| 19:17:31.491 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.17 | p_program_id=FP01570, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:17:31.500 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 37 | 4.98 | p_program_id=FP01570, p_sheet_name=Main |
| 19:17:32.833 | find | GSCM.FP_Common | PR_UI_FP01570_PLANID_HISTORY | 0 | 1299.7 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_E_POST, p_plan_id=, p_plan_type=, p_plan_week=, p_due_from_date=20261105, p_due_to_date=20261112, p_last_release_flag=N |
| 19:17:32.845 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.51 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01570_PLANID_HISTORY, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01570_PLANID_HISTORY @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_E_POST',@p_plan_id=N' |
| 19:17:32.876 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.69 | p_menu_id=FP01570, p_log_type=FIND, p_log_cnt=, p_db_time=1.337, p_ui_time=0.015, p_user_id=jaeuk.shin |
| 19:17:38.465 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.97 | MenuID=Plan ID History, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plan Type | cboPlanType |  |
| FP Plan ID | cboPlanID |  |
| Plan Group | cboInstance |  |
| Plan Week | cboPlanWeek |  |
| Period | drpPeriod |  |
| Target | chkLastReleaseFlag |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 38(보임 37) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

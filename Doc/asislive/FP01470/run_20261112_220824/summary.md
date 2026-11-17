# AS-IS 실측 요약 — FP01470

- 실행: 2026-11-12 22:08:24.413 ~ 2026-11-12 22:09:14.834 · 계정 jaeuk.shin · 상태 OK
- 화면: Order Tracking (GSCM.FP.Analysis.UIL.FP01470_OrderTracking)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "dtpPlanDate", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:08:25.052 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01470 |
| 22:08:25.071 | load | GSCM.FP_Common | SELECT * | 351 | 10.27 | USER_ID= |
| 22:08:25.075 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:08:25.165 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.61 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:08:25.172 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.9 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:08:25, END_TIME=2026-11-12 22:08:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220825_158, PA |
| 22:08:25.602 | load | GSCM.FP_Common | UI_FP_COMMON | 52 | 390.02 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param |
| 22:08:25.605 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:08:25, END_TIME=2026-11-12 22:08:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220825_211, PA |
| 22:08:25.705 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 19.19 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:08:25.710 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 22:08:25.731 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.1 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:08:25.762 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 27.32 | p_program_id=FP01470, p_sheet_name=Main |
| 22:08:25.768 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.81 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:08:25.776 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 4.22 | p_program_id=FP01470, p_sheet_name=Main |
| 22:08:25.795 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.37 | p_program_id=FP01470, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 22:08:25.802 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 3.99 | p_program_id=FP01470, p_sheet_name=Sub |
| 22:08:25.809 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.25 | p_program_id=FP01470, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 22:08:25.816 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 3.73 | p_program_id=FP01470, p_sheet_name=Sub |
| 22:08:25.970 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 57.56 | MenuID=Order Tracking, CnntCode=0104001, UserID=jaeuk.shin |
| 22:08:26.035 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01470 |
| 22:08:34.581 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 64.14 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:08:34.609 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260919',@param3=N'',@param4=N'',@param5= |
| 22:08:39.362 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:08:39.370 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 3.82 | p_program_id=FP01470, p_sheet_name=Main |
| 22:08:39.377 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.77 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:08:39.385 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 4.38 | p_program_id=FP01470, p_sheet_name=Main |
| 22:09:08.765 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 29270.95 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01470_ORDERTRACKING, opt_none=, in_columns=INSTANCE_ID^PLAN_DATE^PLAN_ID^, in_row=KR_CELL^20260919^KR_CELL-20260919-00^ |
| 22:09:08.769 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.74 | PROG_ID=PR_UI_FP01470_ORDERTRACKING, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP014 |
| 22:09:08.972 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 100.23 | p_menu_id=FP01470, p_log_type=FIND, p_log_cnt=, p_db_time=29.367, p_ui_time=0.019, p_user_id=jaeuk.shin |
| 22:09:14.088 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.88 | MenuID=Order Tracking, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem4 | btnSql |  |
| Plan Group | cboInstance |  |
| Plan Date | dtpPlanDate |  |
| Material | txtItemId |  |
| FP Plan ID | cboPlanID |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0
- spdSub / Sub: 행 0 · 컬럼 21(보임 20) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

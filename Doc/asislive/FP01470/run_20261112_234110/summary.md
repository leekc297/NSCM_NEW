# AS-IS 실측 요약 — FP01470

- 실행: 2026-11-12 23:41:10.027 ~ 2026-11-12 23:41:34.442 · 계정 jaeuk.shin · 상태 OK
- 화면: Order Tracking (GSCM.FP.Analysis.UIL.FP01470_OrderTracking)
- 조회 결과: Total :  · DB : 1.107s, UI : 0.124s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "dtpPlanDate", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:41:10.462 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01470 |
| 23:41:10.479 | load | GSCM.FP_Common | SELECT * | 351 | 9.87 | USER_ID= |
| 23:41:10.483 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.38 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:41:10.528 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.29 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:41:10.565 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.82 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:41:10, END_TIME=2026-11-12 23:41:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234110_52, PAR |
| 23:41:11.033 | load | GSCM.FP_Common | UI_FP_COMMON | 52 | 431.41 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param |
| 23:41:11.038 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:41:10, END_TIME=2026-11-12 23:41:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234110_6, PARA |
| 23:41:11.572 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 377.33 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:41:11.577 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 23:41:11.594 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.0 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:41:11.636 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 38.37 | p_program_id=FP01470, p_sheet_name=Main |
| 23:41:11.643 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.4 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:41:11.653 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 6.61 | p_program_id=FP01470, p_sheet_name=Main |
| 23:41:11.666 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 7.89 | p_program_id=FP01470, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 23:41:11.675 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 5.44 | p_program_id=FP01470, p_sheet_name=Sub |
| 23:41:11.693 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.56 | p_program_id=FP01470, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 23:41:11.701 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 5.12 | p_program_id=FP01470, p_sheet_name=Sub |
| 23:41:11.802 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.2 | MenuID=Order Tracking, CnntCode=0104001, UserID=jaeuk.shin |
| 23:41:11.850 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.51 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01470 |
| 23:41:20.654 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 90.43 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:41:20.686 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.58 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260919',@param3=N'',@param4=N'',@param5= |
| 23:41:25.964 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.03 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:41:25.973 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 5.7 | p_program_id=FP01470, p_sheet_name=Main |
| 23:41:25.982 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.61 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:41:25.994 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 6.02 | p_program_id=FP01470, p_sheet_name=Main |
| 23:41:27.098 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 1000.95 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01470_ORDERTRACKING, opt_none=, in_columns=INSTANCE_ID^PLAN_DATE^PLAN_ID^, in_row=KR_CELL^20260919^KR_CELL-20260919-00^ |
| 23:41:27.128 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.26 | PROG_ID=PR_UI_FP01470_ORDERTRACKING, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP014 |
| 23:41:27.331 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.61 | p_menu_id=FP01470, p_log_type=FIND, p_log_cnt=, p_db_time=1.107, p_ui_time=0.124, p_user_id=jaeuk.shin |
| 23:41:33.522 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.02 | MenuID=Order Tracking, CnntCode=0104002, UserID=jaeuk.shin |

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

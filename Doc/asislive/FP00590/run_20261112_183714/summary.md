# AS-IS 실측 요약 — FP00590

- 실행: 2026-11-12 18:37:14.893 ~ 2026-11-12 18:37:38.435 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Control (GSCM.FP.Planning.UIL.FP00590_Plan_Control)
- 조회 결과: Total : 4 · DB : 5.125s, UI : 0.067s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:37:15.316 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 14.69 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:37:15.319 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.29 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:37:15, END_TIME=2026-11-12 18:37:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183715_3, PARA |
| 18:37:15.456 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00590 |
| 18:37:15.473 | load | GSCM.FP_Common | SELECT * | 351 | 10.44 | USER_ID= |
| 18:37:15.519 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.73 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:37:16.172 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 506.92 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, para |
| 18:37:16.175 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.86 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:37:15, END_TIME=2026-11-12 18:37:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183715_665, PA |
| 18:37:16.989 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 753.8 | p_code=FP00590_findInstance, p_user_id=jaeuk.shin, param1=A001, param2=INSTANCE_ID, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:17.030 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_findInstance',@p_user_id=N'jaeuk.shin',@param1=N'A001',@param2=N'INSTANCE_ID',@param3=N'',@param4=N'',@param5=N'' |
| 18:37:17.339 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 218.3 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:17.404 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.74 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 18:37:17.593 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 178.46 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:17.730 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 137.37 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 18:37:17.753 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.13 | p_program_id=FP00590, p_sheet_name=PlanControl, p_user_id=jaeuk.shin |
| 18:37:17.835 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 32 | 77.74 | p_program_id=FP00590, p_sheet_name=PlanControl |
| 18:37:17.844 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.25 | p_program_id=FP00590, p_sheet_name=PlanControl, p_user_id=jaeuk.shin |
| 18:37:17.860 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 32 | 4.99 | p_program_id=FP00590, p_sheet_name=PlanControl |
| 18:37:17.880 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00590, p_sheet_name=EngineRun, p_user_id=jaeuk.shin |
| 18:37:17.914 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 10 | 29.75 | p_program_id=FP00590, p_sheet_name=EngineRun |
| 18:37:17.922 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.17 | p_program_id=FP00590, p_sheet_name=EngineRun, p_user_id=jaeuk.shin |
| 18:37:17.931 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 10 | 3.81 | p_program_id=FP00590, p_sheet_name=EngineRun |
| 18:37:18.282 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 295.84 | MenuID=Plan Control, CnntCode=0104001, UserID=jaeuk.shin |
| 18:37:18.394 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00590 |
| 18:37:31.754 | find | GSCM.FP_Common | PR_UI_FP00590_PLAN_CONTROL | 4 | 4778.92 | p_sys_type=SELECT, p_sys_flag=SELECT_CONTROL, p_sys_gubun=, p_user_id=jaeuk.shin, p_site_id=A001, p_instance_id=KR_E_PRE_A, p_plan_date=20261112, p_plan_id=, p_plan_type=, p_plan_horizon=, p_demand_horizon=, p_basis_plan_id=, p_pre_fix_flag=, p_pre_fix_target_id=, p_sync_operation=, p_description=,  |
| 18:37:31.866 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 111.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00590_PLAN_CONTROL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00590_PLAN_CONTROL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_CONTROL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_site_id=N'A001',@p_instance_ |
| 18:37:31.987 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 35.08 | p_menu_id=FP00590, p_log_type=FIND, p_log_cnt=4, p_db_time=5.125, p_ui_time=0.067, p_user_id=jaeuk.shin |
| 18:37:32.195 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 198.99 | p_code=FP00590_findRevision, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:32.206 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_findRevision',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 18:37:32.591 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 366.41 | p_code=FP00590_find_runValidationMaster, p_user_id=jaeuk.shin, param1=20261112, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:32.620 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_runValidationMaster',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'',@param3=N'',@param4=N'',@param |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem8 | usrLabel2 |  |
| Site | cboSite |  |
| Plan Group | cboPlanGroup |  |
| Plan Date | dtpPlanDate |  |
| WOW Status | btnWowStatus |  |
| Find | btnFind |  |
| layoutControlItem6 | chkStatus |  |
| layoutControlItem7 | usrLabel1 |  |
| Plan Info | btnPlanInfo |  |

## 그리드

- spdMain / PlanControl: 행 4 · 컬럼 33(보임 11) · 헤더 2단 · 고정 컬럼 0
- spdSub / EngineRun: 행 0 · 컬럼 11(보임 6) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:37:33.206 [GSCM] 다시 확인하여 주십시오. not run master validation today → default_button(id=1)

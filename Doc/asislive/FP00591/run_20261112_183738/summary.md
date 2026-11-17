# AS-IS 실측 요약 — FP00591

- 실행: 2026-11-12 18:37:38.539 ~ 2026-11-12 18:37:56.554 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Control(Integration) (GSCM.FP.Planning.UIL.FP00591_Plan_Control_Integration)
- 조회 결과: Total : 4 · DB : 0.427s, UI : 0.002s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:37:39.187 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 260.1 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:37:39.191 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:37:38, END_TIME=2026-11-12 18:37:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183738_927, PA |
| 18:37:39.414 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.31 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00591 |
| 18:37:39.429 | load | GSCM.FP_Common | SELECT * | 351 | 9.83 | USER_ID= |
| 18:37:39.440 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.82 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:37:39.999 | load | GSCM.FP_Common | SELECT SITE_ID AS CODE, | 1 | 446.79 | USER_ID=jaeuk.shin |
| 18:37:40.018 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.38 | PROG_ID=findSiteList, QUERY_ID=FP\Planning\FP00591, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

        SELECT SITE_ID AS CODE,
        	   '(' + SITE_ID + ')' + CASE WHEN SITE_NAME |
| 18:37:40.036 | load | GSCM.FP_Common | SELECT A.SEGMENT1 AS CODE, A.SEGMENT1 AS NAME, MAX(A.SEGMENT2) AS INSTANCE_ID | 1 | 5.07 | SITE_ID=A003 |
| 18:37:40.079 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.79 | PROG_ID=findTotalInstanceList, QUERY_ID=FP\Planning\FP00591, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0SITE_ID
---Check client parameter : USER_ID
---Check client parameter : SITE_ID
---FOUND SITE_ID
-- TYPE = nvarchar---Add string Service

          SELECT A.SEGMENT1 AS CODE, A.S |
| 18:37:40.408 | load | GSCM.FP_Common | SELECT A.SEGMENT1 AS CODE, A.SEGMENT2 AS NAME | 0 | 317.26 | USER_ID=jaeuk.shin, SITE_ID=A003, INTG_PLAN_ID=UC_FORM_A |
| 18:37:40.474 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 65.85 | PROG_ID=findInstanceList, QUERY_ID=FP\Planning\FP00591, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0SITE_ID
---Service Parameter : 1USER_ID
---Service Parameter : 2INTG_PLAN_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check clie |
| 18:37:40.749 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 265.15 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=UC_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:40.821 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 73.24 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'UC_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 18:37:40.914 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 83.27 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=UC_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:41.017 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 102.31 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'UC_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 18:37:41.035 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP00591, p_sheet_name=PlanControl, p_user_id=jaeuk.shin |
| 18:37:41.091 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 32 | 52.37 | p_program_id=FP00591, p_sheet_name=PlanControl |
| 18:37:41.099 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.53 | p_program_id=FP00591, p_sheet_name=PlanControl, p_user_id=jaeuk.shin |
| 18:37:41.107 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 32 | 4.28 | p_program_id=FP00591, p_sheet_name=PlanControl |
| 18:37:41.132 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.47 | p_program_id=FP00591, p_sheet_name=EngineRun, p_user_id=jaeuk.shin |
| 18:37:41.140 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 10 | 3.63 | p_program_id=FP00591, p_sheet_name=EngineRun |
| 18:37:41.148 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.97 | p_program_id=FP00591, p_sheet_name=EngineRun, p_user_id=jaeuk.shin |
| 18:37:41.157 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 10 | 6.08 | p_program_id=FP00591, p_sheet_name=EngineRun |
| 18:37:41.541 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 341.55 | MenuID=Plan Control(Integration), CnntCode=0104001, UserID=jaeuk.shin |
| 18:37:41.678 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00591 |
| 18:37:50.106 | find | GSCM.FP_Common | PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | 4 | 187.9 | p_sys_type=SELECT, p_sys_flag=SELECT_CONTROL, p_sys_gubun=, p_user_id=jaeuk.shin, p_site_id=A003, p_instance_id=UC1, p_plan_date=20261111, p_plan_id=, p_plan_type=, p_plan_horizon=, p_demand_horizon=, p_basis_plan_id=, p_pre_fix_flag=, p_pre_fix_target_id=, p_sync_operation=, p_description=, p_pre_f |
| 18:37:50.118 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00591_PLAN_CONTROL_INTEGRATION @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_CONTROL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_site |
| 18:37:50.136 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.66 | p_menu_id=FP00591, p_log_type=FIND, p_log_cnt=4, p_db_time=0.427, p_ui_time=0.002, p_user_id=jaeuk.shin |
| 18:37:50.394 | find | GSCM.FP_Common | SELECT A.INTG_PLAN_ID AS CODE, A.INTG_PLAN_ID AS NAME | 0 | 250.09 | INSTANCE_ID=UC1, PLAN_DATE=20261111 |
| 18:37:50.434 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.75 | PROG_ID=findTotalPlanList, QUERY_ID=FP\Planning\FP00591, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : USER_ID
---Check client parameter : SITE_ID
---Check client parameter : INTG_PLAN_ID
---Check client paramet |
| 18:37:50.510 | find | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 67.92 | INTG_PLAN_ID=, PLAN_DATE=20261111 |
| 18:37:50.637 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 127.58 | PROG_ID=findPlanList, QUERY_ID=FP\Planning\FP00591, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INTG_PLAN_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : USER_ID
---Check client parameter : SITE_ID
---Check client parameter : INTG_PLAN_ID
---FOUND INTG_PLAN_ID
-- TY |
| 18:37:50.667 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 8.05 | p_code=FP00590_find_runValidationMaster, p_user_id=jaeuk.shin, param1=20261111, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:37:50.676 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 8.28 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_runValidationMaster',@p_user_id=N'jaeuk.shin',@param1=N'20261111',@param2=N'',@param3=N'',@param4=N'',@param |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem8 | usrLabel2 |  |
| Site | cboSite |  |
| Plan Group | cboPlanGroup |  |
| Plan Date | dtpPlanDate |  |
| Find | btnFind |  |
| layoutControlItem6 | chkStatus |  |
| layoutControlItem7 | usrLabel1 |  |
| Plan Info | btnPlanInfo |  |

## 그리드

- spdMain / PlanControl: 행 4 · 컬럼 33(보임 11) · 헤더 2단 · 고정 컬럼 0
- spdSub / EngineRun: 행 0 · 컬럼 11(보임 6) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:37:51.220 [GSCM] 다시 확인하여 주십시오. not run master validation today → default_button(id=1)

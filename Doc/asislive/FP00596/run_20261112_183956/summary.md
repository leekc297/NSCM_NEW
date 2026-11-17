# AS-IS 실측 요약 — FP00596

- 실행: 2026-11-12 18:39:56.692 ~ 2026-11-12 18:41:08.799 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(PreMix) (GSCM.FP.Planning.UIL.FP00596_PlanAmend_Line_PreMix)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:39:57.125 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 29.32 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:39:57.130 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:39:57, END_TIME=2026-11-12 18:39:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183957_096, PA |
| 18:39:57.327 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00596 |
| 18:39:57.344 | load | GSCM.FP_Common | SELECT * | 351 | 11.07 | USER_ID= |
| 18:39:57.348 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:39:57.538 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.62 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:39:57.563 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.33 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:39:57, END_TIME=2026-11-12 18:39:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183957_53, PAR |
| 18:39:57.582 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 30 | 4.32 | USER_ID=jaeuk.shin, MENU_ID=FP00617_Amend |
| 18:39:57.587 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.28 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:39:57.593 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.1 | p_program_id=FP00617, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:39:57.634 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 37.56 | p_program_id=FP00617, p_sheet_name=Amend |
| 18:39:57.756 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 17 | 98.53 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00596_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:39:57.763 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.96 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00596_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 18:39:58.230 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 391.93 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PMIX, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:39:58.238 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.03 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PMIX',@param2=N'Y',@param3=N'',@param4=N'', |
| 18:39:58.362 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 84.39 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:39:58.395 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.22 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 18:39:58.428 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 5.47 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:39:58.471 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 18:39:58.590 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 9.21 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:39:58.595 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.11 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 18:39:58.615 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 5.31 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:39:58.648 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.76 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 18:39:59.015 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 358.6 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:39:59.064 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.03 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:39:58, END_TIME=2026-11-12 18:39:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183958_656, PA |
| 18:39:59.543 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 459.57 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 18:39:59.556 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.78 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:39:59, END_TIME=2026-11-12 18:39:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183959_083, PA |
| 18:39:59.829 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 257.98 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param |
| 18:39:59.833 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.48 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:39:59, END_TIME=2026-11-12 18:39:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183959_571, PA |
| 18:40:00.089 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 237.62 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:40:00.095 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 18:40:00.456 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 331.43 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=N, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:40:00.484 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'N',@pa |
| 18:40:00.734 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 235.31 | p_code=FP00596_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=, param10=E0500, param11=Y, param12=, param13=, param14=Y, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:40:00.755 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@par |
| 18:40:20.001 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 19214.9 | p_code=FP00596_find_FPNickName, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=20261112, param4=, param5=, param6=40,81, param7=A001, param8=HQ06,HQ07, param9=, param10=FP_E2P01,FP_E2P02,FP_EGM01_A, param11=E0500, param12=, param13=FP_AMEND_DAILY_PLAN_R, param14=, param15=, param16=, param1 |
| 18:40:20.005 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_find_FPNickName',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'20261112',@param4=N'',@param |
| 18:40:20.023 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.22 | p_program_id=FP00596, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:40:20.066 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 37.99 | p_program_id=FP00596, p_sheet_name=Amend |
| 18:40:20.075 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.94 | p_program_id=FP00596, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:40:20.083 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 3.88 | p_program_id=FP00596, p_sheet_name=Amend |
| 18:40:20.210 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.17 | MenuID=Plan Amend by Line(PreMix), CnntCode=0104001, UserID=jaeuk.shin |
| 18:40:20.443 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00596 |
| 18:41:08.016 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.41 | MenuID=Plan Amend by Line(PreMix), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem9 | chk_Info |  |
| Operation | mcbo_operation |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Nick Name | txtNickName |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem16 | chk_includeSubOp |  |
| Material | txtItem |  |
| Nick Name List | mcbo_nicknamelt |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 23(보임 12) · 헤더 3단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:40:30.453 [] You need to select one plan ID to proceed → default_button(id=1)

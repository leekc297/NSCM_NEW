# AS-IS 실측 요약 — FP00597

- 실행: 2026-11-12 18:41:08.887 ~ 2026-11-12 18:41:58.952 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(PreMix) (GSCM.FP.Planning.UIL.FP00597_PlanAmend_Model_PreMix)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:41:09.309 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.61 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:41:09.314 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:41:09, END_TIME=2026-11-12 18:41:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184109_3, PARA |
| 18:41:09.445 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00597 |
| 18:41:09.461 | load | GSCM.FP_Common | SELECT * | 351 | 10.48 | USER_ID= |
| 18:41:09.465 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.71 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:41:09.690 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 46.5 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:41:09.712 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.37 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:41:09, END_TIME=2026-11-12 18:41:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184109_643, PA |
| 18:41:09.778 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 16 | 4.38 | USER_ID=jaeuk.shin, MENU_ID=FP00597_Amend |
| 18:41:09.811 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.74 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:41:09.820 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.16 | p_program_id=FP00597, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:41:09.830 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.59 | p_program_id=FP00597, p_sheet_name=Amend |
| 18:41:09.859 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 9.44 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00597_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:09.894 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.49 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00597_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 18:41:10.091 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 155.47 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PMIX, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.119 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PMIX',@param2=N'Y',@param3=N'',@param4=N'', |
| 18:41:10.158 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 20.71 | p_code=FP00597_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.164 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00597_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 18:41:10.185 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 10.99 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.221 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.37 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 18:41:10.246 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.2 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.286 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 18:41:10.329 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.57 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.334 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 18:41:10.384 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 41.35 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:41:10.404 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.12 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:41:10, END_TIME=2026-11-12 18:41:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184110_342, PA |
| 18:41:10.528 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 110.4 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 18:41:10.540 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:41:10, END_TIME=2026-11-12 18:41:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184110_417, PA |
| 18:41:10.599 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 25.87 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param |
| 18:41:10.604 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:41:10, END_TIME=2026-11-12 18:41:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184110_573, PA |
| 18:41:10.676 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 46.77 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.715 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.07 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 18:41:10.788 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 54.21 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=N, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.826 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'N',@pa |
| 18:41:10.847 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 12.47 | p_code=FP00596_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=BUILDING, param5=40,81, param6=A001, param7=HQ06,HQ07, param8=, param9=, param10=E0500, param11=Y, param12=, param13=, param14=Y, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:41:10.881 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.2 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00596_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'BUILDING',@par |
| 18:41:10.898 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.11 | p_program_id=FP00597, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:41:10.907 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.12 | p_program_id=FP00597, p_sheet_name=Amend |
| 18:41:10.920 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.32 | p_program_id=FP00597, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:41:10.932 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 8.18 | p_program_id=FP00597, p_sheet_name=Amend |
| 18:41:11.047 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 71.17 | MenuID=Plan Amend by Model(PreMix), CnntCode=0104001, UserID=jaeuk.shin |
| 18:41:11.193 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00597 |
| 18:41:58.259 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=Plan Amend by Model(PreMix), CnntCode=0104002, UserID=jaeuk.shin |

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
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem16 | chk_includeSubOp |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 32(보임 23) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:41:20.911 [] You need to select one plan ID to proceed → default_button(id=1)

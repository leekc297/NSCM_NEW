# AS-IS 실측 요약 — FP00626

- 실행: 2026-11-12 19:07:30.221 ~ 2026-11-12 19:07:51.484 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simulation(Assy) (GSCM.FP.Planning.UIL.FP00626_PancakeSimulation_Assy)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:07:30.581 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.24 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:07:30.585 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:07:30, END_TIME=2026-11-12 19:07:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190730_573, PA |
| 19:07:30.741 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 19:07:30.758 | load | GSCM.FP_Common | SELECT * | 351 | 9.92 | USER_ID= |
| 19:07:30.783 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.51 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:07:31.336 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 363.38 | p_code=FP00626_findInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:31.344 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_CELL',@param2=N'',@param3=N'',@param4=N'', |
| 19:07:31.442 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 13.13 | p_code=FP00626_find_isPast, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:31.480 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.02 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_isPast',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 19:07:31.507 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.07 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:31.533 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 19:07:31.554 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 4.38 | p_code=FP00626_find_Unit, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:31.558 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_Unit',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@para |
| 19:07:31.599 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 15.21 | p_code=FP00626_find_cellType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:31.612 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.37 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_cellType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 19:07:31.703 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 8.07 | p_code=FP00626_find_pancakeType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:31.710 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.08 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_pancakeType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 19:07:31.780 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.0 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:07:31.809 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 25.57 | p_program_id=FP00626, p_sheet_name=Amend |
| 19:07:31.818 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.81 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:07:31.827 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 5.28 | p_program_id=FP00626, p_sheet_name=Amend |
| 19:07:31.847 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.93 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 19:07:31.854 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.94 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 19:07:31.863 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.21 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 19:07:31.871 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.68 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 19:07:31.977 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 57.96 | MenuID=Pancake Simulation(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 19:07:32.054 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 19:07:42.389 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 121.09 | p_code=FP00626_chk_PlanId, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.393 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_chk_PlanId',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N |
| 19:07:42.422 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 15.92 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.452 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.34 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'20261202',@param4=N'' |
| 19:07:42.469 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 5.78 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.499 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.67 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261112',@param3=N'20261202',@param4=N'',@param5=N' |
| 19:07:42.514 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 6.54 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.518 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:07:42.534 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 7.78 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.586 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:07:42.605 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 25 | 7.84 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.645 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.7 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:07:42.659 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 5.34 | p_code=FP00626_find_measure, p_user_id=jaeuk.shin, param1=FP00626_Main, param2=jaeuk.shin, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:07:42.696 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.51 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00626_Main',@param2=N'jaeuk.shin',@param3=N'',@param4=N'',@par |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Instance Date | sCalendar_planday |  |
| Plan ID(Assy) | cbo_planid |  |
| Unit | cbo_unit |  |
| layoutControlItem2 | chktotalinclude |  |
| Nick Name | txtNickName |  |
| Material | txtItem |  |
| Model Nick Name | txtModelNickName |  |
| Model | txtModel |  |
| Pancake Type | cbo_pancaketype |  |
| layoutControlItem13 | chk_release |  |
| Cell Type | cbo_celltype |  |
| lblSql | btnSql |  |
| Plan Info | btnPlanInfo |  |
| Plan Group | cbo_plan_group |  |
| Plan Period | dCalendar_planrange |  |
| Coater Plan: | lblPlanID |  |

## 그리드

- spdSub / PlanInfo: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0
- spdMain / Amend: 행 0 · 컬럼 25(보임 11) · 헤더 2단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:07:43.239 [GSCM] 다시 확인하여 주십시오. PLAN ID → default_button(id=1)

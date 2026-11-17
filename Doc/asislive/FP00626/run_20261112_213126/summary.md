# AS-IS 실측 요약 — FP00626

- 실행: 2026-11-12 21:31:26.761 ~ 2026-11-12 21:31:52.890 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simulation(Assy) (GSCM.FP.Planning.UIL.FP00626_PancakeSimulation_Assy)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:31:27.151 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 64.91 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:31:27.154 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.97 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:31:27, END_TIME=2026-11-12 21:31:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213127_086, PA |
| 21:31:27.280 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 21:31:27.294 | load | GSCM.FP_Common | SELECT * | 351 | 9.46 | USER_ID= |
| 21:31:27.302 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.96 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:31:27.544 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 144.62 | p_code=FP00626_findInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:27.623 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.27 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_CELL',@param2=N'',@param3=N'',@param4=N'', |
| 21:31:27.681 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 25.8 | p_code=FP00626_find_isPast, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:27.735 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.38 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_isPast',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:31:27.753 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.34 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:27.852 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 98.8 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 21:31:27.875 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 10.88 | p_code=FP00626_find_Unit, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:27.982 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 105.96 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_Unit',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@para |
| 21:31:28.030 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 35.55 | p_code=FP00626_find_cellType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:28.049 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_cellType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 21:31:28.090 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 9.72 | p_code=FP00626_find_pancakeType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:28.101 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.45 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_pancakeType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 21:31:28.151 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.14 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:31:28.157 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 3.73 | p_program_id=FP00626, p_sheet_name=Amend |
| 21:31:28.167 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.98 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:31:28.176 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.86 | p_program_id=FP00626, p_sheet_name=Amend |
| 21:31:28.191 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.41 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 21:31:28.200 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 5.68 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 21:31:28.206 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.55 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 21:31:28.214 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 4.83 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 21:31:28.391 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 157.77 | MenuID=Pancake Simulation(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 21:31:28.460 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 21:31:40.264 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 1936.62 | p_code=FP00626_chk_PlanId, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.347 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 82.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_chk_PlanId',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N |
| 21:31:40.362 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 7.46 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.404 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'20261202',@param4=N'' |
| 21:31:40.427 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 14.33 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.436 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.17 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261112',@param3=N'20261202',@param4=N'',@param5=N' |
| 21:31:40.451 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 7.07 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.533 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 81.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:31:40.548 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 6.06 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.603 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.09 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@para |
| 21:31:40.616 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 25 | 6.07 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.710 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 93.43 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:31:40.729 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 12.35 | p_code=FP00626_find_measure, p_user_id=jaeuk.shin, param1=FP00626_Main, param2=jaeuk.shin, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:40.773 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
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

- 2026-11-12 21:31:41.347 [GSCM] 다시 확인하여 주십시오. PLAN ID → default_button(id=1)

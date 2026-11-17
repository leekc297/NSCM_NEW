# AS-IS 실측 요약 — FP00626

- 실행: 2026-11-12 22:03:29.904 ~ 2026-11-12 22:03:56.258 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simulation(Assy) (GSCM.FP.Planning.UIL.FP00626_PancakeSimulation_Assy)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:03:30.257 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 30.03 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:03:30.260 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:03:30, END_TIME=2026-11-12 22:03:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220330_226, PA |
| 22:03:30.317 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 22:03:30.332 | load | GSCM.FP_Common | SELECT * | 351 | 9.72 | USER_ID= |
| 22:03:30.336 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:03:30.588 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 154.12 | p_code=FP00626_findInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:30.611 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_CELL',@param2=N'',@param3=N'',@param4=N'', |
| 22:03:30.660 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 5.19 | p_code=FP00626_find_isPast, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:30.695 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.51 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_isPast',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 22:03:30.709 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.12 | p_code=FP00626_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:30.751 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 22:03:30.766 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 3.84 | p_code=FP00626_find_Unit, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:30.796 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.04 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_Unit',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@para |
| 22:03:30.814 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 4.48 | p_code=FP00626_find_cellType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:30.817 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_cellType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 22:03:30.853 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 4.46 | p_code=FP00626_find_pancakeType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:30.857 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_find_pancakeType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 22:03:30.890 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.68 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:03:30.902 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.52 | p_program_id=FP00626, p_sheet_name=Amend |
| 22:03:30.910 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.8 | p_program_id=FP00626, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:03:30.917 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.23 | p_program_id=FP00626, p_sheet_name=Amend |
| 22:03:30.931 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.23 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 22:03:30.937 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.72 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 22:03:30.944 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.67 | p_program_id=FP00626, p_sheet_name=PlanInfo, p_user_id=jaeuk.shin |
| 22:03:30.950 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 6 | 3.47 | p_program_id=FP00626, p_sheet_name=PlanInfo |
| 22:03:31.011 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 43.51 | MenuID=Pancake Simulation(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 22:03:31.052 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00626 |
| 22:03:41.331 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 146.04 | p_code=FP00626_chk_PlanId, p_user_id=jaeuk.shin, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.357 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00626_chk_PlanId',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N |
| 22:03:41.374 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 9.67 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.423 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'20261202',@param4=N'' |
| 22:03:41.436 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 6.8 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.493 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.06 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261112',@param3=N'20261202',@param4=N'',@param5=N' |
| 22:03:41.509 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.63 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.550 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.24 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:03:41.564 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 6.59 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.592 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@para |
| 22:03:41.604 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 25 | 5.62 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.641 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.11 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:03:41.653 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 4.71 | p_code=FP00626_find_measure, p_user_id=jaeuk.shin, param1=FP00626_Main, param2=jaeuk.shin, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:03:41.735 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 82.84 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
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

- 2026-11-12 22:03:42.042 [GSCM] 다시 확인하여 주십시오. PLAN ID → default_button(id=1)

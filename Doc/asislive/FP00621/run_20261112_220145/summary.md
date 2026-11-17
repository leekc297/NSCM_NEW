# AS-IS 실측 요약 — FP00621

- 실행: 2026-11-12 22:01:45.562 ~ 2026-11-12 22:02:37.439 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Formation) (GSCM.FP.Planning.UIL.FP00621_PlanAmend_Line_Formation)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:01:45.915 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 40.37 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:01:45.921 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.09 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:01:45, END_TIME=2026-11-12 22:01:45, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220145_874, PA |
| 22:01:46.046 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.81 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00621 |
| 22:01:46.063 | load | GSCM.FP_Common | SELECT * | 351 | 10.53 | USER_ID= |
| 22:01:46.067 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:01:46.215 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.96 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:01:46.219 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:01:46, END_TIME=2026-11-12 22:01:46, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220146_208, PA |
| 22:01:46.272 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 27 | 35.81 | USER_ID=jaeuk.shin, MENU_ID=FP00621_Amend |
| 22:01:46.299 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.51 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:01:46.306 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.98 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:01:46.354 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 44.55 | p_program_id=FP00621, p_sheet_name=Amend |
| 22:01:46.447 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 26.22 | LOGTYPE=SpeedUp, NOTE=FP00621
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 22:01:46.459 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.15 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:01:46.473 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.06 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:01:46.524 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.21 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 22:01:46.552 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.44 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:01:46.556 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.35 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 22:01:46.570 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.23 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:01:46.602 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 22:01:46.611 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.4 | LOGTYPE=SpeedUp, NOTE=FP00621
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 22:01:46.615 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.75 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:01:46.665 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:01:46.673 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 3.88 | p_program_id=FP00621, p_sheet_name=Amend |
| 22:01:46.681 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.52 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:01:46.691 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 4.32 | p_program_id=FP00621, p_sheet_name=Amend |
| 22:01:46.764 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 48.45 | MenuID=Plan Amend by Line(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 22:01:46.823 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00621 |
| 22:02:36.791 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.37 | MenuID=Plan Amend by Line(Formation), CnntCode=0104002, UserID=jaeuk.shin |

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
| Nick Name List | mcbo_nicknamelt |  |
| Nick Name | txtNickName |  |
| Material | txtItem |  |
| Pjt Group Nm | txtPjtGroup |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem16 | chk_includeSubOp |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 12(보임 11) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 22:01:57.952 [] You need to select one plan ID to proceed → default_button(id=1)

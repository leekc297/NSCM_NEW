# AS-IS 실측 요약 — FP00622

- 실행: 2026-11-12 19:05:58.998 ~ 2026-11-12 19:06:49.203 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(NJ_Pouch) (GSCM.FP.Planning.UIL.FP00622_PlanAmend_Line_NJ_Pouch)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:05:59.389 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.77 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:05:59.394 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.56 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:05:59, END_TIME=2026-11-12 19:05:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190559_382, PA |
| 19:05:59.565 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00622 |
| 19:05:59.581 | load | GSCM.FP_Common | SELECT * | 351 | 9.7 | USER_ID= |
| 19:05:59.606 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.74 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:05:59.884 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.68 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:05:59.887 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:05:59, END_TIME=2026-11-12 19:05:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190559_876, PA |
| 19:05:59.911 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 32 | 4.03 | USER_ID=jaeuk.shin, MENU_ID=FP00622_Amend |
| 19:05:59.915 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.7 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:05:59.923 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.09 | p_program_id=FP00622, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:05:59.933 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.71 | p_program_id=FP00622, p_sheet_name=Amend |
| 19:06:00.099 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 103.88 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:06:00.118 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.92 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'', |
| 19:06:00.235 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 96.78 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=00010101, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:06:00.256 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'00010101',@param3=N'',@param4=N'',@para |
| 19:06:00.274 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.4 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:06:00.315 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.41 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20261112',@param3=N'',@param4=N'',@para |
| 19:06:00.433 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.8 | LOGTYPE=SpeedUp, NOTE=FP00622
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:06:00.437 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.8 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:06:00.469 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.1 | LOGTYPE=SpeedUp, NOTE=FP00622
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:06:00.473 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:06:00.537 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.8 | p_program_id=FP00622, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:06:00.545 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.98 | p_program_id=FP00622, p_sheet_name=Amend |
| 19:06:00.553 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.79 | p_program_id=FP00622, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:06:00.561 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.05 | p_program_id=FP00622, p_sheet_name=Amend |
| 19:06:00.664 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 46.35 | MenuID=Plan Amend by Line(NJ_Pouch), CnntCode=0104001, UserID=jaeuk.shin |
| 19:06:00.853 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.65 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00622 |
| 19:06:48.503 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.03 | MenuID=Plan Amend by Line(NJ_Pouch), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Material | txtItem |  |
| NickName List | mcbo_nickname |  |
| Model | txtModel |  |
| layoutControlItem9 | chk_Info |  |
| Simulation | btnCal |  |
| Prod Type | mcbo_prodtype |  |
| Plan Group | cbo_plan_group |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 19(보임 18) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:06:10.705 [] You need to select one plan ID to proceed → default_button(id=1)

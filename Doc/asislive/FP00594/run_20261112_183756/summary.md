# AS-IS 실측 요약 — FP00594

- 실행: 2026-11-12 18:37:56.646 ~ 2026-11-12 18:39:02.819 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(NJ_Pouch) (GSCM.FP.Planning.UIL.FP00594_PlanAmend_Model_NJ_Pouch)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:37:57.203 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 172.25 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:37:57.207 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.8 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:37:57, END_TIME=2026-11-12 18:37:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183757_031, PA |
| 18:37:57.922 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.5 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00594 |
| 18:37:57.937 | load | GSCM.FP_Common | SELECT * | 351 | 11.52 | USER_ID= |
| 18:37:59.085 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1147.28 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:38:00.522 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 1264.47 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:38:00.525 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:37:59, END_TIME=2026-11-12 18:38:00, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183759_257, PA |
| 18:38:11.581 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 23 | 10787.36 | USER_ID=jaeuk.shin, MENU_ID=FP00594_Amend |
| 18:38:11.603 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.1 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:38:11.614 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.1 | p_program_id=FP00594, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:38:11.668 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 49.95 | p_program_id=FP00594, p_sheet_name=Amend |
| 18:38:12.595 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 849.55 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:38:12.618 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.81 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'', |
| 18:38:13.064 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 428.67 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20220907, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:38:13.085 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.59 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20220907',@param3=N'',@param4=N'',@para |
| 18:38:13.178 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 79.71 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:38:13.302 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 124.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@pa |
| 18:38:13.347 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 37.47 | LOGTYPE=SpeedUp, NOTE=FP00594
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:38:13.365 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.96 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:38:13.410 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 38.69 | LOGTYPE=SpeedUp, NOTE=FP00594
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:38:13.414 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.71 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:38:13.457 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 6.58 | USER_ID=jaeuk.shin |
| 18:38:13.463 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.62 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 18:38:13.550 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 37.11 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:38:13.573 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.8 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20261112',@param3=N'',@param4=N'',@para |
| 18:38:13.589 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 6.48 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:38:13.712 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 123.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@pa |
| 18:38:13.776 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00594, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:38:13.786 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 4.38 | p_program_id=FP00594, p_sheet_name=Amend |
| 18:38:13.794 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.97 | p_program_id=FP00594, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:38:13.804 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 5.55 | p_program_id=FP00594, p_sheet_name=Amend |
| 18:38:14.002 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 149.81 | MenuID=Plan Amend by Model(NJ_Pouch), CnntCode=0104001, UserID=jaeuk.shin |
| 18:38:14.202 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00594 |
| 18:39:02.111 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 160.02 | MenuID=Plan Amend by Model(NJ_Pouch), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Group | cbo_plan_group |  |
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem9 | chk_Info |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Model | txtModel |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |
| Prod Type | mcbo_prodtype |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 22(보임 21) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:38:24.439 [] You need to select one plan ID to proceed → default_button(id=1)

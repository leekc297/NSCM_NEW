# AS-IS 실측 요약 — FP00621

- 실행: 2026-11-12 19:05:08.450 ~ 2026-11-12 19:05:58.865 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Formation) (GSCM.FP.Planning.UIL.FP00621_PlanAmend_Line_Formation)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:05:08.812 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.97 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:05:08.815 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:05:08, END_TIME=2026-11-12 19:05:08, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190508_803, PA |
| 19:05:09.033 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00621 |
| 19:05:09.049 | load | GSCM.FP_Common | SELECT * | 351 | 10.19 | USER_ID= |
| 19:05:09.053 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.59 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:05:09.367 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.07 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:05:09.370 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.81 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:05:09, END_TIME=2026-11-12 19:05:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190509_36, PAR |
| 19:05:09.398 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 27 | 4.57 | USER_ID=jaeuk.shin, MENU_ID=FP00621_Amend |
| 19:05:09.410 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.58 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:05:09.420 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.71 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:05:09.454 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 29.03 | p_program_id=FP00621, p_sheet_name=Amend |
| 19:05:09.617 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.55 | LOGTYPE=SpeedUp, NOTE=FP00621
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:05:09.654 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.96 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:05:09.694 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.36 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:05:09.722 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.65 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 19:05:09.786 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 43.42 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:05:09.809 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.13 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 19:05:09.827 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 5.36 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:05:09.865 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 19:05:09.879 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.56 | LOGTYPE=SpeedUp, NOTE=FP00621
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:05:09.883 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:05:10.009 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.13 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:05:10.018 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 4.16 | p_program_id=FP00621, p_sheet_name=Amend |
| 19:05:10.027 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:05:10.036 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 4.23 | p_program_id=FP00621, p_sheet_name=Amend |
| 19:05:10.146 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 61.35 | MenuID=Plan Amend by Line(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 19:05:10.323 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00621 |
| 19:05:58.079 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.61 | MenuID=Plan Amend by Line(Formation), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 19:05:20.100 [] You need to select one plan ID to proceed → default_button(id=1)

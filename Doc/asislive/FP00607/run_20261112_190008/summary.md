# AS-IS 실측 요약 — FP00607

- 실행: 2026-11-12 19:00:08.668 ~ 2026-11-12 19:01:06.771 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Formation) (GSCM.FP.Planning.UIL.FP00607_PlanAmend_Model_Formation)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:00:09.133 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 88.58 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:00:09.138 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.81 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:00:09, END_TIME=2026-11-12 19:00:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190009_041, PA |
| 19:00:09.745 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00607 |
| 19:00:09.773 | load | GSCM.FP_Common | SELECT * | 351 | 13.93 | USER_ID= |
| 19:00:09.778 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.52 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:00:10.023 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.55 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:00:10.026 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:00:10, END_TIME=2026-11-12 19:00:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190010_014, PA |
| 19:00:10.061 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 4.76 | USER_ID=jaeuk.shin, MENU_ID=FP00607_Amend |
| 19:00:10.087 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.63 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:00:10.144 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 49.18 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:00:10.174 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 22 | 24.86 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:00:10.237 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 33 | 32.85 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00607_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:10.282 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00607_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 19:00:10.391 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 4.25 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 19:00:10.397 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.1 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 19:00:15.936 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 5530.14 | USER_ID=jaeuk.shin |
| 19:00:15.946 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.42 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:00:10, END_TIME=2026-11-12 19:00:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190010_404, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 19:00:15.967 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.86 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 19:00:15.984 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.33 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ID = C.COMPANY_ID

INNER JOIN SCM_DIVISION_M D WITH(NOLOCK)
ON FL.DIVISION_ID = D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID
 |
| 19:00:16.099 | load | GSCM.FP_Common | SELECT | 145 | 7.27 | USER_ID=jaeuk.shin |
| 19:00:16.120 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.34 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client par |
| 19:00:16.141 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 10.47 | USER_ID=jaeuk.shin |
| 19:00:16.193 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.25 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client pa |
| 19:00:16.215 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 7.18 | USER_ID=jaeuk.shin |
| 19:00:16.324 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 108.16 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---C |
| 19:00:16.448 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 32.42 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:00:16.511 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 62.06 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:00:16.561 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 26.72 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:16.606 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.52 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 19:00:16.690 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 65.67 | p_code=FP00607_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:16.726 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 19:00:16.784 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 43.26 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:16.887 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 103.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 19:00:16.941 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 46.11 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:00:17.083 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 141.88 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:00:17.260 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 126.7 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:00:17.291 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.69 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:00:17.313 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.45 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:17.342 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 19:00:17.398 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 41.81 | p_code=FP00607_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:17.531 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 130.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 19:00:17.563 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.25 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:00:17.665 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 99.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 19:00:17.698 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 26.91 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:00:17.763 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.67 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:00:17.829 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:00:17.838 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 22 | 5.19 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:00:17.847 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:00:17.855 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 22 | 4.11 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:00:18.215 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 176.66 | MenuID=Plan Amend by Model(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 19:00:18.481 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00607 |
| 19:01:06.081 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.61 | MenuID=Plan Amend by Model(Formation), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 23(보임 14) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:00:28.200 [] You need to select one plan ID to proceed → default_button(id=1)

# AS-IS 실측 요약 — FP00599MK2F

- 실행: 2026-11-12 18:42:49.131 ~ 2026-11-12 18:43:39.007 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Assy_OC/NB/WA) (GSCM.FP.Planning.UIL.FP00599MK2_PlanAmend_Model_Assy)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:42:49.607 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00599MK2F |
| 18:42:49.622 | load | GSCM.FP_Common | SELECT * | 351 | 10.5 | USER_ID= |
| 18:42:49.655 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.44 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:42:49.901 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.24 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:42:49.904 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:42:49, END_TIME=2026-11-12 18:42:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184249_893, PA |
| 18:42:49.944 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 31 | 4.42 | USER_ID=jaeuk.shin, MENU_ID=FP00599_MK2_Main |
| 18:42:49.972 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.96 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:42:49.981 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP00599, p_sheet_name=MK2, p_user_id=jaeuk.shin |
| 18:42:50.042 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 57.64 | p_program_id=FP00599, p_sheet_name=MK2 |
| 18:42:50.205 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.87 | LOGTYPE=SpeedUp, NOTE=FP00599MK2
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:42:50.210 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.34 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:42:50.350 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 107.38 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI |
| 18:42:50.402 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.38 | PROG_ID=PR_UI_FP00599_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FINDFPPLAN |
| 18:42:50.483 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 59.6 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FINDPLANNER_LIST, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PS |
| 18:42:50.492 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.49 | PROG_ID=PR_UI_FP00599_FINDPLANNER_LIST, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FINDPLANN |
| 18:42:50.551 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 45.58 | LOGTYPE=SpeedUp, NOTE=FP00599MK2
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:42:50.558 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.04 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:42:50.588 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 8.17 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^B |
| 18:42:50.594 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.04 | PROG_ID=PR_UI_FP00599_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FINDFPPLAN |
| 18:42:50.631 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 20.29 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLA |
| 18:42:50.636 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.12 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 18:42:50.702 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.08 | p_program_id=FP00599MK2, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:42:50.714 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 8.25 | p_program_id=FP00599MK2, p_sheet_name=Amend |
| 18:42:50.723 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00599MK2, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:42:50.730 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.48 | p_program_id=FP00599MK2, p_sheet_name=Amend |
| 18:42:50.823 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 62.06 | MenuID=Plan Amend by Model(Assy_OC/NB/WA), CnntCode=0104001, UserID=jaeuk.shin |
| 18:42:51.042 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00599MK2F |
| 18:43:38.300 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.23 | MenuID=Plan Amend by Model(Assy_OC/NB/WA), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Planner | mcbo_planner |  |
| FP Plan Id | cbo_fpplanid |  |
| Prod.Type | mcbo_prodtype |  |
| lblSql | btnSql |  |
| layoutControlItem2 | btnExcelImport |  |
| Plan Group | cbo_plan_group |  |
| Plan Date | sCalendar_planday |  |
| Data | btnToggleSave |  |
| Division. | mcbo_division |  |
| Plant | mcbo_plant |  |
| Line | mcbo_line |  |
| Operation | mcbo_operation |  |
| Material | edt_item |  |
| Nick Name | tbNickName |  |
| layoutControlItem12 | chk_all_line |  |
| Model | edt_topItem |  |
| layoutControlItem13 | chk_Info |  |
| Building | mcbo_factory |  |
| Pjt Group Name | edt_PjtGroup |  |
| Plan Period | dCalendar_planrange |  |
| Site | mcbo_site |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 24(보임 23) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:43:00.741 [] You need to select one plan to proceed → default_button(id=1)

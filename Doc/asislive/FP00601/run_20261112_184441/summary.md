# AS-IS 실측 요약 — FP00601

- 실행: 2026-11-12 18:44:41.589 ~ 2026-11-12 18:45:31.297 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Pack) (GSCM.FP.Planning.UIL.FP00601_PlanAmend_Line_Pack)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:44:42.077 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00601 |
| 18:44:42.094 | load | GSCM.FP_Common | SELECT * | 351 | 10.5 | USER_ID= |
| 18:44:42.098 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.56 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:44:42.278 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.84 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:44:42.281 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:44:42, END_TIME=2026-11-12 18:44:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184442_271, PA |
| 18:44:42.331 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 42 | 3.87 | USER_ID=jaeuk.shin, MENU_ID=FP00601_Main |
| 18:44:42.337 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.53 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:44:42.344 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.21 | p_program_id=FP00601, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:44:42.386 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 37.01 | p_program_id=FP00601, p_sheet_name=Main |
| 18:44:42.499 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.2 | LOGTYPE=SpeedUp, NOTE=FP00601
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:44:42.523 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.88 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:44:42.754 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 215.17 | p_sys_type=SELECT, p_sys_flag=PLANNER_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI_AMEND_ |
| 18:44:42.775 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.96 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLANNER_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00601_ETC',@ |
| 18:44:42.886 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 100.61 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=PS |
| 18:44:42.890 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00601_ETC',@opt |
| 18:44:42.920 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 20.82 | LOGTYPE=SpeedUp, NOTE=FP00601
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:44:42.924 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:44:42.971 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:44:42.978 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 3.49 | p_program_id=FP00601, p_sheet_name=Amend |
| 18:44:42.985 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.52 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:44:42.993 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 4.37 | p_program_id=FP00601, p_sheet_name=Amend |
| 18:44:43.103 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 75.56 | MenuID=Plan Amend by Line(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 18:44:43.271 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00601 |
| 18:45:30.556 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.75 | MenuID=Plan Amend by Line(Pack), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| lblExcel | btnExcelImport |  |
| Plan Group | cbo_plan_group |  |
| Planner | mcbo_planner |  |
| Plan Date | sCalendar_planday |  |
| Division. | mcbo_division |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| FP Plan Id | cbo_fpplanid |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| Building | mcbo_factory |  |
| Pjt Group Name | edt_pjtGroup |  |
| Model | edt_topItem |  |
| Material | edt_item |  |
| Nick Name | tbNickName |  |
| Prod.Type | mcbo_prodtype |  |
| Plan Period | dCalendar_planrange |  |
| layoutControlItem12 | chk_allLine |  |
| layoutControlItem13 | chk_Info |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 17(보임 16) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:44:53.083 [] You need to select one plan to proceed → default_button(id=1)

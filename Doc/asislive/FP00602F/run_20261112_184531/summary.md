# AS-IS 실측 요약 — FP00602F

- 실행: 2026-11-12 18:45:31.391 ~ 2026-11-12 18:46:20.504 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Assy) (GSCM.FP.Planning.UIL.FP00602_Plan_Amend_Line_Assy)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:45:31.740 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00602 |
| 18:45:31.758 | load | GSCM.FP_Common | SELECT * | 351 | 12.99 | USER_ID= |
| 18:45:31.790 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.07 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:45:32.044 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.49 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:45:32.047 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:45:32, END_TIME=2026-11-12 18:45:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184532_036, PA |
| 18:45:32.077 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 29 | 5.41 | USER_ID=jaeuk.shin, MENU_ID=FP00602_Main |
| 18:45:32.108 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.46 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:45:32.119 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.17 | p_program_id=FP00602, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:45:32.162 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 39.38 | p_program_id=FP00602, p_sheet_name=Main |
| 18:45:32.390 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 5 | 91.95 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FINDPLANNER_LIST, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI_AMEND_CELL^20261 |
| 18:45:32.395 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.09 | PROG_ID=PR_UI_FP00599_FINDPLANNER_LIST, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FINDPLANN |
| 18:45:32.467 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 45.97 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=PSI_AMEND_ |
| 18:45:32.502 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.24 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 18:45:32.570 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.0 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:45:32.638 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 63.75 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:45:32.648 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.25 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:45:32.657 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 4.64 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:45:32.755 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 46.74 | MenuID=Plan Amend by Line(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 18:45:32.961 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00602 |
| 18:46:19.791 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.89 | MenuID=Plan Amend by Line(Assy), CnntCode=0104002, UserID=jaeuk.shin |

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
| Operation | mcbo_operation |  |
| Material | edt_item |  |
| Nick Name | tbNickName |  |
| Pjt Group Name | edt_PjtGroup |  |
| Plan Period | dCalendar_planrange |  |
| Site | mcbo_site |  |
| Line | mcbo_line |  |
| layoutControlItem12 | chk_allLine |  |
| Building | mcbo_factory |  |
| Model | edt_topItem |  |
| layoutControlItem13 | chk_Info |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 19(보임 18) · 헤더 2단 · 고정 컬럼 19

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:45:42.295 [] You need to select one plan to proceed → default_button(id=1)

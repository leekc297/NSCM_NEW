# AS-IS 실측 요약 — FP00602MK2

- 실행: 2026-11-12 18:46:20.581 ~ 2026-11-12 18:47:10.150 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Assy_OC/NB/WA) (GSCM.FP.Planning.UIL.FP00602MK2_Plan_Amend_Line_Assy)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:46:21.050 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00602MK2 |
| 18:46:21.065 | load | GSCM.FP_Common | SELECT * | 351 | 9.85 | USER_ID= |
| 18:46:21.069 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.17 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:46:21.268 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 28.06 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:46:21.272 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:46:21, END_TIME=2026-11-12 18:46:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184621_24, PAR |
| 18:46:21.324 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 30 | 4.01 | USER_ID=jaeuk.shin, MENU_ID=FP00602MK2_Main |
| 18:46:21.328 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:46:21.338 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.0 | p_program_id=FP00602MK2, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:46:21.350 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 7.92 | p_program_id=FP00602MK2, p_sheet_name=Main |
| 18:46:21.431 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.06 | LOGTYPE=SpeedUp, NOTE=FP00602MK2
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:46:21.453 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.56 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:46:21.492 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 22.24 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI |
| 18:46:21.518 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.91 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 18:46:21.579 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 50.31 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FINDPLANNER_LIST, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PS |
| 18:46:21.583 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=PR_UI_FP00599_FINDPLANNER_LIST, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FINDPLANN |
| 18:46:21.604 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.42 | LOGTYPE=SpeedUp, NOTE=FP00602MK2
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:46:21.644 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.09 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:46:21.662 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 6.94 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, |
| 18:46:21.706 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.88 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 18:46:21.719 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 5.47 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^LOOKUP_TYPE_CODE^MENU_KEY^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLA |
| 18:46:21.764 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.31 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 18:46:21.822 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP00602MK2, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:46:21.831 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.91 | p_program_id=FP00602MK2, p_sheet_name=Amend |
| 18:46:21.838 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.33 | p_program_id=FP00602MK2, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:46:21.845 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 3.93 | p_program_id=FP00602MK2, p_sheet_name=Amend |
| 18:46:21.964 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 81.87 | MenuID=Plan Amend by Line(Assy_OC/NB/WA), CnntCode=0104001, UserID=jaeuk.shin |
| 18:46:22.206 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00602MK2 |
| 18:47:09.452 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.23 | MenuID=Plan Amend by Line(Assy_OC/NB/WA), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 25(보임 24) · 헤더 2단 · 고정 컬럼 25

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:46:32.071 [] You need to select one plan to proceed → default_button(id=1)

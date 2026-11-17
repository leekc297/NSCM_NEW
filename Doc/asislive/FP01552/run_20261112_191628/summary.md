# AS-IS 실측 요약 — FP01552

- 실행: 2026-11-12 19:16:28.349 ~ 2026-11-12 19:17:18.594 · 계정 jaeuk.shin · 상태 OK
- 화면: In-house Moving Plan(Pack) (GSCM.FP.Planning.UIL.FP01552_In_House_Moving_Plan)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:16:29.076 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 38.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01552 |
| 19:16:29.093 | load | GSCM.FP_Common | SELECT * | 351 | 9.31 | USER_ID= |
| 19:16:29.096 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.55 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:16:29.343 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 12.78 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:16:29.350 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:16:29, END_TIME=2026-11-12 19:16:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191629_329, PA |
| 19:16:29.426 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 16 | 6.01 | USER_ID=jaeuk.shin, MENU_ID=FP01552_Main |
| 19:16:29.485 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.79 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:16:29.495 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.93 | p_program_id=FP01552, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:16:29.504 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 3.51 | p_program_id=FP01552, p_sheet_name=Main |
| 19:16:29.821 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 30.41 | LOGTYPE=SpeedUp, NOTE=FP01552
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:16:29.826 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.02 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:16:30.078 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 235.5 | code=CURR_UTDATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 19:16:30.093 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:16:29, END_TIME=2026-11-12 19:16:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191629_842, PA |
| 19:16:30.412 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 307.92 | p_sys_type=SELECT, p_sys_flag=RELEASE_PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01552_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^OPERATION_ID^PLAN_DATE^BUCKET^CONFIRM_AREA^INSTANCE_ID^USE_WOW_STATUS^IS_SAME_PLAN_ID^CURR_DATE^, in_row=mXlVW48SU1c3wPszIA83/w==^PSI_AMEND |
| 19:16:30.424 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.44 | PROG_ID=PR_UI_FP01552_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'RELEASE_PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01552_E |
| 19:16:30.482 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 43.76 | LOGTYPE=SpeedUp, NOTE=FP01552
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:16:30.509 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.33 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:16:30.566 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 48.96 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^OPERATION_ID^PLAN_DATE^BUCKET^CONFIRM_AREA^INSTANCE_ID^USE_WOW_STATUS^IS_SAME_PLAN_ID^CURR_DATE^MASTER_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^P |
| 19:16:30.572 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.05 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_PL |
| 19:16:30.617 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 16.53 | p_program_id=FP01552, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:16:30.628 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 6.07 | p_program_id=FP01552, p_sheet_name=Amend |
| 19:16:30.637 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.37 | p_program_id=FP01552, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:16:30.649 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.6 | p_program_id=FP01552, p_sheet_name=Amend |
| 19:16:30.767 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 44.22 | MenuID=In-house Moving Plan(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 19:16:31.024 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01552 |
| 19:17:17.827 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.21 | MenuID=In-house Moving Plan(Pack), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| Plan Group | cboInstance |  |
| Plan Date | drpPlanDate |  |
| Plan Id | cboPlanId |  |
| Division. | clbDivision |  |
| Site | cboSite |  |
| Plant | clbPlant |  |
| Cell Group Code | txtCellCode |  |
| Plan Period | drpPeriod |  |
| layoutControlItem2 | chk_lineAssign |  |
| Nick Name | txtNickName |  |
| layoutControlItem13 | chk_Info |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 19(보임 18) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:16:40.470 [] You need to select one plan to proceed → default_button(id=1)

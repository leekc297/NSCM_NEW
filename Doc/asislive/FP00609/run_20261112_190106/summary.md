# AS-IS 실측 요약 — FP00609

- 실행: 2026-11-12 19:01:06.878 ~ 2026-11-12 19:01:56.002 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simul By Bld(Elec.) (GSCM.FP.Planning.UIL.FP00609_Pancake_Simul_By_Bld_Elec)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:01:07.315 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00609 |
| 19:01:07.336 | load | GSCM.FP_Common | SELECT * | 351 | 9.74 | USER_ID= |
| 19:01:07.365 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.17 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:01:07.488 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.96 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:01:07.492 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.46 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:01:07, END_TIME=2026-11-12 19:01:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190107_48, PAR |
| 19:01:07.522 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 12 | 4.98 | USER_ID=jaeuk.shin, MENU_ID=FP00609_Main |
| 19:01:07.546 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.98 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:01:07.554 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.36 | p_program_id=FP00609, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:01:07.610 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 51.01 | p_program_id=FP00609, p_sheet_name=Main |
| 19:01:07.793 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 12 | 138.06 | p_sys_type=SELECT, p_sys_flag=CELL_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^ |
| 19:01:07.797 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.69 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CELL_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 19:01:07.893 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 42.15 | p_sys_type=SELECT, p_sys_flag=PANCAKE_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^ |
| 19:01:07.897 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.82 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PANCAKE_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 19:01:07.953 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 5.24 | p_sys_type=SELECT, p_sys_flag=UOM_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^ |
| 19:01:07.972 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.54 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UOM_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_ |
| 19:01:08.004 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 5.94 | p_sys_type=SELECT, p_sys_flag=UNIT, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^CELL^ |
| 19:01:08.008 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.49 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UNIT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_none |
| 19:01:08.523 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 11 | 498.66 | p_sys_type=SELECT, p_sys_flag=INSTANCE_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^CELL^1^ |
| 19:01:08.539 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.96 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'INSTANCE_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@o |
| 19:01:08.603 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 14.26 | p_sys_type=SELECT, p_sys_flag=CURR_DATE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261 |
| 19:01:08.608 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.64 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 19:01:08.646 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 28.79 | p_sys_type=SELECT, p_sys_flag=ELEC_FACTORY, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^, in_row=mXlVW48SU1c3 |
| 19:01:08.650 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'ELEC_FACTORY',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 19:01:08.680 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 21.84 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^, in_row=mXl |
| 19:01:08.713 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.04 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 19:01:08.789 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.63 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:01:08.799 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 5.06 | p_program_id=FP00609, p_sheet_name=Amend |
| 19:01:08.808 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.5 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:01:08.816 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 3.91 | p_program_id=FP00609, p_sheet_name=Amend |
| 19:01:08.924 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 63.52 | MenuID=Pancake Simul By Bld(Elec.), CnntCode=0104001, UserID=jaeuk.shin |
| 19:01:09.020 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00609 |
| 19:01:55.227 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.77 | MenuID=Pancake Simul By Bld(Elec.), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| Plan Group | cboInstance |  |
| Cell Type | cboCellType |  |
| Pancake Type | cboPancakeType |  |
| Material | txtMaterial |  |
| Unit | cboUnit |  |
| Instance Date | drpPlanDate |  |
| Model Nick Name List | tbModelNickNameList |  |
| Plan Id(Coater) | cboPlanId |  |
| Elec. Building | clbBuilding |  |
| Model Nick Name | txtModelNickName |  |
| layoutControlItem1 | chk_rel |  |
| Model | txtModel |  |
| Nick Name | txtNickName |  |
| UOM Type | cboUOMType |  |
| Plan Period | drpPeriod |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 26(보임 25) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:01:17.566 [] You need to select one plan to proceed → default_button(id=1)

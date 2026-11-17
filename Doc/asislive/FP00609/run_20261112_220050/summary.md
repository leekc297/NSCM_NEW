# AS-IS 실측 요약 — FP00609

- 실행: 2026-11-12 22:00:50.351 ~ 2026-11-12 22:01:45.276 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simul By Bld(Elec.) (GSCM.FP.Planning.UIL.FP00609_Pancake_Simul_By_Bld_Elec)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "drpPlanDate", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:00:50.802 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00609 |
| 22:00:50.816 | load | GSCM.FP_Common | SELECT * | 351 | 9.34 | USER_ID= |
| 22:00:50.820 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.47 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:00:50.897 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.99 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:00:50.926 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:00:50, END_TIME=2026-11-12 22:00:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220050_889, PA |
| 22:00:50.952 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 12 | 4.17 | USER_ID=jaeuk.shin, MENU_ID=FP00609_Main |
| 22:00:50.957 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.38 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:00:50.965 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.25 | p_program_id=FP00609, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:00:50.993 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 24.81 | p_program_id=FP00609, p_sheet_name=Main |
| 22:00:51.102 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 12 | 66.33 | p_sys_type=SELECT, p_sys_flag=CELL_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^ |
| 22:00:51.107 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CELL_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 22:00:51.232 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 87.72 | p_sys_type=SELECT, p_sys_flag=PANCAKE_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^ |
| 22:00:51.235 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.38 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PANCAKE_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 22:00:51.271 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 10.86 | p_sys_type=SELECT, p_sys_flag=UOM_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^ |
| 22:00:51.276 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UOM_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_ |
| 22:00:51.297 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 5.43 | p_sys_type=SELECT, p_sys_flag=UNIT, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^CELL^ |
| 22:00:51.327 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.35 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UNIT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_none |
| 22:00:51.754 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 11 | 416.29 | p_sys_type=SELECT, p_sys_flag=INSTANCE_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261112^D^N^CELL^1^ |
| 22:00:51.757 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.95 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'INSTANCE_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@o |
| 22:00:51.820 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 35.64 | p_sys_type=SELECT, p_sys_flag=CURR_DATE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261 |
| 22:00:51.846 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.73 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 22:00:51.861 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 9.45 | p_sys_type=SELECT, p_sys_flag=ELEC_FACTORY, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^, in_row=mXlVW48SU1c3 |
| 22:00:51.895 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.78 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'ELEC_FACTORY',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 22:00:51.928 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 23.67 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^, in_row=mXl |
| 22:00:51.955 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.8 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 22:00:52.067 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.79 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:52.076 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 3.61 | p_program_id=FP00609, p_sheet_name=Amend |
| 22:00:52.085 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.59 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:52.092 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 3.59 | p_program_id=FP00609, p_sheet_name=Amend |
| 22:00:52.215 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 92.7 | MenuID=Pancake Simul By Bld(Elec.), CnntCode=0104001, UserID=jaeuk.shin |
| 22:00:52.272 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00609 |
| 22:01:00.789 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 22.06 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 22:01:00.870 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 81.03 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 22:01:44.570 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.65 | MenuID=Pancake Simul By Bld(Elec.), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 22:01:06.040 [] You need to select one plan to proceed → default_button(id=1)

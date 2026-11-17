# AS-IS 실측 요약 — FP00609

- 실행: 2026-11-13 04:44:52.012 ~ 2026-11-13 04:46:55.681 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simul By Bld(Elec.) (GSCM.FP.Planning.UIL.FP00609_Pancake_Simul_By_Bld_Elec)
- 조회 결과:  · DB : 71.104s, UI : 0.15s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "drpPlanDate", "prop": "DateTime", "value": "20260919"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260918"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260917"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260916"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260915"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260914"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260913"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260912"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260911"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260910"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260909"}, {"name": "drpPlanDate", "prop": "DateTime", "value": "20260908"}, {"name": "chk_rel", "prop": "Checked", "value": "true"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:44:52.741 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00609 |
| 04:44:52.762 | load | GSCM.FP_Common | SELECT * | 351 | 11.07 | USER_ID= |
| 04:44:52.766 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.43 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:44:52.917 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.23 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:44:52.942 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:44:52, END_TIME=2026-11-13 04:44:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044452_906, PA |
| 04:44:53.035 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 12 | 70.21 | USER_ID=jaeuk.shin, MENU_ID=FP00609_Main |
| 04:44:53.039 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 04:44:53.053 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00609, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:44:53.060 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 3.37 | p_program_id=FP00609, p_sheet_name=Main |
| 04:44:53.117 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 12 | 5.23 | p_sys_type=SELECT, p_sys_flag=CELL_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261113^D^N^ |
| 04:44:53.121 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.67 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CELL_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 04:44:53.159 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 6.05 | p_sys_type=SELECT, p_sys_flag=PANCAKE_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261113^D^N^ |
| 04:44:53.163 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PANCAKE_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 04:44:53.189 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 4.92 | p_sys_type=SELECT, p_sys_flag=UOM_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261113^D^N^ |
| 04:44:53.193 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.66 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UOM_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_ |
| 04:44:53.228 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 20.71 | p_sys_type=SELECT, p_sys_flag=UNIT, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261113^D^N^CELL^ |
| 04:44:53.232 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.91 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UNIT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_none |
| 04:44:53.374 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 11 | 129.42 | p_sys_type=SELECT, p_sys_flag=INSTANCE_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261113^D^N^CELL^1^ |
| 04:44:53.377 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.49 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'INSTANCE_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@o |
| 04:44:53.441 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 32.81 | p_sys_type=SELECT, p_sys_flag=CURR_DATE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^, in_row=mXlVW48SU1c3wPszIA83/w==^LINE_AMEND_E_PRE^20261 |
| 04:44:53.456 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.09 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 04:44:53.470 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 6.09 | p_sys_type=SELECT, p_sys_flag=ELEC_FACTORY, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^, in_row=mXlVW48SU1c3 |
| 04:44:53.526 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.45 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'ELEC_FACTORY',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 04:44:53.543 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 7.47 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^, in_row=mXl |
| 04:44:53.583 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.83 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:44:53.650 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.67 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:44:53.658 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 3.85 | p_program_id=FP00609, p_sheet_name=Amend |
| 04:44:53.672 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:44:53.678 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 3.89 | p_program_id=FP00609, p_sheet_name=Amend |
| 04:44:53.802 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 26.83 | MenuID=Pancake Simul By Bld(Elec.), CnntCode=0104001, UserID=jaeuk.shin |
| 04:44:53.874 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00609 |
| 04:45:01.554 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 23.7 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:01.586 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.39 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:04.237 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 22.66 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:04.272 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.52 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:06.933 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 22.79 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:06.962 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.16 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:09.471 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 36.18 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:09.494 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.18 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:12.164 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 23.03 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:12.193 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.73 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:14.875 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 193.41 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:14.931 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.28 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:17.588 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 22.35 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:17.593 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.33 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:20.076 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 22.81 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:20.101 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.53 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:22.800 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 79.33 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:22.880 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.99 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:25.614 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 39.92 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:25.724 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 109.77 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:28.252 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 22.58 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:28.283 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.64 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:30.921 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 21.6 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:30.941 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.7 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:33.938 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 9.13 | p_sys_type=SELECT, p_sys_flag=FP_PLAN_ID, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:45:33.966 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.73 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'FP_PLAN_ID',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:45:38.109 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.73 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:45:38.122 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.0 | p_program_id=FP00609, p_sheet_name=Amend |
| 04:45:38.129 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP00609, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:45:38.136 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.85 | p_program_id=FP00609, p_sheet_name=Amend |
| 04:45:38.163 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 3.18 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:45:38.168 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DAT |
| 04:45:38.177 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 21 | 3.33 | PLAN_DATE=20261112, BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:45:38.182 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=find_DateMap, QUERY_ID=FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : USER_ID
---Check client parameter : AMEND_INSTANCE
-- |
| 04:45:38.192 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 3.33 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:45:38.196 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DA |
| 04:45:38.207 | find | GSCM.FP_Common | SELECT 	A.* | 21 | 4.06 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:45:38.211 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.25 | PROG_ID=find_BukInfo, QUERY_ID=FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DAT |
| 04:46:43.501 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 65281.63 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_PANCAKE_SIMUL_BY_BLD_ELEC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^ |
| 04:46:43.507 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=PR_UI_FP00609_PANCAKE_SIMUL_BY_BLD_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:45:38, END_TIME=2026-11-13 04:46:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044538_21 |
| 04:46:43.563 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.94 | PROG_ID=PR_UI_FP00609_PANCAKE_SIMUL_BY_BLD_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:45:38, END_TIME=2026-11-13 04:46:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044538_21 |
| 04:46:43.569 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.64 | PROG_ID=PR_UI_FP00609_PANCAKE_SIMUL_BY_BLD_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00 |
| 04:46:43.573 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.99 | PROG_ID=PR_UI_FP00609_PANCAKE_SIMUL_BY_BLD_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!ME |
| 04:46:45.390 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3198 | 1801.48 | p_sys_type=SELECT, p_sys_flag=UOM_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^SHE |
| 04:46:45.397 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.99 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:43, END_TIME=2026-11-13 04:46:45, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044643_588, PARAM_VALUE={p_sys_ |
| 04:46:45.402 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:43, END_TIME=2026-11-13 04:46:45, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044643_588, PARAM_VALUE=ME:Sub  |
| 04:46:45.407 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.48 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'UOM_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt_ |
| 04:46:45.413 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.04 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=SER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_total#MEA_VALUE:false#MEA_N |
| 04:46:48.570 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 10584 | 3026.8 | p_sys_type=SELECT, p_sys_flag=YIELD_INFO_CHILD, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRA |
| 04:46:48.584 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.27 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:45, END_TIME=2026-11-13 04:46:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044645_543, PARAM_VALUE={p_sys_ |
| 04:46:48.588 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.82 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:45, END_TIME=2026-11-13 04:46:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044645_543, PARAM_VALUE=e#MEA_N |
| 04:46:48.594 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.4 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'YIELD_INFO_CHILD',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ET |
| 04:46:48.599 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.91 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_total#MEA_VALUE:fal |
| 04:46:48.851 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 727 | 89.23 | p_sys_type=SELECT, p_sys_flag=PROD_VERSION_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGR |
| 04:46:48.863 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.47 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:48, END_TIME=2026-11-13 04:46:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044648_76, PARAM_VALUE={p_sys_t |
| 04:46:48.868 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:48, END_TIME=2026-11-13 04:46:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044648_76, PARAM_VALUE=se#MEA_N |
| 04:46:48.874 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.08 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PROD_VERSION_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_E |
| 04:46:48.895 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.91 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_total#MEA_VALUE:fa |
| 04:46:49.107 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 193.64 | p_sys_type=SELECT, p_sys_flag=POST_YIELD, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^S |
| 04:46:49.113 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.83 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:48, END_TIME=2026-11-13 04:46:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044648_911, PARAM_VALUE={p_sys_ |
| 04:46:49.133 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.97 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:48, END_TIME=2026-11-13 04:46:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044648_911, PARAM_VALUE=NAME:Su |
| 04:46:49.139 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.24 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'POST_YIELD',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@op |
| 04:46:49.144 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.1 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_total#MEA_VALUE:false#MEA |
| 04:46:49.206 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 10 | 49.51 | p_sys_type=SELECT, p_sys_flag=VERSION_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID |
| 04:46:49.211 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.83 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:49, END_TIME=2026-11-13 04:46:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044649_154, PARAM_VALUE={p_sys_ |
| 04:46:49.216 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.9 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:49, END_TIME=2026-11-13 04:46:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044649_154, PARAM_VALUE=A_NAME: |
| 04:46:49.222 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.8 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'VERSION_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@ |
| 04:46:49.239 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.97 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=G:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_total#MEA_VALUE:false#M |
| 04:46:49.344 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 93.02 | p_sys_type=SELECT, p_sys_flag=START_END, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00609_ETC, opt_none=, in_columns=USER_ID^AMEND_INSTANCE^PLAN_DATE^BUCKET^RELEASE_FLAG^UOM_TYPE^UNIT^INSTANCE_ID^MASTER_ID^ROUND_POINT^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^FACTORY_ID^PROGRAM_ID^SH |
| 04:46:49.360 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.62 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:49, END_TIME=2026-11-13 04:46:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044649_251, PARAM_VALUE={p_sys_ |
| 04:46:49.364 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.1 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:49, END_TIME=2026-11-13 04:46:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044649_251, PARAM_VALUE=AME:Sub |
| 04:46:49.371 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.5 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'START_END',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00609_ETC',@opt |
| 04:46:49.377 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.67 | PROG_ID=PR_UI_FP00609_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_subtotal#MEA_VALUE:false#MEA_NAME:Sub Total#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00609_Main#!MEA_ID:chk_total#MEA_VALUE:false#MEA_ |
| 04:46:49.413 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.55 | p_menu_id=FP00609, p_log_type=FIND, p_log_cnt=, p_db_time=71.104, p_ui_time=0.15, p_user_id=jaeuk.shin |
| 04:46:54.920 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.11 | MenuID=Pancake Simul By Bld(Elec.), CnntCode=0104002, UserID=jaeuk.shin |

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

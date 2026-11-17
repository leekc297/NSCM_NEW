# AS-IS 실측 요약 — FP00623

- 실행: 2026-11-12 19:06:49.333 ~ 2026-11-12 19:07:30.090 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Simulation(Elec.) (GSCM.FP.Planning.UIL.FP00623_Pancake_Simulation_Elec)
- 조회 결과:  · DB : 24.39s, UI : 0.134s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:06:49.815 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00623 |
| 19:06:49.830 | load | GSCM.FP_Common | SELECT * | 351 | 9.27 | USER_ID= |
| 19:06:49.835 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.4 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:06:49.925 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.36 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:06:49.929 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.63 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:06:49, END_TIME=2026-11-12 19:06:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190649_917, PA |
| 19:06:49.950 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 0 | 4.89 | USER_ID=jaeuk.shin, MENU_ID=FP00623_Main |
| 19:06:49.993 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.66 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:06:50.001 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00623, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:06:50.011 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 4.84 | p_program_id=FP00623, p_sheet_name=Main |
| 19:06:50.170 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 11 | 108.47 | p_sys_type=SELECT, p_sys_flag=CELL_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^N^N^mXlVW48SU1c3wPszIA83/w==^ |
| 19:06:50.184 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.49 | PROG_ID=PR_UI_FP00623_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CELL_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_ETC',@opt |
| 19:06:50.236 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 6 | 46.3 | p_sys_type=SELECT, p_sys_flag=PANCAKE_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^N^N^mXlVW48SU1c3wPszIA83/w==^ |
| 19:06:50.240 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.55 | PROG_ID=PR_UI_FP00623_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PANCAKE_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_ETC',@ |
| 19:06:50.609 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 13 | 361.91 | p_sys_type=SELECT, p_sys_flag=INSTANCE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^N^N^mXlVW48SU1c3wPszIA83/w==^ |
| 19:06:50.613 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=PR_UI_FP00623_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'INSTANCE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_ETC',@opt_ |
| 19:06:50.717 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 12.9 | p_sys_type=SELECT, p_sys_flag=IS_PAST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^INSTANCE_ID^MASTER_ID^CONFIRM_AREA^, in_row=LINE_AMEND_E_PRE^20261112^Y^N^N^mXlVW48SU1c3wPszIA83/w==^ |
| 19:06:50.721 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00623_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'IS_PAST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_ETC',@opt_n |
| 19:06:50.798 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 44.51 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^INSTANCE_ID^MASTER_ID^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^UOM_TYPE^UNIT^, in_row=LINE_AMEN |
| 19:06:50.810 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.82 | PROG_ID=PR_UI_FP00623_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_ETC',@opt |
| 19:06:50.825 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.17 | p_program_id=FP00623, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:06:50.874 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 44.73 | p_program_id=FP00623, p_sheet_name=Amend |
| 19:06:50.883 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.85 | p_program_id=FP00623, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:06:50.894 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 3.67 | p_program_id=FP00623, p_sheet_name=Amend |
| 19:06:50.996 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 53.72 | MenuID=Pancake Simulation(Elec.), CnntCode=0104001, UserID=jaeuk.shin |
| 19:06:51.122 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00623 |
| 19:06:59.380 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 8.19 | p_sys_type=SELECT, p_sys_flag=IS_PAST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^INSTANCE_ID^MASTER_ID^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^UOM_TYPE^UNIT^RELEASE_FLAG^, in_ro |
| 19:06:59.406 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.86 | PROG_ID=PR_UI_FP00623_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'IS_PAST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_ETC',@opt_n |
| 19:06:59.465 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.87 | p_program_id=FP00623, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:06:59.475 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 6.85 | p_program_id=FP00623, p_sheet_name=Amend |
| 19:06:59.483 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.94 | p_program_id=FP00623, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:06:59.490 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 3.71 | p_program_id=FP00623, p_sheet_name=Amend |
| 19:06:59.512 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 5.72 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:06:59.516 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.7 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check clie |
| 19:06:59.528 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 21 | 5.5 | PLAN_DATE=20261112, BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:06:59.533 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---FOUND PLAN_DATE |
| 19:06:59.545 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 5.87 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:06:59.550 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check cli |
| 19:06:59.563 | find | GSCM.FP_Common | SELECT A.* | 21 | 6.83 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:06:59.567 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=find_BukInfo, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check clie |
| 19:07:23.381 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 23807.59 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^INSTANCE_ID^MASTER_ID^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^UOM_TYPE^UNIT^RELEASE_FLAG |
| 19:07:23.386 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.37 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_PAN |
| 19:07:23.878 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 439.86 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^CHK_TOTAL_INCLUDE^USER_ID^INSTANCE_ID^MASTER_ID^CONFIRM_AREA^CURR_DATE^BUCKET_FROM^BUCKET_TO^UOM_TYPE^UNIT^RELEASE |
| 19:07:23.884 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0062 |
| 19:07:23.911 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.31 | p_program_id=FP00623, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:07:23.920 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 4.3 | p_program_id=FP00623, p_sheet_name=Amend |
| 19:07:23.998 | find | GSCM.FP_Common | ;WITH LOOK_UP AS | 0 | 48.72 | DIVISION_ID=, SITE_ID=, ITEM_ID= |
| 19:07:24.017 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.03 | PROG_ID=list_dio, QUERY_ID=FP\MASTER\DIO, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0DIVISION_ID
---Service Parameter : 1SITE_ID
---Service Parameter : 2ITEM_ID
---Check client parameter : DIVISION_ID
---FOUND DIVISION_ID
-- TYPE = nvarchar---Add string Service
---Check client para |
| 19:07:24.030 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.99 | p_menu_id=FP00623, p_log_type=FIND, p_log_cnt=, p_db_time=24.39, p_ui_time=0.134, p_user_id=jaeuk.shin |
| 19:07:29.247 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 33.25 | MenuID=Pancake Simulation(Elec.), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plan Group | cbo_plan_group |  |
| Instance Date | drpPlanDate |  |
| Plan Id | cboPlanId |  |
| Plan Period | dCalendar_planrange |  |
| Material | edtItem |  |
| Nick Name | edtNickName |  |
| Uom Type | cboUomType |  |
| Unit | cboUnit |  |
| lblRelease | chk_release |  |
| layoutControlItem51 | chkTotal |  |
| Cell Type | cboCellType |  |
| Pancake Type | cboPancakeType |  |
| Model | edtTopItemId |  |
| Model Nick Name | edtModelNickName |  |

## 그리드

- spdMain / Amend: 행 7 · 컬럼 44(보임 43) · 헤더 2단 · 고정 컬럼 23

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

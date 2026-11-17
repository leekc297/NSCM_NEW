# AS-IS 실측 요약 — FP02845

- 실행: 2026-11-12 19:28:55.884 ~ 2026-11-12 19:29:42.022 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Result (Elec Post Shift) (GSCM.FP.Planning.UIL.FP02845_Plan_Result_Elec_Post_Shift)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:28:56.272 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 31.7 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:28:56.275 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.15 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:56, END_TIME=2026-11-12 19:28:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192856_24, PAR |
| 19:28:56.519 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02845 |
| 19:28:56.536 | load | GSCM.FP_Common | SELECT * | 351 | 10.42 | USER_ID= |
| 19:28:56.541 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.55 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:28:56.914 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.6 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:28:56.918 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.65 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:56, END_TIME=2026-11-12 19:28:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192856_906, PA |
| 19:28:56.958 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 15 | 4.77 | USER_ID=jaeuk.shin, MENU_ID=FP02845_Amend |
| 19:28:56.966 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.76 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:28:56.975 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.4 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:28:56.984 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 4.01 | p_program_id=FP02845, p_sheet_name=Amend |
| 19:28:57.029 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 9.26 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP02845_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:28:57.078 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP02845_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 19:28:57.525 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 341.71 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=PSI_AMEND_E_POST, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:28:57.552 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.34 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'PSI_AMEND_E_POST',@param2=N'Y',@param3=N'',@param4=N'',@ |
| 19:28:57.776 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 209.05 | p_sys_type=SELECT, p_sys_flag=PLAN_PERIOD, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02845_ETC, opt_none=, in_columns=UOM^AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=JR^PSI_AMEND_E_POST^ |
| 19:28:57.781 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=PR_UI_FP02845_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_PERIOD',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02845_ETC',@o |
| 19:28:58.316 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 437.36 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:28:58.321 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.88 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:57, END_TIME=2026-11-12 19:28:58, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192857_878, PA |
| 19:28:58.803 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 461.92 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, par |
| 19:28:58.806 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:58, END_TIME=2026-11-12 19:28:58, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192858_34, PAR |
| 19:28:59.125 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 301.96 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24= |
| 19:28:59.129 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.88 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:58, END_TIME=2026-11-12 19:28:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192858_823, PA |
| 19:28:59.371 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 211.05 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=PL_E_POST, param2=, param3=, param4=BUILDING, param5=81, param6=A004, param7=WA00, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:28:59.396 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.32 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'PL_E_POST',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 19:28:59.722 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 277.3 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=WA00, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=,  |
| 19:28:59.725 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.2 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:59, END_TIME=2026-11-12 19:28:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192859_445, PA |
| 19:29:00.183 | load | GSCM.FP_Common | UI_FP_COMMON | 62 | 441.63 | code=LINE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=WA00, param10=, param11=, param12=, param13=E3000,E4000, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, para |
| 19:29:00.188 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.84 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:59, END_TIME=2026-11-12 19:29:00, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192859_741, PA |
| 19:29:00.378 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 151.01 | p_sys_type=SELECT, p_sys_flag=PRODUCTION_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02842_ETC, opt_none=, in_columns=UOM^AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIV |
| 19:29:00.384 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.77 | PROG_ID=PR_UI_FP02842_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PRODUCTION_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02842_ETC |
| 19:29:00.404 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.04 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:29:00.412 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 3.48 | p_program_id=FP02845, p_sheet_name=Amend |
| 19:29:00.421 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.85 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:29:00.429 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 3.83 | p_program_id=FP02845, p_sheet_name=Amend |
| 19:29:00.560 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.01 | MenuID=Plan Result (Elec Post Shift), CnntCode=0104001, UserID=jaeuk.shin |
| 19:29:00.693 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02845 |
| 19:29:10.523 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 5.64 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261109, param3=20261117, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:29:10.527 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.4 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261109',@param3=N'20261117',@param4=N'',@param5=N' |
| 19:29:10.583 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 43.37 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=PL_E_POST, param2=, param3=A004, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:29:10.627 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.03 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'PL_E_POST',@param2=N'',@param3=N'A004',@param4=N'BUILDING',@param5=N' |
| 19:29:10.646 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 6.04 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:29:10.683 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:29:10.700 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 6.5 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:29:10.739 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.31 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:29:10.759 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 7.78 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:29:10.783 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.37 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@param |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Operation | mcbo_operation |  |
| Div | mcbo_division |  |
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| layoutControlItem16 | chk_includeSubOp |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Site | mcbo_site |  |
| UOM | rdo_uom |  |
| Plan Period | dCalendar_planrange |  |
| Plan Date | sCalendar_planday |  |
| Plan Group | cbo_plan_group |  |
| Prod.Type | mcbo_prodtype |  |
| layoutControlItem2 | chk_plannedline |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 18(보임 14) · 헤더 3단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

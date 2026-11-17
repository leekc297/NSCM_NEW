# AS-IS 실측 요약 — FP02845

- 실행: 2026-11-12 22:16:28.573 ~ 2026-11-12 22:17:18.039 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Result (Elec Post Shift) (GSCM.FP.Planning.UIL.FP02845_Plan_Result_Elec_Post_Shift)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:16:28.921 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.58 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:16:28.925 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.42 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:28, END_TIME=2026-11-12 22:16:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221628_914, PA |
| 22:16:29.141 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02845 |
| 22:16:29.158 | load | GSCM.FP_Common | SELECT * | 351 | 9.86 | USER_ID= |
| 22:16:29.180 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.1 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:16:29.373 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.18 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:16:29.377 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:29, END_TIME=2026-11-12 22:16:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221629_366, PA |
| 22:16:29.397 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 15 | 3.99 | USER_ID=jaeuk.shin, MENU_ID=FP02845_Amend |
| 22:16:29.426 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.63 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:16:29.433 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.91 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:16:29.441 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 4.38 | p_program_id=FP02845, p_sheet_name=Amend |
| 22:16:29.483 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 10.84 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP02845_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:29.521 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.15 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP02845_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 22:16:29.963 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 356.3 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=PSI_AMEND_E_POST, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:29.987 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.6 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'PSI_AMEND_E_POST',@param2=N'Y',@param3=N'',@param4=N'',@ |
| 22:16:30.066 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 66.13 | p_sys_type=SELECT, p_sys_flag=PLAN_PERIOD, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02845_ETC, opt_none=, in_columns=UOM^AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=JR^PSI_AMEND_E_POST^ |
| 22:16:30.110 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.05 | PROG_ID=PR_UI_FP02845_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_PERIOD',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02845_ETC',@o |
| 22:16:30.606 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 456.25 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:16:30.612 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.56 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:30, END_TIME=2026-11-12 22:16:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221630_15, PAR |
| 22:16:31.094 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 466.09 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, par |
| 22:16:31.108 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.57 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:30, END_TIME=2026-11-12 22:16:31, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221630_627, PA |
| 22:16:31.413 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 290.73 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24= |
| 22:16:31.417 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.66 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:31, END_TIME=2026-11-12 22:16:31, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221631_123, PA |
| 22:16:31.665 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 214.35 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=PL_E_POST, param2=, param3=, param4=BUILDING, param5=81, param6=A004, param7=WA00, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:31.690 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.32 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'PL_E_POST',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 22:16:32.009 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 305.87 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=WA00, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=,  |
| 22:16:32.012 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.33 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:31, END_TIME=2026-11-12 22:16:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221631_702, PA |
| 22:16:32.420 | load | GSCM.FP_Common | UI_FP_COMMON | 62 | 394.21 | code=LINE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=WA00, param10=, param11=, param12=, param13=E3000,E4000, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, para |
| 22:16:32.423 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:16:32, END_TIME=2026-11-12 22:16:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221632_025, PA |
| 22:16:32.538 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 70.19 | p_sys_type=SELECT, p_sys_flag=PRODUCTION_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02842_ETC, opt_none=, in_columns=UOM^AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIV |
| 22:16:32.543 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=PR_UI_FP02842_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PRODUCTION_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02842_ETC |
| 22:16:32.561 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.17 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:16:32.571 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 4.12 | p_program_id=FP02845, p_sheet_name=Amend |
| 22:16:32.579 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.9 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:16:32.587 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 4.06 | p_program_id=FP02845, p_sheet_name=Amend |
| 22:16:32.679 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 58.08 | MenuID=Plan Result (Elec Post Shift), CnntCode=0104001, UserID=jaeuk.shin |
| 22:16:32.800 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02845 |
| 22:16:43.826 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 6.0 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261109, param3=20261117, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:43.906 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 79.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261109',@param3=N'20261117',@param4=N'',@param5=N' |
| 22:16:43.961 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 39.21 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=PL_E_POST, param2=, param3=A004, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:43.981 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.67 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'PL_E_POST',@param2=N'',@param3=N'A004',@param4=N'BUILDING',@param5=N' |
| 22:16:43.996 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 6.38 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:44.086 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 88.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:16:44.104 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 9.45 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:44.145 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.57 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@para |
| 22:16:44.162 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 7.36 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:16:44.212 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.84 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
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

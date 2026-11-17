# AS-IS 실측 요약 — FP00518

- 실행: 2026-11-12 18:35:37.490 ~ 2026-11-12 18:35:59.782 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipping Plan (GSCM.FP.Master.UIL.FP00518_Shipping_Plan)
- 조회 결과: Total :  · DB : 1.381s, UI : 0.07s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:35:37.893 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 129.62 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:35:37.953 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 59.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:37, END_TIME=2026-11-12 18:35:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183537_762, PA |
| 18:35:38.037 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00518 |
| 18:35:38.053 | load | GSCM.FP_Common | SELECT * | 351 | 9.09 | USER_ID= |
| 18:35:38.110 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 57.75 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:35:38.611 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 13 | 374.31 | p_code=FP00518_findInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PRE, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:35:38.678 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 66.51 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00518_findInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PRE',@param2=N'',@param3=N'',@param4=N'' |
| 18:35:39.186 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 450.81 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 18:35:39.241 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.96 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:38, END_TIME=2026-11-12 18:35:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183538_735, PA |
| 18:35:39.550 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 11 | 252.84 | p_code=FP00518_find_cellType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:35:39.574 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.9 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00518_find_cellType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 18:35:39.718 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 23 | 16.63 | p_code=FP00518_find_WPPWeek, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:35:39.798 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 79.24 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00518_find_WPPWeek',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@p |
| 18:35:40.251 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 0 | 369.9 | p_code=FP00518_find_WPPSeq, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=202646, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:35:40.323 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 72.34 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00518_find_WPPSeq',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'202646',@param3=N'',@param4=N'',@param5=N'' |
| 18:35:41.086 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 1 | 752.81 | p_code=FP00518_find_currVersion, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:35:41.157 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.03 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00518_find_currVersion',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'', |
| 18:35:41.386 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 6 | 219.8 | p_code=FP00518_find_pancakeType, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:35:41.408 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.46 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00518_find_pancakeType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 18:35:41.581 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 161.63 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 18:35:41.642 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 61.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:41, END_TIME=2026-11-12 18:35:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183541_418, PA |
| 18:35:42.179 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 438.45 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, par |
| 18:35:42.185 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:41, END_TIME=2026-11-12 18:35:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183541_741, PA |
| 18:35:42.540 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 300.46 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24 |
| 18:35:42.544 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.48 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:42, END_TIME=2026-11-12 18:35:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183542_239, PA |
| 18:35:42.651 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.85 | p_program_id=FP00518, p_sheet_name=ShippingPlan, p_user_id=jaeuk.shin |
| 18:35:42.728 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 73.18 | p_program_id=FP00518, p_sheet_name=ShippingPlan |
| 18:35:42.744 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.69 | p_program_id=FP00518, p_sheet_name=ShippingPlan, p_user_id=jaeuk.shin |
| 18:35:42.762 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.4 | p_program_id=FP00518, p_sheet_name=ShippingPlan |
| 18:35:43.242 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 420.62 | MenuID=Shipping Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 18:35:43.308 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00518 |
| 18:35:53.513 | find | GSCM.FP_Common | PR_UI_FP00518_SHIPPING_PLAN | 0 | 923.56 | p_sys_type=SELECT, p_sys_flag=SELECT, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_E_PRE_A, p_instance_date=, p_version_id=, p_company_id=, p_division_id=81, p_site_id=A001, p_plant_id=HQ07, p_item_id=, p_item_name=, p_production_type=, p_market=, p_transport_mode=, p_to_site_id=, p_to_plant |
| 18:35:53.632 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 117.65 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00518_SHIPPING_PLAN, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00518_SHIPPING_PLAN @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_E_PRE_A',@p_instance_ |
| 18:35:53.747 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 8.67 | p_menu_id=FP00518, p_log_type=FIND, p_log_cnt=, p_db_time=1.381, p_ui_time=0.07, p_user_id=jaeuk.shin |
| 18:35:59.104 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.6 | MenuID=Shipping Plan, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Site | cboSite |  |
| Div | clbDivision |  |
| Plan Group | cboPlanGroup |  |
| Nick Name | txtItemName |  |
| Material | txtItemID |  |
| Cell Type | cboCellType |  |
| layoutControlItem9 | chkWPP |  |
| WPP Week | cboWppWeek |  |
| WPP Seq | cboWppSeq |  |
| Plant | clbPlant |  |
| Start/End Date | drpPeriod |  |
| lblExcelImport | btnImport |  |
| lblSql | btnSql |  |
| layoutControlItem12 | btnCreateWPP |  |

## 그리드

- spdMain / ShippingPlan: 행 0 · 컬럼 25(보임 15) · 헤더 1단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

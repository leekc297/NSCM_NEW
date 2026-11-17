# AS-IS 실측 요약 — FP00460

- 실행: 2026-11-12 18:32:59.003 ~ 2026-11-12 18:33:28.838 · 계정 jaeuk.shin · 상태 OK
- 화면: Setup Group (GSCM.FP.Master.UIL.FP00460_Setup_Group)
- 조회 결과: Total : 107 · DB : 6.708s, UI : 0.007s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:33:00.108 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 743.73 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:33:00.111 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:32:59, END_TIME=2026-11-12 18:33:00, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183259_364, PA |
| 18:33:00.299 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00460 |
| 18:33:00.315 | load | GSCM.FP_Common | SELECT * | 351 | 10.43 | USER_ID= |
| 18:33:00.364 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.33 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:33:01.838 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 1384.89 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 18:33:01.949 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 110.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:00, END_TIME=2026-11-12 18:33:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183300_454, PA |
| 18:33:02.017 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 4 | 38.53 | p_code=FP00460_find_FilterCategory, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:33:02.141 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 123.82 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00460_find_FilterCategory',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 18:33:03.501 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1646 | 121889.13 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00411_FIND_FP00411, opt_none=, in_columns=USER_ID^SITE_ID^PLANT_ID^FACTORY_ID^LINE_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB |
| 18:33:03.711 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 1547.64 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 18:33:03.711 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 209.86 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:31:01, END_TIME=2026-11-12 18:33:03, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183101_606, PARAM_VAL |
| 18:33:03.715 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.57 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:02, END_TIME=2026-11-12 18:33:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183302_163, PA |
| 18:33:03.774 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 62.8 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:31:01, END_TIME=2026-11-12 18:33:03, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183101_606, PARAM_VAL |
| 18:33:03.896 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 123.82 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00411_FIND_FP |
| 18:33:03.923 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.09 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=7CF6_4,FP_M7CF6_5,FP_M7CF6_6,FP_M7CF6_7,FP_S3E01L-1,FP_S3E01L-2,M1C09,M1CF2,M1CP1,M2C06,M2C07,M2C08,M2C09,M2C10,M2C11,M4J61,M4J62,M4J63,M4JA2,M4K45,M4K46,M4K50,M4K69,M4K79,M4K80,M4K81, |
| 18:33:05.583 | load | GSCM.FP_Common | UI_FP_COMMON | 39 | 1781.34 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=A001,A002,A003,A004,A007,A009, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19= |
| 18:33:05.657 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 73.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:03, END_TIME=2026-11-12 18:33:05, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183303_801, PA |
| 18:33:05.859 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.52 | p_program_id=FP00460, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 18:33:05.872 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 8.63 | p_program_id=FP00460, p_sheet_name=spdMain |
| 18:33:05.880 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.27 | p_program_id=FP00460, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 18:33:05.889 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 5.76 | p_program_id=FP00460, p_sheet_name=spdMain |
| 18:33:05.905 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 7.05 | p_program_id=FP00460, p_sheet_name=spdSub, p_user_id=jaeuk.shin |
| 18:33:05.951 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 43.12 | p_program_id=FP00460, p_sheet_name=spdSub |
| 18:33:05.961 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.89 | p_program_id=FP00460, p_sheet_name=spdSub, p_user_id=jaeuk.shin |
| 18:33:05.969 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 4.13 | p_program_id=FP00460, p_sheet_name=spdSub |
| 18:33:05.980 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.85 | p_program_id=FP00460, p_sheet_name=spdDetail, p_user_id=jaeuk.shin |
| 18:33:05.988 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 4.47 | p_program_id=FP00460, p_sheet_name=spdDetail |
| 18:33:05.990 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.26 | p_program_id=FP00460, p_sheet_name=spdDetail, p_user_id=jaeuk.shin |
| 18:33:06.007 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 7.62 | p_program_id=FP00460, p_sheet_name=spdDetail |
| 18:33:07.709 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1678.21 | MenuID=Setup Group, CnntCode=0104001, UserID=jaeuk.shin |
| 18:33:07.785 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00460 |
| 18:33:19.462 | find | GSCM.FP_Common | PR_UI_FP00460_SETUP_GROUP | 107 | 3713.07 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=, p_operation_id=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000 |
| 18:33:19.700 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 237.81 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00460_SETUP_GROUP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00460_SETUP_GROUP @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'40,81 |
| 18:33:21.586 | find | GSCM.FP_Common | PR_UI_FP00460_SETUP_GROUP | 206 | 1869.0 | p_sys_type=SELECT, p_sys_flag=SELECT_SUB, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=, p_operation_id=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000, |
| 18:33:21.707 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 120.99 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00460_SETUP_GROUP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00460_SETUP_GROUP @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_SUB',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'40,81, |
| 18:33:22.335 | find | GSCM.FP_Common | PR_UI_FP00460_SETUP_GROUP | 456 | 531.42 | p_sys_type=SELECT, p_sys_flag=SELECT_DETAIL_POPUP, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=, p_site_id=, p_plant_id=, p_operation_id=, p_setup_category_id=, p_setup_key_id=, p_level=, p_referance_operation_id=, p_calculation=, p_description=, p_line_setup_group_id=, p_org_li |
| 18:33:22.433 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 97.93 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00460_SETUP_GROUP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00460_SETUP_GROUP @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_DETAIL_POPUP',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id |
| 18:33:22.560 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 85.92 | p_menu_id=FP00460, p_log_type=FIND, p_log_cnt=107, p_db_time=6.708, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 18:33:27.968 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 22.31 | MenuID=Setup Group, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem5 | btnRefreshSetup |  |
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Operation | cboOperation |  |
| Category | cboCategory |  |
| Site | cboSite |  |
| layoutControlItem9 | usrLabel3 |  |
| layoutControlItem11 | btnSubImport |  |
| layoutControlItem10 | usrLabel1 |  |

## 그리드

- spdDetail / spdDetail: 행 456 · 컬럼 13(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdMain / spdMain: 행 107 · 컬럼 15(보임 12) · 헤더 1단 · 고정 컬럼 6
- spdSub / spdSub: 행 206 · 컬럼 12(보임 9) · 헤더 1단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

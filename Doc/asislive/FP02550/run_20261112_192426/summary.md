# AS-IS 실측 요약 — FP02550

- 실행: 2026-11-12 19:24:26.650 ~ 2026-11-12 19:24:48.182 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation(BOD) (GSCM.FP.Master.UIL.FP02550_Operation_Bod)
- 조회 결과: Total :  · DB : 0.259s, UI : 0.004s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:24:26.886 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.19 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:24:26.890 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:26, END_TIME=2026-11-12 19:24:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192426_878, PA |
| 19:24:27.030 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02550 |
| 19:24:27.054 | load | GSCM.FP_Common | SELECT * | 351 | 17.0 | USER_ID= |
| 19:24:27.060 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.47 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:24:27.502 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 137.54 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:24:27.506 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_365, PA |
| 19:24:27.534 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 9.46 | code=LOOKUP_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PRECEDE_PRODUCING_TERM_UOM, param22=, pa |
| 19:24:27.538 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_525, PA |
| 19:24:27.623 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 74.01 | code=LOOKUP_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=BUFFER_TIME_UOM, param22=, param23=, par |
| 19:24:27.627 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_548, PA |
| 19:24:27.646 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 9.11 | code=LOOKUP_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=INITIAL_PRODUCING_LEAD_TIME_UOM, param22 |
| 19:24:27.649 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.27 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_636, PA |
| 19:24:27.697 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 37.57 | code=LOOKUP_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=LOT_SIZE_UOM, param22=, param23=, param2 |
| 19:24:27.703 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_66, PAR |
| 19:24:27.857 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 139.96 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:24:27.861 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.39 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_717, PA |
| 19:24:28.019 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 140.79 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 19:24:28.023 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.25 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:27, END_TIME=2026-11-12 19:24:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192427_878, PA |
| 19:24:28.207 | load | GSCM.FP_Common | UI_FP_COMMON | 78 | 139.4 | code=FACTORY, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param10 |
| 19:24:28.210 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:28, END_TIME=2026-11-12 19:24:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192428_067, PA |
| 19:24:29.050 | load | GSCM.FP_Common | UI_FP_COMMON | 39 | 796.38 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param |
| 19:24:29.069 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.06 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:28, END_TIME=2026-11-12 19:24:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192428_253, PA |
| 19:24:29.117 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.14 | p_program_id=FP02550, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:24:29.126 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.04 | p_program_id=FP02550, p_sheet_name=Main |
| 19:24:29.136 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.94 | p_program_id=FP02550, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:24:29.145 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.13 | p_program_id=FP02550, p_sheet_name=Main |
| 19:24:29.185 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.27 | p_program_id=FP02550, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:24:29.194 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.49 | p_program_id=FP02550, p_sheet_name=Sub |
| 19:24:29.204 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP02550, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:24:29.213 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.33 | p_program_id=FP02550, p_sheet_name=Sub |
| 19:24:29.383 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 56.97 | MenuID=Operation(BOD), CnntCode=0104001, UserID=jaeuk.shin |
| 19:24:29.511 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02550 |
| 19:24:40.921 | find | GSCM.FP_Common | PR_UI_FP02550_OPERATION_BOD | 519 | 2518.1 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=, p_site_id=, p_plant_id=, p_factory_id=, p_operation_id=, p_item_id=, p_nick_name=, p_model_type=, p_line_attr= |
| 19:24:40.925 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02550_OPERATION_BOD, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02550_OPERATION_BOD @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'',@p_sit |
| 19:24:41.212 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.45 | p_menu_id=FP02550, p_log_type=FIND, p_log_cnt=519, p_db_time=2.549, p_ui_time=0.264, p_user_id=jaeuk.shin |
| 19:24:41.272 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.91 | p_program_id=FP02550, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:24:41.282 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.98 | p_program_id=FP02550, p_sheet_name=Sub |
| 19:24:41.292 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.51 | p_program_id=FP02550, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:24:41.301 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 5.15 | p_program_id=FP02550, p_sheet_name=Sub |
| 19:24:41.556 | find | GSCM.FP_Common | PR_UI_FP02550_OPERATION_BOD | 0 | 219.48 | p_sys_type=SELECT, p_sys_flag=SUB, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=HQ00, p_division_id=40, p_site_id=A001, p_plant_id=HQ06, p_factory_id=E2, p_operation_id=E0500, p_item_id=, p_nick_name=, p_model_type=Electrode, p_line_attr=Normal |
| 19:24:41.581 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.92 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02550_OPERATION_BOD, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02550_OPERATION_BOD @p_sys_type=N'SELECT',@p_sys_flag=N'SUB',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'HQ00',@p_division_id=N'40',@ |
| 19:24:41.593 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.35 | p_menu_id=FP02550, p_log_type=FIND, p_log_cnt=, p_db_time=0.259, p_ui_time=0.004, p_user_id=jaeuk.shin |
| 19:24:47.328 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.7 | MenuID=Operation(BOD), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Operation | clbOperation |  |
| lblExcelUpload | btnExcelUpload |  |
| lblSql | btnSql |  |
| layoutControlItem11 | btnSubImport |  |
| layoutControlItem1 | btnSearchAll |  |
| layoutControlItem2 | label1 |  |

## 그리드

- spdMain / Main: 행 519 · 컬럼 24(보임 23) · 헤더 2단 · 고정 컬럼 0
- spdSub / Sub: 행 0 · 컬럼 26(보임 25) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

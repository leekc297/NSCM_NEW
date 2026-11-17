# AS-IS 실측 요약 — FP02670

- 실행: 2026-11-12 19:27:10.874 ~ 2026-11-12 19:27:37.056 · 계정 jaeuk.shin · 상태 OK
- 화면: Slurry Batch Master (GSCM.FP.Master.UIL.FP02670_Slurry_Batch_Master)
- 조회 결과: Total : 107 · DB : 6.682s, UI : 0.114s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:27:11.306 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 91.01 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:27:11.310 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:11, END_TIME=2026-11-12 19:27:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192711_215, PA |
| 19:27:11.409 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02670 |
| 19:27:11.426 | load | GSCM.FP_Common | SELECT * | 351 | 9.47 | USER_ID= |
| 19:27:11.430 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.57 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:27:12.410 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 731.31 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:27:12.448 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.25 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:11, END_TIME=2026-11-12 19:27:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192711_678, PA |
| 19:27:12.497 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 18.44 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:27:12.500 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:12, END_TIME=2026-11-12 19:27:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192712_478, PA |
| 19:27:12.678 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 155.46 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:27:12.718 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.44 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:12, END_TIME=2026-11-12 19:27:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192712_521, PA |
| 19:27:12.900 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 142.01 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 19:27:12.903 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.8 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:12, END_TIME=2026-11-12 19:27:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192712_757, PA |
| 19:27:13.108 | load | GSCM.FP_Common | UI_FP_COMMON | 78 | 141.12 | code=FACTORY, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param10 |
| 19:27:13.112 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:12, END_TIME=2026-11-12 19:27:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192712_966, PA |
| 19:27:13.521 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 361.37 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param |
| 19:27:13.577 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:13, END_TIME=2026-11-12 19:27:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192713_16, PAR |
| 19:27:13.678 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP02670, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:27:13.710 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 26.32 | p_program_id=FP02670, p_sheet_name=Main |
| 19:27:13.720 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP02670, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:27:13.731 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 5.42 | p_program_id=FP02670, p_sheet_name=Main |
| 19:27:14.106 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 299.87 | MenuID=Slurry Batch Master, CnntCode=0104001, UserID=jaeuk.shin |
| 19:27:14.311 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02670 |
| 19:27:23.601 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.17 | p_program_id=FP02670, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:27:23.609 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 3.85 | p_program_id=FP02670, p_sheet_name=Main |
| 19:27:23.617 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.24 | p_program_id=FP02670, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:27:23.626 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 3.92 | p_program_id=FP02670, p_sheet_name=Main |
| 19:27:30.288 | find | GSCM.FP_Common | PR_UI_FP02670_SLURRY_BATCH_MASTER | 107 | 6637.22 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A |
| 19:27:30.312 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.48 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02670_SLURRY_BATCH_MASTER @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81 |
| 19:27:30.464 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 23.04 | p_menu_id=FP02670, p_log_type=FIND, p_log_cnt=107, p_db_time=6.682, p_ui_time=0.114, p_user_id=jaeuk.shin |
| 19:27:36.173 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.47 | MenuID=Slurry Batch Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem10 | btnCopyGplm |  |
| layoutControlItem10 | btnRecieveGplm |  |
| Div | clbDivision |  |
| Operation | clbOperation |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Material | txtItemId |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Main: 행 107 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

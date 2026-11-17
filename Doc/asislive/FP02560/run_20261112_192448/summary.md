# AS-IS 실측 요약 — FP02560

- 실행: 2026-11-12 19:24:48.291 ~ 2026-11-12 19:25:05.948 · 계정 jaeuk.shin · 상태 OK
- 화면: Site(BOD) (GSCM.FP.Master.UIL.FP02560_Site_Bod)
- 조회 결과: Total : 7 · DB : 1.333s, UI : 0.007s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:24:48.628 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.15 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:24:48.631 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:48, END_TIME=2026-11-12 19:24:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192448_62, PAR |
| 19:24:48.715 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02560 |
| 19:24:48.733 | load | GSCM.FP_Common | SELECT * | 351 | 10.18 | USER_ID= |
| 19:24:48.757 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.15 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:24:49.053 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 136.43 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:24:49.056 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.84 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:48, END_TIME=2026-11-12 19:24:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192448_915, PA |
| 19:24:49.119 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 40.28 | code=LOOKUP_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=TRANSPORT_MODE, param22=, param23=, para |
| 19:24:49.122 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.14 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:49, END_TIME=2026-11-12 19:24:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192449_078, PA |
| 19:24:49.288 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 154.31 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:24:49.304 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.12 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:49, END_TIME=2026-11-12 19:24:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192449_133, PA |
| 19:24:49.460 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 139.74 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 19:24:49.464 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:24:49, END_TIME=2026-11-12 19:24:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192449_32, PAR |
| 19:24:49.498 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP02560, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:24:49.533 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 29.0 | p_program_id=FP02560, p_sheet_name=Main |
| 19:24:49.542 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.11 | p_program_id=FP02560, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:24:49.550 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.95 | p_program_id=FP02560, p_sheet_name=Main |
| 19:24:49.755 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.77 | MenuID=Site(BOD), CnntCode=0104001, UserID=jaeuk.shin |
| 19:24:49.895 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02560 |
| 19:24:58.289 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.49 | p_program_id=FP02560, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:24:58.297 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.9 | p_program_id=FP02560, p_sheet_name=Main |
| 19:24:58.307 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.34 | p_program_id=FP02560, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:24:58.315 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.18 | p_program_id=FP02560, p_sheet_name=Main |
| 19:24:59.685 | find | GSCM.FP_Common | PR_UI_FP02560_SITE_BOD | 7 | 1312.97 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id= |
| 19:24:59.691 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.2 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02560_SITE_BOD, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02560_SITE_BOD @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81_ST,81_UC,82',@p |
| 19:24:59.710 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.33 | p_menu_id=FP02560, p_log_type=FIND, p_log_cnt=7, p_db_time=1.333, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 19:25:05.072 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.17 | MenuID=Site(BOD), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| lblExcelUpload | btnExcelImport |  |

## 그리드

- spdMain / Main: 행 7 · 컬럼 24(보임 22) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

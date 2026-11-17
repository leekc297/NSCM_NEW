# AS-IS 실측 요약 — FP03590

- 실행: 2026-11-12 19:30:34.877 ~ 2026-11-12 19:30:54.865 · 계정 jaeuk.shin · 상태 OK
- 화면: PDS Target (GSCM.FP.Master.UIL.FP03590_PDS_Target)
- 조회 결과: Total :  · DB : 0.685s, UI : 0.072s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:30:35.261 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.23 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:30:35.265 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:30:35, END_TIME=2026-11-12 19:30:35, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193035_254, PA |
| 19:30:35.431 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.57 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP03590 |
| 19:30:35.449 | load | GSCM.FP_Common | SELECT * | 351 | 9.4 | USER_ID= |
| 19:30:35.453 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.78 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:30:35.764 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 1 | 15.52 | p_code=FP03590_findMFGDate, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:30:35.774 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.31 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP03590_findMFGDate',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@pa |
| 19:30:35.946 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 163.47 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 19:30:35.962 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:30:35, END_TIME=2026-11-12 19:30:35, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193035_783, PA |
| 19:30:36.138 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 155.34 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:30:36.151 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.9 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:30:35, END_TIME=2026-11-12 19:30:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193035_982, PA |
| 19:30:36.726 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 479.2 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=A001,A002,A003,A004,A007,A009, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, pa |
| 19:30:36.730 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:30:36, END_TIME=2026-11-12 19:30:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193036_248, PA |
| 19:30:37.004 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.1 | p_program_id=FP03590, p_sheet_name=MAIN, p_user_id=jaeuk.shin |
| 19:30:37.040 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 30.03 | p_program_id=FP03590, p_sheet_name=MAIN |
| 19:30:37.050 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.84 | p_program_id=FP03590, p_sheet_name=MAIN, p_user_id=jaeuk.shin |
| 19:30:37.060 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.61 | p_program_id=FP03590, p_sheet_name=MAIN |
| 19:30:37.236 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.01 | MenuID=PDS Target, CnntCode=0104001, UserID=jaeuk.shin |
| 19:30:37.390 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP03590 |
| 19:30:48.158 | find | GSCM.FP_Common | PR_UI_FP03590_PDS_TARGET | 0 | 644.47 | p_sys_type=SELECT, p_sys_flag=S, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_due_start_date=202 |
| 19:30:48.186 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.27 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP03590_PDS_TARGET, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP03590_PDS_TARGET @p_sys_type=N'SELECT',@p_sys_flag=N'S',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'40,81,81_HD,81_HM |
| 19:30:48.270 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.89 | p_menu_id=FP03590, p_log_type=FIND, p_log_cnt=, p_db_time=0.685, p_ui_time=0.072, p_user_id=jaeuk.shin |
| 19:30:53.985 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.66 | MenuID=PDS Target, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Site | cboSite |  |
| Plant | clbPlant |  |
| layoutControlItem5 | btnAdd |  |
| Material | txtItemID |  |
| Nick Name | txtNickName |  |
| lblExcelImport | btnImport |  |
| lblSql | btnSql |  |
| Due Date | drpPeriod |  |

## 그리드

- spdMain / MAIN: 행 0 · 컬럼 29(보임 28) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

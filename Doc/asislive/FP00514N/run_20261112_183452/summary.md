# AS-IS 실측 요약 — FP00514N

- 실행: 2026-11-12 18:34:52.849 ~ 2026-11-12 18:35:10.997 · 계정 jaeuk.shin · 상태 OK
- 화면: Test Target (GSCM.FP.Master.UIL.FP00514_TEST_Target)
- 조회 결과: Total :  · DB : 1.935s, UI : 0.069s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:34:53.412 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 205.66 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:34:53.420 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.82 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:53, END_TIME=2026-11-12 18:34:53, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183453_206, PA |
| 18:34:53.498 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00514 |
| 18:34:53.514 | load | GSCM.FP_Common | SELECT * | 351 | 9.5 | USER_ID= |
| 18:34:53.592 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.23 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:34:53.991 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 1 | 310.62 | p_code=FP00514_findMFGDate, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:34:54.023 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.62 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00514_findMFGDate',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@pa |
| 18:34:54.107 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.82 | p_program_id=FP00514, p_sheet_name=TEST_Target, p_user_id=jaeuk.shin |
| 18:34:54.228 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 116.88 | p_program_id=FP00514, p_sheet_name=TEST_Target |
| 18:34:54.235 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP00514, p_sheet_name=TEST_Target, p_user_id=jaeuk.shin |
| 18:34:54.245 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.86 | p_program_id=FP00514, p_sheet_name=TEST_Target |
| 18:34:54.498 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 211.16 | MenuID=Test Target, CnntCode=0104001, UserID=jaeuk.shin |
| 18:34:54.626 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00514 |
| 18:35:04.856 | find | GSCM.FP_Common | PR_UI_FP00514_TEST_TARGET | 0 | 1872.65 | p_sys_type=SELECT, p_sys_flag=S, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_mfg_start_date=202 |
| 18:35:04.907 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.04 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00514_TEST_TARGET, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00514_TEST_TARGET @p_sys_type=N'SELECT',@p_sys_flag=N'S',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'40,81,81_HD,81_ |
| 18:35:05.030 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 47.03 | p_menu_id=FP00514, p_log_type=FIND, p_log_cnt=, p_db_time=1.935, p_ui_time=0.069, p_user_id=jaeuk.shin |
| 18:35:10.334 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.92 | MenuID=Test Target, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| lblSql | btnSql |  |
| Site | cboSite |  |
| Div | clbDivision |  |
| Material | txtItemID |  |
| MFG Date | drpPeriod |  |
| lblExcelImport | btnImport |  |
| layoutControlItem5 | btnAdd |  |

## 그리드

- spdMain / TEST_Target: 행 0 · 컬럼 26(보임 20) · 헤더 1단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

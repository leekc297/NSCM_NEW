# AS-IS 실측 요약 — FP00517

- 실행: 2026-11-12 18:35:11.121 ~ 2026-11-12 18:35:37.429 · 계정 jaeuk.shin · 상태 OK
- 화면: Domestic Model Master (GSCM.FP.Master.UIL.FP00517_Domestic_Model_Master)
- 조회 결과: Total : 1,202 · DB : 10.165s, UI : 0.57s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:35:11.504 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 64.97 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:35:11.545 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:11, END_TIME=2026-11-12 18:35:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183511_438, PA |
| 18:35:11.604 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00517 |
| 18:35:11.622 | load | GSCM.FP_Common | SELECT * | 351 | 11.02 | USER_ID= |
| 18:35:11.626 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.24 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:35:11.843 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 143.48 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 18:35:11.845 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.52 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:11, END_TIME=2026-11-12 18:35:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183511_7, PARA |
| 18:35:11.928 | load | GSCM.FP_Common | UI_FP_COMMON | 56 | 60.51 | code=PRODUCTION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:35:11.981 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:11, END_TIME=2026-11-12 18:35:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183511_862, PA |
| 18:35:12.213 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 184.45 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 18:35:12.216 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.82 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:35:12, END_TIME=2026-11-12 18:35:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183512_028, PA |
| 18:35:12.280 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.22 | p_program_id=FP00517, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:35:12.329 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 45.43 | p_program_id=FP00517, p_sheet_name=Main |
| 18:35:12.337 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.06 | p_program_id=FP00517, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:35:12.345 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 3.93 | p_program_id=FP00517, p_sheet_name=Main |
| 18:35:12.679 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 285.17 | MenuID=Domestic Model Master, CnntCode=0104001, UserID=jaeuk.shin |
| 18:35:12.720 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00517 |
| 18:35:20.694 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP00517, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:35:20.703 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 4.14 | p_program_id=FP00517, p_sheet_name=Main |
| 18:35:20.715 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.55 | p_program_id=FP00517, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:35:20.739 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 20.81 | p_program_id=FP00517, p_sheet_name=Main |
| 18:35:30.813 | find | GSCM.FP_Common | PR_UI_FP00517_DOMESTIC_MODEL_MASTER | 1202 | 10051.23 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=, p_site_id=, p_active=, p_item_id= |
| 18:35:30.903 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 90.75 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00517_DOMESTIC_MODEL_MASTER, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00517_DOMESTIC_MODEL_MASTER @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'',@p_site_ |
| 18:35:31.559 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 67.33 | p_menu_id=FP00517, p_log_type=FIND, p_log_cnt=1202, p_db_time=10.165, p_ui_time=0.57, p_user_id=jaeuk.shin |
| 18:35:36.712 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.9 | MenuID=Domestic Model Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Site | clbSite |  |
| Material | txtItemId |  |
| Active | cboActive |  |

## 그리드

- spdMain / Main: 행 1202 · 컬럼 12(보임 9) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

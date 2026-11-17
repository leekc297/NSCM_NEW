# AS-IS 실측 요약 — FP02320N

- 실행: 2026-11-12 19:23:02.135 ~ 2026-11-12 19:23:37.856 · 계정 jaeuk.shin · 상태 OK
- 화면: Pancake Master (GSCM.FP.Master.UIL.FP02320_Pancake_Master)
- 조회 결과: Total : 10,542 · DB : 3.277s, UI : 15.681s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:23:02.509 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.7 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:23:02.513 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:02, END_TIME=2026-11-12 19:23:02, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192302_501, PA |
| 19:23:02.636 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02320 |
| 19:23:02.653 | load | GSCM.FP_Common | SELECT * | 351 | 9.48 | USER_ID= |
| 19:23:02.656 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.46 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:23:03.074 | load | GSCM.FP_Common | UI_FP_COMMON | 188 | 47.66 | code=CONVERSION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 19:23:03.090 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:03, END_TIME=2026-11-12 19:23:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192303_025, PA |
| 19:23:03.111 | load | GSCM.FP_Common | UI_FP_COMMON | 17 | 8.25 | code=COUNTRY_ID, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, |
| 19:23:03.115 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:03, END_TIME=2026-11-12 19:23:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192303_103, PA |
| 19:23:03.238 | load | GSCM.FP_Common | UI_FP_COMMON | 60 | 112.61 | code=PROD_VERSION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 19:23:03.242 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.52 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:03, END_TIME=2026-11-12 19:23:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192303_125, PA |
| 19:23:03.284 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP02320, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:23:03.294 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.23 | p_program_id=FP02320, p_sheet_name=Main |
| 19:23:03.305 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP02320, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:23:03.315 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.14 | p_program_id=FP02320, p_sheet_name=Main |
| 19:23:03.511 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 67.06 | MenuID=Pancake Master, CnntCode=0104001, UserID=jaeuk.shin |
| 19:23:03.610 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.34 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02320 |
| 19:23:12.449 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.53 | p_program_id=FP02320, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:23:12.458 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.4 | p_program_id=FP02320, p_sheet_name=Main |
| 19:23:12.468 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.75 | p_program_id=FP02320, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:23:12.476 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.33 | p_program_id=FP02320, p_sheet_name=Main |
| 19:23:15.453 | find | GSCM.FP_Common | PR_UI_FP02320_PANCAKE_MASTER | 10542 | 2940.39 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A |
| 19:23:15.458 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.46 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02320_PANCAKE_MASTER, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02320_PANCAKE_MASTER @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81_ST, |
| 19:23:31.466 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.68 | p_menu_id=FP02320, p_log_type=FIND, p_log_cnt=10542, p_db_time=3.277, p_ui_time=15.681, p_user_id=jaeuk.shin |
| 19:23:36.985 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.53 | MenuID=Pancake Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Site | clbSite |  |
| Plant | clbPlant |  |
| lblSql | btnSql |  |
| lblExcelUpload | btnExcelImport |  |
| Material | tbItemId |  |
| Div | clbDivision |  |
| Nick Name | tbNickName |  |
| Building | clbFactory |  |
| Active | cboActive |  |
| Cut Off Date | dCalendar_planrange |  |
| Conversion Type | clbConversion |  |

## 그리드

- spdMain / Main: 행 10542 · 컬럼 29(보임 22) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

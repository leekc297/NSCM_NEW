# AS-IS 실측 요약 — FP00020

- 실행: 2026-11-12 18:24:01.739 ~ 2026-11-12 18:24:24.306 · 계정 jaeuk.shin · 상태 OK
- 화면: Site & Plant (GSCM.FP.Master.UIL.FP00020_Site_Plant)
- 조회 결과: Total : 122 · DB : 0.157s, UI : 0.127s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:24:03.422 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 1276.55 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:24:03.430 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.45 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:02, END_TIME=2026-11-12 18:24:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182402_119, PA |
| 18:24:03.486 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00020 |
| 18:24:03.791 | load | GSCM.FP_Common | SELECT * | 351 | 298.48 | USER_ID= |
| 18:24:03.812 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.7 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:24:04.427 | load | GSCM.FP_Common | UI_FP_COMMON | 8 | 518.91 | code=DIVISION, user_id=jaeuk.shin, non_auth=Y, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 18:24:04.457 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:03, END_TIME=2026-11-12 18:24:04, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182403_908, PA |
| 18:24:04.613 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 103.27 | code=SITE, user_id=jaeuk.shin, non_auth=Y, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param2 |
| 18:24:04.617 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.53 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:04, END_TIME=2026-11-12 18:24:04, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182404_509, PA |
| 18:24:10.248 | load | GSCM.FP_Common | UI_FP_COMMON | 28 | 5603.84 | code=PLANT, user_id=jaeuk.shin, non_auth=Y, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param1 |
| 18:24:10.253 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.04 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:04, END_TIME=2026-11-12 18:24:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182404_644, PA |
| 18:24:10.305 | load | GSCM.FP_Common | UI_FP_COMMON | 117 | 37.32 | code=NON_AUTH_FACTORY, user_id=jaeuk.shin, non_auth=Y, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB |
| 18:24:10.349 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:10, END_TIME=2026-11-12 18:24:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182410_267, PA |
| 18:24:10.421 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 37.29 | p_program_id=FP00020, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:24:10.574 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 126.02 | MenuID=Site & Plant, CnntCode=0104001, UserID=jaeuk.shin |
| 18:24:10.616 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00020 |
| 18:24:18.406 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 4.03 | p_program_id=FP00020, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:24:18.532 | find | GSCM.FP_Common | PR_UI_FP00020_SITE_PLANT | 122 | 107.74 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_lt=, p_site_id=, p_plant_lt=, p_factory_lt=, p_active= |
| 18:24:18.560 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.84 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00020_SITE_PLANT, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00020_SITE_PLANT @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_lt=N'',@p_site_id=N'',@p_plant_lt=N'' |
| 18:24:18.720 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.02 | p_menu_id=FP00020, p_log_type=FIND, p_log_cnt=122, p_db_time=0.157, p_ui_time=0.127, p_user_id=jaeuk.shin |
| 18:24:23.547 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.86 | MenuID=Site & Plant, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Site | clbSite |  |
| Active | cboActive |  |
| Building | clbFactory |  |
| lblSql | btnSql |  |
| Div | clbDivision |  |

## 그리드

- spdMain / Main: 행 122 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

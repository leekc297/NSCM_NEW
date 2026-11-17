# AS-IS 실측 요약 — FP00070

- 실행: 2026-11-12 18:24:24.450 ~ 2026-11-12 18:24:44.256 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation (GSCM.FP.Master.UIL.FP00070_Operation)
- 조회 결과: Total : 166 · DB : 0.463s, UI : 0.122s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:24:24.767 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.94 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:24:24.771 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.7 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:24, END_TIME=2026-11-12 18:24:24, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182424_759, PA |
| 18:24:24.818 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00070 |
| 18:24:24.834 | load | GSCM.FP_Common | SELECT * | 351 | 11.23 | USER_ID= |
| 18:24:24.858 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.52 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:24:26.291 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 1355.8 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 18:24:26.296 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.72 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:24, END_TIME=2026-11-12 18:24:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182424_935, PA |
| 18:24:26.798 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 489.14 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, param |
| 18:24:26.850 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:26, END_TIME=2026-11-12 18:24:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182426_308, PA |
| 18:24:28.810 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 1926.48 | code=OPERATION_GROUP, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:24:28.820 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.31 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:26, END_TIME=2026-11-12 18:24:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182426_892, PA |
| 18:24:30.100 | load | GSCM.FP_Common | UI_FP_COMMON | 39 | 1187.31 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 18:24:30.143 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.39 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:28, END_TIME=2026-11-12 18:24:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182428_912, PA |
| 18:24:30.317 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 3.32 | p_program_id=FP00070, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:24:30.424 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 72.39 | MenuID=Operation, CnntCode=0104001, UserID=jaeuk.shin |
| 18:24:30.464 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00070 |
| 18:24:38.079 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 6.69 | p_program_id=FP00070, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:24:38.531 | find | GSCM.FP_Common | PR_UI_FP00070_GET_OPERATION | 166 | 436.08 | p_sys_type=SELECT, p_sys_flag=R, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_operation_group_id=A,B,E,E,F,M, p_operation_id=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000,B10 |
| 18:24:38.535 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00070_GET_OPERATION, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00070_GET_OPERATION @p_sys_type=N'SELECT',@p_sys_flag=N'R',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81_ST,81_UC |
| 18:24:38.677 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.3 | p_menu_id=FP00070, p_log_type=FIND, p_log_cnt=166, p_db_time=0.463, p_ui_time=0.122, p_user_id=jaeuk.shin |
| 18:24:43.546 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.63 | MenuID=Operation, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Site | cboSite |  |
| Operation Group | cboOperationGroup |  |
| Operation | cboOperation |  |

## 그리드

- spdMain / Main: 행 166 · 컬럼 9(보임 8) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

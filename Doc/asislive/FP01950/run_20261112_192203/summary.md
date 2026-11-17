# AS-IS 실측 요약 — FP01950

- 실행: 2026-11-12 19:22:03.138 ~ 2026-11-12 19:22:20.205 · 계정 jaeuk.shin · 상태 OK
- 화면: Manual Create WO (GSCM.FP.Admin.UIL.FP01950_Manual_Create_WO)
- 조회 결과: Total :  · DB : 0.165s, UI : 0.069s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:22:03.513 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.61 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:22:03.517 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:22:03, END_TIME=2026-11-12 19:22:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192203_504, PA |
| 19:22:03.594 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01950 |
| 19:22:03.617 | load | GSCM.FP_Common | SELECT * | 351 | 15.36 | USER_ID= |
| 19:22:03.620 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.53 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:22:04.472 | load | GSCM.FP_Common | UI_FP_COMMON | 39 | 755.22 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 19:22:04.486 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.82 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:22:03, END_TIME=2026-11-12 19:22:04, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192203_717, PA |
| 19:22:04.724 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 13.05 | p_sys_type=SELECT, p_sys_flag=STATUS, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01950_ETC, opt_none=, in_columns=OPERATION_ID^WO_BASE_DATE^, in_row=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000,B1000,E0430,E0500,E1000,E2000,E2500,E3000,E4000, |
| 19:22:04.748 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.09 | PROG_ID=PR_UI_FP01950_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'STATUS',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01950_ETC',@opt_no |
| 19:22:04.797 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 2 | 44.3 | p_sys_type=SELECT, p_sys_flag=MARKET, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01950_ETC, opt_none=, in_columns=OPERATION_ID^WO_BASE_DATE^, in_row=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000,B1000,E0430,E0500,E1000,E2000,E2500,E3000,E4000, |
| 19:22:04.812 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.91 | PROG_ID=PR_UI_FP01950_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'MARKET',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01950_ETC',@opt_no |
| 19:22:04.862 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 6 | 43.48 | p_sys_type=SELECT, p_sys_flag=REQUEST_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01950_ETC, opt_none=, in_columns=OPERATION_ID^WO_BASE_DATE^, in_row=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000,B1000,E0430,E0500,E1000,E2000,E2500,E3000, |
| 19:22:04.879 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.44 | PROG_ID=PR_UI_FP01950_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'REQUEST_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01950_ETC',@ |
| 19:22:04.930 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 118 | 43.5 | p_sys_type=SELECT, p_sys_flag=BASIS_TIME, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01950_ETC, opt_none=, in_columns=OPERATION_ID^WO_BASE_DATE^, in_row=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000,B1000,E0430,E0500,E1000,E2000,E2500,E3000,E4 |
| 19:22:04.934 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.24 | PROG_ID=PR_UI_FP01950_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'BASIS_TIME',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01950_ETC',@op |
| 19:22:04.948 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.22 | p_program_id=FP01950, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:22:04.991 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 38 | 38.64 | p_program_id=FP01950, p_sheet_name=Main |
| 19:22:05.000 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.72 | p_program_id=FP01950, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:22:05.007 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 38 | 4.18 | p_program_id=FP01950, p_sheet_name=Main |
| 19:22:05.191 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 76.02 | MenuID=Manual Create WO, CnntCode=0104001, UserID=jaeuk.shin |
| 19:22:05.307 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01950 |
| 19:22:13.962 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 127.67 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01950_MANUAL_CREATE_WO, opt_none=, in_columns=OPERATION_ID^WO_BASE_DATE^, in_row=A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A8210,A8230,A8400,A9000,B1000,E0430,E0500,E1000,E2000,E2500,E3000 |
| 19:22:13.989 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.68 | PROG_ID=PR_UI_FP01950_MANUAL_CREATE_WO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01950_MAN |
| 19:22:14.094 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 27.0 | p_menu_id=FP01950, p_log_type=FIND, p_log_cnt=, p_db_time=0.165, p_ui_time=0.069, p_user_id=jaeuk.shin |
| 19:22:19.334 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.37 | MenuID=Manual Create WO, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Material | txtItemId |  |
| lblSql | btnSql |  |
| Operation | cboOperation |  |
| Plan Date | dtpPlanDate |  |
| Create Order | btnCreateOrder |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 39(보임 38) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

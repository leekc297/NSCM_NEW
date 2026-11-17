# AS-IS 실측 요약 — FP00644

- 실행: 2026-11-12 19:11:05.645 ~ 2026-11-12 19:11:49.885 · 계정 jaeuk.shin · 상태 OK
- 화면: Group Cell Mgmt (GSCM.FP.Master.UIL.FP00644_Group_Cell_Mgmt)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:11:06.024 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.58 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:11:06.028 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.2 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:11:06, END_TIME=2026-11-12 19:11:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191106_016, PA |
| 19:11:06.181 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00644 |
| 19:11:06.198 | load | GSCM.FP_Common | SELECT * | 351 | 9.68 | USER_ID= |
| 19:11:06.202 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.48 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:11:06.579 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 158.45 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:11:06.591 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:11:06, END_TIME=2026-11-12 19:11:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191106_42, PAR |
| 19:11:06.814 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 152.24 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:11:06.823 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:11:06, END_TIME=2026-11-12 19:11:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191106_661, PA |
| 19:11:06.982 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 138.89 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 19:11:06.985 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:11:06, END_TIME=2026-11-12 19:11:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191106_843, PA |
| 19:11:07.026 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.8 | p_program_id=FP00644, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:11:07.035 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 15 | 4.07 | p_program_id=FP00644, p_sheet_name=Main |
| 19:11:07.043 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.97 | p_program_id=FP00644, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:11:07.053 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 15 | 3.67 | p_program_id=FP00644, p_sheet_name=Main |
| 19:11:07.092 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.29 | p_program_id=FP00644, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:11:07.101 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 3.99 | p_program_id=FP00644, p_sheet_name=Sub |
| 19:11:07.112 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.29 | p_program_id=FP00644, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:11:07.121 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 3.77 | p_program_id=FP00644, p_sheet_name=Sub |
| 19:11:07.315 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 96.51 | MenuID=Group Cell Mgmt, CnntCode=0104001, UserID=jaeuk.shin |
| 19:11:07.447 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.27 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00644 |
| 19:11:43.486 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 590 | 27169.61 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00644_GROUP_CELL_MGMT, opt_none=, in_columns=DIVISION_ID^SITE_ID^PLANT_ID^, in_row=40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB |
| 19:11:43.509 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.46 | PROG_ID=PR_UI_FP00644_GROUP_CELL_MGMT, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00644_ |
| 19:11:43.829 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.28 | p_menu_id=FP00644, p_log_type=FIND, p_log_cnt=590, p_db_time=27.222, p_ui_time=0.291, p_user_id=jaeuk.shin |
| 19:11:49.163 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.04 | MenuID=Group Cell Mgmt, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Group Cell | txtGroupCell |  |
| Site | clbSite |  |
| Group Name | txtGroupCellName |  |
| Plant | clbPlant |  |
| Cell | txtCell |  |
| lblSql | btnSql |  |
| New Item | cboNewItem |  |
| Cell Name | txtCellName |  |

## 그리드

- spdMain / Main: 행 590 · 컬럼 16(보임 15) · 헤더 2단 · 고정 컬럼 0
- spdSub / Sub: 행 0 · 컬럼 14(보임 13) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

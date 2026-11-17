# AS-IS 실측 요약 — FP01991

- 실행: 2026-11-12 19:22:36.935 ~ 2026-11-12 19:23:02.005 · 계정 jaeuk.shin · 상태 OK
- 화면: Config Setting (GSCM.FP.Admin.UIL.FP01991_ConfigSetting)
- 조회 결과:  · DB : 0.341s, UI : 8.677s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:22:37.504 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 84 | 200.91 | p_sys_type=, p_sys_flag=SELECT_INSTANCE, p_sys_gubun=, p_user_id=, p_proc_name=PR_UI_FP01991_CONFIGSETTING, opt_none=, in_columns=, in_row= |
| 19:22:37.509 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.16 | PROG_ID=PR_UI_FP01991_CONFIGSETTING, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'SELECT_INSTANCE',@p_sys_gubun=N'',@p_user_id=N'',@p_proc_name=N'PR_UI_FP01991_CONFIGSET |
| 19:22:37.529 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 22 | 12.03 | p_sys_type=, p_sys_flag=SELECT_CATEGORY, p_sys_gubun=, p_user_id=, p_proc_name=PR_UI_FP01991_CONFIGSETTING, opt_none=, in_columns=, in_row= |
| 19:22:37.534 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=PR_UI_FP01991_CONFIGSETTING, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'SELECT_CATEGORY',@p_sys_gubun=N'',@p_user_id=N'',@p_proc_name=N'PR_UI_FP01991_CONFIGSET |
| 19:22:37.602 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01991 |
| 19:22:37.619 | load | GSCM.FP_Common | SELECT * | 351 | 9.84 | USER_ID= |
| 19:22:37.623 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.89 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:22:37.716 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.24 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:22:37.721 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.29 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:22:37, END_TIME=2026-11-12 19:22:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192237_707, PA |
| 19:22:38.274 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.16 | p_program_id=FP01991, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:22:38.301 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 23.11 | p_program_id=FP01991, p_sheet_name=Main |
| 19:22:38.310 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP01991, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:22:38.318 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 3.82 | p_program_id=FP01991, p_sheet_name=Main |
| 19:22:38.450 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 54.59 | MenuID=Config Setting, CnntCode=0104001, UserID=jaeuk.shin |
| 19:22:38.545 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01991 |
| 19:22:46.935 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.41 | p_program_id=FP01991, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:22:46.944 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 4.25 | p_program_id=FP01991, p_sheet_name=Main |
| 19:22:46.953 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.98 | p_program_id=FP01991, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:22:46.962 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 4.17 | p_program_id=FP01991, p_sheet_name=Main |
| 19:22:47.238 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 6987 | 139.89 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01991_CONFIGSETTING, opt_none=, in_columns=, in_row= |
| 19:22:47.242 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=PR_UI_FP01991_CONFIGSETTING, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP019 |
| 19:22:56.119 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.58 | p_menu_id=FP01991, p_log_type=FIND, p_log_cnt=, p_db_time=0.341, p_ui_time=8.677, p_user_id=jaeuk.shin |
| 19:23:01.280 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.97 | MenuID=Config Setting, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Instance | cboInstance |  |
| KEY | txtKeyType |  |
| layoutControlItem4 | btnSql |  |
| Category | usrComboBox_Category |  |
| S-SQL | SuperRoleSQL |  |

## 그리드

- spdMain / Main: 행 6987 · 컬럼 18(보임 13) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

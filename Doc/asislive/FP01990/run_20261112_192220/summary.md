# AS-IS 실측 요약 — FP01990

- 실행: 2026-11-12 19:22:20.334 ~ 2026-11-12 19:22:36.819 · 계정 jaeuk.shin · 상태 OK
- 화면: Look Up(FP) (GSCM.FP.Admin.UIL.FP01990_Lookup)
- 조회 결과:  · DB : 0.217s, UI : 0.112s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:22:20.812 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01990 |
| 19:22:20.829 | load | GSCM.FP_Common | SELECT * | 351 | 10.16 | USER_ID= |
| 19:22:20.833 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:22:20.951 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.22 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:22:20.954 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:22:20, END_TIME=2026-11-12 19:22:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192220_944, PA |
| 19:22:21.308 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 61.05 | MenuID=Look Up(FP), CnntCode=0104001, UserID=jaeuk.shin |
| 19:22:21.415 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01990 |
| 19:22:30.297 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 233 | 168.37 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01990_GET_LOOKUP_FP, opt_none=, in_columns=ACTIVE_FLAG^, in_row=Y^ |
| 19:22:30.309 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.47 | PROG_ID=PR_UI_FP01990_GET_LOOKUP_FP, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP019 |
| 19:22:30.457 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.68 | p_menu_id=FP01990, p_log_type=FIND, p_log_cnt=, p_db_time=0.217, p_ui_time=0.112, p_user_id=jaeuk.shin |
| 19:22:30.643 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 82 | 29.87 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN_DETAIL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01990_GET_LOOKUP_FP, opt_none=, in_columns=ACTIVE_FLAG^LOOKUP_TYPE_CODE^, in_row=Y^ABNORMAL_FACTORY^ |
| 19:22:30.648 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=PR_UI_FP01990_GET_LOOKUP_FP, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN_DETAIL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_U |
| 19:22:36.058 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.69 | MenuID=Look Up(FP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| System | cboLookupGroup |  |
| Lookup Type Name | txtLookupType |  |
| Active | cboValid |  |
| Segment | usrComboBox_Seg |  |
| layoutControl_segment | usrTextBox_Seg |  |
| layoutControlItem4 | btnSql |  |
| Sub Condition | SubComboBox_param |  |
| layoutControlItem8 | simpleButton1 |  |
| item0 | usrTextBox_Att |  |

## 그리드

- spdMain / Lookup Type: 행 233 · 컬럼 27(보임 26) · 헤더 1단 · 고정 컬럼 2
- spdSub / Lookup Values: 행 82 · 컬럼 32(보임 9) · 헤더 1단 · 고정 컬럼 2

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

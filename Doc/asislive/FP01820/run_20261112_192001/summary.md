# AS-IS 실측 요약 — FP01820

- 실행: 2026-11-12 19:20:01.347 ~ 2026-11-12 19:20:21.809 · 계정 jaeuk.shin · 상태 OK
- 화면: Net Job (GSCM.FP.Admin.UIL.FP01820_Net_Job)
- 조회 결과: Total : 202 · DB : 3.635s, UI : 0.026s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:20:01.714 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 31.74 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:20:01.718 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:20:01, END_TIME=2026-11-12 19:20:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192001_683, PA |
| 19:20:01.932 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01820 |
| 19:20:01.952 | load | GSCM.FP_Common | SELECT * | 351 | 12.52 | USER_ID= |
| 19:20:01.958 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.96 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:20:02.289 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 160.44 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:20:02.304 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:20:02, END_TIME=2026-11-12 19:20:02, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192002_129, PA |
| 19:20:02.433 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 202 | 103.65 | p_sys_type=SELECT, p_sys_flag=JOBLIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01820_ETC, opt_none=, in_columns=DIVISION_ID^, in_row=40,81,81_HD,81_HM,81_ST,81_UC,82,999^ |
| 19:20:02.459 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.71 | PROG_ID=PR_UI_FP01820_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'JOBLIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01820_ETC',@opt_n |
| 19:20:02.547 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.32 | p_program_id=FP01820, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:20:02.584 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 31.13 | p_program_id=FP01820, p_sheet_name=Main |
| 19:20:02.596 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.15 | p_program_id=FP01820, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:20:02.606 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 4.35 | p_program_id=FP01820, p_sheet_name=Main |
| 19:20:02.633 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.97 | p_program_id=FP01820, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:20:02.645 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 5.9 | p_program_id=FP01820, p_sheet_name=Sub |
| 19:20:02.657 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.99 | p_program_id=FP01820, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:20:02.668 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 5.6 | p_program_id=FP01820, p_sheet_name=Sub |
| 19:20:02.831 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 84.58 | MenuID=Net Job, CnntCode=0104001, UserID=jaeuk.shin |
| 19:20:02.942 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01820 |
| 19:20:11.877 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 202 | 58.67 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01820_NET_JOB, opt_none=, in_columns=, in_row=, in_row1=, in_row2=, in_row3=, in_row4=, in_row5=, in_row6=, in_row7=, in_row8=, in_row9= |
| 19:20:11.891 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.98 | PROG_ID=PR_UI_FP01820_NET_JOB, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01820_NET_JOB',@op |
| 19:20:12.076 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.86 | p_program_id=FP01820, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:20:12.084 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 3.71 | p_program_id=FP01820, p_sheet_name=Sub |
| 19:20:12.091 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.84 | p_program_id=FP01820, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:20:12.099 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 4.27 | p_program_id=FP01820, p_sheet_name=Sub |
| 19:20:15.733 | find | GSCM.FP_Common | SELECT ROW_NUMBER() OVER ( ORDER BY SEQ, JOB_ID ) AS NUM, | 12 | 3621.84 | GROUP_ID=40_0001, GROUP_NAME=FP DEMAND PEGGING RUN(CN), DIVISION_ID=40, VALID_YN=ALL |
| 19:20:15.737 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.25 | PROG_ID=find_FP01820_Sub, QUERY_ID=FP\ADMIN\FP01820_Net_Job, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0GROUP_NAME
---Service Parameter : 1GROUP_ID
---Service Parameter : 2DIVISION_ID
---Service Parameter : 3VALID_YN
---Check client parameter : GROUP_ID
---FOUND GROUP_ID
-- TYPE =  |
| 19:20:15.777 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.81 | p_menu_id=FP01820, p_log_type=FIND, p_log_cnt=202, p_db_time=3.635, p_ui_time=0.026, p_user_id=jaeuk.shin |
| 19:20:21.043 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.32 | MenuID=Net Job, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Job List | clbJobList |  |
| SQL | btnSql |  |
| Creator | txtCreator |  |
| Stop | btn_stop |  |
| Start | btn_start |  |
| Except | btn_except |  |
| Detail | btn_detail |  |
| Job Description | txtSearch |  |
| layoutControlItem2 | label1 |  |

## 그리드

- spdMain / Main: 행 202 · 컬럼 17(보임 16) · 헤더 2단 · 고정 컬럼 0
- spdSub / Sub: 행 12 · 컬럼 18(보임 17) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

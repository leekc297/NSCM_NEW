# AS-IS 실측 요약 — FP01630

- 실행: 2026-11-12 19:19:26.234 ~ 2026-11-12 19:20:01.207 · 계정 jaeuk.shin · 상태 OK
- 화면: Close Work Order (GSCM.FP.Master.UIL.FP01630_Close_Work_Order)
- 조회 결과: Total :  · DB : 14.564s, UI : 0.003s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:19:26.566 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 4.63 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:19:26.675 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 102.65 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:19:26.679 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:26, END_TIME=2026-11-12 19:19:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191926_572, PA |
| 19:19:26.785 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01630 |
| 19:19:26.804 | load | GSCM.FP_Common | SELECT * | 351 | 10.38 | USER_ID= |
| 19:19:26.813 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 8.05 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:19:27.216 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 137.83 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:19:27.221 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:27, END_TIME=2026-11-12 19:19:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191927_078, PA |
| 19:19:27.248 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 7.86 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:19:27.253 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.57 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:27, END_TIME=2026-11-12 19:19:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191927_239, PA |
| 19:19:27.403 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 134.47 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:19:27.411 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:27, END_TIME=2026-11-12 19:19:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191927_267, PA |
| 19:19:27.633 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 140.66 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 19:19:27.637 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:27, END_TIME=2026-11-12 19:19:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191927_492, PA |
| 19:19:28.089 | load | GSCM.FP_Common | UI_FP_COMMON | 78 | 426.08 | code=FACTORY, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param10 |
| 19:19:28.094 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:27, END_TIME=2026-11-12 19:19:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191927_662, PA |
| 19:19:29.262 | load | GSCM.FP_Common | UI_FP_COMMON | 39 | 1126.03 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param |
| 19:19:29.274 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:28, END_TIME=2026-11-12 19:19:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191928_135, PA |
| 19:19:30.052 | load | GSCM.FP_Common | UI_FP_COMMON | 882 | 517.04 | code=LINE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param10=,  |
| 19:19:30.096 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.86 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:19:29, END_TIME=2026-11-12 19:19:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191929_535, PA |
| 19:19:30.379 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.92 | p_program_id=FP01630, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:19:30.413 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 27 | 27.6 | p_program_id=FP01630, p_sheet_name=Main |
| 19:19:30.423 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.43 | p_program_id=FP01630, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:19:30.432 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 27 | 3.66 | p_program_id=FP01630, p_sheet_name=Main |
| 19:19:30.601 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 82.74 | MenuID=Close Work Order, CnntCode=0104001, UserID=jaeuk.shin |
| 19:19:30.842 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.48 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01630 |
| 19:19:40.176 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.37 | p_program_id=FP01630, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:19:40.185 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 27 | 5.1 | p_program_id=FP01630, p_sheet_name=Main |
| 19:19:40.195 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.22 | p_program_id=FP01630, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:19:40.204 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 27 | 5.17 | p_program_id=FP01630, p_sheet_name=Main |
| 19:19:54.751 | find | GSCM.FP_Common | PR_UI_FP01630_CLOSE_WORK_ORDER | 0 | 14521.39 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A |
| 19:19:54.758 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.91 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01630_CLOSE_WORK_ORDER, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:19:40, END_TIME=2026-11-12 19:19:54, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191940_228, PARAM_VALUE={p_sys_typ |
| 19:19:54.764 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.38 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01630_CLOSE_WORK_ORDER, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:19:40, END_TIME=2026-11-12 19:19:54, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191940_228, PARAM_VALUE=10_A,FP_EJ |
| 19:19:54.770 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.35 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01630_CLOSE_WORK_ORDER, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01630_CLOSE_WORK_ORDER @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81 |
| 19:19:54.777 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.1 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01630_CLOSE_WORK_ORDER, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=,FP_EIM03_A,FP_EIM03_C,FP_EIM04_A,FP_EIM04_C,FP_EJM08_A,FP_EJM08_C,FP_EJM09_A,FP_EJM09_C,FP_EJM10_A,FP_EJM10_C,FP_EKD11_A,FP_EKD11_A,FP_EKD11_C,FP_EKD11_C,FP_EKD12_A,FP_EKD12_A,FP_EKD12_C,FP_EKD12_ |
| 19:19:54.793 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.51 | p_menu_id=FP01630, p_log_type=FIND, p_log_cnt=, p_db_time=14.564, p_ui_time=0.003, p_user_id=jaeuk.shin |
| 19:20:00.511 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.34 | MenuID=Close Work Order, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem10 | btnCancle |  |
| Div | clbDivision |  |
| Operation | cboOperation |  |
| Plan Period* | drpPeriod | Y |
| Site | cboSite |  |
| Line | clbLine |  |
| Plant | clbPlant |  |
| Material | tbItemId |  |
| Building | clbFactory |  |
| Work Order ID | txtWorkOrderID |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 28(보임 27) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

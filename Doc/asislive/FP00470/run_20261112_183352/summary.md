# AS-IS 실측 요약 — FP00470

- 실행: 2026-11-12 18:33:52.698 ~ 2026-11-12 18:34:16.889 · 계정 jaeuk.shin · 상태 OK
- 화면: Master Data Validation (GSCM.FP.Master.UIL.FP00470_Master_Data_Validation)
- 조회 결과: Total :  · DB : 6.188s, UI : 0.076s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:33:53.180 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 158.27 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:33:53.184 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:53, END_TIME=2026-11-12 18:33:53, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183353_022, PA |
| 18:33:53.232 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00470 |
| 18:33:53.247 | load | GSCM.FP_Common | SELECT * | 351 | 10.1 | USER_ID= |
| 18:33:53.276 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.9 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:33:53.555 | load | GSCM.FP_Common | UI_FP_COMMON | 61 | 171.5 | code=INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 18:33:53.558 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.04 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:53, END_TIME=2026-11-12 18:33:53, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183353_382, PA |
| 18:33:53.705 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 6.76 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 18:33:53.788 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 83.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:53, END_TIME=2026-11-12 18:33:53, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183353_698, PA |
| 18:33:54.219 | load | GSCM.FP_Common | PR_UI_FP00470_CODE | 8 | 385.85 | p_code=ListLookup, p_user_id=jaeuk.shin, param1=VALIDATION, param2=PROBLEM TYPE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:33:54.276 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 57.8 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00470_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00470_CODE @p_code=N'ListLookup',@p_user_id=N'jaeuk.shin',@param1=N'VALIDATION',@param2=N'PROBLEM TYPE',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@par |
| 18:33:54.410 | load | GSCM.FP_Common | PR_UI_FP00470_CODE | 7 | 119.69 | p_code=ListLookup, p_user_id=jaeuk.shin, param1=VALIDATION, param2=UI, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:33:54.494 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 84.87 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00470_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00470_CODE @p_code=N'ListLookup',@p_user_id=N'jaeuk.shin',@param1=N'VALIDATION',@param2=N'UI',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@param7=N'',@p |
| 18:33:55.009 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 504.3 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_POST_M,PL_E_POST,US_E_POST,KR_E_PRE_A,KR_E_PRE_A2,KR_E_PRE_M,KR_E_PRE_M2,KR_E_PMIX,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,US_E_PRE,UC_E_PRE_A,UC_E_PRE_A2,PL_E_PRE,ID_E_PRE_A,HD_E_PRE_A,KR_CE |
| 18:33:55.036 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:54, END_TIME=2026-11-12 18:33:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183354_504, PA |
| 18:33:55.612 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 529.7 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_POST_M,PL_E_POST,US_E_POST,KR_E_PRE_A,KR_E_PRE_A2,KR_E_PRE_M,KR_E_PRE_M2,KR_E_PMIX,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,US_E_PRE,UC_E_PRE_A,UC_E_PRE_A2,PL_E_PRE,ID_E_PRE_A,HD_E_PRE_A,KR_CELL,K |
| 18:33:55.665 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.02 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:55, END_TIME=2026-11-12 18:33:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183355_082, PA |
| 18:33:56.262 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 535.26 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_POST_M,PL_E_POST,US_E_POST,KR_E_PRE_A,KR_E_PRE_A2,KR_E_PRE_M,KR_E_PRE_M2,KR_E_PMIX,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,US_E_PRE,UC_E_PRE_A,UC_E_PRE_A2,PL_E_PRE,ID_E_PRE_A,HD_E_PRE_A,KR_CELL, |
| 18:33:56.372 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 110.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:55, END_TIME=2026-11-12 18:33:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183355_726, PA |
| 18:33:56.490 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 67.96 | p_program_id=FP00470, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:33:56.897 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 366.34 | MenuID=Master Data Validation, CnntCode=0104001, UserID=jaeuk.shin |
| 18:33:57.033 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00470 |
| 18:34:05.022 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.12 | p_program_id=FP00470, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:34:11.032 | find | GSCM.FP_Common | PR_UI_FP00470_MASTER_DATA_VALIDATION | 0 | 5992.65 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=, p_plan_date=20261112, p_division_id=, p_site_id=, p_plant_id=, p_check_category=, p_problem_type=, p_check_data=, p_check_ui=, p_item_id= |
| 18:34:11.215 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 182.4 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00470_MASTER_DATA_VALIDATION, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00470_MASTER_DATA_VALIDATION @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'',@p_pla |
| 18:34:11.336 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 38.83 | p_menu_id=FP00470, p_log_type=FIND, p_log_cnt=, p_db_time=6.188, p_ui_time=0.076, p_user_id=jaeuk.shin |
| 18:34:16.130 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.95 | MenuID=Master Data Validation, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plan Group | cboInstance |  |
| Plant | clbPlant |  |
| PlanDate | drpPlanDate |  |
| Demand Material | txtItemId |  |
| Div | clbDivision |  |
| Problem Group | clbProblemType |  |
| Site | cboSite |  |
| ProblemType | clbCheckUI |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

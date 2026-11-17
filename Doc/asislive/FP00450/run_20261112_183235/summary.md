# AS-IS 실측 요약 — FP00450

- 실행: 2026-11-12 18:32:35.715 ~ 2026-11-12 18:32:58.915 · 계정 jaeuk.shin · 상태 OK
- 화면: Setup Condition (GSCM.FP.Master.UIL.FP00450_Setup_Condition)
- 조회 결과:  · DB : 4.934s, UI : 0.073s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:32:36.156 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00450 |
| 18:32:36.170 | load | GSCM.FP_Common | SELECT * | 351 | 9.61 | USER_ID= |
| 18:32:36.222 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.6 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:32:36.364 | load | GSCM.FP_Common | UI_FP_COMMON | 28 | 53.43 | code=USER_AUTH, user_id=, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 18:32:36.368 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:32:36, END_TIME=2026-11-12 18:32:36, INSERT_ID=, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183236_311, PARAM_VALUE= |
| 18:32:36.634 | load | GSCM.FP_Common | SELECT A.SEGMENT1 AS CODE, A.SEGMENT1 AS NAME | 4 | 4.48 |  |
| 18:32:36.649 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.15 | PROG_ID=findSetupCategory, QUERY_ID=FP\MASTER\FP00450_SetupCondition, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---Check client parameter : SITE_ID
---Check client parameter : PLANT_ID
---Check client parameter : OPERATION_ID


  |
| 18:32:38.260 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 19 | 1584.84 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00450_FINDFILTERKEY, opt_none=, in_columns=USER_ID^PLANT_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01^, in_row1=, in_row2=, in_row3 |
| 18:32:38.472 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 211.35 | PROG_ID=PR_UI_FP00450_FINDFILTERKEY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00450_FINDFILTERKE |
| 18:32:38.567 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.61 | p_program_id=FP00450, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:32:38.576 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 9 | 4.82 | p_program_id=FP00450, p_sheet_name=Main |
| 18:32:38.588 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.79 | p_program_id=FP00450, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:32:38.597 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 9 | 5.27 | p_program_id=FP00450, p_sheet_name=Main |
| 18:32:38.610 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.66 | p_program_id=FP00450, p_sheet_name=Matrix, p_user_id=jaeuk.shin |
| 18:32:38.679 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 65.85 | p_program_id=FP00450, p_sheet_name=Matrix |
| 18:32:38.687 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.63 | p_program_id=FP00450, p_sheet_name=Matrix, p_user_id=jaeuk.shin |
| 18:32:38.696 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 4.74 | p_program_id=FP00450, p_sheet_name=Matrix |
| 18:32:39.158 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 428.45 | MenuID=Setup Condition, CnntCode=0104001, UserID=jaeuk.shin |
| 18:32:39.295 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00450 |
| 18:32:47.402 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.46 | p_program_id=FP00450, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:32:47.409 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 9 | 4.3 | p_program_id=FP00450, p_sheet_name=Main |
| 18:32:47.417 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00450, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:32:47.426 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 9 | 4.35 | p_program_id=FP00450, p_sheet_name=Main |
| 18:32:47.435 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.19 | p_program_id=FP00450, p_sheet_name=Matrix, p_user_id=jaeuk.shin |
| 18:32:47.443 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 4.46 | p_program_id=FP00450, p_sheet_name=Matrix |
| 18:32:47.450 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.91 | p_program_id=FP00450, p_sheet_name=Matrix, p_user_id=jaeuk.shin |
| 18:32:47.458 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 4.61 | p_program_id=FP00450, p_sheet_name=Matrix |
| 18:32:47.477 | find | GSCM.FP_Common | SELECT DISTINCT | 284 | 9.42 |  |
| 18:32:47.693 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 216.91 | PROG_ID=findLineSetupGroup, QUERY_ID=FP\MASTER\FP00450_SetupCondition, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---Check client parameter : SITE_ID
---Check client parameter : PLANT_ID
---Check client parameter : OPERATION_ID
-- |
| 18:32:48.482 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.OPERATION_ID | 296 | 780.15 |  |
| 18:32:48.511 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.12 | PROG_ID=find_condition_category, QUERY_ID=FP\MASTER\FP00450_SetupCondition, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---Check client parameter : SITE_ID
---Check client parameter : PLANT_ID
---Check client parameter : OPERATION_ |
| 18:32:48.533 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.OPERATION_ID | 341 | 10.77 |  |
| 18:32:48.579 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.3 | PROG_ID=find_condition_key, QUERY_ID=FP\MASTER\FP00450_SetupCondition, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---Check client parameter : SITE_ID
---Check client parameter : PLANT_ID
---Check client parameter : OPERATION_ID
-- |
| 18:32:48.792 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID | 359 | 204.71 |  |
| 18:32:48.847 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.39 | PROG_ID=findMatrix_setupconditon, QUERY_ID=FP\MASTER\FP00450_SetupCondition, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---Check client parameter : SITE_ID
---Check client parameter : PLANT_ID
---Check client parameter : OPERATION |
| 18:32:48.882 | find | GSCM.FP_Common | SELECT '-' AS COMPANY_ID, '-' AS DIVISION_ID, '-' AS SITE_ID, '-' AS PLANT_ID, '-' AS OPERATION_ID | 1241 | 25.29 |  |
| 18:32:48.954 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.82 | PROG_ID=findMatrix_itemsetup, QUERY_ID=FP\MASTER\FP00450_SetupCondition, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---Check client parameter : SITE_ID
---Check client parameter : PLANT_ID
---Check client parameter : OPERATION_ID
 |
| 18:32:51.005 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 334 | 2027.19 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00450_FIND_FP00450, opt_none=, in_columns=USER_ID^PLANT_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01^, in_row1=, in_row2=, in |
| 18:32:51.112 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 106.52 | PROG_ID=PR_UI_FP00450_FIND_FP00450, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00450_FIND_FP |
| 18:32:52.264 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 10 | 1142.06 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00450_FIND_FP00450_CAL, opt_none=, in_columns=USER_ID^DIVISION_ID^SITE_ID^PLANT_ID^OPERATION_ID^SETUP_CATEGORY_ID^SETUP_KEY_ID^COMPANY_ID^LINE_SETUP_GROUP_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^40^A001^HQ06^A2000^A |
| 18:32:52.392 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 128.15 | PROG_ID=PR_UI_FP00450_FIND_FP00450_CAL, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00450_FIN |
| 18:32:52.521 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 47.77 | p_menu_id=FP00450, p_log_type=FIND, p_log_cnt=, p_db_time=4.934, p_ui_time=0.073, p_user_id=jaeuk.shin |
| 18:32:57.527 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.25 | MenuID=Setup Condition, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Plant | clbPlant |  |
| Site | cboSite |  |
| layoutControlItem9 | btnUpload |  |
| Category | cboCategory |  |
| Class | cboKey |  |
| Form | formTestButton |  |
| Operation | cboOperation |  |

## 그리드

- spdMain / Main: 행 334 · 컬럼 10(보임 9) · 헤더 1단 · 고정 컬럼 0
- spdTotal / Matrix: 행 10 · 컬럼 15(보임 14) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

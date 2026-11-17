# AS-IS 실측 요약 — FP00460B

- 실행: 2026-11-12 18:33:28.933 ~ 2026-11-12 18:33:52.603 · 계정 jaeuk.shin · 상태 OK
- 화면: Setup Group (instance) (GSCM.FP.Master.UIL.FP00460_Setup_Group)
- 조회 결과: Total : 13 · DB : 6.49s, UI : 0.015s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:33:29.314 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 57.13 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:33:29.317 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:29, END_TIME=2026-11-12 18:33:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183329_256, PA |
| 18:33:29.388 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00460B |
| 18:33:29.403 | load | GSCM.FP_Common | SELECT * | 351 | 9.33 | USER_ID= |
| 18:33:29.447 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.86 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:33:29.889 | load | GSCM.FP_Common | UI_FP_COMMON | 61 | 367.79 | code=INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 18:33:29.955 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 65.98 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:29, END_TIME=2026-11-12 18:33:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183329_52, PAR |
| 18:33:30.010 | load | GSCM.FP_Common | SELECT a.segment1 as CODE, a.segment1 as NAME | 3 | 5.69 | USER_ID=jaeuk.shin |
| 18:33:30.063 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.03 | PROG_ID=find_instance, QUERY_ID=FP\MASTER\FP00460_SetupGroup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

                SELECT a.segment1 as CODE, a.segment1 as NAME
              |
| 18:33:31.261 | load | GSCM.FP_Common | UI_FP_COMMON | 15 | 1177.5 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=KR_CELL_M,KR_CELL_M2,CN_CELL_M, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, |
| 18:33:31.380 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 119.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:33:30, END_TIME=2026-11-12 18:33:31, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183330_083, PA |
| 18:33:31.608 | load | GSCM.FP_Common | SELECT a.segment1 as CODE, a.segment1 as NAME | 2 | 34.78 | USER_ID=jaeuk.shin |
| 18:33:31.680 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.96 | PROG_ID=find_category, QUERY_ID=FP\MASTER\FP00460_SetupGroup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

                SELECT a.segment1 as CODE, a.segment1 as NAME
              |
| 18:33:31.719 | load | GSCM.FP_Common | SELECT a.segment1 as CODE, a.segment1 as NAME | 2 | 5.49 | USER_ID=jaeuk.shin |
| 18:33:31.775 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.01 | PROG_ID=find_calculation, QUERY_ID=FP\MASTER\FP00460_SetupGroup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

				      
                 SELECT a.segment1 as CODE, a.segment1 as NAM |
| 18:33:31.792 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.74 | p_program_id=FP00460, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 18:33:31.801 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 3.8 | p_program_id=FP00460, p_sheet_name=spdMain |
| 18:33:31.812 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.51 | p_program_id=FP00460, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 18:33:31.826 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 4.17 | p_program_id=FP00460, p_sheet_name=spdMain |
| 18:33:31.840 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP00460, p_sheet_name=spdSub, p_user_id=jaeuk.shin |
| 18:33:31.847 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 3.5 | p_program_id=FP00460, p_sheet_name=spdSub |
| 18:33:31.858 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.32 | p_program_id=FP00460, p_sheet_name=spdSub, p_user_id=jaeuk.shin |
| 18:33:31.871 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 5.83 | p_program_id=FP00460, p_sheet_name=spdSub |
| 18:33:32.188 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 283.45 | MenuID=Setup Group (instance), CnntCode=0104001, UserID=jaeuk.shin |
| 18:33:32.246 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00460B |
| 18:33:44.962 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 13 | 4877.37 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN_V2, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00460_SETUP_GROUP_V2, opt_none=, in_columns=USER_ID^OPERATION_ID^SETUP_CATEGORY_ID^INSTANCE_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100,A8200,A82 |
| 18:33:45.041 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.7 | PROG_ID=PR_UI_FP00460_SETUP_GROUP_V2, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN_V2',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI |
| 18:33:46.345 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 6 | 1291.34 | p_sys_type=SELECT, p_sys_flag=SELECT_SUB, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00460_SETUP_GROUP_V2, opt_none=, in_columns=USER_ID^INSTANCE_ID^OPERATION_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^KR_CELL_M,KR_CELL_M2,CN_CELL_M^A2000,A3000,A5000,A5700,A6000,A7000,A7100,A7400,A8000,A8100, |
| 18:33:46.484 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 138.91 | PROG_ID=PR_UI_FP00460_SETUP_GROUP_V2, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_SUB',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0 |
| 18:33:46.631 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 43.56 | p_menu_id=FP00460B, p_log_type=FIND, p_log_cnt=13, p_db_time=6.49, p_ui_time=0.015, p_user_id=jaeuk.shin |
| 18:33:51.918 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.56 | MenuID=Setup Group (instance), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem5 | btnRefreshSetup |  |
| lblSql | btnSql |  |
| Operation | cboOperation |  |
| Category | cboCategory |  |
| layoutControlItem9 | usrLabel3 |  |
| Instance | cboInstance |  |
| layoutControlItem11 | btnSubImport |  |
| layoutControlItem10 | usrLabel1 |  |

## 그리드

- spdMain / spdMain: 행 13 · 컬럼 15(보임 12) · 헤더 1단 · 고정 컬럼 6
- spdSub / spdSub: 행 6 · 컬럼 12(보임 9) · 헤더 1단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

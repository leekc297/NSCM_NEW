# AS-IS 실측 요약 — FP00519

- 실행: 2026-11-12 18:35:59.866 ~ 2026-11-12 18:36:38.481 · 계정 jaeuk.shin · 상태 OK
- 화면: PJT Status & Production Type (GSCM.FP.Master.UIL.FP00519_PJT_Status_Production_Type)
- 조회 결과: Total :  · DB : 21.467s, UI : 0.062s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:36:00.239 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 43.92 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:36:00.242 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:00, END_TIME=2026-11-12 18:36:00, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183600_194, PA |
| 18:36:00.349 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.31 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00519 |
| 18:36:00.364 | load | GSCM.FP_Common | SELECT * | 351 | 10.88 | USER_ID= |
| 18:36:00.374 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.16 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:36:00.878 | load | GSCM.FP_Common | UI_FP_COMMON | 37 | 419.94 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=LINE_AMEND_E_PRE,LINE_AMEND_PACK,LINE |
| 18:36:00.882 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:00, END_TIME=2026-11-12 18:36:00, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183600_457, PA |
| 18:36:01.603 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 446.46 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:36:01.657 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:01, END_TIME=2026-11-12 18:36:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183601_155, PA |
| 18:36:01.720 | load | GSCM.FP_Common | UI_FP_COMMON | 26 | 33.07 | code=ITEM_CLASS, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=A, param22=, param23=, param24=, param25= |
| 18:36:01.723 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:01, END_TIME=2026-11-12 18:36:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183601_686, PA |
| 18:36:01.980 | load | GSCM.FP_Common | UI_FP_COMMON | 12 | 84.95 | code=PRODUCTION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=81,82, param6=81,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=Y, param22=, param23=, par |
| 18:36:02.009 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:01, END_TIME=2026-11-12 18:36:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183601_896, PA |
| 18:36:02.039 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.0 | p_program_id=FP00519, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:36:02.060 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 8 | 11.46 | p_program_id=FP00519, p_sheet_name=Main |
| 18:36:02.082 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 13.26 | p_program_id=FP00519, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:36:02.109 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 8 | 20.3 | p_program_id=FP00519, p_sheet_name=Main |
| 18:36:02.132 | load | GSCM.FP_Common | UI_FP_COMMON | 56 | 16.8 | code=PRODUCTION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:36:02.142 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.98 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:02, END_TIME=2026-11-12 18:36:02, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183602_116, PA |
| 18:36:02.572 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 311.49 | MenuID=PJT Status & Production Type, CnntCode=0104001, UserID=jaeuk.shin |
| 18:36:02.607 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00519 |
| 18:36:10.629 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.87 | p_program_id=FP00519, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:36:10.642 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 8 | 3.58 | p_program_id=FP00519, p_sheet_name=Main |
| 18:36:10.649 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.85 | p_program_id=FP00519, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:36:10.656 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 8 | 3.8 | p_program_id=FP00519, p_sheet_name=Main |
| 18:36:10.670 | find | GSCM.FP_Common | UI_FP_COMMON | 56 | 8.82 | code=PRODUCTION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:36:10.688 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:10, END_TIME=2026-11-12 18:36:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183610_661, PA |
| 18:36:32.095 | find | GSCM.FP_Common | PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | 0 | 21363.81 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_CELL, p_shop_group_id=A, p_division_id=, p_item_id=, p_nick_name=, p_applied_model=, p_item_class_id=, p_item_class_name=, p_target_yn=Y |
| 18:36:32.182 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 87.1 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N' |
| 18:36:32.272 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 20.58 | p_menu_id=FP00519, p_log_type=FIND, p_log_cnt=, p_db_time=21.467, p_ui_time=0.062, p_user_id=jaeuk.shin |
| 18:36:37.775 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 177.37 | MenuID=PJT Status & Production Type, CnntCode=0104002, UserID=jaeuk.shin |
| 18:36:37.995 | find | GSCM.FP_Common | PR_UI_FP00210_BOM | 165545 | 564399.66 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=, p_site_id=, p_plant_id=, p_item_id=, p_nick_name=, p_child_item_id=, p_child_nick_name= |
| 18:36:38.017 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.69 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00210_BOM, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00210_BOM @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'',@p_site_id=N'',@p_plant_id |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Target | chkTarget |  |
| Plan Group | cboInstance |  |
| Div | clbDivision |  |
| Item Class | clbItemClassId |  |
| Model | txtAppliedModel |  |
| Material | txtItemId |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 9(보임 8) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

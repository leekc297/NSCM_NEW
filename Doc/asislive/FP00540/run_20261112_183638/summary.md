# AS-IS 실측 요약 — FP00540

- 실행: 2026-11-12 18:36:38.571 ~ 2026-11-12 18:37:14.807 · 계정 jaeuk.shin · 상태 OK
- 화면: SSP Shipping Plan (GSCM.FP.Master.UIL.FP00540_SSP_Shipping_Plan)
- 조회 결과: Total : 9 · DB : 9.596s, UI : 0.068s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:36:38.944 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 21.44 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:36:38.974 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:38, END_TIME=2026-11-12 18:36:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183638_922, PA |
| 18:36:39.229 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.27 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00540 |
| 18:36:39.244 | load | GSCM.FP_Common | SELECT * | 351 | 9.55 | USER_ID= |
| 18:36:39.250 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.77 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:36:46.376 | load | GSCM.FP_Common | UI_FP_COMMON | 36 | 6996.65 | code=TARGET_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=SCP SHIPPING TARGET, param22=, param |
| 18:36:46.401 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.98 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:39, END_TIME=2026-11-12 18:36:46, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183639_38, PAR |
| 18:36:46.881 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 332.05 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:36:46.884 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.94 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:46, END_TIME=2026-11-12 18:36:46, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183646_548, PA |
| 18:36:50.030 | load | GSCM.FP_Common | UI_FP_COMMON | 10 | 3131.25 | code=SCP_PLAN, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_CELL, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=SHIPMENT, param22=, param23=, para |
| 18:36:50.033 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.61 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:46, END_TIME=2026-11-12 18:36:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183646_898, PA |
| 18:36:50.490 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 401.55 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_CELL, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 18:36:50.541 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:50, END_TIME=2026-11-12 18:36:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183650_088, PA |
| 18:36:50.848 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 261.72 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=CN_CELL, param2=, param3=, param4=, param5=81, param6=, param7=A002, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:36:50.851 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:50, END_TIME=2026-11-12 18:36:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183650_586, PA |
| 18:36:50.936 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 77.88 | code=LOOKUP_CODE_TARGET, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 18:36:50.968 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.37 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:36:50, END_TIME=2026-11-12 18:36:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183650_863, PA |
| 18:36:51.066 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 51.39 | p_program_id=FP00540, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:36:51.202 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 118.42 | MenuID=SSP Shipping Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 18:36:51.247 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00540 |
| 18:36:59.231 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 5.59 | p_program_id=FP00540, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:37:08.818 | find | GSCM.FP_Common | PR_UI_FP00540_SSP_SHIPPING_PLAN | 9 | 9556.24 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_CELL, p_division_id=81, p_site_id=, p_plant_id=, p_scp_plan_id=20260919_012, p_production_type=, p_item_id=, p_nick_name= |
| 18:37:08.840 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.79 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00540_SSP_SHIPPING_PLAN @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_CELL',@p_divisi |
| 18:37:08.927 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.8 | p_menu_id=FP00540, p_log_type=FIND, p_log_cnt=9, p_db_time=9.596, p_ui_time=0.068, p_user_id=jaeuk.shin |
| 18:37:14.093 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.98 | MenuID=SSP Shipping Plan, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| lblExcelUpload | btnExcelImport |  |
| Plan Group | cboInstance |  |
| SCP Plan ID | cboScpPlanId |  |
| Site | cboSite |  |
| Div | cboDivision |  |
| Plant | clbPlant |  |
| Production Type | cboProductionType |  |
| Material | txtItemId |  |

## 그리드

- spdMain / Main: 행 9 · 컬럼 18(보임 17) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

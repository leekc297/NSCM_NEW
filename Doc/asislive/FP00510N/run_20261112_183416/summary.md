# AS-IS 실측 요약 — FP00510N

- 실행: 2026-11-12 18:34:16.988 ~ 2026-11-12 18:34:52.755 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP Target (GSCM.FP.Master.UIL.FP00510_SCP_Target)
- 조회 결과: Total :  · DB : 13.53s, UI : 0.075s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:34:17.307 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 40.35 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:34:17.311 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.42 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:17, END_TIME=2026-11-12 18:34:17, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183417_266, PA |
| 18:34:17.369 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00510 |
| 18:34:17.384 | load | GSCM.FP_Common | SELECT * | 351 | 9.63 | USER_ID= |
| 18:34:17.409 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.3 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:34:17.732 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 85.25 | LOGTYPE=SpeedUp, NOTE=FP00510
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:34:17.856 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 124.13 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:34:18.092 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 214.93 | LOGTYPE=SpeedUp, NOTE=FP00510
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:34:18.118 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.83 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:34:18.250 | load | GSCM.FP_Common | UI_FP_COMMON | 11 | 107.51 | code=DIVISION_DEMAND_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 18:34:18.255 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:18, END_TIME=2026-11-12 18:34:18, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183418_138, PA |
| 18:34:23.140 | load | GSCM.FP_Common | UI_FP_COMMON | 10 | 4797.36 | code=SCP_PLAN, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=CN_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A002, param8=, param9=NA00, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PRODUCT, param22=, para |
| 18:34:23.144 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:18, END_TIME=2026-11-12 18:34:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183418_341, PA |
| 18:34:23.294 | load | GSCM.FP_Common | UI_FP_COMMON | 10 | 49.93 | code=SCP_PLAN, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=CN_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A002, param8=, param9=NA00, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PRODUCT, param22=, para |
| 18:34:23.298 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:23, END_TIME=2026-11-12 18:34:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183423_245, PA |
| 18:34:23.809 | load | GSCM.FP_Common | UI_FP_COMMON | 11 | 482.33 | code=DIVISION_DEMAND_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 18:34:23.900 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 90.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:23, END_TIME=2026-11-12 18:34:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183423_326, PA |
| 18:34:24.041 | load | GSCM.FP_Common | UI_FP_COMMON | 56 | 103.9 | code=LOOKUP_CODE_TARGET, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 18:34:24.045 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.84 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:23, END_TIME=2026-11-12 18:34:24, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183423_937, PA |
| 18:34:24.136 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.08 | p_program_id=FP00510, p_sheet_name=SCPTarget, p_user_id=jaeuk.shin |
| 18:34:24.145 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 4.85 | p_program_id=FP00510, p_sheet_name=SCPTarget |
| 18:34:24.154 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.95 | p_program_id=FP00510, p_sheet_name=SCPTarget, p_user_id=jaeuk.shin |
| 18:34:24.163 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 24 | 5.51 | p_program_id=FP00510, p_sheet_name=SCPTarget |
| 18:34:24.180 | load | GSCM.FP_Common | UI_FP_COMMON | 56 | 9.86 | code=LOOKUP_CODE_TARGET, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:34:24.184 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.34 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:24, END_TIME=2026-11-12 18:34:24, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183424_169, PA |
| 18:34:24.305 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 103.23 | code=DEMAND_MARKET_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:34:24.331 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.63 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:34:24, END_TIME=2026-11-12 18:34:24, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183424_202, PA |
| 18:34:24.370 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.66 | p_program_id=FP00510, p_sheet_name=SCPTargetSub, p_user_id=jaeuk.shin |
| 18:34:24.641 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 266.09 | p_program_id=FP00510, p_sheet_name=SCPTargetSub |
| 18:34:24.653 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.37 | p_program_id=FP00510, p_sheet_name=SCPTargetSub, p_user_id=jaeuk.shin |
| 18:34:24.661 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.36 | p_program_id=FP00510, p_sheet_name=SCPTargetSub |
| 18:34:24.978 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 286.72 | MenuID=SCP Target, CnntCode=0104001, UserID=jaeuk.shin |
| 18:34:25.061 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00510 |
| 18:34:46.717 | find | GSCM.FP_Common | PR_UI_FP00510_SCP_TARGET | 0 | 13417.14 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=81, p_site_id=A002, p_plant_id=NA00, p_instance_id=CN_E_POST, p_scp_plan_id=20260914_004, p_scp_target_id=, p_shop_group_id=, p_item_id=, p_nick_name=, p_mfg_week=, p_market=, p_org_market=, p |
| 18:34:46.813 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 95.37 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00510_SCP_TARGET, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00510_SCP_TARGET @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'81',@p_ |
| 18:34:46.910 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 15.73 | p_menu_id=FP00510, p_log_type=FIND, p_log_cnt=, p_db_time=13.53, p_ui_time=0.075, p_user_id=jaeuk.shin |
| 18:34:52.057 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.44 | MenuID=SCP Target, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| SCP Plan ID | cboScpPlanID |  |
| Order Type | cboOrderType |  |
| Plant | clbPlant |  |
| Site | cboSite |  |
| Material | txtItemID |  |
| Div* | cboDivision | Y |
| Plan Group | cboPlanGroup |  |
| Nick Name | txtItemName |  |
| lblChgProdType | btnChangeProd |  |
| lblSplit | btnSplit |  |
| lblSql | btnSql |  |
| lblExcelImport | btnImport |  |

## 그리드

- spdMain / SCPTarget: 행 0 · 컬럼 25(보임 21) · 헤더 1단 · 고정 컬럼 6
- spdSub / SCPTargetSub: 행 0 · 컬럼 19(보임 11) · 헤더 1단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

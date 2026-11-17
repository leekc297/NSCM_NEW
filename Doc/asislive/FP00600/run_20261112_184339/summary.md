# AS-IS 실측 요약 — FP00600

- 실행: 2026-11-12 18:43:39.119 ~ 2026-11-12 18:44:41.509 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Pack) (GSCM.FP.Planning.UIL.FP00600_PlanAmend_Model_Pack)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:43:39.650 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00600 |
| 18:43:39.677 | load | GSCM.FP_Common | SELECT * | 351 | 10.45 | USER_ID= |
| 18:43:39.681 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.84 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:43:39.947 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 26.31 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:43:39.951 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.65 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:43:39, END_TIME=2026-11-12 18:43:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184339_921, PA |
| 18:43:40.035 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 31 | 3.88 | USER_ID=jaeuk.shin, MENU_ID=FP00600_Main |
| 18:43:40.039 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:43:40.050 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.49 | p_program_id=FP00600, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:43:40.060 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.62 | p_program_id=FP00600, p_sheet_name=Main |
| 18:43:40.498 | load | GSCM.FP_Common | UI_FP_COMMON | 8 | 375.54 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PSI_AMEND_PACK, param22=, param23=, p |
| 18:43:40.501 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.37 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:43:40, END_TIME=2026-11-12 18:43:40, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184340_122, PA |
| 18:43:50.660 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 10071.39 | p_sys_type=SELECT, p_sys_flag=PLANNER_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^, in_row=PSI_AMEND_PACK^20261112^Y^N^mXlVW48SU1c3wPszIA83/w==^KR_PACK^KR_PACK^R |
| 18:43:50.665 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLANNER_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@ |
| 18:43:50.785 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 86.41 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^, in_row=PSI_AMEND_PACK^20261112^Y^N^mXlVW48SU1c3wPszIA83/w==^KR_PACK^K |
| 18:43:50.808 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.65 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@opt |
| 18:43:50.856 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 27.5 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^, in_row=PSI_AMEND_PACK^20261112^Y^N^mXlVW48SU1c3wPszIA83/w==^KR_ |
| 18:43:50.881 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.71 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_PL |
| 18:43:51.342 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 454.49 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:43:51.345 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.76 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:43:50, END_TIME=2026-11-12 18:43:51, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184350_887, PA |
| 18:43:51.748 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 17 | 389.87 | p_sys_type=SELECT, p_sys_flag=LINE_CODE_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^, in_row=PSI_AMEND_PACK^20261112^Y^Y^ |
| 18:43:51.775 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.54 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'LINE_CODE_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC' |
| 18:43:52.297 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 511.3 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 18:43:52.300 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:43:51, END_TIME=2026-11-12 18:43:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184351_786, PA |
| 18:43:52.594 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 283.41 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:43:52.600 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.58 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:43:52, END_TIME=2026-11-12 18:43:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184352_311, PA |
| 18:43:52.868 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 251.14 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=HQ07,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, |
| 18:43:52.872 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:43:52, END_TIME=2026-11-12 18:43:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184352_617, PA |
| 18:43:53.195 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 308.13 | p_sys_type=SELECT, p_sys_flag=OPERATION_CODE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^LINE_ID^SITE_ID^PLANT_ID^FACTORY_ID^, |
| 18:43:53.216 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.48 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'OPERATION_CODE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC' |
| 18:43:53.243 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 11 | 9.67 | p_sys_type=SELECT, p_sys_flag=PROD_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^LINE_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERAT |
| 18:43:53.249 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.08 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PROD_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@opt |
| 18:43:53.284 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 7.81 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:43:53.304 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.66 | p_program_id=FP00600, p_sheet_name=Amend |
| 18:43:53.315 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:43:53.325 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.66 | p_program_id=FP00600, p_sheet_name=Amend |
| 18:43:53.422 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 52.19 | MenuID=Plan Amend by Model(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 18:43:53.614 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00600 |
| 18:44:40.813 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.62 | MenuID=Plan Amend by Model(Pack), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Planner | clbPlanner |  |
| FP Plan Id | cboPlanId |  |
| lblSql | btnSql |  |
| Plan Group | cboInstance |  |
| Data | btnToggleSave |  |
| Division. | clbDivision |  |
| Operation | clbOperation |  |
| Material | txtItem |  |
| Nick Name | tbNickName |  |
| Model | txtModel |  |
| layoutControlItem13 | chk_info |  |
| Building | clbFactory |  |
| Line | clbLine |  |
| Site | cboSite |  |
| layoutControlItem12 | chk_allLine |  |
| layoutControlItem2 | btnExcelImport |  |
| Plan Period | drpPeriod |  |
| Shipment Plan | cboShipment |  |
| Plan Date | drpPlanDate |  |
| Plant | clbPlant |  |
| Pjt Group Name | txtPjtGroup |  |
| Prod.Type | clbProdType |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:44:03.437 [] You need to select one plan to proceed → default_button(id=1)

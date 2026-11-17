# AS-IS 실측 요약 — FP00600

- 실행: 2026-11-12 21:54:33.358 ~ 2026-11-12 21:55:22.229 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Pack) (GSCM.FP.Planning.UIL.FP00600_PlanAmend_Model_Pack)
- 조회 결과:  · DB : 23.201s, UI : 0.738s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "drpPlanDate", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:54:33.846 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00600 |
| 21:54:33.859 | load | GSCM.FP_Common | SELECT * | 351 | 9.15 | USER_ID= |
| 21:54:33.864 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:54:33.982 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.08 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:54:33.986 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:33, END_TIME=2026-11-12 21:54:33, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215433_974, PA |
| 21:54:34.020 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 31 | 3.95 | USER_ID=jaeuk.shin, MENU_ID=FP00600_Main |
| 21:54:34.057 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.33 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:54:34.064 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP00600, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 21:54:34.116 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 49.04 | p_program_id=FP00600, p_sheet_name=Main |
| 21:54:34.553 | load | GSCM.FP_Common | UI_FP_COMMON | 8 | 394.47 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PSI_AMEND_PACK, param22=, param23=, p |
| 21:54:34.578 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.14 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:34, END_TIME=2026-11-12 21:54:34, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215434_159, PA |
| 21:54:34.656 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 36.11 | p_sys_type=SELECT, p_sys_flag=PLANNER_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^, in_row=PSI_AMEND_PACK^20261112^Y^N^mXlVW48SU1c3wPszIA83/w==^KR_PACK^KR_PACK^R |
| 21:54:34.689 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.74 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLANNER_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@ |
| 21:54:34.767 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 69.48 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^, in_row=PSI_AMEND_PACK^20261112^Y^N^mXlVW48SU1c3wPszIA83/w==^KR_PACK^K |
| 21:54:34.771 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@opt |
| 21:54:34.807 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 28.23 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^, in_row=PSI_AMEND_PACK^20261112^Y^N^mXlVW48SU1c3wPszIA83/w==^KR_ |
| 21:54:34.842 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.86 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_PL |
| 21:54:35.328 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 480.97 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 21:54:35.331 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:34, END_TIME=2026-11-12 21:54:35, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215434_846, PA |
| 21:54:35.776 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 17 | 420.97 | p_sys_type=SELECT, p_sys_flag=LINE_CODE_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^, in_row=PSI_AMEND_PACK^20261112^Y^Y^ |
| 21:54:35.812 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.8 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'LINE_CODE_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC' |
| 21:54:36.407 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 586.23 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 21:54:36.410 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:35, END_TIME=2026-11-12 21:54:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215435_82, PAR |
| 21:54:36.750 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 329.89 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:54:36.753 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.25 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:36, END_TIME=2026-11-12 21:54:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215436_42, PAR |
| 21:54:37.008 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 246.26 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=HQ07,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, |
| 21:54:37.013 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.63 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:36, END_TIME=2026-11-12 21:54:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215436_761, PA |
| 21:54:37.333 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 309.74 | p_sys_type=SELECT, p_sys_flag=OPERATION_CODE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^LINE_ID^SITE_ID^PLANT_ID^FACTORY_ID^, |
| 21:54:37.369 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.06 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'OPERATION_CODE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC' |
| 21:54:37.447 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 11 | 70.78 | p_sys_type=SELECT, p_sys_flag=PROD_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^LINE_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERAT |
| 21:54:37.453 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.91 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PROD_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@opt |
| 21:54:37.467 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.98 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:54:37.475 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.87 | p_program_id=FP00600, p_sheet_name=Amend |
| 21:54:37.484 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:54:37.490 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 3.98 | p_program_id=FP00600, p_sheet_name=Amend |
| 21:54:37.587 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 72.72 | MenuID=Plan Amend by Model(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 21:54:37.664 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00600 |
| 21:54:46.214 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 71.38 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^BASIS_START_TIME^DIVISION_ID^LINE_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERAT |
| 21:54:46.223 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.09 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@opt |
| 21:54:46.279 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 46.17 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=HQ07,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PRE, param2 |
| 21:54:46.282 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.64 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:54:46, END_TIME=2026-11-12 21:54:46, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215446_232, PA |
| 21:54:46.328 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 3 | 33.35 | p_sys_type=SELECT, p_sys_flag=OPERATION_CODE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^PLAN_ID^FP_PLAN_ID^PLAN_TYPE^UI_END_DATE^BASIS_START_TIME^DIVISION |
| 21:54:46.415 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 87.45 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'OPERATION_CODE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC' |
| 21:54:46.763 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 17 | 339.33 | p_sys_type=SELECT, p_sys_flag=LINE_CODE_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^PLAN_ID^FP_PLAN_ID^PLAN_TYPE^UI_END_DATE^BASIS_START_TIME^DIVISION |
| 21:54:46.789 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.98 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'LINE_CODE_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC' |
| 21:54:51.420 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.13 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:54:51.427 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 3.67 | p_program_id=FP00600, p_sheet_name=Amend |
| 21:54:51.434 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.7 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:54:51.443 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 5.47 | p_program_id=FP00600, p_sheet_name=Amend |
| 21:54:51.461 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 13 | 6.41 | BUCKET_FROM=20260914, BUCKET_TO=20261209 |
| 21:54:51.467 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.23 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check clie |
| 21:54:51.478 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 87 | 6.13 | PLAN_DATE=20260919, BUCKET_FROM=20260914, BUCKET_TO=20261209 |
| 21:54:51.483 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.14 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---FOUND PLAN_DATE |
| 21:54:51.496 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 4 | 6.91 | BUCKET_FROM=20260914, BUCKET_TO=20261209 |
| 21:54:51.508 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.96 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check cli |
| 21:54:51.521 | find | GSCM.FP_Common | SELECT A.* | 87 | 7.06 | BUCKET_FROM=20260914, BUCKET_TO=20261209 |
| 21:54:51.562 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.0 | PROG_ID=find_BukInfo, QUERY_ID=FP\Common\FP00600_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check clie |
| 21:54:51.926 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 47 | 356.28 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_PACK^81^FP_AMEND_PLAN_PACK_BOR_R^KR_PACK-20260919-00^ |
| 21:54:51.947 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.7 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 21:54:52.169 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 214.93 | p_sys_type=SELECT, p_sys_flag=OCV2_LT, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^PLAN_ID^FP_PLAN_ID^PLAN_TYPE^UI_END_DATE^BASIS_START_TIME^DIVISION_ID^LIN |
| 21:54:52.174 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.28 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:51, END_TIME=2026-11-12 21:54:52, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215451_954, PARAM_VALUE={p_sys_ |
| 21:54:52.178 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:51, END_TIME=2026-11-12 21:54:52, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215451_954, PARAM_VALUE=_NAME:2 |
| 21:54:52.183 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:51, END_TIME=2026-11-12 21:54:52, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215451_954, PARAM_VALUE=-11-23  |
| 21:54:52.187 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:51, END_TIME=2026-11-12 21:54:52, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215451_954, PARAM_VALUE=EGORY#F |
| 21:54:52.190 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.84 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'OCV2_LT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@opt_n |
| 21:54:52.195 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=-11 (SUN)#_COUNT:1#_VALUE:D27#_DATE_SEQ:1#WEEK_SEQ:202641#_TYPE:D#!_DATE:20261012#_NAME:2026-10-12 (Mon)#_COUNT:1#_VALUE:D28#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261013#_NAME:2026-10-13  |
| 21:54:52.200 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=_COUNT:1#_VALUE:D69#_DATE_SEQ:1#WEEK_SEQ:202647#_TYPE:D#!_DATE:20261123#_NAME:2026-11-23 (Mon)#_COUNT:1#_VALUE:D70#_DATE_SEQ:1#WEEK_SEQ:202648#_TYPE:D#!_DATE:20261124#_NAME:2026-11-24 (Tue)#_COU |
| 21:54:52.217 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.25 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=shin#MENU_ID:FP00600_Main#!MEA_ID:chk_sales#MEA_VALUE:true#MEA_NAME:Sales#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00600_Main#!MEA_ID:chk_ssp#MEA_VALUE:true#MEA_NAME:SSP#TYPE:CATEGORY#FL |
| 21:55:14.047 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 344 | 21823.1 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^PLAN_ID^FP_PLAN_ID^PLAN_TYPE^UI_END_DATE^BASIS_START_TIME^D |
| 21:55:14.066 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.97 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:52, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215452_222 |
| 21:55:14.071 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:52, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215452_222 |
| 21:55:14.076 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.33 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:52, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215452_222 |
| 21:55:14.080 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:54:52, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215452_222 |
| 21:55:14.085 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.53 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP006 |
| 21:55:14.090 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.94 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=#_NAME:2026-10-11 (SUN)#_COUNT:1#_VALUE:D27#_DATE_SEQ:1#WEEK_SEQ:202641#_TYPE:D#!_DATE:20261012#_NAME:2026-10-12 (Mon)#_COUNT:1#_VALUE:D28#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE: |
| 21:55:14.095 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.16 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=6-11-22 (SUN)#_COUNT:1#_VALUE:D69#_DATE_SEQ:1#WEEK_SEQ:202647#_TYPE:D#!_DATE:20261123#_NAME:2026-11-23 (Mon)#_COUNT:1#_VALUE:D70#_DATE_SEQ:1#WEEK_SEQ:202648#_TYPE:D#!_DATE:2 |
| 21:55:14.119 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.0 | PROG_ID=PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=USER_ID:jaeuk.shin#MENU_ID:FP00600_Main#!MEA_ID:chk_sales#MEA_VALUE:true#MEA_NAME:Sales#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00600_Main#!MEA_ID:chk_ssp#MEA_VALUE |
| 21:55:14.493 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 9 | 339.47 | p_sys_type=Select, p_sys_flag=TOTAL_VALUE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00600_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^SHIPMENT_OPT^PLANNER_YN^PLAN_ID^FP_PLAN_ID^PLAN_TYPE^UI_END_DATE^BASIS_START_TIME^DIVISION_ID |
| 21:55:14.498 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_153, PARAM_VALUE={p_sys_ |
| 21:55:14.523 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.5 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_153, PARAM_VALUE=012#_NA |
| 21:55:14.535 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.09 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_153, PARAM_VALUE=2026-11 |
| 21:55:14.592 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.55 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_153, PARAM_VALUE=:CATEGO |
| 21:55:14.612 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.88 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'TOTAL_VALUE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00600_ETC',@o |
| 21:55:14.616 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=6-10-11 (SUN)#_COUNT:1#_VALUE:D27#_DATE_SEQ:1#WEEK_SEQ:202641#_TYPE:D#!_DATE:20261012#_NAME:2026-10-12 (Mon)#_COUNT:1#_VALUE:D28#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261013#_NAME:2026-10 |
| 21:55:14.621 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.01 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=UN)#_COUNT:1#_VALUE:D69#_DATE_SEQ:1#WEEK_SEQ:202647#_TYPE:D#!_DATE:20261123#_NAME:2026-11-23 (Mon)#_COUNT:1#_VALUE:D70#_DATE_SEQ:1#WEEK_SEQ:202648#_TYPE:D#!_DATE:20261124#_NAME:2026-11-24 (Tue)# |
| 21:55:14.646 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.8 | PROG_ID=PR_UI_FP00600_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=euk.shin#MENU_ID:FP00600_Main#!MEA_ID:chk_sales#MEA_VALUE:true#MEA_NAME:Sales#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00600_Main#!MEA_ID:chk_ssp#MEA_VALUE:true#MEA_NAME:SSP#TYPE:CATEGOR |
| 21:55:14.667 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP00600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:14.675 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.06 | p_program_id=FP00600, p_sheet_name=Amend |
| 21:55:14.726 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 26.2 | INSTANCE_ID=KR_PACK, BUCKET_FROM=20260914, BUCKET_TO=20261209 |
| 21:55:14.749 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.76 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_699, PARAM_VALUE={AMEND_INSTANCE : PSI_AMEND |
| 21:55:14.754 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.23 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_699, PARAM_VALUE=_TYPE:D#!_DATE:20261013#_NA |
| 21:55:14.759 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_699, PARAM_VALUE=DATE:20261124#_NAME:2026-11 |
| 21:55:14.763 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_699, PARAM_VALUE=Main#!MEA_ID:chk_ssp#MEA_VA |
| 21:55:14.768 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 21:55:14.782 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 8.55 | INSTANCE_ID=KR_PACK |
| 21:55:14.811 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.21 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_773, PARAM_VALUE={AMEND_INSTANCE |
| 21:55:14.816 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.24 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_773, PARAM_VALUE=_TYPE:D#!_DATE: |
| 21:55:14.821 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.91 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_773, PARAM_VALUE=DATE:20261124#_ |
| 21:55:14.848 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.27 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_773, PARAM_VALUE=Main#!MEA_ID:ch |
| 21:55:14.853 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.91 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 21:55:14.865 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 5.21 | USER_ID=jaeuk.shin |
| 21:55:14.904 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.54 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_859, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 21:55:14.910 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.15 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_859, PARAM_VALUE=_TYPE:D#!_DATE:20261013# |
| 21:55:14.914 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.09 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_859, PARAM_VALUE=DATE:20261124#_NAME:2026 |
| 21:55:14.982 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 67.94 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:14, END_TIME=2026-11-12 21:55:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215514_859, PARAM_VALUE=Main#!MEA_ID:chk_ssp#MEA |
| 21:55:15.005 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.96 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:55:15.015 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.38 | INSTANCE_ID=KR_PACK |
| 21:55:15.020 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.47 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:15, END_TIME=2026-11-12 21:55:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215515_01, PARAM_VALUE={AMEND_INSTANCE : P |
| 21:55:15.025 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.23 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:15, END_TIME=2026-11-12 21:55:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215515_01, PARAM_VALUE=_TYPE:D#!_DATE:2026 |
| 21:55:15.030 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.38 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:15, END_TIME=2026-11-12 21:55:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215515_01, PARAM_VALUE=DATE:20261124#_NAME |
| 21:55:15.069 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.66 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:15, END_TIME=2026-11-12 21:55:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215515_01, PARAM_VALUE=Main#!MEA_ID:chk_ss |
| 21:55:15.084 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.84 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:55:15.344 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.47 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:55:15.372 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.67 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_PACK',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 21:55:15.422 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 28.52 | p_menu_id=FP00600, p_log_type=FIND, p_log_cnt=, p_db_time=23.201, p_ui_time=0.738, p_user_id=jaeuk.shin |
| 21:55:21.518 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 31.29 | MenuID=Plan Amend by Model(Pack), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 280 · 컬럼 124(보임 123) · 헤더 2단 · 고정 컬럼 20

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

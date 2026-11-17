# AS-IS 실측 요약 — FP02845

- 실행: 2026-11-12 23:43:07.254 ~ 2026-11-12 23:44:21.197 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Result (Elec Post Shift) (GSCM.FP.Planning.UIL.FP02845_Plan_Result_Elec_Post_Shift)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:43:07.722 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.21 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:43:07.725 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.31 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:07, END_TIME=2026-11-12 23:43:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234307_713, PA |
| 23:43:07.843 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 19.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02845 |
| 23:43:07.858 | load | GSCM.FP_Common | SELECT * | 351 | 10.12 | USER_ID= |
| 23:43:07.862 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:43:07.968 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.03 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:43:07.972 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.39 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:07, END_TIME=2026-11-12 23:43:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234307_961, PA |
| 23:43:07.990 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 15 | 4.05 | USER_ID=jaeuk.shin, MENU_ID=FP02845_Amend |
| 23:43:08.026 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.58 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 23:43:08.034 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:43:08.087 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 49.11 | p_program_id=FP02845, p_sheet_name=Amend |
| 23:43:08.246 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 139.5 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP02845_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:08.268 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP02845_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 23:43:08.660 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 331.21 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=PSI_AMEND_E_POST, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:08.687 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.44 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'PSI_AMEND_E_POST',@param2=N'Y',@param3=N'',@param4=N'',@ |
| 23:43:08.752 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 51.7 | p_sys_type=SELECT, p_sys_flag=PLAN_PERIOD, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02845_ETC, opt_none=, in_columns=UOM^AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=JR^PSI_AMEND_E_POST^ |
| 23:43:08.756 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=PR_UI_FP02845_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_PERIOD',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02845_ETC',@o |
| 23:43:09.292 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 506.55 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:43:09.312 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.97 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:08, END_TIME=2026-11-12 23:43:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234308_784, PA |
| 23:43:09.849 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 526.3 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, par |
| 23:43:09.872 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:09, END_TIME=2026-11-12 23:43:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234309_322, PA |
| 23:43:10.227 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 344.0 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24= |
| 23:43:10.229 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:09, END_TIME=2026-11-12 23:43:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234309_882, PA |
| 23:43:10.468 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 222.57 | p_code=findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=PL_E_POST, param2=, param3=, param4=BUILDING, param5=81, param6=A004, param7=WA00, param8=, param9=Y, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:10.490 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.73 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'PL_E_POST',@param2=N'',@param3=N'',@param4=N'BUILDING',@ |
| 23:43:10.838 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 336.98 | code=OPERATION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=WA00, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=,  |
| 23:43:10.842 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.89 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:10, END_TIME=2026-11-12 23:43:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234310_501, PA |
| 23:43:11.278 | load | GSCM.FP_Common | UI_FP_COMMON | 62 | 402.41 | code=LINE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=PL_E_POST, param2=, param3=, param4=, param5=81, param6=, param7=A004, param8=, param9=WA00, param10=, param11=, param12=, param13=E3000,E4000, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, para |
| 23:43:11.282 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.63 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:43:10, END_TIME=2026-11-12 23:43:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234310_875, PA |
| 23:43:11.338 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 7 | 33.35 | p_sys_type=SELECT, p_sys_flag=PRODUCTION_TYPE, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02842_ETC, opt_none=, in_columns=UOM^AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIV |
| 23:43:11.342 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.1 | PROG_ID=PR_UI_FP02842_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PRODUCTION_TYPE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02842_ETC |
| 23:43:11.353 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.77 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:43:11.360 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 3.73 | p_program_id=FP02845, p_sheet_name=Amend |
| 23:43:11.368 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.93 | p_program_id=FP02845, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 23:43:11.375 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 3.82 | p_program_id=FP02845, p_sheet_name=Amend |
| 23:43:11.490 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 95.18 | MenuID=Plan Result (Elec Post Shift), CnntCode=0104001, UserID=jaeuk.shin |
| 23:43:11.551 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02845 |
| 23:43:21.861 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 9 | 5.61 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20261109, param3=20261117, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:21.886 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261109',@param3=N'20261117',@param4=N'',@param5=N' |
| 23:43:21.937 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 44.4 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=PL_E_POST, param2=, param3=A004, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:21.977 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.08 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'PL_E_POST',@param2=N'',@param3=N'A004',@param4=N'BUILDING',@param5=N' |
| 23:43:21.990 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 6.07 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:22.065 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 74.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@param |
| 23:43:22.079 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 7.38 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:22.122 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.04 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@para |
| 23:43:22.139 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 11 | 8.74 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20261109, param2=20261117, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 23:43:22.206 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 66.79 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20261109',@param2=N'20261117',@param3=N'',@param4=N'',@param5=N'',@param |
| 23:44:13.402 | find | GSCM.FP_Common | PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | 0 | 51187.5 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=PL_E_POST, p_company_id=, p_division_id=81, p_site_id=A004, p_plant_id=WA00, p_factory_id=, p_line_id=EJD01,FP_EBR01_A,FP_EBR01-1_C,FP_EBR01-2_C,FP_EBR02_A,FP_EBR02-1_C,FP_EBR02-2_C,FP_EBS01_A,FP_EBS01_C,FP_ |
| 23:44:13.414 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.03 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_i |
| 23:44:13.425 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 3.39 | p_program_id=FP02845, p_user_id=jaeuk.shin, p_sheet_name=Amend |
| 23:44:13.507 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 60.13 | p_menu_id=FP02845, p_log_type=FIND, p_log_cnt=, p_db_time=51.568, p_ui_time=0.027, p_user_id=jaeuk.shin |
| 23:44:20.319 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.15 | MenuID=Plan Result (Elec Post Shift), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Operation | mcbo_operation |  |
| Div | mcbo_division |  |
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| layoutControlItem16 | chk_includeSubOp |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Site | mcbo_site |  |
| UOM | rdo_uom |  |
| Plan Period | dCalendar_planrange |  |
| Plan Date | sCalendar_planday |  |
| Plan Group | cbo_plan_group |  |
| Prod.Type | mcbo_prodtype |  |
| layoutControlItem2 | chk_plannedline |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 42(보임 38) · 헤더 3단 · 고정 컬럼 18

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — FP00618

- 실행: 2026-11-12 19:04:04.788 ~ 2026-11-12 19:04:25.008 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Model(PreMix) (GSCM.FP.Planning.UIL.FP00618_PlanBy_Model_PreMix)
- 조회 결과: Total :  · DB : 1.55s, UI : 0.099s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:04:05.158 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 29.03 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:05.162 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:05, END_TIME=2026-11-12 19:04:05, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190405_128, PA |
| 19:04:05.243 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00618 |
| 19:04:05.260 | load | GSCM.FP_Common | SELECT * | 351 | 10.64 | USER_ID= |
| 19:04:05.267 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.15 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:04:05.454 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.11 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:05.457 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:05, END_TIME=2026-11-12 19:04:05, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190405_446, PA |
| 19:04:05.485 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 26 | 4.17 | USER_ID=jaeuk.shin, MENU_ID=FP00618_Amend |
| 19:04:05.528 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.65 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:04:05.536 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.01 | p_program_id=FP00618, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:05.590 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 50.34 | p_program_id=FP00618, p_sheet_name=Amend |
| 19:04:05.792 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 151.64 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:05.820 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@ |
| 19:04:06.204 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 369.55 | p_code=FP00603_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:06.240 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 19:04:06.257 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.09 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:06.261 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 19:04:06.405 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 139.99 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:04:06.410 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:06, END_TIME=2026-11-12 19:04:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190406_266, PA |
| 19:04:06.562 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 141.24 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:04:06.578 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:06, END_TIME=2026-11-12 19:04:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190406_421, PA |
| 19:04:06.724 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 136.78 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:04:06.742 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:06, END_TIME=2026-11-12 19:04:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190406_586, PA |
| 19:04:06.817 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 65.72 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 19:04:06.870 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.02 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:06, END_TIME=2026-11-12 19:04:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190406_751, PA |
| 19:04:06.894 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.58 | p_code=FP00594_find_FPProdType, p_user_id=jaeuk.shin, param1=40,81, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:06.919 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.81 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'40,81',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:04:07.027 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 96.63 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:04:07.031 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:06, END_TIME=2026-11-12 19:04:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190406_929, PA |
| 19:04:07.081 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 25.82 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 19:04:07.084 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.7 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:07, END_TIME=2026-11-12 19:04:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190407_055, PA |
| 19:04:07.514 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 416.48 | code=FACTORY_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=40,81, param6=, param7=A001, param8=, param9=HQ06,HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=,  |
| 19:04:07.535 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.92 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:04:07, END_TIME=2026-11-12 19:04:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190407_098, PA |
| 19:04:07.900 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 346.87 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:07.923 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.71 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'',@par |
| 19:04:07.951 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 12.83 | p_code=FP00617_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=HQ06,HQ07, param5=E2,EG, param6=E0500, param7=N, param8=Y, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:07.983 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.52 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'HQ06, |
| 19:04:08.011 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 13.06 | p_code=FP00617_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=HQ06,HQ07, param5=E2,EG, param6=E0500, param7=N, param8=Y, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:08.048 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.66 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'HQ06, |
| 19:04:08.086 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP00618, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:08.095 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 4.41 | p_program_id=FP00618, p_sheet_name=Amend |
| 19:04:08.105 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.35 | p_program_id=FP00618, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:04:08.116 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 4.25 | p_program_id=FP00618, p_sheet_name=Amend |
| 19:04:08.260 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.42 | MenuID=Plan by Model(PreMix), CnntCode=0104001, UserID=jaeuk.shin |
| 19:04:08.427 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.5 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00618 |
| 19:04:17.184 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.04 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=A001, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.190 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.08 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'A001',@param4=N'BUILDING',@param5=N' |
| 19:04:17.209 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 10.78 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20260914, param3=20261018, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.241 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.74 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20260914',@param3=N'20261018',@param4=N |
| 19:04:17.254 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 35 | 4.27 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260914, param3=20261018, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.303 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.3 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260914',@param3=N'20261018',@param4=N'',@param5=N' |
| 19:04:17.317 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 5 | 4.51 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.322 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:04:17.334 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 4.46 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.354 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:04:17.369 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 40 | 4.91 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.413 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:04:17.431 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 9.05 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00618_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:04:17.473 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.87 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00618_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 19:04:18.712 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 1230.16 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00618_PLANBY_MODEL_PREMIX, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^CONFIRM_AREA^BASIS_START_TIME^BUCKET_FROM^BUCKET_TO^DIVISION_ID^PROD_TYPE^SITE_ID^PLANT |
| 19:04:18.714 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.71 | PROG_ID=PR_UI_FP00618_PLANBY_MODEL_PREMIX, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI |
| 19:04:18.834 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.37 | p_menu_id=FP00618, p_log_type=FIND, p_log_cnt=, p_db_time=1.55, p_ui_time=0.099, p_user_id=jaeuk.shin |
| 19:04:24.339 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.48 | MenuID=Plan by Model(PreMix), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | mcbo_division |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem2 | chkInAct |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| Site | cbo_site |  |
| Include | chk_IncludeSubOp |  |
| Material | txtItem |  |
| Prod. Type | mcbo_prod_type |  |
| Nick Name | txtNickName |  |
| Plan Period | dCalendar_planrange |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 64(보임 63) · 헤더 2단 · 고정 컬럼 22

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

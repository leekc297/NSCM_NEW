# AS-IS 실측 요약 — FP00617

- 실행: 2026-11-12 19:03:28.000 ~ 2026-11-12 19:04:04.668 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan by Line(PreMix) (GSCM.FP.Planning.UIL.FP00617_PlanBy_Line_PreMix)
- 조회 결과: Total :  · DB : 15.941s, UI : 0.124s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:03:28.406 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 32.53 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:03:28.409 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.48 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:28, END_TIME=2026-11-12 19:03:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190328_373, PA |
| 19:03:28.528 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00617 |
| 19:03:28.545 | load | GSCM.FP_Common | SELECT * | 351 | 10.77 | USER_ID= |
| 19:03:28.549 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.5 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:03:28.765 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.42 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:03:28.791 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:28, END_TIME=2026-11-12 19:03:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190328_757, PA |
| 19:03:28.809 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 30 | 4.24 | USER_ID=jaeuk.shin, MENU_ID=FP00617_Amend |
| 19:03:28.816 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.4 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:03:28.824 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00617, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:03:28.836 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 7.04 | p_program_id=FP00617, p_sheet_name=Amend |
| 19:03:29.077 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 188.73 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:29.105 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.92 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PMIX',@param2=N'',@param3=N'',@param4=N'',@ |
| 19:03:29.591 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 470.66 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 19:03:29.604 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.63 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:29, END_TIME=2026-11-12 19:03:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190329_12, PAR |
| 19:03:29.890 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 259.38 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:03:29.893 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.95 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:29, END_TIME=2026-11-12 19:03:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190329_629, PA |
| 19:03:30.372 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 463.62 | code=FACTORY_CODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=A001, param8=, param9=HQ06,HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param |
| 19:03:30.389 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.02 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:29, END_TIME=2026-11-12 19:03:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190329_908, PA |
| 19:03:30.745 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 335.23 | p_code=findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:30.770 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.3 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'A001',@param4=N'',@param5=N |
| 19:03:30.962 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 180.33 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:03:30.976 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:30, END_TIME=2026-11-12 19:03:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190330_781, PA |
| 19:03:31.116 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 126.27 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:03:31.154 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:30, END_TIME=2026-11-12 19:03:31, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190330_989, PA |
| 19:03:31.307 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 142.04 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, p |
| 19:03:31.349 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.91 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:31, END_TIME=2026-11-12 19:03:31, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190331_165, PA |
| 19:03:31.418 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 58.43 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PMIX, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 19:03:31.432 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.15 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:03:31, END_TIME=2026-11-12 19:03:31, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190331_359, PA |
| 19:03:31.709 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 260.68 | p_code=FP00617_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=HQ06,HQ07, param5=E2,EG, param6=E0500, param7=N, param8=N, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:31.713 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.78 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'HQ06, |
| 19:03:31.738 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 7.03 | p_code=FP00594_find_FPProdType, p_user_id=jaeuk.shin, param1=40,81, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:31.769 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.66 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'40,81',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:03:32.352 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 564.2 | p_code=FP00617_find_FPNickName, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=40,81, param4=A001, param5=HQ06,HQ07, param6=E2,EG, param7=, param8=E0500, param9=4M-VALID,A/S,C-MASS,D-MASS,D-SAMPLE,D-TEST,E-TEST,MASS,M-SAMPLE,SPECIAL,S-TEST,TEST, param10=, param11=, param12=, param13= |
| 19:03:32.357 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_find_FPNickName',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'40,81',@param4=N'A001 |
| 19:03:32.385 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.47 | p_code=FP00594_find_FPProdType, p_user_id=jaeuk.shin, param1=40,81, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:32.410 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'40,81',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:03:32.434 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 9.52 | p_code=FP00617_find_FPNickName, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=40,81, param4=A001, param5=HQ06,HQ07, param6=E2,EG, param7=, param8=E0500, param9=4M-VALID,A/S,C-MASS,D-MASS,D-SAMPLE,D-TEST,E-TEST,MASS,M-SAMPLE,SPECIAL,S-TEST,TEST, param10=, param11=, param12=, param13= |
| 19:03:32.467 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.56 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_find_FPNickName',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'40,81',@param4=N'A001 |
| 19:03:32.692 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 209.02 | p_code=FP00617_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=40,81, param3=A001, param4=HQ06,HQ07, param5=E2,EG, param6=E0500, param7=N, param8=Y, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:32.710 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.22 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'40,81',@param3=N'A001',@param4=N'HQ06, |
| 19:03:32.742 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 8.95 | p_code=FP00617_find_FPNickName, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=40,81, param4=A001, param5=HQ06,HQ07, param6=E2,EG, param7=, param8=E0500, param9=4M-VALID,A/S,C-MASS,D-MASS,D-SAMPLE,D-TEST,E-TEST,MASS,M-SAMPLE,SPECIAL,S-TEST,TEST, param10=, param11=, param12=, param13= |
| 19:03:32.765 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00617_find_FPNickName',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'40,81',@param4=N'A001 |
| 19:03:32.815 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.33 | p_program_id=FP00617, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:03:32.826 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 5.92 | p_program_id=FP00617, p_sheet_name=Amend |
| 19:03:32.834 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.25 | p_program_id=FP00617, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:03:32.842 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.65 | p_program_id=FP00617, p_sheet_name=Amend |
| 19:03:32.984 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 85.78 | MenuID=Plan by Line(PreMix), CnntCode=0104001, UserID=jaeuk.shin |
| 19:03:33.212 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00617 |
| 19:03:42.466 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 44.14 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=, param3=A001, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.508 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'',@param3=N'A001',@param4=N'BUILDING',@param5=N' |
| 19:03:42.533 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 16.25 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_E_PMIX, param2=20260914, param3=20261018, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.567 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.06 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PMIX',@param2=N'20260914',@param3=N'20261018',@param4=N |
| 19:03:42.587 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 35 | 8.88 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260914, param3=20261018, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.591 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.09 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260914',@param3=N'20261018',@param4=N'',@param5=N' |
| 19:03:42.612 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 5 | 6.11 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.649 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:03:42.665 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 6.85 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.669 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'',@param4=N'',@param5=N'',@para |
| 19:03:42.686 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 40 | 7.62 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261018, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.718 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.92 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261018',@param3=N'',@param4=N'',@param5=N'',@param |
| 19:03:42.736 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 9.34 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00617_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:03:42.780 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.53 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00617_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 19:03:58.343 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 15555.22 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00617_PLANBY_LINE_PREMIX, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^CONFIRM_AREA^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^ |
| 19:03:58.348 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.88 | PROG_ID=PR_UI_FP00617_PLANBY_LINE_PREMIX, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_ |
| 19:03:58.489 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.94 | p_menu_id=FP00617, p_log_type=FIND, p_log_cnt=, p_db_time=15.941, p_ui_time=0.124, p_user_id=jaeuk.shin |
| 19:04:03.991 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.03 | MenuID=Plan by Line(PreMix), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Period | dCalendar_planrange |  |
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
| Nick Nm List | mcbo_nickname_lt |  |
| Prod. Type | mcbo_prod_type |  |
| Nick Name | txtNickName |  |
| layoutControlItem3 | lblFullWashing |  |
| layoutControlItem12 | lblPouch |  |
| layoutControlItem15 | lblCylindrical |  |
| layoutControlItem18 | usrLabel1 |  |
| layoutControlItem19 | usrLabel2 |  |
| layoutControlItem20 | usrLabel3 |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 61(보임 59) · 헤더 2단 · 고정 컬럼 19

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

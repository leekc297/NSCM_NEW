# AS-IS 실측 요약 — FP00604

- 실행: 2026-11-12 18:48:20.523 ~ 2026-11-12 18:48:50.264 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan By Model(Pack) (GSCM.FP.Planning.UIL.FP00604_PlanByModel_Pack)
- 조회 결과: Total : 432 · DB : 3.751s, UI : 2.406s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:48:21.005 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.09 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:48:21.008 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:48:20, END_TIME=2026-11-12 18:48:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184820_995, PA |
| 18:48:21.718 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00604 |
| 18:48:21.740 | load | GSCM.FP_Common | SELECT * | 351 | 10.18 | USER_ID= |
| 18:48:21.767 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.22 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:48:22.046 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.63 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:48:22.049 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.71 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:48:22, END_TIME=2026-11-12 18:48:22, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184822_038, PA |
| 18:48:22.143 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 5.8 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 18:48:22.173 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.22 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 18:48:27.338 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 5154.79 | USER_ID=jaeuk.shin |
| 18:48:27.387 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.88 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:22, END_TIME=2026-11-12 18:48:27, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184822_182, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 18:48:27.413 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.45 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 18:48:27.419 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.25 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ID = C.COMPANY_ID

INNER JOIN SCM_DIVISION_M D WITH(NOLOCK)
ON FL.DIVISION_ID = D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.S |
| 18:48:27.492 | load | GSCM.FP_Common | SELECT | 145 | 6.69 | USER_ID=jaeuk.shin |
| 18:48:27.496 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.65 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client par |
| 18:48:27.512 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.51 | USER_ID=jaeuk.shin |
| 18:48:27.521 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.12 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client pa |
| 18:48:27.546 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 5.43 | USER_ID=jaeuk.shin |
| 18:48:27.572 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.57 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---C |
| 18:48:27.645 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 18.34 | LOGTYPE=SpeedUp, NOTE=FP00604
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:48:27.649 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:48:27.878 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 210.91 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 18:48:27.882 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:48:27, END_TIME=2026-11-12 18:48:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184827_666, PA |
| 18:48:27.923 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 28.27 | LOGTYPE=SpeedUp, NOTE=FP00604
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:48:27.980 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.99 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:48:28.017 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 4.28 | USER_ID=jaeuk.shin |
| 18:48:28.042 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.83 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 18:48:28.089 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.01 | p_program_id=FP00604, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:28.162 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 69.85 | p_program_id=FP00604, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:28.171 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP00604, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:28.179 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 4.81 | p_program_id=FP00604, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:28.362 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 61.79 | MenuID=Plan By Model(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 18:48:28.546 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00604 |
| 18:48:38.064 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 4.91 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.068 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.93 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@ |
| 18:48:38.097 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 19.06 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_PACK, param2=20260914, param3=20261108, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.134 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_PACK',@param2=N'20260914',@param3=N'20261108',@param4=N'' |
| 18:48:38.150 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 4.7 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260914, param3=20261108, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.191 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260914',@param3=N'20261108',@param4=N'',@param5=N' |
| 18:48:38.246 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 46.51 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.262 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.05 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:48:38.282 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 5.99 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.315 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.16 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@param5=N'',@para |
| 18:48:38.329 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 5.29 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.385 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.27 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:48:38.449 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 29 | 55.58 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00604_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:38.493 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.11 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00604_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 18:48:41.234 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 432 | 2730.25 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00604_PLANBYMODEL_PACK, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^DIVISION_ID^SITE_ID^PLANT_ID^PROD_TY |
| 18:48:41.239 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.82 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:38, END_TIME=2026-11-12 18:48:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184838_502, PARAM_ |
| 18:48:41.244 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.2 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:38, END_TIME=2026-11-12 18:48:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184838_502, PARAM_ |
| 18:48:41.280 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.66 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:38, END_TIME=2026-11-12 18:48:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184838_502, PARAM_ |
| 18:48:41.284 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:38, END_TIME=2026-11-12 18:48:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184838_502, PARAM_ |
| 18:48:41.325 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.14 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=4, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:38, END_TIME=2026-11-12 18:48:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184838_502, PARAM_ |
| 18:48:41.345 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.95 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP |
| 18:48:41.350 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=.)#DAY_SEQ:5#!IS_PLAN:N#D_VALUE:D25#_DATE:20261009#_WEEK:202641#_MONTH:10#_DATE_TXT:2026-10-09 (Fri.)#DAY_SEQ:6#!IS_PLAN:N#D_VALUE:D26#_DATE:20261010#_WEEK:202641#_MONTH:10#_DATE_TX |
| 18:48:41.354 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=60915#_NAME:2026-09-15 (Tue)#_COUNT:1#_VALUE:D1#_DATE_SEQ:1#WEEK_SEQ:202638#_TYPE:D#!_DATE:20260916#_NAME:2026-09-16 (Wed)#_COUNT:1#_VALUE:D2#_DATE_SEQ:1#WEEK_SEQ:202638#_TYPE:D#!_D |
| 18:48:41.359 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=YPE:D#!_DATE:20261023#_NAME:2026-10-23 (Fri)#_COUNT:1#_VALUE:D39#_DATE_SEQ:1#WEEK_SEQ:202643#_TYPE:D#!_DATE:20261024#_NAME:2026-10-24 (Sat)#_COUNT:1#_VALUE:D40#_DATE_SEQ:1#WEEK_SEQ: |
| 18:48:41.381 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.14 | PROG_ID=PR_UI_FP00604_PLANBYMODEL_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=4, QUERY_VALUE=lt#MEA_VALUE:TRUE#TYPE:CATEGORY#FLAG:#MENU_ID:FP00604_Main#USER_ID:jaeuk.shin#!MEA_ID:chk_resultExp#MEA_NAME:Result(+Exp.)#MEA_VALUE:TRUE#TYPE:CATEGORY#FLAG:#MENU_ID:FP00604_Main#US |
| 18:48:41.484 | find | GSCM.FP_Common | WITH M_TABLE AS ( | 27 | 4.67 | USER_ID=jaeuk.shin, MENU_ID=FP00604_Main |
| 18:48:41.488 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:48:41.501 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP00604, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:48:41.511 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 5.91 | p_program_id=FP00604, p_sheet_name=Main |
| 18:48:41.603 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.91 | p_program_id=FP00604, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:41.615 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 3.99 | p_program_id=FP00604, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:48:42.124 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 468.0 | INSTANCE_ID=KR_PACK, BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 18:48:42.148 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.2 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:41, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184841_654, PARAM_VALUE={AMEND_INSTANCE : PSI_AMEND |
| 18:48:42.152 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.2 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:41, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184841_654, PARAM_VALUE=(Sat.)#DAY_SEQ:7#!IS_PLAN:N |
| 18:48:42.194 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.68 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:41, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184841_654, PARAM_VALUE=EQ:202638#_TYPE:D#!_DATE:20 |
| 18:48:42.799 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 606.07 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:41, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184841_654, PARAM_VALUE=_DATE_SEQ:1#WEEK_SEQ:202643 |
| 18:48:42.830 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.56 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=4, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:41, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184841_654, PARAM_VALUE=ORY#FLAG:#MENU_ID:FP00604_M |
| 18:48:42.838 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.51 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 18:48:42.854 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 6.12 | USER_ID=jaeuk.shin |
| 18:48:42.916 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 62.05 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:42, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184842_845, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 18:48:42.923 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.62 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:42, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184842_845, PARAM_VALUE=(Sat.)#DAY_SEQ:7#!IS_PLA |
| 18:48:42.930 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.14 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:42, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184842_845, PARAM_VALUE=EQ:202638#_TYPE:D#!_DATE |
| 18:48:42.936 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.58 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:42, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184842_845, PARAM_VALUE=_DATE_SEQ:1#WEEK_SEQ:202 |
| 18:48:42.969 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.84 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=4, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:42, END_TIME=2026-11-12 18:48:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184842_845, PARAM_VALUE=ORY#FLAG:#MENU_ID:FP0060 |
| 18:48:43.006 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.79 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 18:48:43.021 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 5.34 | INSTANCE_ID=KR_PACK |
| 18:48:43.027 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.8 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:43, END_TIME=2026-11-12 18:48:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184843_014, PARAM_VALUE={AMEND_INSTANCE :  |
| 18:48:43.037 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.96 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:43, END_TIME=2026-11-12 18:48:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184843_014, PARAM_VALUE=(Sat.)#DAY_SEQ:7#! |
| 18:48:43.044 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.68 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:43, END_TIME=2026-11-12 18:48:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184843_014, PARAM_VALUE=EQ:202638#_TYPE:D# |
| 18:48:43.051 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.02 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:43, END_TIME=2026-11-12 18:48:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184843_014, PARAM_VALUE=_DATE_SEQ:1#WEEK_S |
| 18:48:43.085 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.83 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=4, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:48:43, END_TIME=2026-11-12 18:48:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184843_014, PARAM_VALUE=ORY#FLAG:#MENU_ID: |
| 18:48:43.103 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.56 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 18:48:43.315 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 7.28 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:48:43.356 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_PACK',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 18:48:43.891 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.57 | p_menu_id=FP00604, p_log_type=FIND, p_log_cnt=, p_db_time=3.751, p_ui_time=2.406, p_user_id=jaeuk.shin |
| 18:48:49.529 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.31 | MenuID=Plan By Model(Pack), CnntCode=0104002, UserID=jaeuk.shin |

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
| Model | txtModel |  |
| Material | txtItem |  |
| Plan Group | cbo_plan_group |  |
| Pjt Group Nm | txtPjtGroupName |  |
| Nick Name | txtNickName |  |
| Prod Type | mcbo_prodtype |  |
| Site | cbo_site |  |

## 그리드

- spdMain / Amend: 행 364 · 컬럼 88(보임 83) · 헤더 2단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

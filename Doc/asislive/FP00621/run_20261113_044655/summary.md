# AS-IS 실측 요약 — FP00621

- 실행: 2026-11-13 04:46:55.865 ~ 2026-11-13 04:47:26.726 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Formation) (GSCM.FP.Planning.UIL.FP00621_PlanAmend_Line_Formation)
- 조회 결과:  · DB : 4.904s, UI : 0.182s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:46:56.317 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.2 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:46:56.322 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:46:56, END_TIME=2026-11-13 04:46:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044656_31, PAR |
| 04:46:56.474 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00621 |
| 04:46:56.486 | load | GSCM.FP_Common | SELECT * | 351 | 9.29 | USER_ID= |
| 04:46:56.491 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.84 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:46:56.613 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.71 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:46:56.616 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.49 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:46:56, END_TIME=2026-11-13 04:46:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044656_605, PA |
| 04:46:56.655 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 27 | 25.1 | USER_ID=jaeuk.shin, MENU_ID=FP00621_Amend |
| 04:46:56.683 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.14 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 04:46:56.696 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.19 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:46:56.738 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 37.74 | p_program_id=FP00621, p_sheet_name=Amend |
| 04:46:56.837 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 25.12 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 04:46:56.854 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.74 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 04:47:01.470 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4606.25 | USER_ID=jaeuk.shin |
| 04:47:01.475 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.6 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:46:56, END_TIME=2026-11-13 04:47:01, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044656_862, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 04:47:01.482 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.95 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 04:47:01.486 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.78 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ID = C.COMPANY_ID

INNER JOIN SCM_DIVISION_M D WITH(NOLOCK)
ON FL.DIVISION_ID = D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID
 |
| 04:47:01.726 | load | GSCM.FP_Common | SELECT | 145 | 4.59 | USER_ID=jaeuk.shin |
| 04:47:01.751 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.57 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client par |
| 04:47:01.769 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.78 | USER_ID=jaeuk.shin |
| 04:47:01.791 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.09 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client pa |
| 04:47:01.824 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 9.26 | USER_ID=jaeuk.shin |
| 04:47:01.853 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.1 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---C |
| 04:47:01.914 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.29 | LOGTYPE=SpeedUp, NOTE=FP00621
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 04:47:01.970 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.89 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 04:47:02.005 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.33 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:02.032 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 04:47:02.061 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 17.55 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261113, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:02.100 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.91 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261113',@param3=N'',@param4=N'',@param |
| 04:47:02.129 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.48 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:02.159 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.58 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 04:47:02.174 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.29 | LOGTYPE=SpeedUp, NOTE=FP00621
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 04:47:02.179 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.54 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 04:47:02.252 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.95 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:02.258 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 4.1 | p_program_id=FP00621, p_sheet_name=Amend |
| 04:47:02.265 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.71 | p_program_id=FP00621, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 04:47:02.271 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 11 | 3.96 | p_program_id=FP00621, p_sheet_name=Amend |
| 04:47:02.337 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 48.77 | MenuID=Plan Amend by Line(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 04:47:02.379 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00621 |
| 04:47:10.749 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 18.25 | p_code=FP00621_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:10.792 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.06 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00621_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20260919',@param3=N'',@param4=N'',@param |
| 04:47:10.843 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 5.03 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=KR_FORM_A-20260919-00, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:10.870 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.23 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'KR_FORM_A-20260919-00',@param3=N'',@param4 |
| 04:47:15.686 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 158.13 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:15.712 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.44 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 04:47:15.736 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 4.25 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:15.740 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.7 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 04:47:15.766 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 15.75 | p_code=find_isCurrWeek, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=KR_FORM_A-20260919-00, param3=A001, param4=BUILDING, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:15.825 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_isCurrWeek',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'KR_FORM_A-20260919-00',@param3=N'A001',@param4=N |
| 04:47:15.878 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 32.54 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:15.922 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.07 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:47:15.948 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 4.59 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:15.991 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.38 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@para |
| 04:47:16.026 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 32 | 5.37 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:16.046 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.63 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:47:16.212 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 27 | 154.21 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00621_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:47:16.258 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.52 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00621_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 04:47:20.403 | find | GSCM.FP_Common | PR_UI_FP00621_AMEND_LINE | 0 | 4111.1 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_FORM_A, p_company_id=, p_division_id=81,82, p_site_id=A001, p_plant_id=HQ07,HQ08, p_factory_id=A1,A2,A9,S2, p_line_id=A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A2A10,A2A11,A2A13,A2A14,A9A0 |
| 04:47:20.412 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00621_AMEND_LINE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00621_AMEND_LINE @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_FORM_A',@p_company |
| 04:47:20.612 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.7 | p_menu_id=FP00621, p_log_type=FIND, p_log_cnt=, p_db_time=4.904, p_ui_time=0.182, p_user_id=jaeuk.shin |
| 04:47:26.028 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.18 | MenuID=Plan Amend by Line(Formation), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem9 | chk_Info |  |
| Operation | mcbo_operation |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Nick Name List | mcbo_nicknamelt |  |
| Nick Name | txtNickName |  |
| Material | txtItem |  |
| Pjt Group Nm | txtPjtGroup |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Group | cbo_plan_group |  |
| layoutControlItem16 | chk_includeSubOp |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 46(보임 45) · 헤더 2단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

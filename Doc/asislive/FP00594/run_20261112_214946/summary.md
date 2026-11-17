# AS-IS 실측 요약 — FP00594

- 실행: 2026-11-12 21:49:46.679 ~ 2026-11-12 21:50:32.070 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(NJ_Pouch) (GSCM.FP.Planning.UIL.FP00594_PlanAmend_Model_NJ_Pouch)
- 조회 결과: Total : 201 · DB : 15.9s, UI : 0.615s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:49:47.008 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 59.6 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:49:47.021 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.41 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:49:46, END_TIME=2026-11-12 21:49:47, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214946_947, PA |
| 21:49:47.461 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00594 |
| 21:49:47.481 | load | GSCM.FP_Common | SELECT * | 351 | 12.04 | USER_ID= |
| 21:49:47.528 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.14 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:49:47.744 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 59.07 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:49:47.747 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.9 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:49:47, END_TIME=2026-11-12 21:49:47, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214947_685, PA |
| 21:49:47.803 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 23 | 4.07 | USER_ID=jaeuk.shin, MENU_ID=FP00594_Amend |
| 21:49:47.995 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 191.0 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:49:48.004 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.26 | p_program_id=FP00594, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:49:48.012 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 4.29 | p_program_id=FP00594, p_sheet_name=Amend |
| 21:49:48.079 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 4.13 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 21:49:48.251 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 171.2 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 21:49:52.827 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4569.98 | USER_ID=jaeuk.shin |
| 21:49:52.862 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.34 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:49:48, END_TIME=2026-11-12 21:49:52, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214948_256, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 21:49:52.883 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.28 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:49:52.932 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.61 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ID = C.COMPANY_ID

INNER JOIN SCM_DIVISION_M D WITH(NOLOCK)
ON FL.DIVISION_ID = D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID
 |
| 21:49:53.011 | load | GSCM.FP_Common | SELECT | 145 | 4.52 | USER_ID=jaeuk.shin |
| 21:49:53.017 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.48 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client par |
| 21:49:53.032 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.81 | USER_ID=jaeuk.shin |
| 21:49:53.157 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 123.41 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client pa |
| 21:49:53.172 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.62 | USER_ID=jaeuk.shin |
| 21:49:53.229 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 57.19 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---C |
| 21:49:53.514 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 243.28 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:49:53.532 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.59 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'', |
| 21:49:53.597 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 40.82 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20220907, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:49:53.692 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 94.78 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20220907',@param3=N'',@param4=N'',@para |
| 21:49:53.710 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 6.79 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:49:53.727 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.46 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@pa |
| 21:49:53.749 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 14.58 | LOGTYPE=SpeedUp, NOTE=FP00594
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 21:49:53.800 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.8 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:49:53.867 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 60.28 | LOGTYPE=SpeedUp, NOTE=FP00594
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 21:49:53.870 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.57 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:49:53.895 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 3.83 | USER_ID=jaeuk.shin |
| 21:49:53.985 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 88.46 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 21:49:54.033 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.94 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:49:54.058 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20261112',@param3=N'',@param4=N'',@para |
| 21:49:54.071 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.22 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:49:54.172 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 100.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@pa |
| 21:49:54.227 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.46 | p_program_id=FP00594, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:49:54.233 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 3.54 | p_program_id=FP00594, p_sheet_name=Amend |
| 21:49:54.242 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.54 | p_program_id=FP00594, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:49:54.249 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 3.4 | p_program_id=FP00594, p_sheet_name=Amend |
| 21:49:54.460 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 82.33 | MenuID=Plan Amend by Model(NJ_Pouch), CnntCode=0104001, UserID=jaeuk.shin |
| 21:49:54.523 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00594 |
| 21:50:03.782 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 80.58 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:03.834 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.91 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'20260919',@param3=N'',@param4=N'',@para |
| 21:50:03.880 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.62 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=CN_CELL_M2-20260919-00, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:04.020 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 139.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'CN_CELL_M2-20260919-00',@param3=N'',@para |
| 21:50:08.962 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 270.57 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:09.134 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 170.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 21:50:09.149 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 4.6 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:09.180 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.15 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 21:50:09.193 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.44 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:09.248 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:50:09.263 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 7.17 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:09.313 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@para |
| 21:50:09.330 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 32 | 9.75 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:09.377 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:50:09.431 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 44.31 | p_code=FP00594_find_ListData_BOH, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=CN_CELL_M2-20260919-00, param3=20260919, param4=FP_AMEND_CUTOFF_BOH_R , param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, p |
| 21:50:09.479 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.7 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_ListData_BOH',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'CN_CELL_M2-20260919-00',@param3=N'202 |
| 21:50:09.510 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 66 | 23.27 | p_code=FP00594_find_ListData, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=CN_CELL_M2-20260919-00, param3=A5000,A7000,A7100,A8000,A8100,A8200,A9000, param4=FP_AMEND_PLAN_CELL_R, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, para |
| 21:50:09.543 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_ListData',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'CN_CELL_M2-20260919-00',@param3=N'A5000,A |
| 21:50:09.813 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 37 | 260.39 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00594_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:09.853 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.44 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00594_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 21:50:12.292 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4931 | 2429.8 | p_code=FP00594_find_YieldInfo, p_user_id=jaeuk.shin, param1=40, param2=A002, param3=NJ01, param4=M4,M6, param5=A5000,A7000,A7100,A8000,A8100,A8200,A9000, param6=M4T01,M4T02,M4T03,M4T04,M6L16,M6L17,M6L18,M6L20,M6L21,M6L22,M6L23,M6L24,M6L25,M6L26,M6L27,M6L28,M6L29,M6L30,M6L31,M6L32,M6L33,M6L34,M6L61,M |
| 21:50:12.501 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 210.57 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_find_YieldInfo',@p_user_id=N'jaeuk.shin',@param1=N'40',@param2=N'A002',@param3=N'NJ01',@param4=N'M4,M6',@param5=N |
| 21:50:24.058 | find | GSCM.FP_Common | PR_UI_FP00594_AMEND_MODEL | 418 | 11527.71 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_CELL_M2, p_company_id=, p_division_id=40, p_site_id=A002, p_plant_id=NJ01, p_factory_id=M4,M6, p_line_id=M4T01,M4T02,M4T03,M4T04,M6L16,M6L17,M6L18,M6L20,M6L21,M6L22,M6L23,M6L24,M6L25,M6L26,M6L27,M6L28,M6L |
| 21:50:24.063 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.46 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00594_AMEND_MODEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00594_AMEND_MODEL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_CELL_M2',@p_comp |
| 21:50:24.515 | find | GSCM.FP_Common | PR_UI_FP00594_AMEND_MODEL | 0 | 410.53 | p_sys_type=SELECT, p_sys_flag=SELECT_TOTAL_VALUE, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_CELL_M2, p_company_id=, p_division_id=40, p_site_id=A002, p_plant_id=NJ01, p_factory_id=M4,M6, p_line_id=M4T01,M4T02,M4T03,M4T04,M6L16,M6L17,M6L18,M6L20,M6L21,M6L22,M6L23,M6L24,M6L25,M6L26,M6L27,M6 |
| 21:50:24.570 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.84 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00594_AMEND_MODEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00594_AMEND_MODEL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_TOTAL_VALUE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_CELL_M2', |
| 21:50:24.781 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 179.12 | INSTANCE_ID=CN_CELL_M2, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:50:24.808 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.45 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 21:50:24.823 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 4.43 | INSTANCE_ID=CN_CELL_M2 |
| 21:50:24.858 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.39 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 21:50:24.904 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 39.45 | USER_ID=jaeuk.shin |
| 21:50:24.927 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.2 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:50:24.941 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 6.01 | INSTANCE_ID=CN_CELL_M2 |
| 21:50:24.980 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.42 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:50:25.134 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 38.34 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=CN_CELL_M2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:50:25.180 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'CN_CELL_M2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 21:50:25.240 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 44.87 | p_menu_id=FP00594, p_log_type=FIND, p_log_cnt=, p_db_time=15.9, p_ui_time=0.615, p_user_id=jaeuk.shin |
| 21:50:31.229 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.18 | MenuID=Plan Amend by Model(NJ_Pouch), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Group | cbo_plan_group |  |
| planner | mcbo_planner |  |
| FP Plan ID | cbo_fpplanid |  |
| Plan Date | sCalendar_planday |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem9 | chk_Info |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem11 | chk_allLine |  |
| Plan Period | dCalendar_planrange |  |
| Div | mcbo_division |  |
| lblImport | btnExcelImport |  |
| Data | btnToggleSave |  |
| lblSql | btnSql |  |
| Model | txtModel |  |
| Material | txtItem |  |
| Nick Name | txtNickName |  |
| Prod Type | mcbo_prodtype |  |

## 그리드

- spdMain / Amend: 행 201 · 컬럼 56(보임 55) · 헤더 2단 · 고정 컬럼 22

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

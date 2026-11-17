# AS-IS 실측 요약 — FP00607

- 실행: 2026-11-12 22:00:02.589 ~ 2026-11-12 22:00:49.991 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Formation) (GSCM.FP.Planning.UIL.FP00607_PlanAmend_Model_Formation)
- 조회 결과: Total : 21 · DB : 18.791s, UI : 0.299s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:00:03.304 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 340.18 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:00:03.308 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:00:02, END_TIME=2026-11-12 22:00:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220002_964, PA |
| 22:00:03.719 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00607 |
| 22:00:03.742 | load | GSCM.FP_Common | SELECT * | 351 | 10.11 | USER_ID= |
| 22:00:03.746 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.36 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:00:03.891 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.72 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:00:03.894 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.52 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:00:03, END_TIME=2026-11-12 22:00:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220003_883, PA |
| 22:00:03.912 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 3.99 | USER_ID=jaeuk.shin, MENU_ID=FP00607_Amend |
| 22:00:03.916 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:00:03.925 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.96 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:03.974 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 22 | 46.58 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:04.009 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 33 | 9.51 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00607_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:04.044 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.07 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00607_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 22:00:04.118 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 2.98 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 22:00:04.142 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.43 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 22:00:08.513 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4364.61 | USER_ID=jaeuk.shin |
| 22:00:08.516 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.51 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:00:04, END_TIME=2026-11-12 22:00:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220004_147, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 22:00:08.532 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.01 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 22:00:08.536 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.03 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ID = C.COMPANY_ID

INNER JOIN SCM_DIVISION_M D WITH(NOLOCK)
ON FL.DIVISION_ID = D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID
 |
| 22:00:08.606 | load | GSCM.FP_Common | SELECT | 145 | 5.24 | USER_ID=jaeuk.shin |
| 22:00:08.610 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client par |
| 22:00:08.626 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.7 | USER_ID=jaeuk.shin |
| 22:00:08.652 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.74 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client pa |
| 22:00:08.667 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.8 | USER_ID=jaeuk.shin |
| 22:00:08.691 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.15 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---C |
| 22:00:08.752 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.22 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 22:00:08.787 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.23 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:00:08.805 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.38 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:08.861 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.47 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 22:00:08.974 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 102.22 | p_code=FP00607_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:09.036 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 61.57 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 22:00:09.048 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.53 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:09.087 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.75 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 22:00:09.097 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.97 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 22:00:09.100 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.39 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:00:09.134 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.97 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 22:00:09.199 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.98 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:00:09.212 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.46 | p_code=FP00594_findPlanner_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:09.256 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.4 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findPlanner_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 22:00:09.270 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.6 | p_code=FP00607_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:09.273 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'',@param4=N'',@param |
| 22:00:09.285 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.23 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:09.315 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@par |
| 22:00:09.350 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 29.86 | LOGTYPE=SpeedUp, NOTE=FP00607
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 22:00:09.354 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:00:09.394 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.82 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:09.401 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 22 | 3.96 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:09.407 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.69 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:09.414 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 22 | 4.18 | p_program_id=FP00607, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:00:09.577 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 60.7 | MenuID=Plan Amend by Model(Formation), CnntCode=0104001, UserID=jaeuk.shin |
| 22:00:09.630 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00607 |
| 22:00:18.931 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 72.28 | p_code=FP00607_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20260919, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:18.953 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.96 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20260919',@param3=N'',@param4=N'',@param |
| 22:00:18.993 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 12.8 | p_code=FP00594_findBasisTime, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=KR_FORM_A-20260919-00, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:19.116 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 122.34 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findBasisTime',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'KR_FORM_A-20260919-00',@param3=N'',@param4 |
| 22:00:24.418 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 176.44 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:24.450 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.84 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 22:00:24.476 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 16.53 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:24.500 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.29 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 22:00:24.520 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 13.49 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:24.545 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:00:24.560 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 2 | 8.33 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:24.652 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 92.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@para |
| 22:00:24.681 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 32 | 21.49 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:24.706 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.43 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:00:24.722 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 37 | 9.6 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00607_Amend, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:24.763 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00607_Amend',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 22:00:42.562 | find | GSCM.FP_Common | PR_UI_FP00607_AMEND_MODEL | 21 | 17788.76 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_FORM_A, p_company_id=, p_division_id=81,82, p_site_id=A001, p_plant_id=HQ07,HQ08, p_factory_id=A1,A2,A9,S2, p_line_id=A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A2A10,A2A11,A2A13,A2A14,A9A0 |
| 22:00:42.567 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00607_AMEND_MODEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00607_AMEND_MODEL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_FORM_A',@p_compa |
| 22:00:42.673 | find | GSCM.FP_Common | PR_UI_FP00607_AMEND_MODEL | 1 | 92.3 | p_sys_type=SELECT, p_sys_flag=SELECT_TOTAL_VALUE, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=KR_FORM_A, p_company_id=, p_division_id=81,82, p_site_id=A001, p_plant_id=HQ07,HQ08, p_factory_id=A1,A2,A9,S2, p_line_id=A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A2A10,A2A11,A2A13,A2A |
| 22:00:42.691 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP00607_AMEND_MODEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP00607_AMEND_MODEL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_TOTAL_VALUE',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'KR_FORM_A',@ |
| 22:00:42.704 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.17 | p_code=FP00607_find_ListData, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=KR_FORM_A-20260919-00, param3=F6000, param4=FP_AMEND_PLAN_FORM_R, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:42.737 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.06 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_find_ListData',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'KR_FORM_A-20260919-00',@param3=N'F6000',@p |
| 22:00:42.751 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 6.4 | p_code=FP00607_find_ListData_BOH, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=KR_FORM_A-20260919-00, param3=20260919, param4=FP_AMEND_CUTOFF_BOH_R, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, para |
| 22:00:42.838 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 86.74 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_find_ListData_BOH',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'KR_FORM_A-20260919-00',@param3=N'20260 |
| 22:00:42.851 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 5.48 | p_code=FP00607_find_ListData_LT, p_user_id=jaeuk.shin, param1=81,82, param2=A001, param3=HQ07,HQ08, param4=A1,A2,A9,S2, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:42.878 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.05 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_find_ListData_LT',@p_user_id=N'jaeuk.shin',@param1=N'81,82',@param2=N'A001',@param3=N'HQ07,HQ08',@param4=N'A1,A2, |
| 22:00:42.890 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.35 | p_code=FP00607_find_accumQTY, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:42.894 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_find_accumQTY',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N'',@ |
| 22:00:42.966 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 64.51 | p_code=FP00607_find_operationBOD, p_user_id=jaeuk.shin, param1=81,82, param2=A001, param3=HQ07,HQ08, param4=F6000, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:43.015 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.59 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00607_find_operationBOD',@p_user_id=N'jaeuk.shin',@param1=N'81,82',@param2=N'A001',@param3=N'HQ07,HQ08',@param4=N'F6000 |
| 22:00:43.049 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 6.24 | INSTANCE_ID=KR_FORM_A, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:00:43.054 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 22:00:43.069 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 8.39 | INSTANCE_ID=KR_FORM_A |
| 22:00:43.073 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 22:00:43.086 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 4.99 | USER_ID=jaeuk.shin |
| 22:00:43.091 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 22:00:43.103 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.61 | INSTANCE_ID=KR_FORM_A |
| 22:00:43.116 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.74 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 22:00:43.249 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 33 | 4.82 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00607_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:43.271 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.65 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00607_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 22:00:43.297 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 4.2 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:00:43.303 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.02 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |
| 22:00:43.328 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.97 | p_menu_id=FP00607, p_log_type=FIND, p_log_cnt=, p_db_time=18.791, p_ui_time=0.299, p_user_id=jaeuk.shin |
| 22:00:49.299 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 29.81 | MenuID=Plan Amend by Model(Formation), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 21 · 컬럼 57(보임 48) · 헤더 2단 · 고정 컬럼 23

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

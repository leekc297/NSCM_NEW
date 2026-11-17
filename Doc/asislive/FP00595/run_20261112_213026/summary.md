# AS-IS 실측 요약 — FP00595

- 실행: 2026-11-12 21:30:26.171 ~ 2026-11-12 21:31:26.476 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Elec) (GSCM.FP.Planning.UIL.FP00595_Plan_Amend_Line_Elec)
- 조회 결과:  · DB : 32.497s, UI : 0.205s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:30:26.854 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00595 |
| 21:30:26.871 | load | GSCM.FP_Common | SELECT * | 351 | 9.38 | USER_ID= |
| 21:30:26.874 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.36 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:30:27.049 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.29 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:30:27.051 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:30:27, END_TIME=2026-11-12 21:30:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213027_041, PA |
| 21:30:27.083 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 4.93 | USER_ID=jaeuk.shin, MENU_ID=FP00595_Amend |
| 21:30:27.117 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.77 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:30:27.125 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.55 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:30:27.132 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 3.71 | p_program_id=FP00595, p_sheet_name=Amend |
| 21:30:27.202 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 2.85 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 21:30:27.223 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.36 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 21:30:32.371 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 5141.62 | USER_ID=jaeuk.shin |
| 21:30:32.398 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.68 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:30:27, END_TIME=2026-11-12 21:30:32, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213027_228, PARAM_VALUE={AMEND_INSTANCE : LINE_A |
| 21:30:32.402 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:30:32.406 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.56 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ID = C.COMPANY_ID

INNER JOIN SCM_DIVISION_M D WITH(NOLOCK)
ON FL.DIVISION_ID = D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID
 |
| 21:30:32.481 | load | GSCM.FP_Common | SELECT | 145 | 4.13 | USER_ID=jaeuk.shin |
| 21:30:32.484 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.29 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client par |
| 21:30:32.499 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.17 | USER_ID=jaeuk.shin |
| 21:30:32.545 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.42 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client pa |
| 21:30:32.556 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.28 | USER_ID=jaeuk.shin |
| 21:30:32.599 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.17 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---C |
| 21:30:32.649 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 3.27 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 21:30:32.653 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.49 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 21:30:32.669 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.96 | LOGTYPE=SpeedUp, NOTE=FP00595
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 21:30:32.718 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.01 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:30:32.806 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 73.15 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^Y |
| 21:30:32.843 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.11 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:30:32.854 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 2.66 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 21:30:32.913 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.76 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 21:30:32.925 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.99 | LOGTYPE=SpeedUp, NOTE=FP00595
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 21:30:32.963 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.69 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:30:32.992 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 3.99 | USER_ID=jaeuk.shin |
| 21:30:32.997 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.92 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 21:30:33.052 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 37.41 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^BUCKET_FROM^BUCKET |
| 21:30:33.056 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.73 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 21:30:33.074 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:30:33.079 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 3.64 | p_program_id=FP00595, p_sheet_name=Amend |
| 21:30:33.088 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.4 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:30:33.096 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.44 | p_program_id=FP00595, p_sheet_name=Amend |
| 21:30:33.270 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 77.19 | MenuID=Plan Amend by Line(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 21:30:33.328 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00595 |
| 21:30:42.351 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 59.27 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^BUCKET_FROM^BUCKET_TO^DIVIS |
| 21:30:42.357 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.3 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:30:47.074 | find | GSCM.FP_Common | SELECT @INSTANCE_ID AS INSTANCE_ID | 1 | 26.99 | INSTANCE_ID=KR_E_PRE_A |
| 21:30:47.078 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.77 | PROG_ID=find_isPDS, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client para |
| 21:30:47.188 | find | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 6.81 | INSTANCE_ID=KR_E_PRE_A |
| 21:30:47.193 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 21:30:48.307 | find | GSCM.FP_Common | SELECT A.INSTANCE_ID, A.FP_PLAN_ID | 0 | 1107.42 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:30:48.330 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.06 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:30:47, END_TIME=2026-11-12 21:30:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213047_198, PARAM_VALUE={AMEND_INSTANCE : L |
| 21:30:48.336 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.85 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2BUCKET_FROM
---Service Parameter : 3BUCKET_TO
---Service Parameter : 4CTRL_DIVISION_LT
---Service Parameter : 5CTRL_ |
| 21:30:48.341 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.2 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=_BATCH,2)
           		  ELSE ROUND(A.WPP_IN_QTY_BATCH,2) END AS ADJUST_IN_QTY_BATCH
		   , CASE WHEN B.RELEASE_TYPE = 'DPP' THEN CEILING(A.ADJUST_IN_QTY)
           		  WHEN B.RELEASE_TYPE = 'MPP' THEN CEI |
| 21:30:49.669 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 11529 | 1167.97 |  |
| 21:30:49.711 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.82 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:30:48, END_TIME=2026-11-12 21:30:49, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213048_501, PARAM_VALUE={AMEND_INSTANCE : LI |
| 21:30:49.722 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.1 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0CTRL_DIVISION_LT
---Service Parameter : 1CTRL_SITE_LT
---Service Parameter : 2CTRL_PLANT_LT
---Service Parameter : 3CTRL_FACTORY_LT
---Check client parameter : AMEND_INSTANCE
---Check |
| 21:30:49.727 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.18 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=-ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
--       , A.MODEL_ID, A.ITEM_ID, A.APPLY_DATE DESC
--       , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE
ORDER BY A.COMPANY_ID |
| 21:30:55.847 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 14103 | 5874.56 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:30:55.895 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.69 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:30:49, END_TIME=2026-11-12 21:30:55, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213049_972, PARAM_VALUE={AMEND_INSTA |
| 21:30:55.904 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.83 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_LT
---Service Parameter : 4CTRL_PLANT_LT
---Service Parame |
| 21:30:55.909 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE='E5DP2','FP_E5M01_A','FP_E5M01_C','FP_E5M02_A','FP_E5M02_C','FP_E6M01_A','FP_E6M01_C','FP_E6M02_A','FP_E6M02_C')

      
      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_I |
| 21:30:56.714 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1915 | 492.8 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_E_PRE_A^81^FP_AMEND_DAILY_BOR_R^KR_E_PRE_A-20260919-0 |
| 21:30:56.758 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.86 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 21:30:56.924 | find | GSCM.FP_Common | SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE | 727 | 88.7 | MASTER_ID=KR_E_PRE_A |
| 21:30:56.949 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.3 | PROG_ID=find_Prod_Version_Type, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1CTRL_DIVISION_LT
---Service Parameter : 2CTRL_SITE_LT
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---C |
| 21:30:57.011 | find | GSCM.FP_Common | SELECT A.SEGMENT3 AS PRODUCTION_TYPE | 10 | 51.45 | MASTER_ID=KR_E_PRE_A |
| 21:30:57.016 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.78 | PROG_ID=find_versionType, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:31:00.419 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 0 | 3396.85 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:31:00.440 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.56 | PROG_ID=find_yieldInfo_ALL, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2AMEND_BOR_TABLE
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client pa |
| 21:31:00.522 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.67 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:31:00.543 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.8 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---C |
| 21:31:00.593 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 39.8 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:00.644 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.2 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 21:31:00.661 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.21 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:31:00.701 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.1 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:31:00.715 | find | GSCM.FP_Common | SELECT A.* | 28 | 6.48 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:31:00.768 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.43 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:31:00, END_TIME=2026-11-12 21:31:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213100_708, PARAM_VALUE={AME |
| 21:31:00.785 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.67 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
- |
| 21:31:00.789 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=ROM, 112)
          --    AND    CAL.DT <= CONVERT(DATETIME, @BUCKET_TO, 112)
          --    GROUP BY ISO_YYYYWW
          --) A
          --INNER JOIN (
          --    SELECT '_QTY' AS POS |
| 21:31:19.304 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 18496.85 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00595_ROW_FIND_FP00595_ROW, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN_ID^PLAN_ |
| 21:31:19.311 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.04 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:31:00, END_TIME=2026-11-12 21:31:19, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213100_805, P |
| 21:31:19.319 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.62 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:31:00, END_TIME=2026-11-12 21:31:19, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213100_805, P |
| 21:31:19.416 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 96.68 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:31:00, END_TIME=2026-11-12 21:31:19, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112213100_805, P |
| 21:31:19.493 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 75.68 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00595 |
| 21:31:19.522 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.59 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261007#_NAME:2026-10-07 (Wed)#_COUNT:1#_VALUE:D23_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261008#_NAME:2026-10- |
| 21:31:19.646 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 124.07 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=tup#MEA_VALUE:true#MEA_NAME:M/C(sec)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00595_Amend#!MEA_ID:chk_sim#MEA_VALUE:true#MEA_NAME:Simulation#TYPE:CATEGORY#FLAG:#USER_ID |
| 21:31:19.913 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 35.59 | p_menu_id=FP00595, p_log_type=FIND, p_log_cnt=, p_db_time=32.497, p_ui_time=0.205, p_user_id=jaeuk.shin |
| 21:31:25.603 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.24 | MenuID=Plan Amend by Line(Elec), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Planner | mcbo_planner |  |
| FP Plan Id | cbo_fpplanid |  |
| lblSql | btnSql |  |
| layoutControlItem2 | btnExcelImport |  |
| Plan Group | cbo_plan_group |  |
| Plan Date | sCalendar_planday |  |
| Data | btnToggleSave |  |
| Division. | mcbo_division |  |
| Site | mcbo_site |  |
| Operation | mcbo_operation |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem13 | chk_Info |  |
| Plan Period | dCalendar_planrange |  |
| Material | edt_item |  |
| layoutControlItem3 | usrCheckBox1 |  |
| Line | mcbo_line |  |
| layoutControlItem12 | chk_all_line |  |
| Nick Name | tbNickName |  |
| Prod.Type | mcbo_prodtype |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 63(보임 62) · 헤더 2단 · 고정 컬럼 29

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

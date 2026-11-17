# AS-IS 실측 요약 — FP00598

- 실행: 2026-11-12 21:53:21.284 ~ 2026-11-12 21:53:55.699 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Elec) (GSCM.FP.Planning.UIL.FP00598_Plan_Amend_Model_Elec)
- 조회 결과:  · DB : 13.11s, UI : 0.117s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:53:21.693 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00598 |
| 21:53:21.708 | load | GSCM.FP_Common | SELECT * | 351 | 10.19 | USER_ID= |
| 21:53:21.712 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.51 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:53:21.870 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.93 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:53:21.873 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.7 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:53:21, END_TIME=2026-11-12 21:53:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215321_862, PA |
| 21:53:21.897 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 49 | 4.24 | USER_ID=jaeuk.shin, MENU_ID=FP00598_Amend |
| 21:53:21.926 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.13 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:53:21.934 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.17 | p_program_id=FP00598, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:53:21.985 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 48.71 | p_program_id=FP00598, p_sheet_name=Amend |
| 21:53:22.094 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 27.64 | LOGTYPE=SpeedUp, NOTE=FP00598
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 21:53:22.097 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.82 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:53:22.113 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 3.72 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 21:53:22.117 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.17 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 21:53:22.135 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 7.22 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=LINE_AMEND_E_PRE^2 |
| 21:53:22.160 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.61 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:53:22.174 | load | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 4.22 | INSTANCE_ID=KR_E_PRE_A |
| 21:53:22.222 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.53 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 21:53:22.233 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.48 | LOGTYPE=SpeedUp, NOTE=FP00598
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 21:53:22.269 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.28 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:53:22.326 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 49.14 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TABLE^AMEND_ |
| 21:53:22.331 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.28 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 21:53:22.369 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.98 | p_program_id=FP00598, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:53:22.376 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.13 | p_program_id=FP00598, p_sheet_name=Amend |
| 21:53:22.383 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.61 | p_program_id=FP00598, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:53:22.391 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.37 | p_program_id=FP00598, p_sheet_name=Amend |
| 21:53:22.484 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 71.08 | MenuID=Plan Amend by Model(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 21:53:22.561 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00598 |
| 21:53:31.201 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 10.18 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TABLE^AMEND_CUTOFF_BO |
| 21:53:31.208 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.29 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:53:35.489 | find | GSCM.FP_Common | SELECT @INSTANCE_ID AS INSTANCE_ID | 1 | 5.04 | INSTANCE_ID=KR_E_PRE_A |
| 21:53:35.495 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.27 | PROG_ID=find_isPDS, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client para |
| 21:53:35.815 | find | GSCM.FP_Common | WITH MAIN AS ( | 1 | 225.94 | PLAN_DATE=20260919, MASTER_ID=KR_E_PRE_A, BUCKET_FROM=20260914, BUCKET_TO=20261011, DIVISION_ID=81, SITE_ID=A001, PLANT_ID=HQ07, FACTORY_ID=E5,E6, OPERATION_ID=E2000, LINE_ID=E5DP1,E5DP2,FP_E5M01_A,FP_E5M01_C,FP_E5M02_A,FP_E5M02_C,FP_E6M01_A,FP_E6M01_C,FP_E6M02_A,FP_E6M02_C, PRODTYPE_ID=, PLAN_ID=KR |
| 21:53:35.820 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=find_totalValue, QUERY_ID=FP\Planning\FP00598_carryOver, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:35, END_TIME=2026-11-12 21:53:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215335_588, PARAM_VALUE={AMEND_INST |
| 21:53:35.824 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.1 | PROG_ID=find_totalValue, QUERY_ID=FP\Planning\FP00598_carryOver, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0AMEND_SALES_TABLE
---Service Parameter : 1AMEND_TABLE
---Service Parameter : 2CTRL_PRODUCTION_TYPE
---Service Parameter : 3CTRL_DIVISION_LT
---Service Parameter : 4DIVISION_I |
| 21:53:35.828 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.36 | PROG_ID=find_totalValue, QUERY_ID=FP\Planning\FP00598_carryOver, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE= ITEMNAME_ID
---FOUND ITEMNAME_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : NICKNAME_ID
---FOUND NICKNAME_ID
-- TYPE = nvarchar---Add string Service
---Check client paramet |
| 21:53:35.833 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=find_totalValue, QUERY_ID=FP\Planning\FP00598_carryOver, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=LAN_DATE
					                       , A.TOP_ITEM_ID, A.ITEM_ID, '' AS NICK_NAME
					                       , A.PRODUCTION_TYPE
					                       , A.MARKET
					                       ,  |
| 21:53:35.845 | find | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 4.39 | INSTANCE_ID=KR_E_PRE_A |
| 21:53:35.856 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.92 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 21:53:35.876 | find | GSCM.FP_Common | SELECT A.INSTANCE_ID, A.FP_PLAN_ID | 0 | 11.47 | MASTER_ID=KR_E_PRE_A, BUCKET_FROM=20260914, BUCKET_TO=20261011, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:53:35.912 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.7 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:35, END_TIME=2026-11-12 21:53:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215335_863, PARAM_VALUE={AMEND_INSTANCE : L |
| 21:53:35.928 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.67 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2BUCKET_FROM
---Service Parameter : 3BUCKET_TO
---Service Parameter : 4CTRL_DIVISION_LT
---Service Parameter : 5CTRL_ |
| 21:53:35.944 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.01 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=QTY_BATCH,2)
           		  ELSE ROUND(A.WPP_IN_QTY_BATCH,2) END AS ADJUST_IN_QTY_BATCH
		   , CASE WHEN B.RELEASE_TYPE = 'DPP' THEN CEILING(A.ADJUST_IN_QTY)
           		  WHEN B.RELEASE_TYPE = 'MPP' THEN  |
| 21:53:36.241 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 11529 | 255.32 |  |
| 21:53:36.245 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.93 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:35, END_TIME=2026-11-12 21:53:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215335_984, PARAM_VALUE={AMEND_INSTANCE : LI |
| 21:53:36.250 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0CTRL_DIVISION_LT
---Service Parameter : 1CTRL_SITE_LT
---Service Parameter : 2CTRL_PLANT_LT
---Service Parameter : 3CTRL_FACTORY_LT
---Check client parameter : AMEND_INSTANCE
---Check |
| 21:53:36.255 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=

--ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
--       , A.MODEL_ID, A.ITEM_ID, A.APPLY_DATE DESC
--       , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE
ORDER BY A.COMPANY |
| 21:53:36.834 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 14103 | 422.75 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:53:36.840 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.13 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:36, END_TIME=2026-11-12 21:53:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215336_409, PARAM_VALUE={AMEND_INSTA |
| 21:53:36.888 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.03 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_LT
---Service Parameter : 4CTRL_PLANT_LT
---Service Parame |
| 21:53:36.893 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.12 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=1','E5DP2','FP_E5M01_A','FP_E5M01_C','FP_E5M02_A','FP_E5M02_C','FP_E6M01_A','FP_E6M01_C','FP_E6M02_A','FP_E6M02_C')

      
      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTOR |
| 21:53:37.318 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1915 | 98.56 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_E_PRE_A^81^FP_AMEND_DAILY_BOR_R^KR_E_PRE_A-20260919-0 |
| 21:53:37.344 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.31 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 21:53:37.448 | find | GSCM.FP_Common | SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE | 727 | 66.23 | MASTER_ID=KR_E_PRE_A |
| 21:53:37.486 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.39 | PROG_ID=find_Prod_Version_Type, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1CTRL_DIVISION_LT
---Service Parameter : 2CTRL_SITE_LT
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---C |
| 21:53:37.503 | find | GSCM.FP_Common | SELECT A.SEGMENT3 AS PRODUCTION_TYPE | 10 | 6.01 | MASTER_ID=KR_E_PRE_A |
| 21:53:37.509 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.85 | PROG_ID=find_versionType, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:53:37.660 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 0 | 142.73 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:53:37.679 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.06 | PROG_ID=find_yieldInfo_ALL, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2AMEND_BOR_TABLE
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client pa |
| 21:53:37.723 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.4 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:53:37.752 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.48 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---C |
| 21:53:37.765 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 4.57 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:53:37.807 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 21:53:37.820 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.36 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:53:37.859 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.55 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:53:37.872 | find | GSCM.FP_Common | SELECT A.* | 28 | 6.5 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:53:37.921 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.72 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:37, END_TIME=2026-11-12 21:53:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215337_865, PARAM_VALUE={AME |
| 21:53:37.926 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.55 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
- |
| 21:53:37.930 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.52 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=WHERE  CAL.DT >= CONVERT(DATETIME, @BUCKET_FROM, 112)
          --    AND    CAL.DT <= CONVERT(DATETIME, @BUCKET_TO, 112)
          --    GROUP BY ISO_YYYYWW
          --) A
          --INNER |
| 21:53:48.644 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 10701.41 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^ |
| 21:53:48.659 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.86 | PROG_ID=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:37, END_TIME=2026-11-12 21:53:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261 |
| 21:53:48.664 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.67 | PROG_ID=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:37, END_TIME=2026-11-12 21:53:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261 |
| 21:53:48.670 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.93 | PROG_ID=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:53:37, END_TIME=2026-11-12 21:53:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261 |
| 21:53:48.675 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.64 | PROG_ID=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name |
| 21:53:48.681 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.29 | PROG_ID=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=_VALUE:D20_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261005#_NAME:2026-10-05 (Mon)#_COUNT:1#_VALUE:D21_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYP |
| 21:53:48.687 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.02 | PROG_ID=PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=chk_outqty_MPP#MEA_VALUE:true#MEA_NAME:MPP(Out)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00598_Amend#!MEA_ID:chk_outqty_MPP_tot#MEA_VALUE:true#MEA_NAME: |
| 21:53:48.818 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.52 | p_menu_id=FP00598, p_log_type=FIND, p_log_cnt=, p_db_time=13.11, p_ui_time=0.117, p_user_id=jaeuk.shin |
| 21:53:54.842 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 56.89 | MenuID=Plan Amend by Model(Elec), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 65(보임 64) · 헤더 2단 · 고정 컬럼 31

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

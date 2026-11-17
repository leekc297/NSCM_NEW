# AS-IS 실측 요약 — FP00595

- 실행: 2026-11-12 21:50:32.388 ~ 2026-11-12 21:51:32.145 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Elec) (GSCM.FP.Planning.UIL.FP00595_Plan_Amend_Line_Elec)
- 조회 결과:  · DB : 22.796s, UI : 0.044s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:50:32.781 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00595 |
| 21:50:32.794 | load | GSCM.FP_Common | SELECT * | 351 | 9.54 | USER_ID= |
| 21:50:33.137 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 342.4 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:50:33.741 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 456.19 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:50:33.744 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.99 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:50:33, END_TIME=2026-11-12 21:50:33, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215033_284, PA |
| 21:50:34.314 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 4.29 | USER_ID=jaeuk.shin, MENU_ID=FP00595_Amend |
| 21:50:36.474 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2160.15 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:50:36.480 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.91 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:50:36.487 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 3.7 | p_program_id=FP00595, p_sheet_name=Amend |
| 21:50:36.575 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 7.13 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 21:50:37.320 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 744.12 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 21:50:39.136 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 1806.67 | LOGTYPE=SpeedUp, NOTE=FP00595
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 21:50:40.955 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1646 | 102417.86 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00411_FIND_FP00411, opt_none=, in_columns=USER_ID^SITE_ID^PLANT_ID^FACTORY_ID^LINE_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB |
| 21:50:41.576 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2440.61 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:50:41.684 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 728.3 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:48:58, END_TIME=2026-11-12 21:50:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214858_535, PARAM_VAL |
| 21:50:42.454 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 858.0 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^Y |
| 21:50:42.454 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 769.89 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:48:58, END_TIME=2026-11-12 21:50:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214858_535, PARAM_VAL |
| 21:50:43.074 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 620.15 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00411_FIND_FP |
| 21:50:43.515 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1061.43 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:50:43.516 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 440.76 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=7CF6_4,FP_M7CF6_5,FP_M7CF6_6,FP_M7CF6_7,FP_S3E01L-1,FP_S3E01L-2,M1C09,M1CF2,M1CP1,M2C06,M2C07,M2C08,M2C09,M2C10,M2C11,M4J61,M4J62,M4J63,M4JA2,M4K45,M4K46,M4K50,M4K69,M4K79,M4K80,M4K81, |
| 21:50:43.526 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 3.12 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 21:50:43.529 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 21:50:43.544 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.15 | LOGTYPE=SpeedUp, NOTE=FP00595
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 21:50:43.548 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.82 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:50:43.645 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 46.15 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^BUCKET_FROM^BUCKET |
| 21:50:43.668 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.57 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 21:50:43.687 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.85 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:50:43.695 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 3.74 | p_program_id=FP00595, p_sheet_name=Amend |
| 21:50:43.704 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:50:43.711 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 3.76 | p_program_id=FP00595, p_sheet_name=Amend |
| 21:50:43.780 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 36.25 | MenuID=Plan Amend by Line(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 21:50:43.843 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00595 |
| 21:50:53.792 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 936.45 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^BUCKET_FROM^BUCKET_TO^DIVIS |
| 21:50:55.002 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1210.25 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:50:59.784 | find | GSCM.FP_Common | SELECT @INSTANCE_ID AS INSTANCE_ID | 1 | 85.8 | INSTANCE_ID=KR_E_PRE_A |
| 21:51:00.638 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 853.1 | PROG_ID=find_isPDS, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client para |
| 21:51:00.744 | find | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 4.43 | INSTANCE_ID=KR_E_PRE_A |
| 21:51:00.816 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.4 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 21:51:00.828 | find | GSCM.FP_Common | SELECT A.INSTANCE_ID, A.FP_PLAN_ID | 0 | 4.53 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:51:00.960 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 131.38 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:00, END_TIME=2026-11-12 21:51:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215100_822, PARAM_VALUE={AMEND_INSTANCE : L |
| 21:51:01.032 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.97 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2BUCKET_FROM
---Service Parameter : 3BUCKET_TO
---Service Parameter : 4CTRL_DIVISION_LT
---Service Parameter : 5CTRL_ |
| 21:51:01.127 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 93.9 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=_BATCH,2)
           		  ELSE ROUND(A.WPP_IN_QTY_BATCH,2) END AS ADJUST_IN_QTY_BATCH
		   , CASE WHEN B.RELEASE_TYPE = 'DPP' THEN CEILING(A.ADJUST_IN_QTY)
           		  WHEN B.RELEASE_TYPE = 'MPP' THEN CEI |
| 21:51:01.549 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 11529 | 380.88 |  |
| 21:51:01.601 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.93 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:01, END_TIME=2026-11-12 21:51:01, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215101_167, PARAM_VALUE={AMEND_INSTANCE : LI |
| 21:51:01.628 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.27 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0CTRL_DIVISION_LT
---Service Parameter : 1CTRL_SITE_LT
---Service Parameter : 2CTRL_PLANT_LT
---Service Parameter : 3CTRL_FACTORY_LT
---Check client parameter : AMEND_INSTANCE
---Check |
| 21:51:01.853 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 223.72 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=-ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
--       , A.MODEL_ID, A.ITEM_ID, A.APPLY_DATE DESC
--       , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE
ORDER BY A.COMPANY_ID |
| 21:51:13.508 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 14103 | 11496.3 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:51:13.564 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.46 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:02, END_TIME=2026-11-12 21:51:13, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215102_009, PARAM_VALUE={AMEND_INSTA |
| 21:51:13.576 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.33 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_LT
---Service Parameter : 4CTRL_PLANT_LT
---Service Parame |
| 21:51:13.583 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.75 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE='E5DP2','FP_E5M01_A','FP_E5M01_C','FP_E5M02_A','FP_E5M02_C','FP_E6M01_A','FP_E6M01_C','FP_E6M02_A','FP_E6M02_C')

      
      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_I |
| 21:51:14.130 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1915 | 309.6 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_E_PRE_A^81^FP_AMEND_DAILY_BOR_R^KR_E_PRE_A-20260919-0 |
| 21:51:14.171 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.15 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 21:51:14.302 | find | GSCM.FP_Common | SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE | 727 | 96.39 | MASTER_ID=KR_E_PRE_A |
| 21:51:14.417 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 114.89 | PROG_ID=find_Prod_Version_Type, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1CTRL_DIVISION_LT
---Service Parameter : 2CTRL_SITE_LT
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---C |
| 21:51:14.503 | find | GSCM.FP_Common | SELECT A.SEGMENT3 AS PRODUCTION_TYPE | 10 | 74.61 | MASTER_ID=KR_E_PRE_A |
| 21:51:14.527 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.83 | PROG_ID=find_versionType, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:51:14.727 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 0 | 193.23 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 21:51:14.818 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 90.13 | PROG_ID=find_yieldInfo_ALL, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2AMEND_BOR_TABLE
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client pa |
| 21:51:14.972 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.58 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:51:15.054 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 81.75 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---C |
| 21:51:15.118 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 56.63 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:15.243 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 124.71 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 21:51:15.489 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 238.12 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:51:15.493 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.41 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 21:51:15.507 | find | GSCM.FP_Common | SELECT A.* | 28 | 7.87 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:51:15.583 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 75.97 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:15, END_TIME=2026-11-12 21:51:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215115_498, PARAM_VALUE={AME |
| 21:51:15.680 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 96.37 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
- |
| 21:51:15.688 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.13 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=ROM, 112)
          --    AND    CAL.DT <= CONVERT(DATETIME, @BUCKET_TO, 112)
          --    GROUP BY ISO_YYYYWW
          --) A
          --INNER JOIN (
          --    SELECT '_QTY' AS POS |
| 21:51:23.191 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 7494.6 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00595_ROW_FIND_FP00595_ROW, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN_ID^PLAN_ |
| 21:51:23.239 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.37 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:15, END_TIME=2026-11-12 21:51:23, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215115_695, P |
| 21:51:23.285 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.96 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:15, END_TIME=2026-11-12 21:51:23, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215115_695, P |
| 21:51:23.363 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.1 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:51:15, END_TIME=2026-11-12 21:51:23, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215115_695, P |
| 21:51:23.428 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.62 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00595 |
| 21:51:23.475 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.24 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261007#_NAME:2026-10-07 (Wed)#_COUNT:1#_VALUE:D23_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261008#_NAME:2026-10- |
| 21:51:23.519 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.32 | PROG_ID=PR_UI_FP00595_ROW_FIND_FP00595_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=tup#MEA_VALUE:true#MEA_NAME:M/C(sec)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00595_Amend#!MEA_ID:chk_sim#MEA_VALUE:true#MEA_NAME:Simulation#TYPE:CATEGORY#FLAG:#USER_ID |
| 21:51:23.620 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 44.22 | p_menu_id=FP00595, p_log_type=FIND, p_log_cnt=, p_db_time=22.796, p_ui_time=0.044, p_user_id=jaeuk.shin |
| 21:51:25.793 | find | GSCM.FP_Common | PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL | 199410 | 255238.87 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_lt=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_lt=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_model=, p_nick_name= |
| 21:51:25.854 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.95 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_lt=N'40,81, |
| 21:51:31.266 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.68 | MenuID=Plan Amend by Line(Elec), CnntCode=0104002, UserID=jaeuk.shin |

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

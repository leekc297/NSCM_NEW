# AS-IS 실측 요약 — FP00634

- 실행: 2026-11-13 04:37:35.847 ~ 2026-11-13 04:42:13.791 · 계정 jaeuk.shin · 상태 OK
- 화면: Tray Simulation (GSCM.FP.Planning.UIL.FP00634_Tray_Simulation)
- 조회 결과:  · DB : 60.704s, UI : 0.011s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "dp_plan_date", "prop": "DateTime", "value": "20260919"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260918"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260917"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260916"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260915"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260914"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260913"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260912"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260911"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260910"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260909"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260908"}, {"name": "chk_rel", "prop": "Checked", "value": "true"}, {"name": "mcbo_division", "check": "0", "only": "1"}, {"name": "mcbo_division", "check": "1", "only": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:37:36.319 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.03 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:37:36.349 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.12 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:37:36, END_TIME=2026-11-13 04:37:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043736_311, PA |
| 04:37:36.422 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.5 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 04:37:36.437 | load | GSCM.FP_Common | SELECT * | 351 | 9.48 | USER_ID= |
| 04:37:36.442 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.9 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:37:36.666 | load | GSCM.FP_Common | SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER | 8 | 128.32 | AMEND_INSTANCE=PSI_AMEND_FORM, USER_ID=jaeuk.shin |
| 04:37:36.672 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.77 | PROG_ID=findInstanceList_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1AMEND_INSTANCE
---Check client parameter : AMEND_INSTANCE
---FOUND AMEND_INSTANCE
-- TYPE = nvarchar---Add string Service
---Che |
| 04:37:36.713 | load | GSCM.FP_Common | SELECT AA.* | 1 | 4.33 | INSTANCE_ID=KR_FORM_A |
| 04:37:36.717 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.96 | PROG_ID=find_isPast, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check client parameter : MASTER_ID
-- |
| 04:37:36.760 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 36.96 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20261112 |
| 04:37:36.765 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.36 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:37:36, END_TIME=2026-11-13 04:37:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043736_723, PARAM_VALUE={AMEN |
| 04:37:36.771 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.71 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:37:36.777 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=
  		AND A.PLAN_ID     = C.PLAN_ID
      WHERE 1=1
     -- AND   A.PLAN_TYPE <> 'RELEASE'
      AND 	CHARINDEX('-00',A.PLAN_ID) = 0
      AND A.INSTANCE_ID='KR_FORM_A' 

	    AND   CONVERT(VAR |
| 04:37:36.798 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.02 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:37:36.833 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.13 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:37:36.987 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 149.67 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:37:36.992 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:37:36, END_TIME=2026-11-13 04:37:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043736_837, PA |
| 04:37:37.009 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.72 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:37:37.014 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:37:37.144 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 124.81 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:37:37.160 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.06 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:37:37, END_TIME=2026-11-13 04:37:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043737_019, PA |
| 04:37:37.784 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 611.3 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 04:37:37.787 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.27 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:37:37, END_TIME=2026-11-13 04:37:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043737_172, PA |
| 04:37:38.181 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 373.27 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=HQ07,HQ08,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, par |
| 04:37:38.186 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.57 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:37:37, END_TIME=2026-11-13 04:37:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043737_807, PA |
| 04:37:38.272 | load | GSCM.FP_Common | SELECT DISTINCT A.OPERATION_ID AS CODE, '(' + A.OPERATION_ID + ')' + B.OPERATION_NAME AS NAME | 1 | 50.92 | SITE_ID=, USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 04:37:38.286 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.37 | PROG_ID=findOperationCode_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1USER_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_ID
---Service Parameter : 4CTRL_AMEND
-- |
| 04:37:38.364 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 16 | 48.65 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 04:37:38.408 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.11 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:37:38, END_TIME=2026-11-13 04:37:38, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043738_312, PARAM_VALUE={AM |
| 04:37:38.441 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.15 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---S |
| 04:37:38.447 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.32 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=07','HQ08','HQ11')

      AND A.FACTORY_ID  IN ('A1','A2','A9','AF','AL','S2')

      AND A.OPERATION_ID  = 'F6000' 
      
      AND EXISTS ( SELECT  1 
             FROM    SCM_SYS_LOOKUP_ |
| 04:40:00.626 | load | GSCM.FP_Common | SELECT DISTINCT A.TOP_ITEM_ID AS CODE_ID, A.TOP_ITEM_ID AS CODE | 28 | 142160.37 | SITE_ID=, MASTER_ID=, PLAN_DATE=20261112, BUCKET_FROM=20261113, BUCKET_TO=20261203, PLAN_ID=, OPERATION_ID=F6000 |
| 04:40:00.658 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.28 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:37:38, END_TIME=2026-11-13 04:40:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113043738_463, PARAM_VALUE={AMEN |
| 04:40:00.704 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.56 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2PLAN_DATE
---Service Parameter : 3SITE_ID
---Service Parameter : 4OPERATION_ID
---Service Parameter :  |
| 04:40:00.711 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.92 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=   WHERE  A.INSTANCE_ID  = @MASTER_ID
          AND    A.FP_PLAN_ID   = @PLAN_ID
          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= @PLAN_DATE
          AND A.DIVISION_ID  IN ('81','82')

   |
| 04:40:01.545 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 817.58 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:01.595 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:00, END_TIME=2026-11-13 04:40:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044000_726, PA |
| 04:40:01.759 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 27 | 139.16 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, opt_none=, in_columns=AMEND_INSTANCE^SITE_ID^USER_ID^INSTANCE_ID^FACTORY_YN^CURR_DATE^PLAN_DATE^BUCKET_FROM^BUCKET_TO^CTRL_INSTANCE_DATE^CTRL_START_TIME^CTRL_INSTANCE^FP_SITE_ID^BASIS_STA |
| 04:40:01.793 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.08 | PROG_ID=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_XPCOMMON_F |
| 04:40:01.830 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.56 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:40:01.891 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 55.98 | p_program_id=FP00634, p_sheet_name=Main |
| 04:40:01.908 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.82 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:40:01.923 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 5.13 | p_program_id=FP00634, p_sheet_name=Main |
| 04:40:02.037 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.36 | MenuID=Tray Simulation, CnntCode=0104001, UserID=jaeuk.shin |
| 04:40:02.089 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 04:40:09.593 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.38 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260919 |
| 04:40:09.619 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.0 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:09, END_TIME=2026-11-13 04:40:09, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044009_588, PARAM_VALUE={AMEN |
| 04:40:09.623 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.03 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:09.646 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.72 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:09.659 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 6.13 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:09.705 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.26 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:09.839 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 121.82 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:09.842 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:09, END_TIME=2026-11-13 04:40:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044009_716, PA |
| 04:40:10.126 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 264.48 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:10.132 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:09, END_TIME=2026-11-13 04:40:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044009_86, PAR |
| 04:40:10.465 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 319.77 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:10.469 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.34 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:10, END_TIME=2026-11-13 04:40:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044010_144, PA |
| 04:40:10.755 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 245.84 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:10.787 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.31 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:11.142 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 317.06 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:11.164 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.8 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:11.729 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 549.52 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:11.791 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 61.6 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:11.845 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 29.93 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:11.849 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:14.408 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 14.6 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260918 |
| 04:40:14.456 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.15 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:14, END_TIME=2026-11-13 04:40:14, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044014_392, PARAM_VALUE={AMEN |
| 04:40:14.504 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.23 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:14.509 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:14.527 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.6 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:14.533 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.4 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:14.670 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 127.04 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:14.683 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.31 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:14, END_TIME=2026-11-13 04:40:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044014_543, PA |
| 04:40:14.951 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 246.83 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:14.994 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:14, END_TIME=2026-11-13 04:40:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044014_704, PA |
| 04:40:15.114 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 95.53 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:15.118 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:15, END_TIME=2026-11-13 04:40:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044015_017, PA |
| 04:40:15.227 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 80.08 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:15.287 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.47 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:15.343 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.86 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:15.369 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.05 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:15.521 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 102.79 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:15.527 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.93 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:15.582 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.51 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:15.606 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:18.308 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 15.06 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260917 |
| 04:40:18.345 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.07 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:18, END_TIME=2026-11-13 04:40:18, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044018_293, PARAM_VALUE={AMEN |
| 04:40:18.361 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.59 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:18.389 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.94 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:18.401 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.65 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:18.405 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:18.528 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 116.09 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:18.531 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:18, END_TIME=2026-11-13 04:40:18, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044018_411, PA |
| 04:40:18.809 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 259.65 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:18.857 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:18, END_TIME=2026-11-13 04:40:18, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044018_549, PA |
| 04:40:18.942 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 62.29 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:18.946 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.04 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:18, END_TIME=2026-11-13 04:40:18, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044018_88, PAR |
| 04:40:19.024 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 56.92 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:19.030 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:19.064 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.33 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:19.097 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:19.206 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 99.66 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:19.241 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:19.263 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.97 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:19.302 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.09 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:22.123 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 16.81 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260916 |
| 04:40:22.152 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.51 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:22, END_TIME=2026-11-13 04:40:22, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044022_103, PARAM_VALUE={AMEN |
| 04:40:22.166 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.21 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:22.171 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:22.203 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.83 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:22.209 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.65 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:22.328 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 109.5 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:22.345 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.76 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:22, END_TIME=2026-11-13 04:40:22, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044022_219, PA |
| 04:40:22.624 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 255.28 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:22.669 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.27 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:22, END_TIME=2026-11-13 04:40:22, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044022_368, PA |
| 04:40:22.755 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.73 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:22.759 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.58 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:22, END_TIME=2026-11-13 04:40:22, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044022_693, PA |
| 04:40:22.850 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 60.26 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:22.882 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.71 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:22.927 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.91 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:22.961 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.1 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:23.084 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.73 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:23.091 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:23.126 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.82 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:23.204 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 77.57 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:25.909 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 15.5 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260915 |
| 04:40:25.934 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.96 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:25, END_TIME=2026-11-13 04:40:25, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044025_891, PARAM_VALUE={AMEN |
| 04:40:25.940 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.71 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:25.964 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.87 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:25.975 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.8 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:26.022 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.04 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:26.159 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 129.44 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:26.162 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.52 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:26, END_TIME=2026-11-13 04:40:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044026_029, PA |
| 04:40:26.431 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 255.78 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:26.486 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:26, END_TIME=2026-11-13 04:40:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044026_175, PA |
| 04:40:26.570 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.94 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:26.573 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:26, END_TIME=2026-11-13 04:40:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044026_507, PA |
| 04:40:26.663 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 57.89 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:26.692 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:26.754 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 28.2 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:26.811 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.1 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:26.946 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 99.75 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:26.952 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:27.006 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.15 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:27.042 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.48 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:29.721 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 16.53 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260914 |
| 04:40:29.746 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.32 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:29, END_TIME=2026-11-13 04:40:29, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044029_703, PARAM_VALUE={AMEN |
| 04:40:29.752 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.74 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:29.808 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.21 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:29.826 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.07 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:29.831 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.02 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:29.955 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 114.74 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:29.960 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:29, END_TIME=2026-11-13 04:40:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044029_841, PA |
| 04:40:30.252 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 268.02 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:30.304 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:29, END_TIME=2026-11-13 04:40:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044029_983, PA |
| 04:40:30.394 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 62.52 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:30.400 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:30, END_TIME=2026-11-13 04:40:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044030_329, PA |
| 04:40:30.497 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 51.95 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:30.531 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.77 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:30.601 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.33 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:30.624 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.4 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:30.757 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 98.21 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:30.794 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:30.874 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 29.05 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:30.904 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:33.573 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 15.04 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260913 |
| 04:40:33.602 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.66 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:33, END_TIME=2026-11-13 04:40:33, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044033_557, PARAM_VALUE={AMEN |
| 04:40:33.622 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.77 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:33.626 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:33.642 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.76 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:33.647 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.9 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:33.784 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 127.84 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:33.796 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.08 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:33, END_TIME=2026-11-13 04:40:33, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044033_655, PA |
| 04:40:34.074 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 250.16 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:34.088 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:33, END_TIME=2026-11-13 04:40:34, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044033_822, PA |
| 04:40:34.158 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 60.13 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:34.162 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:34, END_TIME=2026-11-13 04:40:34, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044034_097, PA |
| 04:40:34.231 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 52.95 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:34.256 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:34.296 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.55 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:34.336 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.48 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:34.455 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.4 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:34.486 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:34.511 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.72 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:34.547 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.01 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:37.229 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 14.97 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260912 |
| 04:40:37.255 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.16 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:37, END_TIME=2026-11-13 04:40:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044037_214, PARAM_VALUE={AMEN |
| 04:40:37.273 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.06 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:37.277 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:37.288 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.36 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:37.311 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.51 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:37.431 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 114.14 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:37.478 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.84 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:37, END_TIME=2026-11-13 04:40:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044037_317, PA |
| 04:40:37.755 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 258.44 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:37.773 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:37, END_TIME=2026-11-13 04:40:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044037_496, PA |
| 04:40:37.858 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.42 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:37.863 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.53 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:37, END_TIME=2026-11-13 04:40:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044037_797, PA |
| 04:40:37.955 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 51.47 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:37.979 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.56 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:38.036 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.59 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:38.064 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.71 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:38.202 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 98.28 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:38.239 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:38.290 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.22 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:38.320 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.34 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:40.855 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 15.11 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260911 |
| 04:40:40.888 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.58 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:40, END_TIME=2026-11-13 04:40:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044040_838, PARAM_VALUE={AMEN |
| 04:40:40.936 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.0 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:40.959 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.16 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:40.973 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.34 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:40.977 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:41.088 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 106.13 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:41.093 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:40, END_TIME=2026-11-13 04:40:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044040_982, PA |
| 04:40:41.369 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 264.38 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:41.376 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.56 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:41, END_TIME=2026-11-13 04:40:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044041_104, PA |
| 04:40:41.445 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 59.74 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:41.449 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:41, END_TIME=2026-11-13 04:40:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044041_385, PA |
| 04:40:41.529 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 53.78 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:41.534 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.28 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:41.567 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.63 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:41.597 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:41.721 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 98.07 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:41.749 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.11 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:41.792 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.98 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:41.835 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.63 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:44.669 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 16.67 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260910 |
| 04:40:44.696 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.08 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:44, END_TIME=2026-11-13 04:40:44, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044044_65, PARAM_VALUE={AMEND |
| 04:40:44.713 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.37 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:44.718 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:44.730 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.42 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:44.735 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.26 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:44.872 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 126.52 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:44.883 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.2 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:44, END_TIME=2026-11-13 04:40:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044044_745, PA |
| 04:40:45.131 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 221.65 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:45.136 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:44, END_TIME=2026-11-13 04:40:45, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044044_908, PA |
| 04:40:45.225 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 62.05 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:45.231 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:45, END_TIME=2026-11-13 04:40:45, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044045_162, PA |
| 04:40:45.319 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 52.12 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:45.346 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.51 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:45.390 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.69 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:45.429 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.25 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:45.554 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 100.43 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:45.587 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.66 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:45.615 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.84 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:45.638 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.51 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:48.479 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 17.54 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260909 |
| 04:40:48.513 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.7 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:48, END_TIME=2026-11-13 04:40:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044048_455, PARAM_VALUE={AMEN |
| 04:40:48.532 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.61 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:48.537 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.47 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:48.555 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.47 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:48.561 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.92 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:48.702 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 131.38 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:48.752 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:48, END_TIME=2026-11-13 04:40:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044048_57, PAR |
| 04:40:49.037 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 266.46 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:49.048 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.8 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:48, END_TIME=2026-11-13 04:40:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044048_769, PA |
| 04:40:49.122 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 63.34 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:49.127 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.47 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:49, END_TIME=2026-11-13 04:40:49, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044049_058, PA |
| 04:40:49.208 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 52.47 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:49.246 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:49.293 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.16 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:49.323 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:49.441 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 99.35 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:49.446 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.45 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:49.472 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.65 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:49.516 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:40:52.373 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 15.64 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260908 |
| 04:40:52.395 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.01 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:40:52, END_TIME=2026-11-13 04:40:52, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044052_356, PARAM_VALUE={AMEN |
| 04:40:52.402 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.8 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:40:52.450 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.84 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:40:52.469 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.35 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:40:52.474 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.14 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:40:52.593 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 109.78 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:40:52.597 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:52, END_TIME=2026-11-13 04:40:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044052_483, PA |
| 04:40:52.886 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 267.04 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:40:52.905 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.29 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:52, END_TIME=2026-11-13 04:40:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044052_62, PAR |
| 04:40:52.991 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.34 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:40:52.996 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:40:52, END_TIME=2026-11-13 04:40:52, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044052_928, PA |
| 04:40:53.092 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 53.95 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:53.098 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.88 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:40:53.161 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.16 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:53.196 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.04 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:40:53.307 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.25 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:40:53.333 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:40:53.365 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.95 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:40:53.369 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:41:06.662 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.04 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:41:06.670 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.65 | p_program_id=FP00634, p_sheet_name=Main |
| 04:41:06.676 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:41:06.683 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.39 | p_program_id=FP00634, p_sheet_name=Main |
| 04:41:06.704 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 5.88 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20261113, param2=20261203, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:41:06.747 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.52 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20261113',@param2=N'20261203',@param3=N'',@param4=N'',@ |
| 04:41:06.777 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 14.07 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261113, param3=20261203, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:41:06.803 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.04 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261113',@param3=N'20261203',@param4=N |
| 04:41:06.828 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 5.85 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:41:06.832 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.33 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 04:41:06.846 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 21 | 6.07 | PLAN_DATE=20260908, BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:41:06.889 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.69 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Chec |
| 04:41:06.908 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.25 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:41:06.946 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.54 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---C |
| 04:41:06.968 | find | GSCM.FP_Common | SELECT A.* | 21 | 7.33 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:41:07.019 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.61 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:41:06, END_TIME=2026-11-13 04:41:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044106_957, PARAM_VALUE={AMEND_I |
| 04:41:07.030 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.63 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 04:41:07.034 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=POSTFIX, 100 AS POST_ORDER
          --) B
          --ON     1=1
      ) A
      ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = 'W' THEN 1 ELSE 2 END), _DATE, POST_ORDER
    
      , JOB_TYPE=read, START |
| 04:42:07.346 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 60302.94 | p_sys_type=SELECT, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00634_FIND_FP00634, opt_none=, in_columns=AMEND_INSTANCE^SITE_ID^USER_ID^INSTANCE_ID^FACTORY_YN^CURR_DATE^PLAN_DATE^BUCKET_FROM^BUCKET_TO^CTRL_INSTANCE_DATE^CTRL_START_TIME^CTRL_INSTANCE^FP_SITE_ID^PLAN_TYPE^BASI |
| 04:42:07.368 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.1 | PROG_ID=PR_UI_FP00634_FIND_FP00634, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:41:07, END_TIME=2026-11-13 04:42:07, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113044107_042, PARAM_VALU |
| 04:42:07.375 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.79 | PROG_ID=PR_UI_FP00634_FIND_FP00634, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00634_FIND_FP00 |
| 04:42:07.380 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=PR_UI_FP00634_FIND_FP00634, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=#!VALUE:20261130#!VALUE:20261201#!VALUE:20261202#!VALUE:20261203#^N^', JOB_TYPE=read, START_TIME=2026-11-13 04:41:07, END_TIME=2026-11-13 04:42:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, I |
| 04:42:07.431 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.85 | p_menu_id=FP00634, p_log_type=FIND, p_log_cnt=, p_db_time=60.704, p_ui_time=0.011, p_user_id=jaeuk.shin |
| 04:42:13.093 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.77 | MenuID=Tray Simulation, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Period | rp_plan_period |  |
| lblSql | btnSql |  |
| Div | mcbo_division |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| layoutControlItem2 | chk_rel |  |
| layoutControlItem11 | chk_all_line |  |
| Group Tray ID | txt_group_id |  |
| Plan Group | cbo_plan_group |  |
| Site | cbo_site |  |
| Plan Date | dp_plan_date |  |
| FP Plan ID | cbo_fpplanid |  |
| layoutControlItem9 | chk_sub_op |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 23(보임 22) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

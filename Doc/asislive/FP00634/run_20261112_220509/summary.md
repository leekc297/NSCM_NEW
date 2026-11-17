# AS-IS 실측 요약 — FP00634

- 실행: 2026-11-12 22:05:09.662 ~ 2026-11-12 22:06:10.517 · 계정 jaeuk.shin · 상태 OK
- 화면: Tray Simulation (GSCM.FP.Planning.UIL.FP00634_Tray_Simulation)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "dp_plan_date", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:05:10.007 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 28.8 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:05:10.011 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:09, END_TIME=2026-11-12 22:05:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220509_977, PA |
| 22:05:10.101 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 22:05:10.116 | load | GSCM.FP_Common | SELECT * | 351 | 11.1 | USER_ID= |
| 22:05:10.120 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:05:10.378 | load | GSCM.FP_Common | SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER | 8 | 143.85 | AMEND_INSTANCE=PSI_AMEND_FORM, USER_ID=jaeuk.shin |
| 22:05:10.384 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.55 | PROG_ID=findInstanceList_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1AMEND_INSTANCE
---Check client parameter : AMEND_INSTANCE
---FOUND AMEND_INSTANCE
-- TYPE = nvarchar---Add string Service
---Che |
| 22:05:10.413 | load | GSCM.FP_Common | SELECT AA.* | 1 | 4.29 | INSTANCE_ID=KR_FORM_A |
| 22:05:10.443 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.27 | PROG_ID=find_isPast, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check client parameter : MASTER_ID
-- |
| 22:05:10.453 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.74 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20261112 |
| 22:05:10.485 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.89 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:05:10, END_TIME=2026-11-12 22:05:10, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220510_448, PARAM_VALUE={AMEN |
| 22:05:10.490 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 22:05:10.496 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.82 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=
  		AND A.PLAN_ID     = C.PLAN_ID
      WHERE 1=1
     -- AND   A.PLAN_TYPE <> 'RELEASE'
      AND 	CHARINDEX('-00',A.PLAN_ID) = 0
      AND A.INSTANCE_ID='KR_FORM_A' 

	    AND   CONVERT(VAR |
| 22:05:10.507 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.87 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 22:05:10.511 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.36 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 22:05:10.632 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 115.22 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 22:05:10.636 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.15 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:10, END_TIME=2026-11-12 22:05:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220510_516, PA |
| 22:05:10.655 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.46 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 22:05:10.731 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 76.53 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 22:05:10.845 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 109.05 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 22:05:10.848 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.06 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:10, END_TIME=2026-11-12 22:05:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220510_735, PA |
| 22:05:11.326 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 468.06 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 22:05:11.329 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.88 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:10, END_TIME=2026-11-12 22:05:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220510_858, PA |
| 22:05:11.700 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 360.12 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=HQ07,HQ08,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, par |
| 22:05:11.733 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.37 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:11, END_TIME=2026-11-12 22:05:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220511_339, PA |
| 22:05:11.808 | load | GSCM.FP_Common | SELECT DISTINCT A.OPERATION_ID AS CODE, '(' + A.OPERATION_ID + ')' + B.OPERATION_NAME AS NAME | 1 | 43.23 | SITE_ID=, USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 22:05:11.851 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.1 | PROG_ID=findOperationCode_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1USER_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_ID
---Service Parameter : 4CTRL_AMEND
-- |
| 22:05:11.915 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 16 | 44.64 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 22:05:11.976 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.95 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:05:11, END_TIME=2026-11-12 22:05:11, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220511_869, PARAM_VALUE={AM |
| 22:05:11.995 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.39 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---S |
| 22:05:12.029 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.79 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=07','HQ08','HQ11')

      AND A.FACTORY_ID  IN ('A1','A2','A9','AF','AL','S2')

      AND A.OPERATION_ID  = 'F6000' 
      
      AND EXISTS ( SELECT  1 
             FROM    SCM_SYS_LOOKUP_ |
| 22:05:38.337 | load | GSCM.FP_Common | SELECT DISTINCT A.TOP_ITEM_ID AS CODE_ID, A.TOP_ITEM_ID AS CODE | 28 | 26296.17 | SITE_ID=, MASTER_ID=, PLAN_DATE=20261112, BUCKET_FROM=20261112, BUCKET_TO=20261202, PLAN_ID=, OPERATION_ID=F6000 |
| 22:05:38.362 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.27 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:05:12, END_TIME=2026-11-12 22:05:38, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220512_039, PARAM_VALUE={AMEN |
| 22:05:38.367 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.32 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2PLAN_DATE
---Service Parameter : 3SITE_ID
---Service Parameter : 4OPERATION_ID
---Service Parameter :  |
| 22:05:38.408 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.37 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=   WHERE  A.INSTANCE_ID  = @MASTER_ID
          AND    A.FP_PLAN_ID   = @PLAN_ID
          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= @PLAN_DATE
          AND A.DIVISION_ID  IN ('81','82')

   |
| 22:05:39.063 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 648.78 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:05:39.066 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:38, END_TIME=2026-11-12 22:05:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220538_414, PA |
| 22:05:39.266 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 27 | 183.03 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, opt_none=, in_columns=AMEND_INSTANCE^SITE_ID^USER_ID^INSTANCE_ID^FACTORY_YN^CURR_DATE^PLAN_DATE^BUCKET_FROM^BUCKET_TO^CTRL_INSTANCE_DATE^CTRL_START_TIME^CTRL_INSTANCE^FP_SITE_ID^BASIS_STA |
| 22:05:39.271 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.47 | PROG_ID=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_XPCOMMON_F |
| 22:05:39.282 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.91 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:05:39.290 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.43 | p_program_id=FP00634, p_sheet_name=Main |
| 22:05:39.297 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.97 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:05:39.305 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.88 | p_program_id=FP00634, p_sheet_name=Main |
| 22:05:39.408 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 82.61 | MenuID=Tray Simulation, CnntCode=0104001, UserID=jaeuk.shin |
| 22:05:39.561 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 22:05:48.111 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 14.66 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260919 |
| 22:05:48.143 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.49 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:05:48, END_TIME=2026-11-12 22:05:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220548_095, PARAM_VALUE={AMEN |
| 22:05:48.149 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.89 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 22:05:48.172 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.96 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 22:05:48.185 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 6.62 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 22:05:48.189 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.38 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 22:05:48.304 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 110.17 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 22:05:48.308 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.97 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:48, END_TIME=2026-11-12 22:05:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220548_194, PA |
| 22:05:48.558 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 239.39 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:05:48.571 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.39 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:48, END_TIME=2026-11-12 22:05:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220548_318, PA |
| 22:05:48.900 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 317.3 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 22:05:48.903 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:05:48, END_TIME=2026-11-12 22:05:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220548_582, PA |
| 22:05:49.186 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 268.35 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:05:49.205 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.11 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 22:05:49.532 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 317.17 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:05:49.556 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.84 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 22:05:50.107 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 543.11 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 22:05:50.125 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.02 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 22:05:50.142 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.89 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:05:50.182 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:05:55.413 | find | GSCM.FP_Common | SELECT A.* | 0 | 269.1 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 22:05:55.436 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.66 | PROG_ID=chk_PlanId, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check  |
| 22:05:55.513 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.41 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:05:55.523 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.17 | p_program_id=FP00634, p_sheet_name=Main |
| 22:05:55.531 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.0 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:05:55.537 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.76 | p_program_id=FP00634, p_sheet_name=Main |
| 22:05:55.565 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 5.62 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:05:55.600 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.54 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@ |
| 22:05:55.620 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 13.7 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:05:55.625 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.84 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'20261202',@param4=N |
| 22:05:55.637 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 5.51 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 22:05:55.641 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.79 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 22:05:55.653 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 21 | 5.35 | PLAN_DATE=20260919, BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 22:05:55.680 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.77 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Chec |
| 22:05:55.692 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 5.99 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 22:05:55.749 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.93 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---C |
| 22:05:55.762 | find | GSCM.FP_Common | SELECT A.* | 21 | 7.34 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 22:05:55.799 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.41 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:05:55, END_TIME=2026-11-12 22:05:55, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220555_754, PARAM_VALUE={AMEND_I |
| 22:05:55.803 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 22:05:55.822 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.27 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=STFIX, 100 AS POST_ORDER
          --) B
          --ON     1=1
      ) A
      ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = 'W' THEN 1 ELSE 2 END), _DATE, POST_ORDER
    
      , JOB_TYPE=read, START_T |

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

## 대화상자

- 2026-11-12 22:05:56.260 [] FP Plan ID is required → default_button(id=1)

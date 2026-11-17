# AS-IS 실측 요약 — FP00634

- 실행: 2026-11-13 04:52:35.868 ~ 2026-11-13 04:54:22.081 · 계정 jaeuk.shin · 상태 OK
- 화면: Tray Simulation (GSCM.FP.Planning.UIL.FP00634_Tray_Simulation)
- 조회 결과:  · DB : 15.866s, UI : 0.001s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "dp_plan_date", "prop": "DateTime", "value": "20260919"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260918"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260917"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260916"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260915"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260914"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260913"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260912"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260911"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260910"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260909"}, {"name": "dp_plan_date", "prop": "DateTime", "value": "20260908"}, {"name": "chk_rel", "prop": "Checked", "value": "true"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:52:36.125 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.13 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:52:36.128 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:52:36, END_TIME=2026-11-13 04:52:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045236_117, PA |
| 04:52:36.189 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 04:52:36.203 | load | GSCM.FP_Common | SELECT * | 351 | 9.7 | USER_ID= |
| 04:52:36.230 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.6 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:52:36.471 | load | GSCM.FP_Common | SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER | 8 | 127.04 | AMEND_INSTANCE=PSI_AMEND_FORM, USER_ID=jaeuk.shin |
| 04:52:36.476 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.96 | PROG_ID=findInstanceList_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1AMEND_INSTANCE
---Check client parameter : AMEND_INSTANCE
---FOUND AMEND_INSTANCE
-- TYPE = nvarchar---Add string Service
---Che |
| 04:52:36.506 | load | GSCM.FP_Common | SELECT AA.* | 1 | 3.75 | INSTANCE_ID=KR_FORM_A |
| 04:52:36.530 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.56 | PROG_ID=find_isPast, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check client parameter : MASTER_ID
-- |
| 04:52:36.541 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.56 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20261112 |
| 04:52:36.548 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.94 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:52:36, END_TIME=2026-11-13 04:52:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045236_536, PARAM_VALUE={AMEN |
| 04:52:36.553 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.92 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:52:36.557 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.82 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=
  		AND A.PLAN_ID     = C.PLAN_ID
      WHERE 1=1
     -- AND   A.PLAN_TYPE <> 'RELEASE'
      AND 	CHARINDEX('-00',A.PLAN_ID) = 0
      AND A.INSTANCE_ID='KR_FORM_A' 

	    AND   CONVERT(VAR |
| 04:52:36.572 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.09 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:52:36.600 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.97 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:52:36.719 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 114.18 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:52:36.723 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:52:36, END_TIME=2026-11-13 04:52:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045236_605, PA |
| 04:52:36.738 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.21 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:52:36.788 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.33 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:52:36.918 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 124.46 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:52:36.922 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:52:36, END_TIME=2026-11-13 04:52:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045236_793, PA |
| 04:52:36.985 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 53.74 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 04:52:36.988 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.01 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:52:36, END_TIME=2026-11-13 04:52:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045236_931, PA |
| 04:52:37.102 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 92.43 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=HQ07,HQ08,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, par |
| 04:52:37.105 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:52:37, END_TIME=2026-11-13 04:52:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045237_008, PA |
| 04:52:37.194 | load | GSCM.FP_Common | SELECT DISTINCT A.OPERATION_ID AS CODE, '(' + A.OPERATION_ID + ')' + B.OPERATION_NAME AS NAME | 1 | 52.93 | SITE_ID=, USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 04:52:37.199 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.58 | PROG_ID=findOperationCode_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1USER_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_ID
---Service Parameter : 4CTRL_AMEND
-- |
| 04:52:37.270 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 16 | 48.16 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 04:52:37.276 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.44 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:52:37, END_TIME=2026-11-13 04:52:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045237_22, PARAM_VALUE={AME |
| 04:52:37.282 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.49 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---S |
| 04:52:37.321 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.28 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=07','HQ08','HQ11')

      AND A.FACTORY_ID  IN ('A1','A2','A9','AF','AL','S2')

      AND A.OPERATION_ID  = 'F6000' 
      
      AND EXISTS ( SELECT  1 
             FROM    SCM_SYS_LOOKUP_ |
| 04:53:00.400 | load | GSCM.FP_Common | SELECT DISTINCT A.TOP_ITEM_ID AS CODE_ID, A.TOP_ITEM_ID AS CODE | 28 | 23052.93 | SITE_ID=, MASTER_ID=, PLAN_DATE=20261112, BUCKET_FROM=20261113, BUCKET_TO=20261203, PLAN_ID=, OPERATION_ID=F6000 |
| 04:53:00.468 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 67.28 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:52:37, END_TIME=2026-11-13 04:53:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045237_344, PARAM_VALUE={AMEN |
| 04:53:00.537 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 68.46 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2PLAN_DATE
---Service Parameter : 3SITE_ID
---Service Parameter : 4OPERATION_ID
---Service Parameter :  |
| 04:53:00.542 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.64 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=   WHERE  A.INSTANCE_ID  = @MASTER_ID
          AND    A.FP_PLAN_ID   = @PLAN_ID
          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= @PLAN_DATE
          AND A.DIVISION_ID  IN ('81','82')

   |
| 04:53:00.811 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 263.32 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:00.880 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 67.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:00, END_TIME=2026-11-13 04:53:00, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045300_547, PA |
| 04:53:00.956 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 27 | 16.9 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, opt_none=, in_columns=AMEND_INSTANCE^SITE_ID^USER_ID^INSTANCE_ID^FACTORY_YN^CURR_DATE^PLAN_DATE^BUCKET_FROM^BUCKET_TO^CTRL_INSTANCE_DATE^CTRL_START_TIME^CTRL_INSTANCE^FP_SITE_ID^BASIS_STA |
| 04:53:00.966 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.95 | PROG_ID=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_XPCOMMON_F |
| 04:53:01.019 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 31.16 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:53:01.028 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.74 | p_program_id=FP00634, p_sheet_name=Main |
| 04:53:01.039 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.82 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:53:01.090 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 44.47 | p_program_id=FP00634, p_sheet_name=Main |
| 04:53:01.223 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 76.97 | MenuID=Tray Simulation, CnntCode=0104001, UserID=jaeuk.shin |
| 04:53:01.368 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 04:53:09.642 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.59 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260919 |
| 04:53:09.669 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.64 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:09, END_TIME=2026-11-13 04:53:09, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045309_636, PARAM_VALUE={AMEN |
| 04:53:09.676 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.04 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:09.745 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 67.9 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:09.783 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 13.67 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:09.789 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.97 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:09.907 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 111.62 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:09.927 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.47 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:09, END_TIME=2026-11-13 04:53:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045309_795, PA |
| 04:53:10.186 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 241.51 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:10.190 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.46 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:09, END_TIME=2026-11-13 04:53:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045309_945, PA |
| 04:53:10.279 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 63.9 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:10.283 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.85 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:10, END_TIME=2026-11-13 04:53:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045310_214, PA |
| 04:53:10.377 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 74.95 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:10.416 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.07 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:10.465 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 22.07 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:10.471 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:10.606 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 98.45 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:10.631 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.23 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:10.655 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.37 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:10.687 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.75 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:13.510 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.15 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260918 |
| 04:53:13.514 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:13, END_TIME=2026-11-13 04:53:13, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045313_505, PARAM_VALUE={AMEN |
| 04:53:13.519 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.55 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:13.546 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.42 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:13.555 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.07 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:13.604 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.51 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:13.735 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 124.87 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:13.751 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.44 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:13, END_TIME=2026-11-13 04:53:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045313_609, PA |
| 04:53:14.033 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 270.99 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:14.046 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.6 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:13, END_TIME=2026-11-13 04:53:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045313_761, PA |
| 04:53:14.119 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 63.62 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:14.122 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.14 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:14, END_TIME=2026-11-13 04:53:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045314_055, PA |
| 04:53:14.199 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 61.8 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:14.234 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.83 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:14.269 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.19 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:14.293 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:14.401 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.31 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:14.436 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.6 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:14.456 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.49 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:14.493 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.56 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:17.122 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 3.97 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260917 |
| 04:53:17.148 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.75 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:17, END_TIME=2026-11-13 04:53:17, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045317_116, PARAM_VALUE={AMEN |
| 04:53:17.164 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.2 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:17.168 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.7 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:17.179 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.17 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:17.183 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.91 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:17.309 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 120.41 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:17.324 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:17, END_TIME=2026-11-13 04:53:17, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045317_187, PA |
| 04:53:17.555 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 220.67 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:17.559 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:17, END_TIME=2026-11-13 04:53:17, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045317_334, PA |
| 04:53:17.630 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 60.26 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:17.633 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.17 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:17, END_TIME=2026-11-13 04:53:17, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045317_569, PA |
| 04:53:17.714 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 54.06 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:17.755 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.77 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:17.790 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 20.7 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:17.821 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.58 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:17.936 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 104.18 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:17.963 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.63 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:17.981 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.22 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:18.025 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.07 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:20.721 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 5.45 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260916 |
| 04:53:20.747 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.27 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:20, END_TIME=2026-11-13 04:53:20, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045320_712, PARAM_VALUE={AMEN |
| 04:53:20.804 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.44 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:20.878 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 73.25 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:20.893 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.77 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:20.898 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:21.017 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 113.51 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:21.021 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.52 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:20, END_TIME=2026-11-13 04:53:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045320_903, PA |
| 04:53:21.305 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 257.54 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:21.365 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:21, END_TIME=2026-11-13 04:53:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045321_047, PA |
| 04:53:21.450 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.65 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:21.454 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:21, END_TIME=2026-11-13 04:53:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045321_387, PA |
| 04:53:21.549 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 53.26 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:21.581 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.42 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:21.619 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.79 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:21.657 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.98 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:21.784 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.69 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:21.822 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.86 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:21.863 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.88 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:21.889 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.03 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:24.695 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.73 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260915 |
| 04:53:24.700 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.14 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:24, END_TIME=2026-11-13 04:53:24, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045324_689, PARAM_VALUE={AMEN |
| 04:53:24.705 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.58 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:24.737 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.51 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:24.746 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.48 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:24.751 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.44 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:24.867 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 111.04 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:24.870 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:24, END_TIME=2026-11-13 04:53:24, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045324_755, PA |
| 04:53:25.141 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 259.79 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:25.158 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:24, END_TIME=2026-11-13 04:53:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045324_882, PA |
| 04:53:25.230 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 60.29 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:25.234 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:25, END_TIME=2026-11-13 04:53:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045325_17, PAR |
| 04:53:25.306 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 58.29 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:25.342 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.23 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:25.375 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.06 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:25.401 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.33 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:25.510 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.67 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:25.542 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.75 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:25.564 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.39 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:25.597 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.81 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:28.228 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.37 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260914 |
| 04:53:28.265 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.96 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:28, END_TIME=2026-11-13 04:53:28, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045328_222, PARAM_VALUE={AMEN |
| 04:53:28.282 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.68 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:28.287 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.64 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:28.311 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.8 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:28.352 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.24 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:28.484 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 126.64 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:28.500 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.37 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:28, END_TIME=2026-11-13 04:53:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045328_358, PA |
| 04:53:28.759 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 245.91 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:28.778 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:28, END_TIME=2026-11-13 04:53:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045328_513, PA |
| 04:53:28.856 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 62.07 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:28.859 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.96 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:28, END_TIME=2026-11-13 04:53:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045328_793, PA |
| 04:53:28.935 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 55.42 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:28.968 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.93 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:29.003 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.5 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:29.043 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:29.149 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.04 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:29.175 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.2 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:29.224 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.07 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:29.255 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.82 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:31.927 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 5.41 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260913 |
| 04:53:31.958 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.73 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:31, END_TIME=2026-11-13 04:53:31, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045331_919, PARAM_VALUE={AMEN |
| 04:53:31.977 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.43 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:31.982 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:31.992 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.36 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:31.997 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.09 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:32.146 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 142.79 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:32.180 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:32, END_TIME=2026-11-13 04:53:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045332_002, PA |
| 04:53:32.457 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 259.81 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:32.475 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:32, END_TIME=2026-11-13 04:53:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045332_197, PA |
| 04:53:32.561 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 63.79 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:32.565 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:32, END_TIME=2026-11-13 04:53:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045332_495, PA |
| 04:53:32.651 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 54.7 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:32.657 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.3 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:32.701 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 28.22 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:32.736 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.87 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:32.860 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 99.38 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:32.885 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.17 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:32.920 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.5 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:32.962 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.66 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:35.801 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.86 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260912 |
| 04:53:35.824 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.46 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:35, END_TIME=2026-11-13 04:53:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045335_794, PARAM_VALUE={AMEN |
| 04:53:35.829 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.61 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:35.847 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.12 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:35.861 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.69 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:35.865 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.45 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:35.987 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 114.73 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:35.992 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.13 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:35, END_TIME=2026-11-13 04:53:35, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045335_872, PA |
| 04:53:36.277 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 262.1 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:36.293 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:36, END_TIME=2026-11-13 04:53:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045336_014, PA |
| 04:53:36.380 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 63.2 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:36.384 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.03 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:36, END_TIME=2026-11-13 04:53:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045336_316, PA |
| 04:53:36.464 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 54.64 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:36.490 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.52 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:36.525 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.77 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:36.549 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.1 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:36.660 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.44 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:36.683 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:36.703 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.42 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:36.747 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.05 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:39.408 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.58 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260911 |
| 04:53:39.435 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.95 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:39, END_TIME=2026-11-13 04:53:39, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045339_4, PARAM_VALUE={AMEND_ |
| 04:53:39.453 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.31 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:39.471 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.77 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:39.493 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.99 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:39.534 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.71 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:39.654 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 113.44 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:39.658 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:39, END_TIME=2026-11-13 04:53:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045339_54, PAR |
| 04:53:39.934 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 252.53 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:39.994 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:39, END_TIME=2026-11-13 04:53:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045339_681, PA |
| 04:53:40.080 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.3 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:40.085 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:40, END_TIME=2026-11-13 04:53:40, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045340_018, PA |
| 04:53:40.250 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 52.31 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:40.256 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.9 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:40.294 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 28.72 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:40.319 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.27 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:40.441 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 99.08 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:40.469 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.94 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:40.487 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 4.14 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:40.523 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.69 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:43.488 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 4.92 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260910 |
| 04:53:43.514 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.41 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:43, END_TIME=2026-11-13 04:53:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045343_483, PARAM_VALUE={AMEN |
| 04:53:43.522 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.44 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:43.536 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.44 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:43.558 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.07 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:43.598 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.88 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:43.707 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 103.65 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:43.711 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.38 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:43, END_TIME=2026-11-13 04:53:43, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045343_604, PA |
| 04:53:43.975 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 242.31 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:43.985 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.1 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:43, END_TIME=2026-11-13 04:53:43, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045343_731, PA |
| 04:53:44.071 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.08 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:44.075 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:44, END_TIME=2026-11-13 04:53:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045344_009, PA |
| 04:53:44.168 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 61.92 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:44.191 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:44.241 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.47 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:44.265 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.68 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:44.387 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.49 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:44.391 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.34 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:44.422 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 11.97 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:44.459 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.65 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:47.430 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 5.5 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260909 |
| 04:53:47.451 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.62 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:47, END_TIME=2026-11-13 04:53:47, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045347_422, PARAM_VALUE={AMEN |
| 04:53:47.455 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.75 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:47.534 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 78.58 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:47.556 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.81 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:47.567 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.67 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:47.691 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 113.55 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:47.707 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.49 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:47, END_TIME=2026-11-13 04:53:47, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045347_576, PA |
| 04:53:47.947 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 222.41 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:47.951 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.39 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:47, END_TIME=2026-11-13 04:53:47, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045347_725, PA |
| 04:53:48.036 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 61.54 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:48.041 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:47, END_TIME=2026-11-13 04:53:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045347_974, PA |
| 04:53:48.131 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 62.93 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:48.168 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.99 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:48.211 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 21.83 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:48.247 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.21 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:48.370 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 97.83 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:48.396 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.71 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:48.434 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.16 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:48.453 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.8 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:51.250 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 5.55 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20260908 |
| 04:53:51.255 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.3 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:53:51, END_TIME=2026-11-13 04:53:51, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045351_243, PARAM_VALUE={AMEN |
| 04:53:51.260 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.72 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 04:53:51.292 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.43 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=TANCE_ID
            ,A.SITE_ID
            ,A.DESCRIPTION
            ,A.PLAN_TYPE
            ,CASE WHEN A.RELEASE_FLAG = 'Y' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID
             |
| 04:53:51.313 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.26 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 04:53:51.319 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.63 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 04:53:51.445 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 113.89 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 04:53:51.449 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:51, END_TIME=2026-11-13 04:53:51, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045351_331, PA |
| 04:53:51.778 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 304.16 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:53:51.818 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.52 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:51, END_TIME=2026-11-13 04:53:51, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045351_473, PA |
| 04:53:51.904 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 66.38 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=A001, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param2 |
| 04:53:51.907 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.16 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:53:51, END_TIME=2026-11-13 04:53:51, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045351_837, PA |
| 04:53:52.003 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 6 | 65.78 | p_code=FP00594_findFactoryCode_amend_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:52.032 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.0 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFactoryCode_amend_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@ |
| 04:53:52.094 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 28.13 | p_code=FP00594_findOperationCode_common, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=81,82, param3=A001, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:52.121 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.64 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findOperationCode_common',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'81,82',@param3=N'A001',@param4= |
| 04:53:52.252 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 15 | 102.98 | p_code=FP00603_findLineCode_List, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=A001, param7=HQ07,HQ08,HQ11, param8=A1,A2,A9,AF,AL,S2, param9=F6000, param10=N, param11=Y, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20 |
| 04:53:52.283 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.65 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_findLineCode_List',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'81 |
| 04:53:52.321 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 12 | 5.22 | p_code=FP00603_find_FPProdType, p_user_id=jaeuk.shin, param1=, param2=81,82, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:53:52.361 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.23 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_FPProdType',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'81,82',@param3=N'',@param4=N'',@param5=N'',@param |
| 04:53:59.987 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.29 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:53:59.995 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 5.37 | p_program_id=FP00634, p_sheet_name=Main |
| 04:54:00.002 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:54:00.009 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.29 | p_program_id=FP00634, p_sheet_name=Main |
| 04:54:00.028 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 4.18 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20261113, param2=20261203, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:54:00.032 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20261113',@param2=N'20261203',@param3=N'',@param4=N'',@ |
| 04:54:00.060 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 21.23 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261113, param3=20261203, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 04:54:00.114 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.18 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261113',@param3=N'20261203',@param4=N |
| 04:54:00.147 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 4.15 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:54:00.151 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.87 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 04:54:00.171 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 21 | 8.16 | PLAN_DATE=20260908, BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:54:00.192 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.94 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Chec |
| 04:54:00.216 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 7.0 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:54:00.251 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.07 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---C |
| 04:54:00.261 | find | GSCM.FP_Common | SELECT A.* | 21 | 3.58 | BUCKET_FROM=20261113, BUCKET_TO=20261203 |
| 04:54:00.305 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.06 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:54:00, END_TIME=2026-11-13 04:54:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045400_257, PARAM_VALUE={AMEND_I |
| 04:54:00.312 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.87 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 04:54:00.332 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.3 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=POSTFIX, 100 AS POST_ORDER
          --) B
          --ON     1=1
      ) A
      ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = 'W' THEN 1 ELSE 2 END), _DATE, POST_ORDER
    
      , JOB_TYPE=read, START |
| 04:54:15.810 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 15471.99 | p_sys_type=SELECT, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00634_FIND_FP00634, opt_none=, in_columns=AMEND_INSTANCE^SITE_ID^USER_ID^INSTANCE_ID^FACTORY_YN^CURR_DATE^PLAN_DATE^BUCKET_FROM^BUCKET_TO^CTRL_INSTANCE_DATE^CTRL_START_TIME^CTRL_INSTANCE^FP_SITE_ID^PLAN_TYPE^BASI |
| 04:54:15.861 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.91 | PROG_ID=PR_UI_FP00634_FIND_FP00634, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:54:00, END_TIME=2026-11-13 04:54:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045400_337, PARAM_VALU |
| 04:54:15.867 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.14 | PROG_ID=PR_UI_FP00634_FIND_FP00634, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00634_FIND_FP00 |
| 04:54:15.871 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.01 | PROG_ID=PR_UI_FP00634_FIND_FP00634, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=#!VALUE:20261130#!VALUE:20261201#!VALUE:20261202#!VALUE:20261203#^N^', JOB_TYPE=read, START_TIME=2026-11-13 04:54:00, END_TIME=2026-11-13 04:54:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, I |
| 04:54:15.900 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.86 | p_menu_id=FP00634, p_log_type=FIND, p_log_cnt=, p_db_time=15.866, p_ui_time=0.001, p_user_id=jaeuk.shin |
| 04:54:21.369 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.53 | MenuID=Tray Simulation, CnntCode=0104002, UserID=jaeuk.shin |

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

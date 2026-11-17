# AS-IS 실측 요약 — FP00634

- 실행: 2026-11-12 19:08:56.811 ~ 2026-11-12 19:09:57.324 · 계정 jaeuk.shin · 상태 OK
- 화면: Tray Simulation (GSCM.FP.Planning.UIL.FP00634_Tray_Simulation)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:08:57.088 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.06 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:08:57.092 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:08:57, END_TIME=2026-11-12 19:08:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190857_079, PA |
| 19:08:57.309 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 19:08:57.327 | load | GSCM.FP_Common | SELECT * | 351 | 9.69 | USER_ID= |
| 19:08:57.351 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.13 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:08:58.056 | load | GSCM.FP_Common | SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER | 8 | 375.85 | AMEND_INSTANCE=PSI_AMEND_FORM, USER_ID=jaeuk.shin |
| 19:08:58.060 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=findInstanceList_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1AMEND_INSTANCE
---Check client parameter : AMEND_INSTANCE
---FOUND AMEND_INSTANCE
-- TYPE = nvarchar---Add string Service
---Che |
| 19:08:58.155 | load | GSCM.FP_Common | SELECT AA.* | 1 | 10.65 | INSTANCE_ID=KR_FORM_A |
| 19:08:58.162 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.76 | PROG_ID=find_isPast, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check client parameter : MASTER_ID
-- |
| 19:08:58.186 | load | GSCM.FP_Common | WITH RELEASE_PLAN AS ( | 0 | 14.7 | INSTANCE_ID=KR_FORM_A, PLAN_DATE=20261112 |
| 19:08:58.190 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.78 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:08:58, END_TIME=2026-11-12 19:08:58, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190858_171, PARAM_VALUE={AMEN |
| 19:08:58.195 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.27 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Service Parameter : 2CTRL_INSTANCE_DATE
---Service Parameter : 3CTRL_INSTANCE
---Service Parameter : 4CTRL_START_TIME
- |
| 19:08:58.199 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=findFpPlan_info, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=
  		AND A.PLAN_ID     = C.PLAN_ID
      WHERE 1=1
     -- AND   A.PLAN_TYPE <> 'RELEASE'
      AND 	CHARINDEX('-00',A.PLAN_ID) = 0
      AND A.INSTANCE_ID='KR_FORM_A' 

	    AND   CONVERT(VAR |
| 19:08:58.220 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 3.91 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 19:08:58.225 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 19:08:58.648 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 415.86 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 19:08:58.705 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.69 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:08:58, END_TIME=2026-11-12 19:08:58, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190858_231, PA |
| 19:08:58.732 | load | GSCM.FP_Common | SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME(@INSTANCE_ID, @PLAN_ID), 24), ':', '') AS BASIS_TIME | 1 | 4.16 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 19:08:58.755 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.42 | PROG_ID=findBasisTime, QUERY_ID=FP\Common\PRAMEND_planamend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check clien |
| 19:08:58.874 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 111.28 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 19:08:58.892 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.07 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:08:58, END_TIME=2026-11-12 19:08:58, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190858_762, PA |
| 19:08:59.298 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 390.44 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 19:08:59.301 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:08:58, END_TIME=2026-11-12 19:08:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190858_908, PA |
| 19:08:59.687 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 370.08 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=HQ07,HQ08,HQ11, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, par |
| 19:08:59.691 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:08:59, END_TIME=2026-11-12 19:08:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190859_317, PA |
| 19:09:00.195 | load | GSCM.FP_Common | SELECT DISTINCT A.OPERATION_ID AS CODE, '(' + A.OPERATION_ID + ')' + B.OPERATION_NAME AS NAME | 1 | 478.0 | SITE_ID=, USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 19:09:00.199 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.84 | PROG_ID=findOperationCode_common, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1USER_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_ID
---Service Parameter : 4CTRL_AMEND
-- |
| 19:09:00.570 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 16 | 353.11 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_FORM_A |
| 19:09:00.574 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:09:00, END_TIME=2026-11-12 19:09:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190900_216, PARAM_VALUE={AM |
| 19:09:00.602 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.94 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---S |
| 19:09:00.643 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.29 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=07','HQ08','HQ11')

      AND A.FACTORY_ID  IN ('A1','A2','A9','AF','AL','S2')

      AND A.OPERATION_ID  = 'F6000' 
      
      AND EXISTS ( SELECT  1 
             FROM    SCM_SYS_LOOKUP_ |
| 19:09:31.600 | load | GSCM.FP_Common | SELECT DISTINCT A.TOP_ITEM_ID AS CODE_ID, A.TOP_ITEM_ID AS CODE | 28 | 30935.9 | SITE_ID=, MASTER_ID=, PLAN_DATE=20261112, BUCKET_FROM=20261112, BUCKET_TO=20261202, PLAN_ID=, OPERATION_ID=F6000 |
| 19:09:31.645 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.77 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:09:00, END_TIME=2026-11-12 19:09:31, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190900_662, PARAM_VALUE={AMEN |
| 19:09:31.650 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2PLAN_DATE
---Service Parameter : 3SITE_ID
---Service Parameter : 4OPERATION_ID
---Service Parameter :  |
| 19:09:31.695 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.51 | PROG_ID=find_Model_List, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=   WHERE  A.INSTANCE_ID  = @MASTER_ID
          AND    A.FP_PLAN_ID   = @PLAN_ID
          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= @PLAN_DATE
          AND A.DIVISION_ID  IN ('81','82')

   |
| 19:09:32.302 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 599.21 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_FORM_A, param2=, param3=, param4=, param5=81,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:09:32.317 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:09:31, END_TIME=2026-11-12 19:09:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190931_703, PA |
| 19:09:32.591 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 27 | 234.31 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, opt_none=, in_columns=AMEND_INSTANCE^SITE_ID^USER_ID^INSTANCE_ID^FACTORY_YN^CURR_DATE^PLAN_DATE^BUCKET_FROM^BUCKET_TO^CTRL_INSTANCE_DATE^CTRL_START_TIME^CTRL_INSTANCE^FP_SITE_ID^BASIS_STA |
| 19:09:32.597 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.59 | PROG_ID=PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_XPCOMMON_F |
| 19:09:32.657 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.34 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:09:32.666 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.36 | p_program_id=FP00634, p_sheet_name=Main |
| 19:09:32.675 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.14 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:09:32.683 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.99 | p_program_id=FP00634, p_sheet_name=Main |
| 19:09:32.874 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 107.39 | MenuID=Tray Simulation, CnntCode=0104001, UserID=jaeuk.shin |
| 19:09:33.118 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00634 |
| 19:09:43.478 | find | GSCM.FP_Common | SELECT A.* | 0 | 308.94 | INSTANCE_ID=KR_FORM_A, PLAN_ID= |
| 19:09:43.503 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.69 | PROG_ID=chk_PlanId, QUERY_ID=FP\Planning\FP00634_Tray_Simulation, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Check  |
| 19:09:43.542 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.25 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:09:43.554 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 7.37 | p_program_id=FP00634, p_sheet_name=Main |
| 19:09:43.564 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.13 | p_program_id=FP00634, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:09:43.573 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.19 | p_program_id=FP00634, p_sheet_name=Main |
| 19:09:43.600 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 21 | 6.02 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20261112, param2=20261202, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:09:43.625 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.26 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20261202',@param3=N'',@param4=N'',@ |
| 19:09:43.648 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 14.45 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_FORM_A, param2=20261112, param3=20261202, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:09:43.689 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.31 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_FORM_A',@param2=N'20261112',@param3=N'20261202',@param4=N |
| 19:09:43.705 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 6.25 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:09:43.709 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.92 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 19:09:43.721 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 21 | 5.26 | PLAN_DATE=20261112, BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:09:43.747 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.36 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Chec |
| 19:09:43.760 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.37 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:09:43.794 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.46 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---C |
| 19:09:43.809 | find | GSCM.FP_Common | SELECT A.* | 21 | 6.42 | BUCKET_FROM=20261112, BUCKET_TO=20261202 |
| 19:09:43.814 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.41 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:09:43, END_TIME=2026-11-12 19:09:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190943_801, PARAM_VALUE={AMEND_I |
| 19:09:43.854 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.63 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : CTRL_SITE_ID
---Check client parameter : SITE_ID
---Ch |
| 19:09:43.859 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.72 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=STFIX, 100 AS POST_ORDER
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

- 2026-11-12 19:09:44.255 [] FP Plan ID is required → default_button(id=1)

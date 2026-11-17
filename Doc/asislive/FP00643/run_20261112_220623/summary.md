# AS-IS 실측 요약 — FP00643

- 실행: 2026-11-12 22:06:23.852 ~ 2026-11-12 22:07:16.152 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line, PSI(Elec) (GSCM.FP.Planning.UIL.FP00643_Plan_Amend_Line_PSI_Elec)
- 조회 결과:  · DB : 26.992s, UI : 0.244s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:06:24.564 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00643 |
| 22:06:24.583 | load | GSCM.FP_Common | SELECT * | 351 | 10.07 | USER_ID= |
| 22:06:24.610 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.73 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:06:24.811 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.19 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:06:24.814 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.86 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:24, END_TIME=2026-11-12 22:06:24, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220624_801, PA |
| 22:06:24.844 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 4.63 | USER_ID=jaeuk.shin, MENU_ID=FP00643_Amend |
| 22:06:24.876 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.47 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:06:24.884 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.76 | p_program_id=FP00643, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:06:24.942 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 43 | 54.55 | p_program_id=FP00643, p_sheet_name=Amend |
| 22:06:25.381 | load | GSCM.FP_Common | UI_FP_COMMON | 13 | 364.17 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=LINE_AMEND_E_PRE, param22=, param23=, |
| 22:06:25.384 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:25, END_TIME=2026-11-12 22:06:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220625_016, PA |
| 22:06:25.457 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 5.24 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 22:06:25.461 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 22:06:25.480 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 6.6 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=LINE_AMEN |
| 22:06:25.485 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 22:06:25.556 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 58.24 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TAB |
| 22:06:25.577 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.11 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 22:06:25.589 | load | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 4.78 | INSTANCE_ID=KR_E_PRE_A |
| 22:06:25.626 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.0 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 22:06:25.703 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 71.07 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:06:25.707 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:25, END_TIME=2026-11-12 22:06:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220625_631, PA |
| 22:06:25.985 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 269.92 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 22:06:25.989 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.47 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:25, END_TIME=2026-11-12 22:06:25, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220625_716, PA |
| 22:06:26.234 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 235.19 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=BUILDIN |
| 22:06:26.237 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.03 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:25, END_TIME=2026-11-12 22:06:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220625_999, PA |
| 22:06:26.285 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 10 | 31.26 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 22:06:26.290 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:26, END_TIME=2026-11-12 22:06:26, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220626_253, PARAM_VALUE={AMEND_INSTANCE |
| 22:06:26.294 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---Service Param |
| 22:06:26.321 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.32 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=ND		A.ACTIVE_FLAG = 'Y'
          ) C
          WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID
      )
   |
| 22:06:26.730 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 399.11 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 22:06:26.732 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.54 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:26, END_TIME=2026-11-12 22:06:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220626_33, PAR |
| 22:06:26.845 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 11 | 103.73 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FIND_FPPRODTYPE, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TABLE^AMEND_ |
| 22:06:26.850 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=PR_UI_FP00599_FIND_FPPRODTYPE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FIND_FPPRO |
| 22:06:26.867 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP00643, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:06:26.874 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 43 | 4.17 | p_program_id=FP00643, p_sheet_name=Amend |
| 22:06:26.888 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.18 | p_program_id=FP00643, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:06:26.896 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 43 | 4.83 | p_program_id=FP00643, p_sheet_name=Amend |
| 22:06:27.074 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 76.39 | MenuID=Plan Amend by Line, PSI(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 22:06:27.191 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00643 |
| 22:06:36.228 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 9.47 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TABLE^AMEND_ |
| 22:06:36.233 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.92 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 22:06:36.445 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 203.03 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=A001, param8=, param9=HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PRE, param22= |
| 22:06:36.449 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:06:36, END_TIME=2026-11-12 22:06:36, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220636_242, PA |
| 22:06:36.678 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 10 | 213.17 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 22:06:36.682 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:36, END_TIME=2026-11-12 22:06:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220636_464, PARAM_VALUE={AMEND_INSTANCE |
| 22:06:36.688 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.32 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---Service Param |
| 22:06:36.693 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=IVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID
              FROM  SCM_FACTORY_M A(NOLOCK)
              INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK)
              ON    A.FACTORY_ID=B.FACTORY_ID
           |
| 22:06:41.625 | find | GSCM.FP_Common | SELECT @INSTANCE_ID AS INSTANCE_ID | 1 | 5.08 | INSTANCE_ID=KR_E_PRE_A |
| 22:06:41.630 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=find_isPDS, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client para |
| 22:06:41.751 | find | GSCM.FP_Common | SELECT DISTINCT ISNULL(B.NICK_NAME,'-') AS CODE, ISNULL(B.NICK_NAME,'-') AS NAME | 0 | 11.27 | INSTANCE_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00, BUCKET_FROM=20260914, BUCKET_TO=20261011, TOP_ITEM_ID=, ITEM_ID=, PROD_TYPE= |
| 22:06:41.782 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.8 | PROG_ID=find_FPNickName, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:41, END_TIME=2026-11-12 22:06:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220641_739, PARAM_VALUE={AMEND_INSTANCE : |
| 22:06:41.797 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.82 | PROG_ID=find_FPNickName, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2BUCKET_FROM
---Service Parameter : 3BUCKET_TO
---Service Parameter : 4PROD_TYPE
---Service Parameter : 5ITEM_ID
 |
| 22:06:41.801 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.67 | PROG_ID=find_FPNickName, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=AME,'-') AS CODE, ISNULL(B.NICK_NAME,'-') AS NAME
    	FROM (
    			  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID
    			  FROM   FP_AMEND_DAILY_PLAN |
| 22:06:41.814 | find | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 4.15 | INSTANCE_ID=KR_E_PRE_A |
| 22:06:41.818 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.64 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 22:06:41.837 | find | GSCM.FP_Common | SELECT A.INSTANCE_ID, A.FP_PLAN_ID | 0 | 11.55 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:06:41.869 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.91 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00643, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:41, END_TIME=2026-11-12 22:06:41, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220641_824, PARAM_VALUE={AMEND_INSTANCE : LINE_ |
| 22:06:41.886 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.18 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00643, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2BUCKET_FROM
---Service Parameter : 3BUCKET_TO
---Service Parameter : 4CTRL_DIVISION_LT
---Service Parameter : 5CTRL_SITE |
| 22:06:41.891 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.02 | PROG_ID=find_ListData, QUERY_ID=FP\Planning\FP00643, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=ATCH,2)
           		  ELSE ROUND(A.WPP_IN_QTY_BATCH,2) END AS ADJUST_IN_QTY_BATCH
		   , CASE WHEN B.RELEASE_TYPE = 'DPP' THEN CEILING(A.ADJUST_IN_QTY)
           		  WHEN B.RELEASE_TYPE = 'MPP' THEN CEILING(A |
| 22:06:42.179 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 11529 | 253.45 |  |
| 22:06:42.182 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.03 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:41, END_TIME=2026-11-12 22:06:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220641_924, PARAM_VALUE={AMEND_INSTANCE : LI |
| 22:06:42.186 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.63 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0CTRL_DIVISION_LT
---Service Parameter : 1CTRL_SITE_LT
---Service Parameter : 2CTRL_PLANT_LT
---Service Parameter : 3CTRL_FACTORY_LT
---Check client parameter : AMEND_INSTANCE
---Check |
| 22:06:42.189 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.04 | PROG_ID=find_UOMInfo, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=RDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
--       , A.MODEL_ID, A.ITEM_ID, A.APPLY_DATE DESC
--       , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE
ORDER BY A.COMPANY_ID,  |
| 22:06:42.686 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 14103 | 351.52 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 22:06:42.690 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.77 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:42, END_TIME=2026-11-12 22:06:42, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220642_334, PARAM_VALUE={AMEND_INSTA |
| 22:06:42.695 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.14 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2CTRL_DIVISION_LT
---Service Parameter : 3CTRL_SITE_LT
---Service Parameter : 4CTRL_PLANT_LT
---Service Parame |
| 22:06:42.699 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.4 | PROG_ID=find_YieldInfo_Child, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=5DP2','FP_E5M01_A','FP_E5M01_C','FP_E5M02_A','FP_E5M02_C','FP_E6M01_A','FP_E6M01_C','FP_E6M02_A','FP_E6M02_C')

      
      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
 |
| 22:06:43.036 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1915 | 99.04 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_E_PRE_A^81^FP_AMEND_DAILY_BOR_R^KR_E_PRE_A-20260919-0 |
| 22:06:43.052 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.87 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 22:06:43.129 | find | GSCM.FP_Common | SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE | 727 | 39.58 | MASTER_ID=KR_E_PRE_A |
| 22:06:43.154 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.2 | PROG_ID=find_Prod_Version_Type, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1CTRL_DIVISION_LT
---Service Parameter : 2CTRL_SITE_LT
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---C |
| 22:06:43.171 | find | GSCM.FP_Common | SELECT A.SEGMENT3 AS PRODUCTION_TYPE | 10 | 5.32 | MASTER_ID=KR_E_PRE_A |
| 22:06:43.176 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.24 | PROG_ID=find_versionType, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 22:06:43.293 | find | GSCM.FP_Common | SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID | 0 | 110.48 | MASTER_ID=KR_E_PRE_A, PLAN_ID=KR_E_PRE_A-20260919-00 |
| 22:06:43.310 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.09 | PROG_ID=find_yieldInfo_ALL, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0MASTER_ID
---Service Parameter : 1PLAN_ID
---Service Parameter : 2AMEND_BOR_TABLE
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client pa |
| 22:06:43.779 | find | GSCM.FP_Common | if object_id('tempdb..#COATER_SITE') is not null | 10 | 460.4 | INSTANCE_ID=KR_E_PRE_A, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:06:43.805 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.31 | PROG_ID=find_PostYield, QUERY_ID=FP\Planning\FP00643, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parame |
| 22:06:43.846 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.07 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:06:43.867 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.28 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---C |
| 22:06:43.880 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 4.39 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:06:43.938 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.36 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 22:06:43.948 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 4.4 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:06:43.985 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.17 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:06:43.996 | find | GSCM.FP_Common | SELECT A.* | 28 | 6.21 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:06:44.046 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.78 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:43, END_TIME=2026-11-12 22:06:43, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220643_99, PARAM_VALUE={AMEN |
| 22:06:44.084 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.37 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
- |
| 22:06:44.088 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.38 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=M, 112)
          --    AND    CAL.DT <= CONVERT(DATETIME, @BUCKET_TO, 112)
          --    GROUP BY ISO_YYYYWW
          --) A
          --INNER JOIN (
          --    SELECT '_QTY' AS POSTF |
| 22:06:48.531 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 4435.45 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00643_ROW_FIND_FP00643_ROW, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN |
| 22:06:48.536 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.31 | PROG_ID=PR_UI_FP00643_ROW_FIND_FP00643_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:44, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220644_095, P |
| 22:06:48.540 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=PR_UI_FP00643_ROW_FIND_FP00643_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:44, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220644_095, P |
| 22:06:48.575 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.33 | PROG_ID=PR_UI_FP00643_ROW_FIND_FP00643_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:44, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220644_095, P |
| 22:06:48.589 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.98 | PROG_ID=PR_UI_FP00643_ROW_FIND_FP00643_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00643 |
| 22:06:48.593 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=PR_UI_FP00643_ROW_FIND_FP00643_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=640#_TYPE:D#POST_ORDER:10#!_DATE:20261007#_NAME:2026-10-07 (Wed)#_COUNT:1#_VALUE:D23_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261008#_NAME:2026-10-08 (Thu |
| 22:06:48.597 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.49 | PROG_ID=PR_UI_FP00643_ROW_FIND_FP00643_ROW, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=_VALUE:true#MEA_NAME:M/C(sec)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00643_Amend#!MEA_ID:chk_sim#MEA_VALUE:true#MEA_NAME:Simulation#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk. |
| 22:06:48.773 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 7.67 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:06:48.778 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.29 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:48, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220648_764, PARAM_VALUE={AMEND_ |
| 22:06:48.782 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:48, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220648_764, PARAM_VALUE=640#_TY |
| 22:06:48.806 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.35 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:48, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220648_764, PARAM_VALUE=d#!MEA_ |
| 22:06:48.812 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.19 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---C |
| 22:06:48.823 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 28 | 4.04 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20260919, param2=20260914, param3=20261011, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:06:48.866 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.12 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20260919',@param2=N'20260914',@param3=N'20261011',@param4=N'',@param5=N' |
| 22:06:48.876 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 4 | 3.9 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261011, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 22:06:48.941 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261011',@param3=N'',@param4=N'',@param5=N'',@param |
| 22:06:48.954 | find | GSCM.FP_Common | SELECT A.* | 28 | 6.47 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 22:06:49.005 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.45 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:48, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220648_946, PARAM_VALUE={AME |
| 22:06:49.010 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.33 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:48, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220648_946, PARAM_VALUE=640# |
| 22:06:49.075 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 65.62 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:48, END_TIME=2026-11-12 22:06:48, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220648_946, PARAM_VALUE=d#!M |
| 22:06:49.117 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.18 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
- |
| 22:06:49.121 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=find_bukInfo_sun, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=         --         , 1 AS _DATE_SEQ
          --         , ISO_YYYYWW AS WEEK_SEQ
          --         , 'W' AS _TYPE
          --    FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)
          --    WH |
| 22:07:06.425 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 105 | 17298.69 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN_I |
| 22:07:06.440 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.53 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:49, END_TIME=2026-11-12 22:07:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220649_125, PARA |
| 22:07:06.445 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.67 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:49, END_TIME=2026-11-12 22:07:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220649_125, PARA |
| 22:07:06.449 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.74 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:06:49, END_TIME=2026-11-12 22:07:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220649_125, PARA |
| 22:07:06.454 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.83 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00623_PAN |
| 22:07:06.458 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.49 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=E_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261007#_NAME:2026-10-07 (Wed)#_COUNT:1#_VALUE:D23_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261008#_NAM |
| 22:07:06.479 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.64 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=MEA_ID:chk_setup#MEA_VALUE:true#MEA_NAME:M/C(sec)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00643_Amend#!MEA_ID:chk_sim#MEA_VALUE:true#MEA_NAME:Simulation#TYPE:CATEGORY#FLA |
| 22:07:08.752 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 43 | 2093.75 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_P |
| 22:07:08.757 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.18 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:07:06, END_TIME=2026-11-12 22:07:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220706_657, |
| 22:07:08.761 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.4 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:07:06, END_TIME=2026-11-12 22:07:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220706_657, |
| 22:07:08.765 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.84 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:07:06, END_TIME=2026-11-12 22:07:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220706_657, |
| 22:07:08.772 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.96 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0062 |
| 22:07:08.776 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.31 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:20261007#_NAME:2026-10-07 (Wed)#_COUNT:1#_VALUE:D23_QTY#_DATE_SEQ:1#WEEK_SEQ:202640#_TYPE:D#POST_ORDER:10#!_DATE:202 |
| 22:07:08.791 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.1 | PROG_ID=PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=end#!MEA_ID:chk_setup#MEA_VALUE:true#MEA_NAME:M/C(sec)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00643_Amend#!MEA_ID:chk_sim#MEA_VALUE:true#MEA_NAME:Simulation#TYPE:CA |
| 22:07:08.951 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP00643, p_sheet_name=Simul, p_user_id=jaeuk.shin |
| 22:07:08.975 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 21.47 | p_program_id=FP00643, p_sheet_name=Simul |
| 22:07:09.020 | find | GSCM.FP_Common | ;WITH LOOK_UP AS | 0 | 19.33 | DIVISION_ID=, SITE_ID=, ITEM_ID= |
| 22:07:09.036 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.13 | PROG_ID=list_dio, QUERY_ID=FP\MASTER\DIO, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0DIVISION_ID
---Service Parameter : 1SITE_ID
---Service Parameter : 2ITEM_ID
---Check client parameter : DIVISION_ID
---FOUND DIVISION_ID
-- TYPE = nvarchar---Add string Service
---Check client para |
| 22:07:09.049 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.67 | p_menu_id=FP00643, p_log_type=FIND, p_log_cnt=, p_db_time=26.992, p_ui_time=0.244, p_user_id=jaeuk.shin |
| 22:07:15.311 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 54.54 | MenuID=Plan Amend by Line, PSI(Elec), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 78(보임 77) · 헤더 2단 · 고정 컬럼 44
- spdSimul / Simul: 행 105 · 컬럼 52(보임 50) · 헤더 2단 · 고정 컬럼 24

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

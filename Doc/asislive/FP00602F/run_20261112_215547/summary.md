# AS-IS 실측 요약 — FP00602F

- 실행: 2026-11-12 21:55:47.890 ~ 2026-11-12 21:56:13.309 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Assy) (GSCM.FP.Planning.UIL.FP00602_Plan_Amend_Line_Assy)
- 조회 결과:  · DB : 3.218s, UI : 0.524s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:55:48.256 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00602 |
| 21:55:48.270 | load | GSCM.FP_Common | SELECT * | 351 | 10.33 | USER_ID= |
| 21:55:48.274 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.52 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:55:48.454 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 29.91 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:55:48.457 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:55:48, END_TIME=2026-11-12 21:55:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215548_423, PA |
| 21:55:48.479 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 29 | 4.11 | USER_ID=jaeuk.shin, MENU_ID=FP00602_Main |
| 21:55:48.513 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.33 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:55:48.520 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.13 | p_program_id=FP00602, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 21:55:48.579 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 55.74 | p_program_id=FP00602, p_sheet_name=Main |
| 21:55:48.752 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 5 | 93.8 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FINDPLANNER_LIST, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI_AMEND_CELL^20261 |
| 21:55:48.756 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=PR_UI_FP00599_FINDPLANNER_LIST, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FINDPLANN |
| 21:55:48.822 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 47.83 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=PSI_AMEND_ |
| 21:55:48.851 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.48 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:55:48.902 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.18 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:48.975 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 68.27 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:48.983 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.84 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:48.991 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 5.52 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:49.224 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 210.13 | MenuID=Plan Amend by Line(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 21:55:49.316 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00602 |
| 21:55:58.228 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 52.65 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^PLANNER_ID^USER_LT^ |
| 21:55:58.232 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 21:56:02.817 | find | GSCM.FP_Common | SELECT @INSTANCE_ID AS INSTANCE_ID | 1 | 28.45 | INSTANCE_ID=KR_CELL_A2 |
| 21:56:02.823 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.39 | PROG_ID=find_isPDS, QUERY_ID=FP\Planning\FP00595, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client para |
| 21:56:02.920 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.18 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:02.929 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 5.93 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:02.936 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.35 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:02.944 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 5.02 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:02.963 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 5.72 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:56:02.968 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Ch |
| 21:56:02.980 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 28 | 5.43 | PLAN_DATE=20260919, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:56:03.012 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.04 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---FOUND P |
| 21:56:03.027 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.31 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:56:03.077 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.32 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---C |
| 21:56:03.089 | find | GSCM.FP_Common | SELECT A.* | 28 | 6.1 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:56:03.134 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.7 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:03, END_TIME=2026-11-12 21:56:03, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215603_082, PARAM_VALUE={AMEND_I |
| 21:56:03.140 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.41 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Ch |
| 21:56:03.143 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.12 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00602_PlanAmendLineAssy, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=          --INNER JOIN (
          --    SELECT '_QTY' AS POSTFIX, 100 AS POST_ORDER
          --) B
          --ON     1=1
      ) A
      ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = 'W' THEN 1 ELSE 2 |
| 21:56:03.313 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 149 | 164.03 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_CELL_A2^81^FP_AMEND_PLAN_CELL_BOR_R^KR_CELL_A2-202609 |
| 21:56:03.346 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.5 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 21:56:05.793 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 885 | 2440.34 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FIND_FP00602, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN_ID^PLAN_ |
| 21:56:05.811 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.83 | PROG_ID=PR_UI_FP00602_FIND_FP00602, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:03, END_TIME=2026-11-12 21:56:05, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215603_352, PARAM_VAL |
| 21:56:05.816 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.57 | PROG_ID=PR_UI_FP00602_FIND_FP00602, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:03, END_TIME=2026-11-12 21:56:05, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215603_352, PARAM_VAL |
| 21:56:05.821 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=PR_UI_FP00602_FIND_FP00602, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:03, END_TIME=2026-11-12 21:56:05, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215603_352, PARAM_VAL |
| 21:56:05.825 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.36 | PROG_ID=PR_UI_FP00602_FIND_FP00602, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FIND_FP |
| 21:56:05.831 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.79 | PROG_ID=PR_UI_FP00602_FIND_FP00602, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=10-05 (Mon)#_COUNT:1#_VALUE:D21_QTY#_DATE_SEQ:1#WEEK_SEQ:202641#_TYPE:D#POST_ORDER:10#!_DATE:20261006#_NAME:2026-10-06 (Tue)#_COUNT:1#_VALUE:D22_QTY#_DATE_SEQ:1#WEEK_SEQ:202641#_TYPE:D |
| 21:56:05.856 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.55 | PROG_ID=PR_UI_FP00602_FIND_FP00602, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=A_VALUE:true#MEA_NAME:WPP Plan (In)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00602_Main#!MEA_ID:chk_wpp_outqty#MEA_VALUE:true#MEA_NAME:WPP Plan (Out)#TYPE:CATEGORY#FLAG:#USER_I |
| 21:56:06.122 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 14 | 222.36 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FIND_TOTALVALUE, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^AMENDUI^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN_ID^PL |
| 21:56:06.136 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.65 | PROG_ID=PR_UI_FP00599_FIND_TOTALVALUE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:05, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215605_899, PARAM_ |
| 21:56:06.141 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.79 | PROG_ID=PR_UI_FP00599_FIND_TOTALVALUE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:05, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215605_899, PARAM_ |
| 21:56:06.144 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.26 | PROG_ID=PR_UI_FP00599_FIND_TOTALVALUE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:05, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215605_899, PARAM_ |
| 21:56:06.149 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=PR_UI_FP00599_FIND_TOTALVALUE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FIND |
| 21:56:06.154 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.41 | PROG_ID=PR_UI_FP00599_FIND_TOTALVALUE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=26-10-05 (Mon)#_COUNT:1#_VALUE:D21_QTY#_DATE_SEQ:1#WEEK_SEQ:202641#_TYPE:D#POST_ORDER:10#!_DATE:20261006#_NAME:2026-10-06 (Tue)#_COUNT:1#_VALUE:D22_QTY#_DATE_SEQ:1#WEEK_SEQ:202641#_ |
| 21:56:06.158 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.61 | PROG_ID=PR_UI_FP00599_FIND_TOTALVALUE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=#MEA_VALUE:true#MEA_NAME:WPP Plan (In)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00602_Main#!MEA_ID:chk_wpp_outqty#MEA_VALUE:true#MEA_NAME:WPP Plan (Out)#TYPE:CATEGORY#FLAG:# |
| 21:56:06.188 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.22 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:06.195 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 18 | 3.92 | p_program_id=FP00602, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:56:06.216 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 6.03 | INSTANCE_ID=KR_CELL_A2, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:56:06.220 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_209, PARAM_VALUE={AMEND_INSTANCE : PSI_AMEND |
| 21:56:06.226 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.55 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_209, PARAM_VALUE=ATE_SEQ:1#WEEK_SEQ:202641#_ |
| 21:56:06.230 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_209, PARAM_VALUE=E:true#MEA_NAME:WPP Plan (O |
| 21:56:06.233 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 21:56:06.285 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 43.78 | INSTANCE_ID=KR_CELL_A2 |
| 21:56:06.290 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.2 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_24, PARAM_VALUE={AMEND_INSTANCE  |
| 21:56:06.294 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_24, PARAM_VALUE=ATE_SEQ:1#WEEK_S |
| 21:56:06.297 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.66 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_24, PARAM_VALUE=E:true#MEA_NAME: |
| 21:56:06.301 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 21:56:06.313 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 4.56 | USER_ID=jaeuk.shin |
| 21:56:06.318 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.52 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_307, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 21:56:06.323 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.76 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_307, PARAM_VALUE=ATE_SEQ:1#WEEK_SEQ:20264 |
| 21:56:06.326 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_307, PARAM_VALUE=E:true#MEA_NAME:WPP Plan |
| 21:56:06.330 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:56:06.343 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 5.01 | INSTANCE_ID=KR_CELL_A2 |
| 21:56:06.358 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.24 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_337, PARAM_VALUE={AMEND_INSTANCE :  |
| 21:56:06.362 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.29 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_337, PARAM_VALUE=ATE_SEQ:1#WEEK_SEQ |
| 21:56:06.366 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.42 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:56:06, END_TIME=2026-11-12 21:56:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215606_337, PARAM_VALUE=E:true#MEA_NAME:WP |
| 21:56:06.381 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.3 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:56:06.579 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.31 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_CELL_A2, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:56:06.667 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 87.59 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL_A2',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6 |
| 21:56:06.698 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.56 | p_menu_id=FP00602, p_log_type=FIND, p_log_cnt=, p_db_time=3.218, p_ui_time=0.524, p_user_id=jaeuk.shin |
| 21:56:12.521 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.97 | MenuID=Plan Amend by Line(Assy), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Planner | mcbo_planner |  |
| FP Plan Id | cbo_fpplanid |  |
| Prod.Type | mcbo_prodtype |  |
| lblSql | btnSql |  |
| layoutControlItem2 | btnExcelImport |  |
| Plan Group | cbo_plan_group |  |
| Plan Date | sCalendar_planday |  |
| Data | btnToggleSave |  |
| Division. | mcbo_division |  |
| Plant | mcbo_plant |  |
| Operation | mcbo_operation |  |
| Material | edt_item |  |
| Nick Name | tbNickName |  |
| Pjt Group Name | edt_PjtGroup |  |
| Plan Period | dCalendar_planrange |  |
| Site | mcbo_site |  |
| Line | mcbo_line |  |
| layoutControlItem12 | chk_allLine |  |
| Building | mcbo_factory |  |
| Model | edt_topItem |  |
| layoutControlItem13 | chk_Info |  |

## 그리드

- spdMain / Amend: 행 881 · 컬럼 53(보임 52) · 헤더 2단 · 고정 컬럼 19

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

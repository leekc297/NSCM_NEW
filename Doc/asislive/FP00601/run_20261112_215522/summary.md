# AS-IS 실측 요약 — FP00601

- 실행: 2026-11-12 21:55:22.592 ~ 2026-11-12 21:55:47.545 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Pack) (GSCM.FP.Planning.UIL.FP00601_PlanAmend_Line_Pack)
- 조회 결과:  · DB : 3.023s, UI : 0.365s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "sCalendar_planday", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:55:23.080 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00601 |
| 21:55:23.095 | load | GSCM.FP_Common | SELECT * | 351 | 11.24 | USER_ID= |
| 21:55:23.100 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.2 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:55:23.207 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.65 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:55:23.211 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:55:23, END_TIME=2026-11-12 21:55:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215523_198, PA |
| 21:55:23.247 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 42 | 4.59 | USER_ID=jaeuk.shin, MENU_ID=FP00601_Main |
| 21:55:23.278 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.68 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 21:55:23.285 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.28 | p_program_id=FP00601, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 21:55:23.337 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 47.53 | p_program_id=FP00601, p_sheet_name=Main |
| 21:55:23.423 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.92 | LOGTYPE=SpeedUp, NOTE=FP00601
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 21:55:23.427 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:55:23.524 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 88.23 | p_sys_type=SELECT, p_sys_flag=PLANNER_LIST, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI_AMEND_ |
| 21:55:23.556 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.69 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLANNER_LIST',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00601_ETC',@ |
| 21:55:23.624 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 59.94 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=PS |
| 21:55:23.628 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.91 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00601_ETC',@opt |
| 21:55:23.642 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.22 | LOGTYPE=SpeedUp, NOTE=FP00601
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 21:55:23.646 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:55:23.684 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:23.714 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 28.14 | p_program_id=FP00601, p_sheet_name=Amend |
| 21:55:23.721 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.31 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:23.728 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 3.8 | p_program_id=FP00601, p_sheet_name=Amend |
| 21:55:23.832 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 84.5 | MenuID=Plan Amend by Line(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 21:55:23.914 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00601 |
| 21:55:32.664 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 35.84 | p_sys_type=SELECT, p_sys_flag=PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^BUCKET_FROM |
| 21:55:32.668 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.89 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00601_ETC',@opt |
| 21:55:37.292 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.45 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:37.300 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 4.74 | p_program_id=FP00601, p_sheet_name=Amend |
| 21:55:37.308 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.35 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:37.317 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 5.24 | p_program_id=FP00601, p_sheet_name=Amend |
| 21:55:37.337 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 4 | 6.72 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:55:37.344 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.43 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP00601_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check clie |
| 21:55:37.357 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 28 | 5.35 | PLAN_DATE=20260919, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:55:37.403 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.64 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP00601_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---FOUND PLAN_DATE |
| 21:55:37.416 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 2 | 6.5 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:55:37.468 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.89 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP00601_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check cli |
| 21:55:37.480 | find | GSCM.FP_Common | SELECT 	A.* | 28 | 7.1 | BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:55:37.541 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.66 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\FP00601_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check clie |
| 21:55:37.737 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 47 | 189.16 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=chkim.68, p_proc_name=PR_UI_FP00599_FIND_YIELDINFO_CHILD, opt_none=, in_columns=MASTER_ID^DIVISION_ID^AMEND_BOR_TABLE^PLAN_ID^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^PLAN_DATE^, in_row=KR_PACK^81^FP_AMEND_PLAN_PACK_BOR_R^KR_PACK-20260919-00^ |
| 21:55:37.750 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.73 | PROG_ID=PR_UI_FP00599_FIND_YIELDINFO_CHILD, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'chkim.68',@p_proc_name=N'PR_UI_FP00599_FIND_YIEL |
| 21:55:37.810 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 53.51 | p_sys_type=SELECT, p_sys_flag=OCV2_LT, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^FP_PLAN_ID^PL |
| 21:55:37.815 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.33 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:37, END_TIME=2026-11-12 21:55:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215537_756, PARAM_VALUE={p_sys_ |
| 21:55:37.819 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:37, END_TIME=2026-11-12 21:55:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215537_756, PARAM_VALUE=TE:2026 |
| 21:55:37.823 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.73 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:37, END_TIME=2026-11-12 21:55:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215537_756, PARAM_VALUE=1_Main# |
| 21:55:37.828 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'OCV2_LT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00601_ETC',@opt_n |
| 21:55:37.848 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.35 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=:202641#_MONTH:10#_DATE_TXT:2026-10-10 (Sat.)#DAY_SEQ:7#!IS_PLAN:Y#D_VALUE:D27#_DATE:20261011#_WEEK:202641#_MONTH:10#_DATE_TXT:2026-10-11 (SUN.)#DAY_SEQ:1#^MONTH:202609#MONTH_NAME:2026-Sep#MONTH |
| 21:55:37.859 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.89 | PROG_ID=PR_UI_FP00601_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=MEA_VALUE:true#MEA_NAME:Memo#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00601_Main#!MEA_ID:chk_month#MEA_VALUE:true#MEA_NAME:Month#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00601_Ma |
| 21:55:40.312 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 188 | 2446.24 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^CONFIRM_STEP^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^ |
| 21:55:40.315 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.54 | PROG_ID=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:37, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215537_864, |
| 21:55:40.319 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:37, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215537_864, |
| 21:55:40.323 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.68 | PROG_ID=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:37, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215537_864, |
| 21:55:40.326 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.3 | PROG_ID=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP0060 |
| 21:55:40.331 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.1 | PROG_ID=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=0261010#_WEEK:202641#_MONTH:10#_DATE_TXT:2026-10-10 (Sat.)#DAY_SEQ:7#!IS_PLAN:Y#D_VALUE:D27#_DATE:20261011#_WEEK:202641#_MONTH:10#_DATE_TXT:2026-10-11 (SUN.)#DAY_SEQ:1#^MONTH |
| 21:55:40.334 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.34 | PROG_ID=PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=chk_memo_tot#MEA_VALUE:true#MEA_NAME:Memo#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00601_Main#!MEA_ID:chk_month#MEA_VALUE:true#MEA_NAME:Month#TYPE:CATEGORY#FLAG:#USER |
| 21:55:40.356 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.04 | p_program_id=FP00601, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 21:55:40.362 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 16 | 3.72 | p_program_id=FP00601, p_sheet_name=Amend |
| 21:55:40.383 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 6.16 | INSTANCE_ID=KR_PACK, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 21:55:40.387 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.15 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_375, PARAM_VALUE={AMEND_INSTANCE : PSI_AMEND |
| 21:55:40.398 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.62 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_375, PARAM_VALUE=2609#MONTH_NAME:2026-Sep#MO |
| 21:55:40.407 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.5 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_375, PARAM_VALUE=Month#TYPE:CATEGORY#FLAG:#U |
| 21:55:40.411 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.93 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 21:55:40.428 | find | GSCM.FP_Common | SELECT B.SETUP_COLOR_CODE, A.* FROM FP_AMEND_MEMO_M  A WITH(NOLOCK) | 0 | 9.0 | INSTANCE_ID=KR_PACK |
| 21:55:40.441 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.83 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_417, PARAM_VALUE={AMEND_INSTANCE |
| 21:55:40.452 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.08 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_417, PARAM_VALUE=2609#MONTH_NAME |
| 21:55:40.463 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.43 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_417, PARAM_VALUE=Month#TYPE:CATE |
| 21:55:40.478 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.71 | PROG_ID=list_setup_color_code, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check  |
| 21:55:40.490 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 5.05 | USER_ID=jaeuk.shin |
| 21:55:40.500 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.35 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_485, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 21:55:40.510 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.07 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_485, PARAM_VALUE=2609#MONTH_NAME:2026-Sep |
| 21:55:40.522 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.37 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_485, PARAM_VALUE=Month#TYPE:CATEGORY#FLAG |
| 21:55:40.532 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.04 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 21:55:40.543 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.43 | INSTANCE_ID=KR_PACK |
| 21:55:40.555 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.86 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_537, PARAM_VALUE={AMEND_INSTANCE :  |
| 21:55:40.566 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.62 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_537, PARAM_VALUE=2609#MONTH_NAME:20 |
| 21:55:40.578 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.33 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:55:40, END_TIME=2026-11-12 21:55:40, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112215540_537, PARAM_VALUE=Month#TYPE:CATEGOR |
| 21:55:40.588 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.07 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 21:55:40.695 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 4.33 | p_code=find_SetupColor_P, p_user_id=jaeuk.shin, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 21:55:40.700 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.35 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_SetupColor_P',@p_user_id=N'jaeuk.shin',@param1=N'KR_PACK',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 21:55:40.718 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.5 | p_menu_id=FP00601, p_log_type=FIND, p_log_cnt=, p_db_time=3.023, p_ui_time=0.365, p_user_id=jaeuk.shin |
| 21:55:46.860 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.2 | MenuID=Plan Amend by Line(Pack), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| lblExcel | btnExcelImport |  |
| Plan Group | cbo_plan_group |  |
| Planner | mcbo_planner |  |
| Plan Date | sCalendar_planday |  |
| Division. | mcbo_division |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| FP Plan Id | cbo_fpplanid |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| Building | mcbo_factory |  |
| Pjt Group Name | edt_pjtGroup |  |
| Model | edt_topItem |  |
| Material | edt_item |  |
| Nick Name | tbNickName |  |
| Prod.Type | mcbo_prodtype |  |
| Plan Period | dCalendar_planrange |  |
| layoutControlItem12 | chk_allLine |  |
| layoutControlItem13 | chk_Info |  |

## 그리드

- spdMain / Amend: 행 186 · 컬럼 51(보임 50) · 헤더 2단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

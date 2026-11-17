# AS-IS 실측 요약 — FP00611

- 실행: 2026-11-12 19:01:56.136 ~ 2026-11-12 19:02:22.352 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan By Line(Assy) (GSCM.FP.Planning.UIL.FP00611_PlanBy_Line_Assy)
- 조회 결과:  · DB : 8.016s, UI : 0.001s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:01:56.574 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00611 |
| 19:01:56.599 | load | GSCM.FP_Common | SELECT * | 351 | 9.73 | USER_ID= |
| 19:01:56.629 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.14 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:01:56.818 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.46 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:01:56.822 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.74 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:01:56, END_TIME=2026-11-12 19:01:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190156_81, PAR |
| 19:01:56.883 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 33 | 4.4 | USER_ID=jaeuk.shin, MENU_ID=FP00611_Main |
| 19:01:56.917 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.23 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:01:56.925 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00611, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:01:56.933 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 3.98 | p_program_id=FP00611, p_sheet_name=Main |
| 19:01:57.112 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 21.27 | LOGTYPE=SpeedUp, NOTE=FP00611
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:01:57.117 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:01:57.282 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 144.38 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:01:57.331 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:01:57, END_TIME=2026-11-12 19:01:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190157_138, PA |
| 19:01:57.348 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.41 | LOGTYPE=SpeedUp, NOTE=FP00611
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:01:57.352 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.61 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:01:57.408 | load | GSCM.FP_Common | SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG | 85 | 3.7 | USER_ID=jaeuk.shin |
| 19:01:57.443 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.85 | PROG_ID=get_prodtype, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT DIVISION_ID, CODE, NAME, ACTIVE_FLAG
FROM (
                 SELE |
| 19:01:57.525 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 26.12 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLA |
| 19:01:57.543 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.43 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_PL |
| 19:01:57.752 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 131.85 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:01:57.757 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.63 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:01:57, END_TIME=2026-11-12 19:01:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190157_62, PAR |
| 19:01:57.769 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.96 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:01:57.817 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 42.65 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:01:57.829 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.46 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:01:57.837 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 4.15 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:01:57.977 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 128.12 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:01:57.986 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.08 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:01:57, END_TIME=2026-11-12 19:01:57, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190157_848, PA |
| 19:01:58.098 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 62.74 | MenuID=Plan By Line(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 19:01:58.321 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00611 |
| 19:02:08.480 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.69 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:08.488 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 4.57 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:08.496 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.04 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:08.503 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 20 | 4.27 | p_program_id=FP00611, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:08.556 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 8 | 5.99 | BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:08.561 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client par |
| 19:02:08.573 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 56 | 6.13 | PLAN_DATE=20261112, BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:08.578 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.09 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---FOUND PLAN_DATE
-- TY |
| 19:02:08.593 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 3 | 7.27 | BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:08.598 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.38 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client pa |
| 19:02:08.611 | find | GSCM.FP_Common | SELECT 	A.* | 56 | 6.56 | BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:08.617 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.07 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client par |
| 19:02:08.739 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 56 | 116.23 | p_sys_type=SELECT, p_sys_flag=DAY2_WEEK_MONTH, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00611_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLA |
| 19:02:08.751 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.84 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'DAY2_WEEK_MONTH',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00611_ETC |
| 19:02:08.803 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 39.18 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00611_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT |
| 19:02:08.807 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.56 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_763, PARAM_VALUE={p_sys_ |
| 19:02:08.813 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_763, PARAM_VALUE=:202610 |
| 19:02:08.835 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.13 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_763, PARAM_VALUE=:#USER_ |
| 19:02:08.839 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.1 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_763, PARAM_VALUE=W_COL:W |
| 19:02:08.845 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.39 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE_COL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00611_ETC', |
| 19:02:08.851 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.14 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=ME:2026-10-14 (Wed)#_COUNT:1#_VALUE:D30#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261015#_NAME:2026-10-15 (Thu)#_COUNT:1#_VALUE:D31#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261016#_NAME:2 |
| 19:02:08.858 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.06 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=1_Main#!MEA_ID:chk_inqty_tot#MEA_VALUE:false#MEA_NAME:Plan (In)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00611_Main#!MEA_ID:chk_memo#MEA_VALUE:false#MEA_NAME:Memo#TYPE:CATEGORY#FLAG:#USE |
| 19:02:08.862 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=PR_UI_FP00611_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=:W5#M_COL:M1#!D_COL:D42#W_COL:W6#M_COL:M1#!D_COL:D43#W_COL:W6#M_COL:M1#!D_COL:D44#W_COL:W6#M_COL:M1#!D_COL:D45#W_COL:W6#M_COL:M1#!D_COL:D46#W_COL:W6#M_COL:M1#!D_COL:D47#W_COL:W6#M_COL:M1#!D_COL: |
| 19:02:16.441 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 7572.66 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00611_PLAN_BY_LINE_ASSY, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLAN |
| 19:02:16.446 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.01 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:16, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_867, PARAM |
| 19:02:16.451 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.62 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:16, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_867, PARAM |
| 19:02:16.456 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.48 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:16, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_867, PARAM |
| 19:02:16.461 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.75 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:08, END_TIME=2026-11-12 19:02:16, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190208_867, PARAM |
| 19:02:16.466 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.42 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00611_PLAN |
| 19:02:16.508 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.87 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=AME:2026-10-14 (Wed)#_COUNT:1#_VALUE:D30#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261015#_NAME:2026-10-15 (Thu)#_COUNT:1#_VALUE:D31#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:2 |
| 19:02:16.515 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.1 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=11_Main#!MEA_ID:chk_inqty_tot#MEA_VALUE:false#MEA_NAME:Plan (In)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00611_Main#!MEA_ID:chk_memo#MEA_VALUE:false#MEA_NAME:Memo#TYPE:CAT |
| 19:02:16.520 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.69 | PROG_ID=PR_UI_FP00611_PLAN_BY_LINE_ASSY, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=3, QUERY_VALUE=L:W5#M_COL:M1#!D_COL:D42#W_COL:W6#M_COL:M1#!D_COL:D43#W_COL:W6#M_COL:M1#!D_COL:D44#W_COL:W6#M_COL:M1#!D_COL:D45#W_COL:W6#M_COL:M1#!D_COL:D46#W_COL:W6#M_COL:M1#!D_COL:D47#W_COL:W6#M |
| 19:02:16.583 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 41.42 | p_menu_id=FP00611, p_log_type=FIND, p_log_cnt=, p_db_time=8.016, p_ui_time=0.001, p_user_id=jaeuk.shin |
| 19:02:21.624 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.51 | MenuID=Plan By Line(Assy), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plant | clbPlant |  |
| Pjt Group Name | edt_pjtGroup |  |
| Prod.Type | clbProdType |  |
| Site | clbSite |  |
| Line | clbLine |  |
| Nick Name | tbNickName |  |
| layoutControlItem12 | chk_allLine |  |
| layoutControlItem3 | chk_inActive |  |
| Plan Period | drpPeriod |  |
| Plan Group | cboInstance |  |
| Building | clbFactory |  |
| Model | edt_topItem |  |
| Division. | clbDivision |  |
| Operation | clbOperation |  |
| Material | edt_item |  |
| lciHideZero | chk_hide_zero |  |
| lciNoteMemo | chk_use_memo |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 21(보임 20) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

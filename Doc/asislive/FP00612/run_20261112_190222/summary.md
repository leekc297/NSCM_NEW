# AS-IS 실측 요약 — FP00612

- 실행: 2026-11-12 19:02:22.480 ~ 2026-11-12 19:02:42.271 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan By Line(Pack) (GSCM.FP.Planning.UIL.FP00612_PlanBy_Line_Pack)
- 조회 결과: Total : 286 · DB : 2.331s, UI : 0.608s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:02:22.901 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00612 |
| 19:02:22.924 | load | GSCM.FP_Common | SELECT * | 351 | 9.82 | USER_ID= |
| 19:02:22.928 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.5 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:02:23.097 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.18 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:02:23.101 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:02:23, END_TIME=2026-11-12 19:02:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190223_088, PA |
| 19:02:23.131 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 34 | 4.25 | USER_ID=jaeuk.shin, MENU_ID=FP00612_Main |
| 19:02:23.161 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.95 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:02:23.169 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.4 | p_program_id=FP00612, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:02:23.221 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 49.73 | p_program_id=FP00612, p_sheet_name=Main |
| 19:02:23.383 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 21.33 | LOGTYPE=SpeedUp, NOTE=FP00612
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:02:23.387 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:02:23.527 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 129.26 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:02:23.539 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:02:23, END_TIME=2026-11-12 19:02:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190223_397, PA |
| 19:02:23.555 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.54 | LOGTYPE=SpeedUp, NOTE=FP00612
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:02:23.560 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:02:23.613 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 19.59 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLA |
| 19:02:23.679 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 65.35 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_PL |
| 19:02:23.818 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 133.01 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:02:23.821 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.27 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:02:23, END_TIME=2026-11-12 19:02:23, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190223_684, PA |
| 19:02:23.838 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.7 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:23.847 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 4.45 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:23.856 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:23.864 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 3.79 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:24.069 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 163.43 | MenuID=Plan By Line(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 19:02:24.265 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00612 |
| 19:02:33.247 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.01 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:33.257 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 5.32 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:33.273 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.73 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:33.281 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 3.96 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:33.298 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 8 | 3.47 | BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:33.303 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.39 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client par |
| 19:02:33.325 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 56 | 15.34 | PLAN_DATE=20261112, BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:33.339 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.3 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---FOUND PLAN_DATE
-- TY |
| 19:02:33.354 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 3 | 7.07 | BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:33.360 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.12 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client pa |
| 19:02:33.372 | find | GSCM.FP_Common | SELECT 	A.* | 56 | 4.79 | BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:33.382 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.51 | PROG_ID=find_bukInfo, QUERY_ID=FP\Common\AmendCommon, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client par |
| 19:02:33.403 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 56 | 13.33 | p_sys_type=SELECT, p_sys_flag=DAY2_WEEK_MONTH, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLA |
| 19:02:33.407 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'DAY2_WEEK_MONTH',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_ETC |
| 19:02:33.450 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 33.97 | p_sys_type=SELECT, p_sys_flag=CURR_DATE_COL, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_ETC, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT |
| 19:02:33.456 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.37 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:33, END_TIME=2026-11-12 19:02:33, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190233_415, PARAM_VALUE={p_sys_ |
| 19:02:33.463 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.52 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:33, END_TIME=2026-11-12 19:02:33, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190233_415, PARAM_VALUE=10-15 ( |
| 19:02:33.482 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.42 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:33, END_TIME=2026-11-12 19:02:33, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190233_415, PARAM_VALUE=FP00612 |
| 19:02:33.486 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.49 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'CURR_DATE_COL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_ETC', |
| 19:02:33.492 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.52 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=COUNT:1#_VALUE:D30#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261015#_NAME:2026-10-15 (Thu)#_COUNT:1#_VALUE:D31#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261016#_NAME:2026-10-16 (Fri)#_COUN |
| 19:02:33.497 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.17 | PROG_ID=PR_UI_FP00612_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=onth#MEA_VALUE:true#MEA_NAME:Month#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00612_Main#!MEA_ID:chk_mpp_inqty#MEA_VALUE:true#MEA_NAME:MPP Plan (In)#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin# |
| 19:02:35.499 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 286 | 1996.87 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00612_PLAN_BY_LINE_PACK, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLAN |
| 19:02:35.551 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.94 | PROG_ID=PR_UI_FP00612_PLAN_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:33, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190233_502, PARAM |
| 19:02:35.555 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.09 | PROG_ID=PR_UI_FP00612_PLAN_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:33, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190233_502, PARAM |
| 19:02:35.561 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.19 | PROG_ID=PR_UI_FP00612_PLAN_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:33, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190233_502, PARAM |
| 19:02:35.566 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.28 | PROG_ID=PR_UI_FP00612_PLAN_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00612_PLAN |
| 19:02:35.571 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.77 | PROG_ID=PR_UI_FP00612_PLAN_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=_COUNT:1#_VALUE:D30#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261015#_NAME:2026-10-15 (Thu)#_COUNT:1#_VALUE:D31#_DATE_SEQ:1#WEEK_SEQ:202642#_TYPE:D#!_DATE:20261016#_NAME:2026-10 |
| 19:02:35.575 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.12 | PROG_ID=PR_UI_FP00612_PLAN_BY_LINE_PACK, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=1, INST_SEQ=2, QUERY_VALUE=month#MEA_VALUE:true#MEA_NAME:Month#TYPE:CATEGORY#FLAG:#USER_ID:jaeuk.shin#MENU_ID:FP00612_Main#!MEA_ID:chk_mpp_inqty#MEA_VALUE:true#MEA_NAME:MPP Plan (In)#TYPE:CATEGORY#FLAG:#USER |
| 19:02:35.655 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.04 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:35.664 | find | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 19 | 4.27 | p_program_id=FP00612, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:02:35.801 | find | GSCM.FP_Common | SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID | 0 | 117.5 | INSTANCE_ID=KR_PACK, BUCKET_FROM=20260914, BUCKET_TO=20261108 |
| 19:02:35.807 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.17 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_683, PARAM_VALUE={AMEND_INSTANCE : LINE_AMEN |
| 19:02:35.813 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.85 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_683, PARAM_VALUE=EQ:1#WEEK_SEQ:202642#_TYPE: |
| 19:02:35.817 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.51 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_683, PARAM_VALUE=n#MENU_ID:FP00612_Main#!MEA |
| 19:02:35.822 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.17 | PROG_ID=list_memo, QUERY_ID=FP\Common\AmendMemo, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : |
| 19:02:35.835 | find | GSCM.FP_Common | SELECT * FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) | 10 | 4.77 | USER_ID=jaeuk.shin |
| 19:02:35.851 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.45 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_829, PARAM_VALUE={AMEND_INSTANCE : LINE_A |
| 19:02:35.881 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.29 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_829, PARAM_VALUE=EQ:1#WEEK_SEQ:202642#_TY |
| 19:02:35.886 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.42 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_829, PARAM_VALUE=n#MENU_ID:FP00612_Main#! |
| 19:02:35.922 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.19 | PROG_ID=find_Category, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check client parame |
| 19:02:35.939 | find | GSCM.FP_Common | SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS UI_PARAM, A.SEGMENT3 AS UI_COLOR | 0 | 4.32 | INSTANCE_ID=KR_PACK |
| 19:02:35.979 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.36 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_932, PARAM_VALUE={AMEND_INSTANCE :  |
| 19:02:35.984 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_932, PARAM_VALUE=EQ:1#WEEK_SEQ:2026 |
| 19:02:35.990 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.53 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:02:35, END_TIME=2026-11-12 19:02:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190235_932, PARAM_VALUE=n#MENU_ID:FP00612_ |
| 19:02:36.043 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.24 | PROG_ID=find_Category_Color, QUERY_ID=FP\Common\PICAlarm, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check cli |
| 19:02:36.258 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 27.04 | p_menu_id=FP00612, p_log_type=FIND, p_log_cnt=, p_db_time=2.331, p_ui_time=0.608, p_user_id=jaeuk.shin |
| 19:02:41.545 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.59 | MenuID=Plan By Line(Pack), CnntCode=0104002, UserID=jaeuk.shin |

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

## 그리드

- spdMain / Amend: 행 278 · 컬럼 23(보임 22) · 헤더 2단 · 고정 컬럼 19

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

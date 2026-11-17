# AS-IS 실측 요약 — FP00100N

- 실행: 2026-11-12 18:24:44.333 ~ 2026-11-12 18:25:37.219 · 계정 jaeuk.shin · 상태 OK
- 화면: Line (GSCM.FP.Master.UIL.FP00100_Line)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:24:44.680 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.6 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:24:44.684 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:44, END_TIME=2026-11-12 18:24:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182444_672, PA |
| 18:24:44.788 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00100N |
| 18:24:44.802 | load | GSCM.FP_Common | SELECT * | 351 | 10.27 | USER_ID= |
| 18:24:44.830 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.98 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:24:46.297 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 13 | 1311.71 | p_code=findAmendInstanceList_common, p_user_id=jaeuk.shin, param1=LINE_AMEND_E_PRE, param2=Y, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:24:46.336 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.62 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'findAmendInstanceList_common',@p_user_id=N'jaeuk.shin',@param1=N'LINE_AMEND_E_PRE',@param2=N'Y',@param3=N'',@param4=N'',@ |
| 18:24:46.353 | load | GSCM.FP_Common | SELECT a.segment1 as CODE, a.segment1 as NAME | 3 | 6.43 | USER_ID=jaeuk.shin |
| 18:24:46.381 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.34 | PROG_ID=find_instance, QUERY_ID=FP\MASTER\FP00460_SetupGroup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

                SELECT a.segment1 as CODE, a.segment1 as NAME
              |
| 18:24:47.301 | load | GSCM.FP_Common | WITH LINE_SETUP_INSTANCE | 102 | 914.92 | USER_ID=jaeuk.shin |
| 18:24:47.331 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.64 | PROG_ID=find_line_operation_group, QUERY_ID=FP\MASTER\FP00460_SetupGroup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

WITH LINE_SETUP_INSTANCE
AS
( SELECT a.segment1 as INSTANCE_ID, |
| 18:24:47.537 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 103 | 195.95 | p_code=FP00100_findLineLookup, p_user_id=jaeuk.shin, param1=LINE_ATTRIBUTE, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:24:47.617 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 79.54 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00100_findLineLookup',@p_user_id=N'jaeuk.shin',@param1=N'LINE_ATTRIBUTE',@param2=N'',@param3=N'',@param4=N'',@param5=N' |
| 18:24:47.644 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 114 | 15.51 | p_code=FP00100_findLineLookup, p_user_id=jaeuk.shin, param1=LINE_LOCATION, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:24:47.665 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.27 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00100_findLineLookup',@p_user_id=N'jaeuk.shin',@param1=N'LINE_LOCATION',@param2=N'',@param3=N'',@param4=N'',@param5=N'' |
| 18:24:47.685 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 239 | 8.79 | p_code=FP00100_findLineLookup, p_user_id=jaeuk.shin, param1=LINE_MODEL_TYPE, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:24:47.758 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 72.54 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00100_findLineLookup',@p_user_id=N'jaeuk.shin',@param1=N'LINE_MODEL_TYPE',@param2=N'',@param3=N'',@param4=N'',@param5=N |
| 18:24:47.848 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 284 | 81.0 | p_code=FP00100_findMatrix_linesetup, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:24:47.897 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.83 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00100_findMatrix_linesetup',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:24:48.724 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 0 | 808.14 | p_code=FP00100_find_virtual_factory, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:24:48.757 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.94 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00100_find_virtual_factory',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:24:48.784 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 4.17 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 18:24:48.812 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.74 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 18:24:54.647 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 5829.78 | USER_ID=jaeuk.shin |
| 18:24:54.651 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.25 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:24:48, END_TIME=2026-11-12 18:24:54, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182448_816, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 18:24:54.655 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.18 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 18:24:54.724 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 68.57 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 18:24:54.795 | load | GSCM.FP_Common | SELECT | 145 | 6.71 | USER_ID=jaeuk.shin |
| 18:24:54.799 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 18:24:54.813 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.77 | USER_ID=jaeuk.shin |
| 18:24:54.817 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.34 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 18:24:54.832 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 5.27 | USER_ID=jaeuk.shin |
| 18:24:54.840 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.92 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 18:24:55.068 | load | GSCM.FP_Common | UI_FP_COMMON | 10 | 26.96 | code=ELECTRODE_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:24:55.072 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.59 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_041, PA |
| 18:24:55.104 | load | GSCM.FP_Common | UI_FP_COMMON | 17 | 7.02 | code=COUNTRY_ID, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25= |
| 18:24:55.108 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_097, PA |
| 18:24:55.125 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.74 | p_program_id=FP00100, p_sheet_name=Line(FP), p_user_id=jaeuk.shin |
| 18:24:55.155 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 26.56 | p_program_id=FP00100, p_sheet_name=Line(FP) |
| 18:24:55.162 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.18 | p_program_id=FP00100, p_sheet_name=Line(FP), p_user_id=jaeuk.shin |
| 18:24:55.169 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.17 | p_program_id=FP00100, p_sheet_name=Line(FP) |
| 18:24:55.186 | load | GSCM.FP_Common | UI_FP_COMMON | 10 | 7.63 | code=ELECTRODE_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param |
| 18:24:55.189 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_178, PA |
| 18:24:55.207 | load | GSCM.FP_Common | UI_FP_COMMON | 9 | 10.7 | code=LINE_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 18:24:55.212 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_197, PA |
| 18:24:55.266 | load | GSCM.FP_Common | UI_FP_COMMON | 50 | 46.77 | code=LINE_MODEL_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 18:24:55.270 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_219, PA |
| 18:24:55.289 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 10.34 | code=LINE_ATTRIBUTE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param |
| 18:24:55.292 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.37 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_278, PA |
| 18:24:55.309 | load | GSCM.FP_Common | UI_FP_COMMON | 5 | 8.87 | code=LINE_LOCATION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 18:24:55.313 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.35 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:24:55, END_TIME=2026-11-12 18:24:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182455_3, PARA |
| 18:24:55.337 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.27 | p_program_id=FP00100, p_sheet_name=WIP_LEVEL, p_user_id=jaeuk.shin |
| 18:24:55.349 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 8.8 | p_program_id=FP00100, p_sheet_name=WIP_LEVEL |
| 18:24:55.359 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.8 | p_program_id=FP00100, p_sheet_name=WIP_LEVEL, p_user_id=jaeuk.shin |
| 18:24:55.366 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.02 | p_program_id=FP00100, p_sheet_name=WIP_LEVEL |
| 18:24:55.465 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.2 | MenuID=Line, CnntCode=0104001, UserID=jaeuk.shin |
| 18:24:55.503 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00100N |
| 18:25:29.846 | find | GSCM.FP_Common | PR_UI_FP00100_LINE | 3384 | 26359.1 | p_sys_type=SELECT, p_sys_flag=S, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A7,A8,A9,AA,AB,AC, |
| 18:25:29.850 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.27 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00100_LINE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00100_LINE @p_sys_type=N'SELECT',@p_sys_flag=N'S',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'40,81,81_HD,81_HM,81_ST,81_UC |
| 18:25:32.031 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 47.55 | p_menu_id=FP00100N, p_log_type=FIND, p_log_cnt=3384, p_db_time=26.566, p_ui_time=2.051, p_user_id=jaeuk.shin |
| 18:25:36.495 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.35 | MenuID=Line, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Building | clbBuilding |  |
| Operation | clbOperation |  |
| Active | cboActive |  |
| Site | clbSite |  |
| Line | clbLine |  |
| lblExcelImport | btnImport |  |
| lblSql | btnSql |  |
| Div | clbDivision |  |

## 그리드

- spdMain / Line(FP): 행 3384 · 컬럼 29(보임 24) · 헤더 1단 · 고정 컬럼 8
- spdSub / WIP_LEVEL: 행 0 · 컬럼 19(보임 18) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

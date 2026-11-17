# AS-IS 실측 요약 — FP01551A

- 실행: 2026-11-12 22:09:15.133 ~ 2026-11-12 22:10:08.323 · 계정 jaeuk.shin · 상태 OK
- 화면: In-house Request Plan(Pack) (GSCM.FP.Planning.UIL.FP01551_In_House_Request_Plan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "drpPlanDate", "prop": "DateTime", "value": "20260919"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:09:15.594 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01551 |
| 22:09:15.615 | load | GSCM.FP_Common | SELECT * | 351 | 11.58 | USER_ID= |
| 22:09:15.645 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.3 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:09:15.724 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.04 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:09:15.727 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:09:15, END_TIME=2026-11-12 22:09:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220915_717, PA |
| 22:09:15.760 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 11 | 3.65 | USER_ID=jaeuk.shin, MENU_ID=FP01551_Main |
| 22:09:15.791 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.18 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:09:15.799 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.43 | p_program_id=FP01551, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:09:15.849 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 47.81 | p_program_id=FP01551, p_sheet_name=Main |
| 22:09:16.037 | load | GSCM.FP_Common | UI_FP_COMMON | 8 | 149.77 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PSI_AMEND_PACK, param22=, param23=, p |
| 22:09:16.054 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.58 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:09:15, END_TIME=2026-11-12 22:09:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220915_887, PA |
| 22:09:16.101 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.86 | LOGTYPE=SpeedUp, NOTE=FP01551
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 22:09:16.105 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:09:16.129 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 2.81 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 22:09:16.162 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.61 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 22:09:20.317 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4144.38 | USER_ID=jaeuk.shin |
| 22:09:20.343 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.46 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:09:16, END_TIME=2026-11-12 22:09:20, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220916_166, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 22:09:20.348 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.54 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Check client parame |
| 22:09:20.352 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.12 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=    ACTIVE_FLAG = 'Y'
				) VK
				ON 1=1
				AND FL.INSTANCE_ID = VK.INSTANCE_ID

INNER JOIN SCM_FACTORY_M  F WITH(NOLOCK)
ON FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ |
| 22:09:20.421 | load | GSCM.FP_Common | SELECT | 145 | 8.24 | USER_ID=jaeuk.shin |
| 22:09:20.444 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.62 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Check client par |
| 22:09:20.459 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.38 | USER_ID=jaeuk.shin |
| 22:09:20.509 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.45 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Check client pa |
| 22:09:20.526 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 7.29 | USER_ID=jaeuk.shin |
| 22:09:20.578 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.84 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---C |
| 22:09:20.736 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 135.79 | code=CURR_UTDATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:09:20.784 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:09:20, END_TIME=2026-11-12 22:09:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220920_6, PARA |
| 22:09:21.246 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 436.27 | p_sys_type=SELECT, p_sys_flag=RELEASE_PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01551_ETC, opt_none=, in_columns=AMEND_INSTANCE^OPERATION_ID^PLAN_DATE^BUCKET^USER_ID^INSTANCE_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI_AMEND_PACK^P5000^20261112^D^mXlVW48SU1c3 |
| 22:09:21.267 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.77 | PROG_ID=PR_UI_FP01551_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'RELEASE_PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01551_E |
| 22:09:21.319 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 46.63 | LOGTYPE=SpeedUp, NOTE=FP01551
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 22:09:21.323 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.48 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:09:21.382 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 40.86 | code=CURR_UTDATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:09:21.386 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.44 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:09:21, END_TIME=2026-11-12 22:09:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220921_34, PAR |
| 22:09:21.398 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.9 | p_program_id=FP01551, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:09:21.405 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.74 | p_program_id=FP01551, p_sheet_name=Amend |
| 22:09:21.412 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.75 | p_program_id=FP01551, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:09:21.419 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.86 | p_program_id=FP01551, p_sheet_name=Amend |
| 22:09:21.545 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 89.62 | MenuID=In-house Request Plan(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 22:09:21.608 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01551 |
| 22:09:30.097 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 1 | 209.05 | p_sys_type=SELECT, p_sys_flag=RELEASE_PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01551_ETC, opt_none=, in_columns=AMEND_INSTANCE^OPERATION_ID^PLAN_DATE^BUCKET^USER_ID^INSTANCE_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^MASTER_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^P |
| 22:09:30.102 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.92 | PROG_ID=PR_UI_FP01551_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'RELEASE_PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01551_E |
| 22:09:34.875 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.28 | p_program_id=FP01551, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:09:34.882 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.87 | p_program_id=FP01551, p_sheet_name=Amend |
| 22:09:34.889 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.56 | p_program_id=FP01551, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 22:09:34.896 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.08 | p_program_id=FP01551, p_sheet_name=Amend |
| 22:09:34.915 | find | GSCM.FP_Common | SELECT ISO_YYYYWW AS WEEK | 17 | 6.01 | BUCKET_FROM=20260919, BUCKET_TO=20270106 |
| 22:09:34.920 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=find_WeekCnt, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check cl |
| 22:09:34.931 | find | GSCM.FP_Common | SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN | 110 | 6.26 | PLAN_DATE=20260919, BUCKET_FROM=20260919, BUCKET_TO=20270106 |
| 22:09:34.957 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.23 | PROG_ID=find_DateMap, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client |
| 22:09:34.970 | find | GSCM.FP_Common | SELECT YYYYMM AS MONTH | 5 | 6.2 | BUCKET_FROM=20260919, BUCKET_TO=20270106 |
| 22:09:34.982 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.89 | PROG_ID=find_MonthCnt, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check c |
| 22:09:34.996 | find | GSCM.FP_Common | SELECT 	A.* | 110 | 8.58 | BUCKET_FROM=20260919, BUCKET_TO=20270106 |
| 22:09:35.032 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.45 | PROG_ID=find_BukInfo, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0BUCKET_FROM
---Service Parameter : 1BUCKET_TO
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check cl |
| 22:09:35.088 | find | GSCM.FP_Common | SELECT MAX(B.SEGMENT1) AS INSTANCE_ID, (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY | 1 | 47.43 | INSTANCE_ID=KR_PACK |
| 22:09:35.092 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=find_CellAssyYN, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:09:35, END_TIME=2026-11-12 22:09:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220935_04, PARAM_VALUE={AMEND_INSTANC |
| 22:09:35.098 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.31 | PROG_ID=find_CellAssyYN, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:09:35, END_TIME=2026-11-12 22:09:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220935_04, PARAM_VALUE= (Fri)#_COUNT: |
| 22:09:35.102 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=find_CellAssyYN, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=2, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:09:35, END_TIME=2026-11-12 22:09:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220935_04, PARAM_VALUE=UNT:1#_VALUE:D |
| 22:09:35.121 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.86 | PROG_ID=find_CellAssyYN, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=0, INST_SEQ=3, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:09:35, END_TIME=2026-11-12 22:09:35, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220935_04, PARAM_VALUE=E:2026W49#WEEK |
| 22:09:35.135 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.61 | PROG_ID=find_CellAssyYN, QUERY_ID=FP\Common\FP01551_PlanAmend, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Chec |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| Plan Group | cboInstance |  |
| Plan Date | drpPlanDate |  |
| Plan Id | cboPlanId |  |
| Division. | clbDivision |  |
| Site | cboSite |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Cell Code | txtCellCode |  |
| Nick Name(Cell) | txtNickName |  |
| Plan Period | drpPeriod |  |
| layoutControlItem13 | chk_Info |  |
| layoutControlItem2 | chk_lineAssign |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 24(보임 23) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — FP01551A

- 실행: 2026-11-12 19:15:30.697 ~ 2026-11-12 19:16:28.207 · 계정 jaeuk.shin · 상태 OK
- 화면: In-house Request Plan(Pack) (GSCM.FP.Planning.UIL.FP01551_In_House_Request_Plan)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:15:31.919 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01551 |
| 19:15:31.944 | load | GSCM.FP_Common | SELECT * | 351 | 9.64 | USER_ID= |
| 19:15:32.007 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 62.48 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:15:32.277 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.25 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:15:32.281 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.67 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:15:32, END_TIME=2026-11-12 19:15:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191532_27, PAR |
| 19:15:32.392 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 11 | 4.04 | USER_ID=jaeuk.shin, MENU_ID=FP01551_Main |
| 19:15:32.415 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.12 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:15:32.427 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP01551, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:15:32.477 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 45.09 | p_program_id=FP01551, p_sheet_name=Main |
| 19:15:32.721 | load | GSCM.FP_Common | UI_FP_COMMON | 8 | 140.17 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=PSI_AMEND_PACK, param22=, param23=, p |
| 19:15:32.744 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.51 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:15:32, END_TIME=2026-11-12 19:15:32, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191532_581, PA |
| 19:15:32.849 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.31 | LOGTYPE=SpeedUp, NOTE=FP01551
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:15:32.895 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.99 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:15:32.945 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 4.05 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 19:15:32.968 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.17 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 19:15:37.892 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4915.27 | USER_ID=jaeuk.shin |
| 19:15:37.896 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:15:32, END_TIME=2026-11-12 19:15:37, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191532_975, PARAM_VALUE={AMEND_INSTANCE : PSI_AM |
| 19:15:37.929 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.64 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Check client parame |
| 19:15:37.952 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.18 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=    ACTIVE_FLAG = 'Y'
				) VK
				ON 1=1
				AND FL.INSTANCE_ID = VK.INSTANCE_ID

INNER JOIN SCM_FACTORY_M  F WITH(NOLOCK)
ON FL.FACTORY_ID = F.FACTORY_ID

INNER JOIN SCM_COMPANY_M C WITH(NOLOCK)
ON FL.COMPANY_ |
| 19:15:38.083 | load | GSCM.FP_Common | SELECT | 145 | 6.27 | USER_ID=jaeuk.shin |
| 19:15:38.104 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.66 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Check client par |
| 19:15:38.122 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.42 | USER_ID=jaeuk.shin |
| 19:15:38.161 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.12 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---Check client pa |
| 19:15:38.187 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 5.48 | USER_ID=jaeuk.shin |
| 19:15:38.215 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.15 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : OPERATION_ID
---Check client parameter : PLAN_DATE
---Check client parameter : BUCKET
---C |
| 19:15:38.464 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 201.66 | code=CURR_UTDATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:15:38.468 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.9 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:15:38, END_TIME=2026-11-12 19:15:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191538_263, PA |
| 19:15:39.143 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 0 | 661.13 | p_sys_type=SELECT, p_sys_flag=RELEASE_PLAN_INFO, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP01551_ETC, opt_none=, in_columns=AMEND_INSTANCE^OPERATION_ID^PLAN_DATE^BUCKET^USER_ID^INSTANCE_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=PSI_AMEND_PACK^P5000^20261112^D^mXlVW48SU1c3 |
| 19:15:39.148 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.16 | PROG_ID=PR_UI_FP01551_ETC, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'RELEASE_PLAN_INFO',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP01551_E |
| 19:15:39.205 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 44.24 | LOGTYPE=SpeedUp, NOTE=FP01551
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:15:39.209 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.66 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:15:39.326 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 64.72 | code=CURR_UTDATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_PACK, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:15:39.376 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:15:39, END_TIME=2026-11-12 19:15:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191539_261, PA |
| 19:15:39.395 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP01551, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:15:39.405 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.07 | p_program_id=FP01551, p_sheet_name=Amend |
| 19:15:39.415 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.1 | p_program_id=FP01551, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:15:39.424 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 3.99 | p_program_id=FP01551, p_sheet_name=Amend |
| 19:15:39.617 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 78.58 | MenuID=In-house Request Plan(Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 19:15:39.860 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01551 |
| 19:16:27.558 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.46 | MenuID=In-house Request Plan(Pack), CnntCode=0104002, UserID=jaeuk.shin |

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

## 대화상자

- 2026-11-12 19:15:51.081 [] You need to select one plan to proceed → default_button(id=1)

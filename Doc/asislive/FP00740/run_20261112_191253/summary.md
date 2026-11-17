# AS-IS 실측 요약 — FP00740

- 실행: 2026-11-12 19:12:53.542 ~ 2026-11-12 19:13:27.737 · 계정 jaeuk.shin · 상태 OK
- 화면: Theory Stock (GSCM.FP.Master.UIL.FP00740_Theory_Stock)
- 조회 결과: Total : 87,827 · DB : 9.443s, UI : 1.325s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:12:53.988 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 27.88 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:12:53.993 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:12:53, END_TIME=2026-11-12 19:12:53, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191253_96, PAR |
| 19:12:54.912 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00740 |
| 19:12:54.941 | load | GSCM.FP_Common | SELECT * | 351 | 11.91 | USER_ID= |
| 19:12:54.946 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.47 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:12:55.356 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 4.1 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 19:12:55.360 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 19:13:00.253 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4881.4 | USER_ID=jaeuk.shin |
| 19:13:00.309 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.25 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:12:55, END_TIME=2026-11-12 19:13:00, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191255_37, PARAM_VALUE={AMEND_INSTANCE : LINE_AM |
| 19:13:00.314 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.0 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC0 |
| 19:13:00.320 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.94 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE== D.DIVISION_ID
AND FL.COMPANY_ID = D.COMPANY_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
 |
| 19:13:00.462 | load | GSCM.FP_Common | SELECT | 145 | 7.17 | USER_ID=jaeuk.shin |
| 19:13:00.466 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.6 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID,  |
| 19:13:00.483 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.27 | USER_ID=jaeuk.shin |
| 19:13:00.494 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.05 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID,  |
| 19:13:00.514 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 5.82 | USER_ID=jaeuk.shin |
| 19:13:00.519 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.63 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGME |
| 19:13:00.819 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP00740, p_sheet_name=Theory_Stock, p_user_id=jaeuk.shin |
| 19:13:00.828 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 4.52 | p_program_id=FP00740, p_sheet_name=Theory_Stock |
| 19:13:00.840 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP00740, p_sheet_name=Theory_Stock, p_user_id=jaeuk.shin |
| 19:13:00.850 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 4.24 | p_program_id=FP00740, p_sheet_name=Theory_Stock |
| 19:13:01.205 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 65.82 | MenuID=Theory Stock, CnntCode=0104001, UserID=jaeuk.shin |
| 19:13:01.326 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.81 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00740 |
| 19:13:17.832 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 87827 | 7801.92 | p_sys_type=SELECT, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00740_FIND_FP00740, opt_none=, in_columns=AMEND_INSTANCE^USER_ID^INSTANCE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^LINE_ID^CHK_LINE_ASSIGN^, in_row=LINE_AMEND_E_PRE^mXlVW48SU1c3wPszIA83/w==^KR_E_PRE_A,KR_E_PRE_A2,KR_E |
| 19:13:17.837 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.05 | PROG_ID=PR_UI_FP00740_FIND_FP00740, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'SELECT',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00740_FIND_FP |
| 19:13:20.792 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.89 | p_menu_id=FP00740, p_log_type=FIND, p_log_cnt=87827, p_db_time=9.443, p_ui_time=1.325, p_user_id=jaeuk.shin |
| 19:13:26.433 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.01 | MenuID=Theory Stock, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Mixer Material | txtItemID |  |
| lblSql | btnSql |  |
| Plant | clbPlant |  |
| Building | cboFactory |  |
| Line | cboLine |  |
| Instance | clbInstance |  |
| layoutControlItem5 | chk_lineAssign |  |

## 그리드

- spdMain / Theory_Stock: 행 87827 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

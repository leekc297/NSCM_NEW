# AS-IS 실측 요약 — FP00413

- 실행: 2026-11-12 18:31:48.150 ~ 2026-11-12 18:32:14.194 · 계정 jaeuk.shin · 상태 OK
- 화면: Formation Tray Master (GSCM.FP.Master.UIL.FP00413_Formation_Tray_Master)
- 조회 결과: Total : 503 · DB : 4.628s, UI : 0.312s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:31:48.662 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 149.3 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:31:48.667 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.13 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:31:48, END_TIME=2026-11-12 18:31:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183148_513, PA |
| 18:31:49.072 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00413 |
| 18:31:49.096 | load | GSCM.FP_Common | SELECT * | 351 | 14.12 | USER_ID= |
| 18:31:49.137 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.03 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:31:49.286 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 3.49 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 18:31:49.430 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 143.61 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 18:31:54.127 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4689.83 | USER_ID=jaeuk.shin |
| 18:31:54.308 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 181.09 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:31:49, END_TIME=2026-11-12 18:31:54, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183149_436, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 18:31:54.345 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.86 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 18:31:54.470 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 125.09 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 18:31:54.563 | load | GSCM.FP_Common | SELECT | 145 | 4.91 | USER_ID=jaeuk.shin |
| 18:31:54.904 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 340.98 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 18:31:54.920 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.16 | USER_ID=jaeuk.shin |
| 18:31:55.034 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 113.85 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 18:31:55.049 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.53 | USER_ID=jaeuk.shin |
| 18:31:55.127 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 77.79 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 18:31:55.237 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.45 | p_program_id=FP00413, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:31:55.244 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 15 | 3.86 | p_program_id=FP00413, p_sheet_name=Main |
| 18:31:55.251 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.69 | p_program_id=FP00413, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:31:55.267 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 15 | 3.98 | p_program_id=FP00413, p_sheet_name=Main |
| 18:31:55.606 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 231.0 | MenuID=Formation Tray Master, CnntCode=0104001, UserID=jaeuk.shin |
| 18:31:55.729 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00413 |
| 18:32:05.307 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 503 | 1863.66 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00413_FIND_FP00413, opt_none=, in_columns=USER_ID^SITE_ID^PLANT_ID^TRAY_TYPE^, in_row=mXlVW48SU1c3wPszIA83/w==^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,N |
| 18:32:05.450 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 142.83 | PROG_ID=PR_UI_FP00413_FIND_FP00413, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00413_FIND_FP |
| 18:32:07.799 | find | GSCM.FP_Common | SELECT   DISTINCT | 398 | 2331.55 |  |
| 18:32:08.049 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 249.1 | PROG_ID=find_Tray, QUERY_ID=FP\Master\FP00413_FormationTrayMaster, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0CTRL_SITE_ID
---Service Parameter : 1CTRL_PLANT_ID
---Service Parameter : 2CTRL_DIVISION_ID
---Check client parameter : USER_ID
---Check client parameter : DIVISION_ID
---C |
| 18:32:08.407 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 33.04 | p_menu_id=FP00413, p_log_type=FIND, p_log_cnt=503, p_db_time=4.628, p_ui_time=0.312, p_user_id=jaeuk.shin |
| 18:32:13.530 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.31 | MenuID=Formation Tray Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem5 | btnExcel |  |
| Div | clbDivision |  |
| Plant | clbPlant |  |
| Active | usrLabel1 |  |
| layoutControlItem7 | radioActiveAll |  |
| layoutControlItem8 | radioActiveY |  |
| layoutControlItem9 | radioActiveN |  |
| Site | cboSite |  |
| Tray ID | textTrayId |  |
| layoutControlItem2 | cbOnlyGroupTray |  |
| Tray Type | cboTray |  |

## 그리드

- spdMain / Main: 행 503 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

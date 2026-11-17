# AS-IS 실측 요약 — FP00731N

- 실행: 2026-11-12 19:11:49.991 ~ 2026-11-12 19:12:35.659 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock (GSCM.FP.Planning.UIL.FP00731_Stock)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:11:50.382 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 32.0 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:11:50.387 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.75 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:11:50, END_TIME=2026-11-12 19:11:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191150_35, PAR |
| 19:11:50.538 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00731 |
| 19:11:50.554 | load | GSCM.FP_Common | SELECT * | 351 | 10.73 | USER_ID= |
| 19:11:50.559 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.66 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:11:50.815 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 11.42 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:11:50.820 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.25 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:11:50, END_TIME=2026-11-12 19:11:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191150_803, PA |
| 19:11:50.914 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 6.43 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 19:11:50.939 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.8 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 19:11:54.969 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4022.72 | USER_ID=jaeuk.shin |
| 19:11:54.997 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.55 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:11:50, END_TIME=2026-11-12 19:11:54, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191150_946, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 19:11:55.003 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.89 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 19:11:55.007 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.13 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 19:11:55.133 | load | GSCM.FP_Common | SELECT | 145 | 4.54 | USER_ID=jaeuk.shin |
| 19:11:55.137 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 19:11:55.155 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.65 | USER_ID=jaeuk.shin |
| 19:11:55.163 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.46 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 19:11:55.178 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.31 | USER_ID=jaeuk.shin |
| 19:11:55.184 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.11 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 19:11:55.248 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.99 | LOGTYPE=SpeedUp, NOTE=FP00731
division_id_changed
start
, USER_ID=jaeuk.shin |
| 19:11:55.273 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.97 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:11:55.334 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.58 | LOGTYPE=SpeedUp, NOTE=FP00731
division_id_changed
end
, USER_ID=jaeuk.shin |
| 19:11:55.338 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.71 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:11:55.486 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP00731, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:11:55.517 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 41 | 26.87 | p_program_id=FP00731, p_sheet_name=Main |
| 19:11:55.527 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.27 | p_program_id=FP00731, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:11:55.537 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 41 | 4.43 | p_program_id=FP00731, p_sheet_name=Main |
| 19:11:55.709 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 88.36 | MenuID=Stock, CnntCode=0104001, UserID=jaeuk.shin |
| 19:11:55.805 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00731 |
| 19:12:04.601 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.44 | p_program_id=FP00731, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:12:04.610 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 41 | 4.71 | p_program_id=FP00731, p_sheet_name=Main |
| 19:12:04.618 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.32 | p_program_id=FP00731, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:12:04.627 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 41 | 5.51 | p_program_id=FP00731, p_sheet_name=Main |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Cut Off Date | drpCutoffDate |  |
| Div | clbDivision |  |
| lblSql | btnSql |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Operation | clbOperation |  |
| Stock Type | clbStockType |  |
| Material(FP) | txtItemId |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 42(보임 41) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

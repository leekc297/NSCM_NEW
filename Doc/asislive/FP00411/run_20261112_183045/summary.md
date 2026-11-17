# AS-IS 실측 요약 — FP00411

- 실행: 2026-11-12 18:30:45.002 ~ 2026-11-12 18:31:31.727 · 계정 jaeuk.shin · 상태 OK
- 화면: FCS Shorter Aging Routing (GSCM.FP.Master.UIL.FP00411_FCS_Shorter_Aging_Routing)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:30:45.417 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 25.7 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:30:45.420 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.41 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:30:45, END_TIME=2026-11-12 18:30:45, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183045_391, PA |
| 18:30:45.896 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.4 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00411 |
| 18:30:45.921 | load | GSCM.FP_Common | SELECT * | 351 | 12.88 | USER_ID= |
| 18:30:45.957 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.36 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:30:46.211 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 2.98 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 18:30:46.251 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.06 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 18:30:50.593 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4336.4 | USER_ID=jaeuk.shin |
| 18:30:51.258 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 664.61 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:30:46, END_TIME=2026-11-12 18:30:50, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183046_257, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 18:30:51.280 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.55 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 18:30:51.350 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 68.63 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 18:30:51.436 | load | GSCM.FP_Common | SELECT | 145 | 6.34 | USER_ID=jaeuk.shin |
| 18:30:51.464 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.11 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 18:30:51.481 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.64 | USER_ID=jaeuk.shin |
| 18:30:51.554 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.68 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 18:30:51.567 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.36 | USER_ID=jaeuk.shin |
| 18:30:51.632 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.38 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 18:30:51.829 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.12 | p_program_id=FP00411, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:30:52.978 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 1146.03 | p_program_id=FP00411, p_sheet_name=Main |
| 18:30:52.991 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP00411, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:30:52.998 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.18 | p_program_id=FP00411, p_sheet_name=Main |
| 18:30:53.541 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 446.74 | MenuID=FCS Shorter Aging Routing, CnntCode=0104001, UserID=jaeuk.shin |
| 18:30:53.636 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00411 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Div | clbDivision |  |
| Line | clbLine |  |
| Site | clbSite |  |
| Material | txtItemId |  |
| Nick Name | txtNickName |  |
| lblSql | btnSql |  |
| layoutControlItem5 | btnExcel |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

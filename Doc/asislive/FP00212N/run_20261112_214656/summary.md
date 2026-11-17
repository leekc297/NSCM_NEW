# AS-IS 실측 요약 — FP00212N

- 실행: 2026-11-12 21:46:56.236 ~ 2026-11-12 21:47:43.306 · 계정 jaeuk.shin · 상태 OK
- 화면: BOM Explosion 1 Level (GSCM.FP.Master.UIL.FP00212_BOMExplosionLevel)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:46:56.698 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 45.63 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:46:56.702 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:46:56, END_TIME=2026-11-12 21:46:56, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214656_652, PA |
| 21:46:57.019 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00212 |
| 21:46:57.045 | load | GSCM.FP_Common | SELECT * | 351 | 14.03 | USER_ID= |
| 21:46:57.047 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.53 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:46:57.187 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 3.26 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 21:46:57.221 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.97 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 21:47:01.189 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 3960.82 | USER_ID=jaeuk.shin |
| 21:47:01.217 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.03 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:46:57, END_TIME=2026-11-12 21:47:01, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214657_227, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 21:47:01.221 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.52 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 21:47:01.227 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.36 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 21:47:01.318 | load | GSCM.FP_Common | SELECT | 145 | 4.96 | USER_ID=jaeuk.shin |
| 21:47:01.323 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.79 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 21:47:01.337 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.93 | USER_ID=jaeuk.shin |
| 21:47:01.352 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.13 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 21:47:01.368 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.6 | USER_ID=jaeuk.shin |
| 21:47:01.375 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.71 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 21:47:01.469 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 6.61 | p_program_id=FP00212, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 21:47:01.620 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 55.0 | MenuID=BOM Explosion 1 Level, CnntCode=0104001, UserID=jaeuk.shin |
| 21:47:01.686 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00212 |
| 21:47:10.531 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 6.45 | p_program_id=FP00212, p_user_id=jaeuk.shin, p_sheet_name=Main |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| Model | txtModel |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 13(보임 12) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

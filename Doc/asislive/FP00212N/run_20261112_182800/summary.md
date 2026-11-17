# AS-IS 실측 요약 — FP00212N

- 실행: 2026-11-12 18:28:00.024 ~ 2026-11-12 18:28:49.764 · 계정 jaeuk.shin · 상태 OK
- 화면: BOM Explosion 1 Level (GSCM.FP.Master.UIL.FP00212_BOMExplosionLevel)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:28:01.133 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 756.22 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:28:01.139 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.64 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:28:00, END_TIME=2026-11-12 18:28:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182800_376, PA |
| 18:28:01.470 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 11.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00212 |
| 18:28:01.491 | load | GSCM.FP_Common | SELECT * | 351 | 13.33 | USER_ID= |
| 18:28:02.563 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1071.2 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:28:02.698 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 3.11 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 18:28:02.745 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.62 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 18:28:07.100 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4348.87 | USER_ID=jaeuk.shin |
| 18:28:07.384 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 282.25 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:28:02, END_TIME=2026-11-12 18:28:07, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182802_75, PARAM_VALUE={USER_ID : jaeuk.shin },  |
| 18:28:07.438 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 55.27 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 18:28:07.809 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 369.52 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 18:28:07.883 | load | GSCM.FP_Common | SELECT | 145 | 4.19 | USER_ID=jaeuk.shin |
| 18:28:09.220 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1337.41 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 18:28:09.236 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 7.77 | USER_ID=jaeuk.shin |
| 18:28:09.242 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.4 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 18:28:09.255 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.77 | USER_ID=jaeuk.shin |
| 18:28:09.265 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.29 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 18:28:09.330 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.68 | p_program_id=FP00212, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 18:28:11.270 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1844.9 | MenuID=BOM Explosion 1 Level, CnntCode=0104001, UserID=jaeuk.shin |
| 18:28:11.363 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00212 |
| 18:28:19.021 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.99 | p_program_id=FP00212, p_user_id=jaeuk.shin, p_sheet_name=Main |

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

# AS-IS 실측 요약 — FP00310

- 실행: 2026-11-12 18:29:06.850 ~ 2026-11-12 18:30:29.386 · 계정 jaeuk.shin · 상태 OK
- 화면: Formation Yield (GSCM.FP.Master.UIL.FP00310_Formation_Yield)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:29:16.044 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8822.88 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:29:16.050 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.94 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:29:07, END_TIME=2026-11-12 18:29:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182907_221, PA |
| 18:29:16.858 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.6 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00310 |
| 18:29:16.881 | load | GSCM.FP_Common | SELECT * | 351 | 14.88 | USER_ID= |
| 18:29:17.168 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 287.22 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:29:17.464 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 3.06 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 18:29:42.836 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25370.95 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 18:29:47.279 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4426.56 | USER_ID=jaeuk.shin |
| 18:29:47.323 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.69 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 18:29:42, END_TIME=2026-11-12 18:29:47, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182942_851, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 18:29:47.364 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.9 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 18:29:47.867 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 502.33 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 18:29:48.043 | load | GSCM.FP_Common | SELECT | 145 | 4.86 | USER_ID=jaeuk.shin |
| 18:29:48.067 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.26 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 18:29:48.091 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.14 | USER_ID=jaeuk.shin |
| 18:29:48.127 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.06 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 18:29:48.158 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.49 | USER_ID=jaeuk.shin |
| 18:29:48.190 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.09 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 18:29:48.405 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.29 | p_program_id=FP00310, p_sheet_name=FormationYield, p_user_id=jaeuk.shin |
| 18:29:48.481 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 72.84 | p_program_id=FP00310, p_sheet_name=FormationYield |
| 18:29:48.502 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.37 | p_program_id=FP00310, p_sheet_name=FormationYield, p_user_id=jaeuk.shin |
| 18:29:48.513 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 4.0 | p_program_id=FP00310, p_sheet_name=FormationYield |
| 18:29:48.843 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 174.75 | MenuID=Formation Yield, CnntCode=0104001, UserID=jaeuk.shin |
| 18:29:48.964 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00310 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Building | clbBuilding |  |
| lblSql | btnSql |  |
| Site | cboSite |  |
| Div | clbDivision |  |
| Line | clbLine |  |
| Material | txtItemID |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / FormationYield: 행 0 · 컬럼 22(보임 21) · 헤더 2단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

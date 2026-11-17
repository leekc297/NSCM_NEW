# AS-IS 실측 요약 — FP00960

- 실행: 2026-11-12 22:07:16.510 ~ 2026-11-12 22:08:05.102 · 계정 jaeuk.shin · 상태 OK
- 화면: Aging Inventory (GSCM.FP.Master.UIL.FP00960_Aging_Inventory)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:07:16.832 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.98 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:07:16.856 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.62 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:07:16, END_TIME=2026-11-12 22:07:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220716_825, PA |
| 22:07:16.903 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00960 |
| 22:07:16.917 | load | GSCM.FP_Common | SELECT * | 351 | 9.52 | USER_ID= |
| 22:07:16.922 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.89 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:07:17.040 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 23.4 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 22:07:17.044 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 22:07:21.667 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4618.0 | USER_ID=jaeuk.shin |
| 22:07:21.671 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.58 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 22:07:17, END_TIME=2026-11-12 22:07:21, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220717_049, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 22:07:21.675 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.97 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 22:07:21.679 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.47 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 22:07:21.749 | load | GSCM.FP_Common | SELECT | 145 | 5.2 | USER_ID=jaeuk.shin |
| 22:07:21.753 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 22:07:21.768 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.0 | USER_ID=jaeuk.shin |
| 22:07:21.778 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.91 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 22:07:21.792 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.82 | USER_ID=jaeuk.shin |
| 22:07:21.806 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.28 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 22:07:21.840 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 16.1 | LOGTYPE=SpeedUp, NOTE=FP00960
division_id_changed
start
, USER_ID=jaeuk.shin |
| 22:07:21.889 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.65 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:07:21.920 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.05 | LOGTYPE=SpeedUp, NOTE=FP00960
division_id_changed
end
, USER_ID=jaeuk.shin |
| 22:07:21.923 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.83 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:07:21.983 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.34 | p_program_id=FP00960, p_sheet_name=AgingInventory, p_user_id=jaeuk.shin |
| 22:07:22.020 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 34.09 | p_program_id=FP00960, p_sheet_name=AgingInventory |
| 22:07:22.027 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.46 | p_program_id=FP00960, p_sheet_name=AgingInventory, p_user_id=jaeuk.shin |
| 22:07:22.034 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 4.24 | p_program_id=FP00960, p_sheet_name=AgingInventory |
| 22:07:22.118 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 63.27 | MenuID=Aging Inventory, CnntCode=0104001, UserID=jaeuk.shin |
| 22:07:22.162 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00960 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Route | txtRoute |  |
| Site | cboSite |  |
| Operation | txtOperation |  |
| Plant | clbPlant |  |
| Line | txtLine |  |
| Building | clbFactory |  |
| Material | txtItemID |  |
| Cut Off Date | dtpCurOffDate |  |

## 그리드

- spdMain / AgingInventory: 행 0 · 컬럼 27(보임 26) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

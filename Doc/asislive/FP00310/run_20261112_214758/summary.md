# AS-IS 실측 요약 — FP00310

- 실행: 2026-11-12 21:47:58.899 ~ 2026-11-12 21:48:48.260 · 계정 jaeuk.shin · 상태 OK
- 화면: Formation Yield (GSCM.FP.Master.UIL.FP00310_Formation_Yield)
- 조회 결과: Total : 876 · DB : 24.052s, UI : 0.639s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:47:59.738 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 475.54 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:47:59.743 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:47:59, END_TIME=2026-11-12 21:47:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214759_263, PA |
| 21:48:00.491 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 35.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00310 |
| 21:48:00.511 | load | GSCM.FP_Common | SELECT * | 351 | 11.12 | USER_ID= |
| 21:48:00.618 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 106.89 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:48:00.798 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 30.07 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 21:48:01.950 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1151.2 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 21:48:06.181 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4212.62 | USER_ID=jaeuk.shin |
| 21:48:07.163 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 982.31 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 21:48:01, END_TIME=2026-11-12 21:48:06, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214801_966, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 21:48:07.168 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.16 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 21:48:07.176 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.35 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 21:48:07.247 | load | GSCM.FP_Common | SELECT | 145 | 4.65 | USER_ID=jaeuk.shin |
| 21:48:07.258 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.43 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 21:48:07.274 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 9.78 | USER_ID=jaeuk.shin |
| 21:48:07.320 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.05 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 21:48:07.334 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 4.44 | USER_ID=jaeuk.shin |
| 21:48:07.342 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.39 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 21:48:07.494 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.82 | p_program_id=FP00310, p_sheet_name=FormationYield, p_user_id=jaeuk.shin |
| 21:48:07.559 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 62.47 | p_program_id=FP00310, p_sheet_name=FormationYield |
| 21:48:07.574 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.31 | p_program_id=FP00310, p_sheet_name=FormationYield, p_user_id=jaeuk.shin |
| 21:48:07.584 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 6.02 | p_program_id=FP00310, p_sheet_name=FormationYield |
| 21:48:07.812 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 125.84 | MenuID=Formation Yield, CnntCode=0104001, UserID=jaeuk.shin |
| 21:48:07.878 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.68 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00310 |
| 21:48:40.692 | find | GSCM.FP_Common | PR_UI_FP00310_FORMATION_YIELD | 876 | 23771.17 | p_sys_type=SELECT, p_sys_flag=SELECT, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A7,A8,A9,AA,AB,AC,AD,AE,AF,A |
| 21:48:40.797 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 104.77 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00310_FORMATION_YIELD, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00310_FORMATION_YIELD @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81 |
| 21:48:41.641 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 131.94 | p_menu_id=FP00310, p_log_type=FIND, p_log_cnt=876, p_db_time=24.052, p_ui_time=0.639, p_user_id=jaeuk.shin |
| 21:48:47.557 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.51 | MenuID=Formation Yield, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / FormationYield: 행 876 · 컬럼 22(보임 21) · 헤더 2단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

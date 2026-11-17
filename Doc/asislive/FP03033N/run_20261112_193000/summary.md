# AS-IS 실측 요약 — FP03033N

- 실행: 2026-11-12 19:30:00.759 ~ 2026-11-12 19:30:34.715 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Measure Conversion (GSCM.FP.Master.UIL.FP03033_Model_MeasureConversion)
- 조회 결과: Total : 2 · DB : 1.439s, UI : 0.094s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:30:01.295 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 26.1 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:30:01.299 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:30:01, END_TIME=2026-11-12 19:30:01, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193001_269, PA |
| 19:30:02.713 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP03033 |
| 19:30:02.743 | load | GSCM.FP_Common | SELECT * | 351 | 9.83 | USER_ID= |
| 19:30:02.747 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.59 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:30:04.203 | load | GSCM.FP_Common | SELECT SEGMENT1 AS MENU_KEY | 3 | 3.83 | LOOKUP_TYPE_CODE=INSTANCE_CELL_OCNB, MENU_KEY=OCNB |
| 19:30:04.226 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.05 | PROG_ID=find_OCNB, QUERY_ID=FP\Common\XpCommonAmend, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0LOOKUP_TYPE_CODE
---Service Parameter : 1MENU_KEY
---Check client parameter : LOOKUP_TYPE_CODE
---FOUND LOOKUP_TYPE_CODE
-- TYPE = nvarchar---Add string Service
---Check client parameter |
| 19:30:08.451 | load | GSCM.FP_Common | DECLARE @OPTBL AS TABLE | 2637 | 4210.12 | USER_ID=jaeuk.shin |
| 19:30:08.483 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.51 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:30:04, END_TIME=2026-11-12 19:30:08, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193004_239, PARAM_VALUE={USER_ID : jaeuk.shin }, |
| 19:30:08.488 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.54 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

--declare @USER_ID nvarchar(100) = 'A11NC001'

--(@USER_ID nvarchar(100))---Service P |
| 19:30:08.493 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.26 | PROG_ID=list_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=Y_ID

INNER JOIN SCM_SITE_M S WITH(NOLOCK)
ON FL.SITE_ID = S.SITE_ID
AND FL.COMPANY_ID = S.COMPANY_ID

INNER JOIN SCM_PLANT_M P WITH(NOLOCK)
ON FL.SITE_ID = P.SITE_ID
AND FL.COMPANY_ID = P.COMPANY_ID
AND FL.PLAN |
| 19:30:08.628 | load | GSCM.FP_Common | SELECT | 145 | 4.65 | USER_ID=jaeuk.shin |
| 19:30:08.632 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=get_amend_ui, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


 SELECT 
 AMEND_UI_NAME, INSTANCE_ID, USE_FLAG
 FROM FP_AMEND_UI_V WITH(NOLOCK)
  |
| 19:30:08.651 | load | GSCM.FP_Common | SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, PLAN_GROUP_ID, PLAN_GROUP_DESC | 393 | 8.68 | USER_ID=jaeuk.shin |
| 19:30:08.662 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.25 | PROG_ID=get_user_line, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT DISTINCT INSTANCE_ID,USER_ID, LINE_ID, DIVISION_ID, COMPANY_ID, SITE_ID,  |
| 19:30:08.701 | load | GSCM.FP_Common | SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TYPE,AA.ATTRIBUTE6 AS GROUP_ID FROM SCM_SYS_LOOKUP_VALU | 29 | 3.78 | USER_ID=jaeuk.shin |
| 19:30:08.706 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.77 | PROG_ID=get_instance_planning_group, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

SELECT DISTINCT AA.SEGMENT1 AS INSTANCE_ID, AA.SEGMENT2 AS MODEL_TY |
| 19:30:09.338 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.94 | p_program_id=FP03033, p_sheet_name=MeasureConversion, p_user_id=jaeuk.shin |
| 19:30:09.374 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 28.58 | p_program_id=FP03033, p_sheet_name=MeasureConversion |
| 19:30:09.389 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP03033, p_sheet_name=MeasureConversion, p_user_id=jaeuk.shin |
| 19:30:09.398 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 3.85 | p_program_id=FP03033, p_sheet_name=MeasureConversion |
| 19:30:09.508 | load | GSCM.FP_Common | UI_FP_COMMON | 25 | 13.68 | code=LANE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, param |
| 19:30:09.536 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.97 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:30:09, END_TIME=2026-11-12 19:30:09, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112193009_495, PA |
| 19:30:09.573 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.93 | p_program_id=FP03033, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:30:09.583 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.44 | p_program_id=FP03033, p_sheet_name=Sub |
| 19:30:09.594 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.57 | p_program_id=FP03033, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:30:09.604 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.62 | p_program_id=FP03033, p_sheet_name=Sub |
| 19:30:10.060 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 58.43 | MenuID=Model Measure Conversion, CnntCode=0104001, UserID=jaeuk.shin |
| 19:30:10.976 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP03033 |
| 19:30:24.205 | find | GSCM.FP_Common | PR_UI_FP03033_MODEL_MEASURECONVERSION | 11984 | 3736.02 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A7,A8,A9 |
| 19:30:24.209 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP03033_MODEL_MEASURECONVERSION @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N' |
| 19:30:25.226 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.69 | p_menu_id=FP03033, p_log_type=FIND, p_log_cnt=, p_db_time=4.676, p_ui_time=0.315, p_user_id=jaeuk.shin |
| 19:30:25.956 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.96 | p_program_id=FP03033, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:30:25.965 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 4.52 | p_program_id=FP03033, p_sheet_name=Sub |
| 19:30:25.975 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.59 | p_program_id=FP03033, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:30:25.983 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.83 | p_program_id=FP03033, p_sheet_name=Sub |
| 19:30:27.430 | find | GSCM.FP_Common | PR_UI_FP03033_MODEL_MEASURECONVERSION | 2 | 1423.96 | p_sys_type=SELECT, p_sys_flag=SELECT_DETAIL, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40, p_site_id=A001, p_plant_id=HQ06, p_factory_id=E2, p_model_id=, p_pjt_code=, p_version_type=, p_version=, p_prod_yn=, p_operation_id=, p_item_id=APCAN1102A, p_electrode_type=, p_category_ |
| 19:30:27.435 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.0 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP03033_MODEL_MEASURECONVERSION @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_DETAIL',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id= |
| 19:30:27.538 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.47 | p_menu_id=FP03033, p_log_type=FIND, p_log_cnt=2, p_db_time=1.439, p_ui_time=0.094, p_user_id=jaeuk.shin |
| 19:30:33.634 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.15 | MenuID=Model Measure Conversion, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem11 | btnSubImport |  |
| layoutControlItem1 | btnSearchAll |  |
| layoutControlItem10 | label1 |  |
| layoutControlItem12 | btnGenerate |  |
| lblExcelImport | btnImport |  |
| lblSql | btnSql |  |
| Site | cboSite |  |
| Div | clbDivision |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Operation | clbOperation |  |
| Wide Range | cboWideRange |  |
| Model | txtModel |  |
| Material | txtItemID |  |
| PJT Code | txtPjtCode |  |
| Max Version | rdoGroup1 |  |
| layoutControlItem17 | btnAdd |  |

## 그리드

- spdMain / MeasureConversion: 행 11984 · 컬럼 27(보임 22) · 헤더 1단 · 고정 컬럼 14
- spdSub / Sub: 행 2 · 컬럼 19(보임 18) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — FP01620N

- 실행: 2026-11-12 19:17:39.484 ~ 2026-11-12 19:18:30.528 · 계정 jaeuk.shin · 상태 OK
- 화면: W/O Create (GSCM.FP.Master.UIL.FP01620_WO_Create)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:17:39.984 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 97.19 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:17:39.997 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.28 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:17:40.000 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.62 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:39, END_TIME=2026-11-12 19:17:39, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191739_99, PAR |
| 19:17:40.141 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01620 |
| 19:17:40.157 | load | GSCM.FP_Common | SELECT * | 351 | 10.08 | USER_ID= |
| 19:17:40.161 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.37 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:17:40.825 | load | GSCM.FP_Common | SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER | 54 | 343.99 | USER_ID=jaeuk.shin |
| 19:17:40.829 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.96 | PROG_ID=get_instance_id_except_post, QUERY_ID=FP\Common\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service

				SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER	 |
| 19:17:41.244 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 58.42 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:17:41.304 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.05 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 19:17:41.529 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 1 | 60.85 | p_code=FP00590_find_CurrUTDate, p_user_id=jaeuk.shin, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:17:41.553 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.83 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00590_find_CurrUTDate',@p_user_id=N'jaeuk.shin',@param1=N'KR_E_PRE_A',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@ |
| 19:17:41.804 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 215.06 | code=FP_PLAN_INFO, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=KR_E_PRE_A, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=RELEASE, param22=20261112, pa |
| 19:17:41.807 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.61 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:17:41, END_TIME=2026-11-12 19:17:41, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191741_588, PA |
| 19:17:41.906 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.8 | p_program_id=FP01620, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:17:41.937 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 25.54 | p_program_id=FP01620, p_sheet_name=Main |
| 19:17:41.952 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.02 | p_program_id=FP01620, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:17:41.961 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 3.68 | p_program_id=FP01620, p_sheet_name=Main |
| 19:17:42.099 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 57.08 | MenuID=W/O Create, CnntCode=0104001, UserID=jaeuk.shin |
| 19:17:42.309 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01620 |
| 19:18:29.889 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 124.6 | MenuID=W/O Create, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plan Group | cboInstance |  |
| Site | cboSite |  |
| Plan Period* | drpPeriod | Y |
| Plan Date | drpPlanDate |  |
| Plant | clbPlant |  |
| FP Plan ID | cboPlanID |  |
| Building | clbFactory |  |
| Div | clbDivision |  |
| Operation | cboOperation |  |
| Line | clbLine |  |
| Material | tbItemId |  |
| Work Order ID | txtWorkOrderID |  |
| Publication Target Only | cboTarget |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 31(보임 30) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:17:52.445 [GSCM] You need to select one plan to proceed → default_button(id=1)

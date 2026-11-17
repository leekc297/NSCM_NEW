# AS-IS 실측 요약 — FP01470

- 실행: 2026-11-12 19:14:29.846 ~ 2026-11-12 19:15:30.560 · 계정 jaeuk.shin · 상태 OK
- 화면: Order Tracking (GSCM.FP.Analysis.UIL.FP01470_OrderTracking)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:14:31.303 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01470 |
| 19:14:31.362 | load | GSCM.FP_Common | SELECT * | 351 | 30.4 | USER_ID= |
| 19:14:34.450 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3087.73 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:14:38.081 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 3348.01 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:14:38.085 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:14:34, END_TIME=2026-11-12 19:14:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191434_733, PA |
| 19:14:40.352 | load | GSCM.FP_Common | UI_FP_COMMON | 52 | 2174.67 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param |
| 19:14:40.355 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.68 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:14:38, END_TIME=2026-11-12 19:14:40, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191438_177, PA |
| 19:14:40.832 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 20.91 | p_code=FP00594_findFpPlan_info, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20261112, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:14:40.870 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.85 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00594_findFpPlan_info',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20261112',@param3=N'',@param4=N'',@param5= |
| 19:14:40.906 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:14:40.938 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 26.48 | p_program_id=FP01470, p_sheet_name=Main |
| 19:14:40.949 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:14:40.958 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 3.78 | p_program_id=FP01470, p_sheet_name=Main |
| 19:14:40.999 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.96 | p_program_id=FP01470, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:14:41.008 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 4.23 | p_program_id=FP01470, p_sheet_name=Sub |
| 19:14:41.019 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.66 | p_program_id=FP01470, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 19:14:41.028 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 3.86 | p_program_id=FP01470, p_sheet_name=Sub |
| 19:14:42.645 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1292.48 | MenuID=Order Tracking, CnntCode=0104001, UserID=jaeuk.shin |
| 19:14:42.874 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01470 |
| 19:14:45.370 | load | GSCM.FP_Common | PR_UI_FP00960_AGING_INVENTORY | 0 | 65750.22 | p_sys_type=SELECT, p_sys_flag=SELECT, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A7,A8,A9,AA,AB,AC,AD,AE,AF,A |
| 19:14:45.384 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.42 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00960_AGING_INVENTORY, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00960_AGING_INVENTORY @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81 |
| 19:14:52.135 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.38 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:14:52.143 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 4.15 | p_program_id=FP01470, p_sheet_name=Main |
| 19:14:52.153 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.32 | p_program_id=FP01470, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:14:52.161 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 13 | 4.01 | p_program_id=FP01470, p_sheet_name=Main |
| 19:15:29.790 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.75 | MenuID=Order Tracking, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem4 | btnSql |  |
| Plan Group | cboInstance |  |
| Plan Date | dtpPlanDate |  |
| Material | txtItemId |  |
| FP Plan ID | cboPlanID |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0
- spdSub / Sub: 행 0 · 컬럼 21(보임 20) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:14:52.947 [GSCM] Plan ID 에 대한 선택값이 없습니다. → default_button(id=1)

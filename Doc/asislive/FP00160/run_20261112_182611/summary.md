# AS-IS 실측 요약 — FP00160

- 실행: 2026-11-12 18:26:11.454 ~ 2026-11-12 18:26:29.065 · 계정 jaeuk.shin · 상태 OK
- 화면: Building(BOD) (GSCM.FP.Master.UIL.FP00160_Building_BOD)
- 조회 결과: Total : 34 · DB : 1.649s, UI : 0.073s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:26:11.787 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.51 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:26:11.814 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:11, END_TIME=2026-11-12 18:26:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182611_779, PA |
| 18:26:11.864 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.4 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00160 |
| 18:26:11.880 | load | GSCM.FP_Common | SELECT * | 351 | 10.4 | USER_ID= |
| 18:26:11.884 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:26:12.030 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 2 | 5.63 | p_code=FP00160_findLookUpCode, p_user_id=jaeuk.shin, param1=TRANSPORT_MODE, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:26:12.037 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.98 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00160_findLookUpCode',@p_user_id=N'jaeuk.shin',@param1=N'TRANSPORT_MODE',@param2=N'',@param3=N'',@param4=N'',@param5=N' |
| 18:26:12.054 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 2 | 5.67 | p_code=FP00160_findLookUpCode, p_user_id=jaeuk.shin, param1=TRANSPORT_TIME_UOM, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:26:12.084 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.49 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP00160_findLookUpCode',@p_user_id=N'jaeuk.shin',@param1=N'TRANSPORT_TIME_UOM',@param2=N'',@param3=N'',@param4=N'',@param |
| 18:26:12.246 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 155.83 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 18:26:12.251 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:12, END_TIME=2026-11-12 18:26:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182612_089, PA |
| 18:26:12.797 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 530.86 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 18:26:12.814 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.47 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:12, END_TIME=2026-11-12 18:26:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182612_266, PA |
| 18:26:13.310 | load | GSCM.FP_Common | UI_FP_COMMON | 78 | 475.69 | code=FACTORY, user_id=jaeuk.shin, non_auth=, save_auth=Y, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=A001,A002,A003,A004,A007,A009, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=,  |
| 18:26:13.313 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.88 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:12, END_TIME=2026-11-12 18:26:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182612_834, PA |
| 18:26:13.350 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.75 | p_program_id=FP00160, p_sheet_name=BuildingBOD, p_user_id=jaeuk.shin |
| 18:26:13.385 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 31.9 | p_program_id=FP00160, p_sheet_name=BuildingBOD |
| 18:26:13.393 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.81 | p_program_id=FP00160, p_sheet_name=BuildingBOD, p_user_id=jaeuk.shin |
| 18:26:13.400 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 21 | 3.9 | p_program_id=FP00160, p_sheet_name=BuildingBOD |
| 18:26:13.414 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 8.03 | code=TRANSPORT_MODE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param |
| 18:26:13.418 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.53 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:13, END_TIME=2026-11-12 18:26:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182613_406, PA |
| 18:26:13.435 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 8.92 | code=TRANSPORT_TIME_UOM, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:26:13.438 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.92 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:13, END_TIME=2026-11-12 18:26:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182613_426, PA |
| 18:26:13.521 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 59.73 | MenuID=Building(BOD), CnntCode=0104001, UserID=jaeuk.shin |
| 18:26:13.551 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00160 |
| 18:26:22.900 | find | GSCM.FP_Common | PR_UI_FP00160_BUILDING_BOD | 34 | 1373.04 | p_sys_type=SELECT, p_sys_flag=SELECT, p_sys_gubun=, p_user_id=jaeuk.shin, p_company_id=, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=, p_plant_id=, p_factory_id=A1,A2,A3,A4,A5,A6,A7,A8,A9,AA,AB,AC,AD,AE,AF,AI,AJ,AL,E2,E3,E4,E5,E6,E7,E9,EA,EB,EC,ED,EE,EF,EG,EH,EI,EJ,EK,EL,EN,EO,EP,ER,ES |
| 18:26:23.004 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 103.2 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00160_BUILDING_BOD, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00160_BUILDING_BOD @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_company_id=N'',@p_division_id=N'40,81,81 |
| 18:26:23.091 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.23 | p_menu_id=FP00160, p_log_type=FIND, p_log_cnt=34, p_db_time=1.649, p_ui_time=0.073, p_user_id=jaeuk.shin |
| 18:26:28.343 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.16 | MenuID=Building(BOD), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Site | cboSite |  |
| Div | clbDivision |  |
| lblExcelImport | btnImport |  |
| lblSql | btnSql |  |
| Building | clbBuilding |  |

## 그리드

- spdMain / BuildingBOD: 행 34 · 컬럼 22(보임 7) · 헤더 2단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — FP02510

- 실행: 2026-11-12 22:13:54.868 ~ 2026-11-12 22:14:45.373 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Routing (GSCM.FP.Master.UIL.FP02510_Model_Routing)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:13:55.340 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02510 |
| 22:13:55.357 | load | GSCM.FP_Common | SELECT * | 351 | 10.01 | USER_ID= |
| 22:13:55.361 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.54 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:13:55.451 | load | GSCM.FP_Common | UI_FP_COMMON | 28 | 26.77 | code=USER_AUTH, user_id=, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 22:13:55.454 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.19 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:55, END_TIME=2026-11-12 22:13:55, INSERT_ID=, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221355_423, PARAM_VALUE= |
| 22:13:55.646 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 154.98 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 22:13:55.658 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.5 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:55, END_TIME=2026-11-12 22:13:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221355_49, PAR |
| 22:13:55.815 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 140.96 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 22:13:55.818 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.58 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:55, END_TIME=2026-11-12 22:13:55, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221355_673, PA |
| 22:13:55.867 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.6 | p_program_id=FP02510, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:13:55.897 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 34 | 25.47 | p_program_id=FP02510, p_sheet_name=Main |
| 22:13:55.905 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.19 | p_program_id=FP02510, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:13:55.915 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 34 | 4.74 | p_program_id=FP02510, p_sheet_name=Main |
| 22:13:55.997 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 45.24 | MenuID=Model Routing, CnntCode=0104001, UserID=jaeuk.shin |
| 22:13:56.051 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02510 |
| 22:14:44.615 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.42 | MenuID=Model Routing, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Site | cboSite |  |
| Material | tbMaterial |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 35(보임 34) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 22:14:06.082 [] You need to specify material id for Model Routing. → default_button(id=1)

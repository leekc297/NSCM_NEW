# AS-IS 실측 요약 — FP02510

- 실행: 2026-11-12 19:23:37.990 ~ 2026-11-12 19:24:26.460 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Routing (GSCM.FP.Master.UIL.FP02510_Model_Routing)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:23:38.275 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.34 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02510 |
| 19:23:38.292 | load | GSCM.FP_Common | SELECT * | 351 | 9.9 | USER_ID= |
| 19:23:38.297 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.45 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:23:38.411 | load | GSCM.FP_Common | UI_FP_COMMON | 28 | 21.96 | code=USER_AUTH, user_id=, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:23:38.415 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.42 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:38, END_TIME=2026-11-12 19:23:38, INSERT_ID=, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192338_388, PARAM_VALUE= |
| 19:23:38.604 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 136.08 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:23:38.607 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:38, END_TIME=2026-11-12 19:23:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192338_468, PA |
| 19:23:38.760 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 134.92 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=40,81,81_HD,81_HM,81_ST,81_UC,82, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:23:38.783 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:23:38, END_TIME=2026-11-12 19:23:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192338_625, PA |
| 19:23:38.868 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.03 | p_program_id=FP02510, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:23:38.879 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 34 | 5.33 | p_program_id=FP02510, p_sheet_name=Main |
| 19:23:38.888 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.91 | p_program_id=FP02510, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:23:38.899 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 34 | 5.24 | p_program_id=FP02510, p_sheet_name=Main |
| 19:23:39.053 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 74.8 | MenuID=Model Routing, CnntCode=0104001, UserID=jaeuk.shin |
| 19:23:39.156 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02510 |
| 19:24:25.747 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.56 | MenuID=Model Routing, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 19:23:48.191 [] You need to specify material id for Model Routing. → default_button(id=1)

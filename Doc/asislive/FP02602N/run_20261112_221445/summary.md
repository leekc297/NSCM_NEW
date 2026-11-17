# AS-IS 실측 요약 — FP02602N

- 실행: 2026-11-12 22:14:45.710 ~ 2026-11-12 22:15:37.239 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Result (GSCM.FP.Planning.UIL.FP02602_Production_Result)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:14:46.164 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02602 |
| 22:14:46.181 | load | GSCM.FP_Common | SELECT * | 351 | 10.74 | USER_ID= |
| 22:14:46.205 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.27 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:14:46.332 | load | GSCM.FP_Common | UI_FP_COMMON | 28 | 7.35 | code=USER_AUTH, user_id=, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 22:14:46.335 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:14:46, END_TIME=2026-11-12 22:14:46, INSERT_ID=, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221446_324, PARAM_VALUE= |
| 22:14:47.454 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.34 | p_program_id=FP02602, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:14:47.462 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.11 | p_program_id=FP02602, p_sheet_name=Main |
| 22:14:47.470 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.86 | p_program_id=FP02602, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:14:47.477 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 3.75 | p_program_id=FP02602, p_sheet_name=Main |
| 22:14:47.580 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 69.94 | MenuID=Production Result, CnntCode=0104001, UserID=jaeuk.shin |
| 22:14:47.690 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02602 |
| 22:15:36.518 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.81 | MenuID=Production Result, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Factory | clbFactory |  |
| Div | clbDivision |  |
| Plant | clbPlant |  |
| Site | cboSite |  |
| Nick Name | tbNickName |  |
| Material | txtMaterial |  |
| Line | cboLine |  |
| Operation | cboOperation |  |
| lblSql | btnSql |  |
| Period | drpPeriod |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 26(보임 25) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 22:14:58.409 [] Please inserts Division. → default_button(id=1)

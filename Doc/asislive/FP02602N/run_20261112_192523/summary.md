# AS-IS 실측 요약 — FP02602N

- 실행: 2026-11-12 19:25:23.140 ~ 2026-11-12 19:26:14.016 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Result (GSCM.FP.Planning.UIL.FP02602_Production_Result)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:25:23.563 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02602 |
| 19:25:23.580 | load | GSCM.FP_Common | SELECT * | 351 | 10.36 | USER_ID= |
| 19:25:23.664 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 83.86 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:25:23.907 | load | GSCM.FP_Common | UI_FP_COMMON | 28 | 44.57 | code=USER_AUTH, user_id=, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:25:23.912 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:25:23, END_TIME=2026-11-12 19:25:23, INSERT_ID=, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192523_863, PARAM_VALUE= |
| 19:25:25.206 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.12 | p_program_id=FP02602, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:25:25.300 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 89.91 | p_program_id=FP02602, p_sheet_name=Main |
| 19:25:25.310 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.33 | p_program_id=FP02602, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:25:25.320 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 25 | 4.48 | p_program_id=FP02602, p_sheet_name=Main |
| 19:25:25.904 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 507.29 | MenuID=Production Result, CnntCode=0104001, UserID=jaeuk.shin |
| 19:25:26.155 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02602 |
| 19:26:13.270 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.79 | MenuID=Production Result, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 19:25:35.884 [] Please inserts Division. → default_button(id=1)

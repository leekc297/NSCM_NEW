# AS-IS 실측 요약 — FP00411

- 실행: 2026-11-12 21:48:48.522 ~ 2026-11-12 21:49:31.200 · 계정 jaeuk.shin · 상태 OK
- 화면: FCS Shorter Aging Routing (GSCM.FP.Master.UIL.FP00411_FCS_Shorter_Aging_Routing)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:48:48.903 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 12.82 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:48:48.907 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.29 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:48:48, END_TIME=2026-11-12 21:48:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112214848_891, PA |
| 21:48:49.077 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00411 |
| 21:48:49.090 | load | GSCM.FP_Common | SELECT * | 351 | 9.41 | USER_ID= |
| 21:48:49.185 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 94.33 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:48:49.413 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.3 | p_program_id=FP00411, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 21:48:49.439 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 22.89 | p_program_id=FP00411, p_sheet_name=Main |
| 21:48:49.447 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP00411, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 21:48:49.456 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 5.1 | p_program_id=FP00411, p_sheet_name=Main |
| 21:48:49.533 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 58.58 | MenuID=FCS Shorter Aging Routing, CnntCode=0104001, UserID=jaeuk.shin |
| 21:48:49.570 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00411 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Div | clbDivision |  |
| Line | clbLine |  |
| Site | clbSite |  |
| Material | txtItemId |  |
| Nick Name | txtNickName |  |
| lblSql | btnSql |  |
| layoutControlItem5 | btnExcel |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

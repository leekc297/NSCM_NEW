# AS-IS 실측 요약 — SCM0016

- 실행: 2026-11-12 21:13:30.563 ~ 2026-11-12 21:14:12.146 · 계정 jaeuk.shin · 상태 OK
- 화면: Batch Log (GSCM.SCM.Master.UIL.SCM0016_BatchLog)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:13:30.938 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 31.38 | Code=LookupCommon, Param1=JOB_RUN_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:13:31.056 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0207 |
| 21:13:31.083 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.21 | USER_ID= |
| 21:13:31.569 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 303.24 | MenuID=Batch Log, CnntCode=0104001, UserID=jaeuk.shin |
| 21:13:31.651 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0207 |
| 21:13:40.572 | find | GSCM.SCM.Master.WSL | SCM0016_GET_BATCH_LOG | 1 | 262.16 | p_run_status=0,1,2,3,4 |
| 21:14:11.399 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.93 | MenuID=Batch Log, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Run Status | clbRunStatus |  |

## 그리드

- spdMain / Batch Log: 행 1 · 컬럼 13(보임 9) · 헤더 1단 · 고정 컬럼 6
- spdStep / Step Info: 행 0 · 컬럼 11(보임 6) · 헤더 1단 · 고정 컬럼 0
- spdHist / Batch Run Log: 행 0 · 컬럼 6(보임 4) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

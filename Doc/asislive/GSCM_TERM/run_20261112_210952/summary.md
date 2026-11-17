# AS-IS 실측 요약 — GSCM_TERM

- 실행: 2026-11-12 21:09:52.651 ~ 2026-11-12 21:10:33.637 · 계정 jaeuk.shin · 상태 OK
- 화면: Term (GSCM.SystemMgmt.UIL.TermInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:09:52.987 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0109 |
| 21:09:53.012 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.57 | USER_ID= |
| 21:09:53.460 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 327.49 | MenuID=Term, CnntCode=0104001, UserID=jaeuk.shin |
| 21:09:53.526 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0109 |
| 21:10:01.921 | find | GSCM.SystemMgmt.WSL | UP_FX_GetTermInfoList | 665 | 16.35 | Search= |
| 21:10:32.922 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.73 | MenuID=Term, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Term | txtSearch |  |

## 그리드

- spdMain / TermInfo: 행 665 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

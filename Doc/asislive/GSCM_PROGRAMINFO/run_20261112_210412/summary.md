# AS-IS 실측 요약 — GSCM_PROGRAMINFO

- 실행: 2026-11-12 21:04:12.448 ~ 2026-11-12 21:04:54.195 · 계정 jaeuk.shin · 상태 OK
- 화면: Program (GSCM.SystemMgmt.UIL.ProgramInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:04:12.718 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0101 |
| 21:04:12.745 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.9 | USER_ID= |
| 21:04:13.605 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 709.78 | MenuID=Program, CnntCode=0104001, UserID=jaeuk.shin |
| 21:04:13.717 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0101 |
| 21:04:23.120 | find | GSCM.SystemMgmt.WSL | UP_FX_GetProgramInfoList | 370 | 978.41 | Search= |
| 21:04:53.250 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.36 | MenuID=Program, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Program ID (Name) | txtSearch |  |

## 그리드

- spdMain / ProgramInfo: 행 370 · 컬럼 6(보임 4) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

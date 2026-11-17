# AS-IS 실측 요약 — GSCM_GROUPMENUAUTH

- 실행: 2026-11-12 21:07:46.331 ~ 2026-11-12 21:08:28.255 · 계정 jaeuk.shin · 상태 OK
- 화면: Group Menu (GSCM.SystemMgmt.UIL.GroupMenuAuth)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:07:46.743 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0106 |
| 21:07:46.768 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.18 | USER_ID= |
| 21:07:46.907 | load | GSCM.SystemMgmt.WSL | UP_FX_GetGroupInfoList | 19 | 3.08 |  |
| 21:07:47.452 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 512.54 | MenuID=Group Menu, CnntCode=0104001, UserID=jaeuk.shin |
| 21:07:47.608 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0106 |
| 21:07:48.948 | load | GSCM.SystemMgmt.WSL | UP_FX_GetGroupMenuAuthList | 333 | 1195.38 | GroupID=ADMIN |
| 21:07:56.190 | find | GSCM.SystemMgmt.WSL | UP_FX_GetGroupInfoList | 19 | 3.16 |  |
| 21:08:27.136 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.49 | MenuID=Group Menu, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|

## 그리드

- spdMain / GroupInfo: 행 19 · 컬럼 4(보임 2) · 헤더 1단 · 고정 컬럼 0
- spdSub / MenuItemInfo: 행 0 · 컬럼 14(보임 6) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — GSCM_MENUITEMINFO

- 실행: 2026-11-12 21:04:54.320 ~ 2026-11-12 21:05:36.861 · 계정 jaeuk.shin · 상태 OK
- 화면: Menu (GSCM.SystemMgmt.UIL.MenuItemInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:04:54.734 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0102 |
| 21:04:54.762 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.31 | USER_ID= |
| 21:04:55.720 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 738.23 | MenuID=Menu, CnntCode=0104001, UserID=jaeuk.shin |
| 21:04:55.969 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0102 |
| 21:04:56.034 | load | GSCM.SystemMgmt.WSL | UP_FX_GetMenuItemInfoList | 8 | 1084.16 | MenuID=, ProgramID=, Title=, MenuLevel=1, PrntMenuID= |
| 21:05:04.491 | find | GSCM.SystemMgmt.WSL | UP_FX_GetMenuItemInfoList | 8 | 27.7 | MenuID=, ProgramID=, Title=, MenuLevel=1, PrntMenuID= |
| 21:05:35.404 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.52 | MenuID=Menu, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Search | txtSearch |  |

## 그리드

- spdLevel1 / Level1: 행 8 · 컬럼 12(보임 5) · 헤더 1단 · 고정 컬럼 1
- spdLevel2 / Level2: 행 0 · 컬럼 13(보임 7) · 헤더 2단 · 고정 컬럼 3
- spdLevel3 / Level3: 행 0 · 컬럼 16(보임 11) · 헤더 2단 · 고정 컬럼 4

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

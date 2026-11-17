# AS-IS 실측 요약 — GSCM_GROUPUSERINFO

- 실행: 2026-11-12 21:07:04.176 ~ 2026-11-12 21:07:46.192 · 계정 jaeuk.shin · 상태 OK
- 화면: Group User (GSCM.SystemMgmt.UIL.GroupUserInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:07:04.637 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0105 |
| 21:07:04.662 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.77 | USER_ID= |
| 21:07:04.814 | load | GSCM.SystemMgmt.WSL | UP_FX_GetGroupInfoList | 19 | 3.26 |  |
| 21:07:05.510 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 661.53 | MenuID=Group User, CnntCode=0104001, UserID=jaeuk.shin |
| 21:07:05.681 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0105 |
| 21:07:14.150 | find | GSCM.SystemMgmt.WSL | UP_FX_GetGroupInfoList | 19 | 3.96 |  |
| 21:07:45.346 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.0 | MenuID=Group User, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Message | txtSearch |  |

## 그리드

- spdMain / GroupInfo: 행 19 · 컬럼 4(보임 2) · 헤더 1단 · 고정 컬럼 1
- spdUserInfo / UserInfo: 행 0 · 컬럼 9(보임 5) · 헤더 1단 · 고정 컬럼 2
- spdDivision / Division: 행 0 · 컬럼 4(보임 1) · 헤더 1단 · 고정 컬럼 2

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

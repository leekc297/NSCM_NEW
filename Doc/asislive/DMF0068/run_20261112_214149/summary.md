# AS-IS 실측 요약 — DMF0068

- 실행: 2026-11-12 21:41:49.185 ~ 2026-11-12 21:42:38.474 · 계정 jaeuk.shin · 상태 OK
- 화면: Demand Manager  (GSCM.DM.Plan.UIL.DMF0068_DemandManager40)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:41:49.488 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.71 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:49.525 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0068 |
| 21:41:49.548 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.82 | USER_ID= |
| 21:41:49.657 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 156 | 6.0 | p_program_id=DMF0068, p_user_id=jaeuk.shin, p_sheet_name=ContributeSalesList |
| 21:41:49.807 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 79.95 | MenuID=Demand Manager , CnntCode=0104001, UserID=jaeuk.shin |
| 21:41:49.855 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0068 |
| 21:42:37.785 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.29 | MenuID=Demand Manager , CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Version | txtVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Period | drpPeriodMonth |  |

## 그리드

- spdMain / ContributeSalesList: 행 0 · 컬럼 157(보임 48) · 헤더 2단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 21:41:59.205 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)

# AS-IS 실측 요약 — SCP0015

- 실행: 2026-11-12 19:47:28.833 ~ 2026-11-12 19:48:20.335 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Management (GSCM.SCP.Analysis.UIL.SCP0015_PlanManagement)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:47:29.245 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.92 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:47:31.063 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1 | 1810.86 | Code=PlanYear1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:47:31.419 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1 | 352.16 | Code=PlanWeek1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:47:31.726 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0015 |
| 19:47:31.787 | load | GSCM.BizService.WSL | SELECT * | 874 | 51.11 | USER_ID= |
| 19:47:32.496 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 436.44 | MenuID=Plan Management, CnntCode=0104001, UserID=jaeuk.shin |
| 19:47:32.600 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0015 |
| 19:48:19.623 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.19 | MenuID=Plan Management, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Revision | txtRevision |  |
| Div* | cboDivision | Y |
| Plan Date* | cboPlanWeek | Y |
| Year* | cboPlanYear | Y |

## 그리드

- spdPlan / Plan Management: 행 0 · 컬럼 19(보임 9) · 헤더 2단 · 고정 컬럼 0
- spdEngin / Engine Run: 행 0 · 컬럼 15(보임 7) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:47:41.248 [GSCM] Plan Date* 값은 필수 입력입니다 → default_button(id=1)

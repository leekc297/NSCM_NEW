# AS-IS 실측 요약 — SCP0015

- 실행: 2026-11-12 22:31:05.710 ~ 2026-11-12 22:32:09.288 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Management (GSCM.SCP.Analysis.UIL.SCP0015_PlanManagement)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:31:06.077 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.34 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:31:07.389 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1 | 1306.5 | Code=PlanYear1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:31:07.445 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1 | 52.46 | Code=PlanWeek1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:31:07.732 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.61 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0015 |
| 22:31:07.761 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.96 | USER_ID= |
| 22:31:08.767 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 765.96 | MenuID=Plan Management, CnntCode=0104001, UserID=jaeuk.shin |
| 22:31:08.910 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0015 |
| 22:31:28.882 | find | GSCM.SCP.Analysis.WSL | SCP0015_GET_PLAN_MST | 0 | 319.29 | p_division_id=40, p_plan_year=2026, p_plan_week=W43, p_user_id=jaeuk.shin |
| 22:32:08.615 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.8 | MenuID=Plan Management, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 22:31:29.399 [GSCM] 시스템 오류입니다. 담당자에게 화면 캡쳐해서 시스템 담당자에게 전달하세요. → default_button(id=1)

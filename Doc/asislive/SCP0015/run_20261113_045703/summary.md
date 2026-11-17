# AS-IS 실측 요약 — SCP0015

- 실행: 2026-11-13 04:57:03.574 ~ 2026-11-13 04:57:30.600 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Management (GSCM.SCP.Analysis.UIL.SCP0015_PlanManagement)
- 조회 결과: Total : 4 · DB : 0.218s, UI : 0.005s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:57:04.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.68 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:57:04.432 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1 | 416.53 | Code=PlanYear1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:57:04.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1 | 53.6 | Code=PlanWeek1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:57:04.557 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 23.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0015 |
| 04:57:04.584 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.69 | USER_ID= |
| 04:57:04.836 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 31.53 | MenuID=Plan Management, CnntCode=0104001, UserID=jaeuk.shin |
| 04:57:04.886 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0015 |
| 04:57:24.289 | find | GSCM.SCP.Analysis.WSL | SCP0015_GET_PLAN_MST | 5 | 1820.03 | p_division_id=40, p_plan_year=2026, p_plan_week=W43, p_user_id=jaeuk.shin, p_group_id=ADMIN |
| 04:57:24.349 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 11.39 | p_menu_id=SCP0015, p_log_type=FIND, p_log_cnt=5, p_db_time=1.875, p_ui_time=0.031, p_user_id=jaeuk.shin |
| 04:57:24.618 | find | GSCM.SCP.Analysis.WSL | SCP0015_GET_PLAN_ENGINE_RUN | 4 | 206.51 | p_modeling_id=, p_division_id=, p_revision_no= |
| 04:57:24.650 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 19.29 | p_menu_id=SCP0015, p_log_type=FIND, p_log_cnt=4, p_db_time=0.218, p_ui_time=0.005, p_user_id=jaeuk.shin |
| 04:57:29.842 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.05 | MenuID=Plan Management, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Revision | txtRevision |  |
| Div* | cboDivision | Y |
| Plan Date* | cboPlanWeek | Y |
| Year* | cboPlanYear | Y |

## 그리드

- spdPlan / Plan Management: 행 5 · 컬럼 20(보임 9) · 헤더 2단 · 고정 컬럼 1
- spdEngin / Engine Run: 행 4 · 컬럼 16(보임 7) · 헤더 2단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

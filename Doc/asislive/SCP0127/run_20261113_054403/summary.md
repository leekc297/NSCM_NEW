# AS-IS 실측 요약 — SCP0127

- 실행: 2026-11-13 05:44:03.233 ~ 2026-11-13 05:44:24.880 · 계정 jaeuk.shin · 상태 OK
- 화면: Precede/Safety Stock Day (GSCM.SCP.Master.UIL.SCP0127_PrecedeSafetyStockDay)
- 조회 결과: Total : 534 · DB : 0.172s, UI : 0.094s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:44:03.584 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.63 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:44:08.668 | load | GSCM.SCP.Master.WSL | SCP0127_GET_SEARCH_INFO | 46 | 5076.08 | p_division_id=81, p_site_id= |
| 05:44:09.110 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 05:44:09.133 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.61 | USER_ID= |
| 05:44:09.320 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.43 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 05:44:09.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.64 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:44:09.567 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 206.49 | MenuID=Precede/Safety Stock Day, CnntCode=0104001, UserID=jaeuk.shin |
| 05:44:09.615 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 05:44:18.490 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.39 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 05:44:18.508 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 9.84 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:44:18.679 | find | GSCM.SCP.Master.WSL | SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY | 534 | 151.31 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_stage=, p_valid_yn=, p_value_type=, p_period_from=20261109, p_period_to=20271108 |
| 05:44:18.805 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 8.5 | p_menu_id=SCP0127, p_log_type=FIND, p_log_cnt=534, p_db_time=0.172, p_ui_time=0.094, p_user_id=jaeuk.shin |
| 05:44:24.232 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.69 | MenuID=Precede/Safety Stock Day, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Model | txtItemId |  |
| Type | cboType |  |
| Valid | cboValid |  |
| lblItemIdButton | btnItemId |  |
| Stage | cboStage |  |
| Period* | dCalendar | Y |
| SCM Site | clbSite |  |
| Plan Group | clbPlanGroup |  |

## 그리드

- spdMain / PRECEDE / SAFETY STOCK DAY: 행 534 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

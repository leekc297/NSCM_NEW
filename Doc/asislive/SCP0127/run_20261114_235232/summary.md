# AS-IS 실측 요약 — SCP0127

- 실행: 2026-11-14 23:52:32.554 ~ 2026-11-14 23:52:54.776 · 계정 jaeuk.shin · 상태 OK
- 화면: Precede/Safety Stock Day (GSCM.SCP.Master.UIL.SCP0127_PrecedeSafetyStockDay)
- 조회 결과: Total : 534 · DB : 0.094s, UI : 0.077s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:52:33.101 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:52:36.983 | load | GSCM.SCP.Master.WSL | SCP0127_GET_SEARCH_INFO | 46 | 3879.69 | p_division_id=81, p_site_id= |
| 23:52:37.764 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 23:52:37.792 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.58 | USER_ID= |
| 23:52:38.093 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 24.78 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 23:52:38.105 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.84 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:52:38.274 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 67.52 | MenuID=Precede/Safety Stock Day, CnntCode=0104001, UserID=jaeuk.shin |
| 23:52:38.335 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 23:52:47.675 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.73 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 23:52:47.685 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.29 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:52:47.770 | find | GSCM.SCP.Master.WSL | SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY | 534 | 69.51 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_stage=, p_valid_yn=, p_value_type=, p_period_from=20261109, p_period_to=20271108 |
| 23:52:47.875 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.49 | p_menu_id=SCP0127, p_log_type=FIND, p_log_cnt=534, p_db_time=0.094, p_ui_time=0.077, p_user_id=jaeuk.shin |
| 23:52:54.022 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.7 | MenuID=Precede/Safety Stock Day, CnntCode=0104002, UserID=jaeuk.shin |

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

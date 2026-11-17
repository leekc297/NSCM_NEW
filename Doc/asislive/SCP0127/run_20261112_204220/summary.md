# AS-IS 실측 요약 — SCP0127

- 실행: 2026-11-12 20:42:20.558 ~ 2026-11-12 20:42:37.915 · 계정 jaeuk.shin · 상태 OK
- 화면: Precede/Safety Stock Day (GSCM.SCP.Master.UIL.SCP0127_PrecedeSafetyStockDay)
- 조회 결과: Total : 534 · DB : 0.092s, UI : 0.007s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:42:20.908 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.62 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:22.756 | load | GSCM.SCP.Master.WSL | SCP0127_GET_SEARCH_INFO | 46 | 1843.42 | p_division_id=81, p_site_id= |
| 20:42:23.189 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 20:42:23.214 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.32 | USER_ID= |
| 20:42:23.498 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 19.58 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 20:42:23.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.99 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:23.595 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 59.48 | MenuID=Precede/Safety Stock Day, CnntCode=0104001, UserID=jaeuk.shin |
| 20:42:23.633 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 20:42:31.731 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.84 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 20:42:31.741 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.59 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:31.826 | find | GSCM.SCP.Master.WSL | SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY | 534 | 74.89 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_stage=, p_valid_yn=, p_value_type=, p_period_from=20261109, p_period_to=20271108 |
| 20:42:31.852 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.03 | p_menu_id=SCP0127, p_log_type=FIND, p_log_cnt=534, p_db_time=0.092, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 20:42:37.196 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.4 | MenuID=Precede/Safety Stock Day, CnntCode=0104002, UserID=jaeuk.shin |

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

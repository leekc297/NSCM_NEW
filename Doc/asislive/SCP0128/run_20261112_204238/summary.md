# AS-IS 실측 요약 — SCP0128

- 실행: 2026-11-12 20:42:38.053 ~ 2026-11-12 20:42:55.679 · 계정 jaeuk.shin · 상태 OK
- 화면: Precede/Safety Stock Qty (GSCM.SCP.Master.UIL.SCP0128_SafetyStock)
- 조회 결과: Total : 3 · DB : 0.211s, UI : 0.002s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:42:38.442 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.36 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:40.595 | load | GSCM.SCP.Master.WSL | SCP0128_GET_SEARCH_INFO | 46 | 2147.75 | p_division_id=81, p_site_id= |
| 20:42:41.045 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.31 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0128 |
| 20:42:41.070 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.5 | USER_ID= |
| 20:42:41.278 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.71 | p_program_id=SCP0128, p_user_id=jaeuk.shin, p_sheet_name=SAFETY STOCK |
| 20:42:41.287 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.55 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:41.363 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 54.09 | MenuID=Precede/Safety Stock Qty, CnntCode=0104001, UserID=jaeuk.shin |
| 20:42:41.405 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.6 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0128 |
| 20:42:49.356 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.15 | p_program_id=SCP0128, p_user_id=jaeuk.shin, p_sheet_name=SAFETY STOCK |
| 20:42:49.365 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.48 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:49.580 | find | GSCM.SCP.Master.WSL | SCP0128_GET_SAFETY_STOCK | 3 | 205.14 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_stage=, p_valid_yn=, p_value_type=, p_period_from=20261109, p_period_to=20271108 |
| 20:42:49.591 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.59 | p_menu_id=SCP0128, p_log_type=FIND, p_log_cnt=3, p_db_time=0.211, p_ui_time=0.002, p_user_id=jaeuk.shin |
| 20:42:54.787 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.81 | MenuID=Precede/Safety Stock Qty, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / SAFETY STOCK: 행 3 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

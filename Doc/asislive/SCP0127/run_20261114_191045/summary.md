# AS-IS 실측 요약 — SCP0127

- 실행: 2026-11-14 19:10:45.291 ~ 2026-11-14 19:11:22.562 · 계정 jaeuk.shin · 상태 OK
- 화면: Precede/Safety Stock Day (GSCM.SCP.Master.UIL.SCP0127_PrecedeSafetyStockDay)
- 조회 결과: Total : 534 · DB : 0.066s, UI : 0.079s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:11:02.035 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.11 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:11:02.645 | load | GSCM.SCP.Master.WSL | SCP0127_GET_SEARCH_INFO | 46 | 578.65 | p_division_id=81, p_site_id= |
| 19:11:04.850 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 19:11:04.880 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.92 | USER_ID= |
| 19:11:05.743 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 25.08 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 19:11:05.764 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.96 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:11:06.160 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 61.0 | MenuID=Precede/Safety Stock Day, CnntCode=0104001, UserID=jaeuk.shin |
| 19:11:06.348 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0127 |
| 19:11:16.034 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 5.01 | p_program_id=SCP0127, p_user_id=jaeuk.shin, p_sheet_name=PRECEDE / SAFETY STOCK DAY |
| 19:11:16.045 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.58 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:11:16.100 | find | GSCM.SCP.Master.WSL | SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY | 534 | 30.17 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_stage=, p_valid_yn=, p_value_type=, p_period_from=20261109, p_period_to=20271108 |
| 19:11:16.212 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.4 | p_menu_id=SCP0127, p_log_type=FIND, p_log_cnt=534, p_db_time=0.066, p_ui_time=0.079, p_user_id=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(10920)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

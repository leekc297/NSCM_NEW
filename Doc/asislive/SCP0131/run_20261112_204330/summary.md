# AS-IS 실측 요약 — SCP0131

- 실행: 2026-11-12 20:43:30.603 ~ 2026-11-12 20:43:48.209 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Site Priority (GSCM.SCP.Master.UIL.SCP0131_SalesSitePriority)
- 조회 결과: Total : 61 · DB : 0.05s, UI : 0.005s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:43:31.009 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.69 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:32.780 | load | GSCM.SCP.Master.WSL | SCP0128_GET_SEARCH_INFO | 46 | 1766.01 | p_division_id=81, p_site_id= |
| 20:43:33.189 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0131 |
| 20:43:33.212 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.1 | USER_ID= |
| 20:43:33.493 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.73 | p_program_id=SCP0131, p_user_id=jaeuk.shin, p_sheet_name=Sales Site Priority |
| 20:43:33.502 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.78 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:33.681 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 155.65 | MenuID=Sales Site Priority, CnntCode=0104001, UserID=jaeuk.shin |
| 20:43:33.717 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0131 |
| 20:43:41.786 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.47 | p_program_id=SCP0131, p_user_id=jaeuk.shin, p_sheet_name=Sales Site Priority |
| 20:43:41.798 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.85 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:41.852 | find | GSCM.SCP.Master.WSL | SCP0131_GET_SALES_SITE_PRIORITY | 61 | 43.81 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_valid_yn=, p_period_from=20261109, p_period_to=20271108 |
| 20:43:41.867 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.75 | p_menu_id=SCP0131, p_log_type=FIND, p_log_cnt=61, p_db_time=0.05, p_ui_time=0.005, p_user_id=jaeuk.shin |
| 20:43:47.279 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.61 | MenuID=Sales Site Priority, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Model | txtItemId |  |
| lblItemIdButton | btnItemId |  |
| Valid | cboValid |  |
| Period* | dCalendar | Y |
| Plan Group | clbPlanGroup |  |
| SCM Site | clbSite |  |

## 그리드

- spdMain / Sales Site Priority: 행 61 · 컬럼 15(보임 14) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0131

- 실행: 2026-11-15 00:00:41.252 ~ 2026-11-15 00:00:57.336 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Site Priority (GSCM.SCP.Master.UIL.SCP0131_SalesSitePriority)
- 조회 결과: Total : 61 · DB : 0.068s, UI : 0.061s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:00:41.774 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.2 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:00:42.330 | load | GSCM.SCP.Master.WSL | SCP0128_GET_SEARCH_INFO | 46 | 546.39 | p_division_id=81, p_site_id= |
| 00:00:43.079 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0131 |
| 00:00:43.108 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.03 | USER_ID= |
| 00:00:43.375 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 23.1 | p_program_id=SCP0131, p_user_id=jaeuk.shin, p_sheet_name=Sales Site Priority |
| 00:00:43.386 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.61 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:00:43.580 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 100.16 | MenuID=Sales Site Priority, CnntCode=0104001, UserID=jaeuk.shin |
| 00:00:43.635 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0131 |
| 00:00:51.742 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.11 | p_program_id=SCP0131, p_user_id=jaeuk.shin, p_sheet_name=Sales Site Priority |
| 00:00:51.745 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 4.4 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:00:51.810 | find | GSCM.SCP.Master.WSL | SCP0131_GET_SALES_SITE_PRIORITY | 61 | 41.2 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_valid_yn=, p_period_from=20261116, p_period_to=20271115 |
| 00:00:51.887 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.3 | p_menu_id=SCP0131, p_log_type=FIND, p_log_cnt=61, p_db_time=0.068, p_ui_time=0.061, p_user_id=jaeuk.shin |
| 00:00:56.652 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.84 | MenuID=Sales Site Priority, CnntCode=0104002, UserID=jaeuk.shin |

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

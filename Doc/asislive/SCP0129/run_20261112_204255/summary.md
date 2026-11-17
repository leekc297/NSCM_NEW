# AS-IS 실측 요약 — SCP0129

- 실행: 2026-11-12 20:42:55.816 ~ 2026-11-12 20:43:13.862 · 계정 jaeuk.shin · 상태 OK
- 화면: Demand Exception (GSCM.SCP.Master.UIL.SCP0129_DemandException)
- 조회 결과: Total : 7 · DB : 0.207s, UI : 0.004s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:42:56.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.15 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:57.971 | load | GSCM.SCP.Master.WSL | SCP0128_GET_SEARCH_INFO | 46 | 1769.14 | p_division_id=81, p_site_id= |
| 20:42:58.419 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0129 |
| 20:42:58.443 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.79 | USER_ID= |
| 20:42:58.653 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.98 | p_program_id=SCP0129, p_user_id=jaeuk.shin, p_sheet_name=DEMAND EXCEPTION |
| 20:42:58.662 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 4.01 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:58.748 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 59.66 | MenuID=Demand Exception, CnntCode=0104001, UserID=jaeuk.shin |
| 20:42:58.791 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0129 |
| 20:43:07.216 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.64 | p_program_id=SCP0129, p_user_id=jaeuk.shin, p_sheet_name=DEMAND EXCEPTION |
| 20:43:07.224 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 4.18 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:07.443 | find | GSCM.SCP.Master.WSL | SCP0129_GET_DEMAND_EXCEPTION | 7 | 202.78 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_stage=, p_valid_yn=, p_period_from=20261109, p_period_to=20271108 |
| 20:43:07.457 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.89 | p_menu_id=SCP0129, p_log_type=FIND, p_log_cnt=7, p_db_time=0.207, p_ui_time=0.004, p_user_id=jaeuk.shin |
| 20:43:12.933 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.94 | MenuID=Demand Exception, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Stage | cboStage |  |
| lblItemIdButton | btnItemId |  |
| Valid | cboValid |  |
| Period* | dCalendar | Y |
| SCM Site | clbSite |  |
| Model | txtItemId |  |
| Plan Group | clbPlanGroup |  |

## 그리드

- spdMain / DEMAND EXCEPTION: 행 7 · 컬럼 17(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

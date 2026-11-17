# AS-IS 실측 요약 — SCP0006

- 실행: 2026-11-12 23:46:27.380 ~ 2026-11-12 23:51:23.613 · 계정 jaeuk.shin · 상태 OK
- 화면: Project Route (GSCM.SCP.Master.UIL.SCP0006_ProjectRoute)
- 조회 결과: Total : 163 · DB : 268.958s, UI : 0.13s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:46:27.771 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:27.801 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 23.53 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:27.828 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 6.28 | Code=BuildingByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:35.578 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 7743.8 | Code=PlantByDivisionOperationItem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:35.587 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 16 | 3.76 | Code=PlantSiteOsPack, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:35.661 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.27 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0006 |
| 23:46:35.685 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.04 | USER_ID= |
| 23:46:36.405 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 29 | 441.66 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:36.516 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 96.17 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:46:36.571 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 25.47 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 23:46:36.617 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 12 | 35.86 | Code=CalendarMonth, Param1=202611, Param2=202710, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:46:36.629 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 4.09 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=BOM Explosion |
| 23:46:36.642 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 4.04 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Plant Assign |
| 23:46:36.655 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 7.35 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:46:36.747 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 63.89 | MenuID=Project Route, CnntCode=0104001, UserID=jaeuk.shin |
| 23:46:36.857 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0006 |
| 23:46:47.060 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.52 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 23:46:47.077 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 12 | 3.73 | Code=CalendarMonth, Param1=202611, Param2=202710, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:51:15.921 | find | GSCM.SCM.Master.WSL | SCP0006_GET_PROJECT_ROUTE_SITE | 163 | 268827.3 | p_division_id=81, p_scm_site_id=, p_project_code=, p_item_id=, p_from_yyyymm=202611, p_to_yyyymm=202710, p_status=None, debug_mode=F |
| 23:51:15.946 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 3.55 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=BOM Explosion |
| 23:51:15.959 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 4.3 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Plant Assign |
| 23:51:15.970 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.94 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:51:16.069 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.26 | p_menu_id=SCP0006, p_log_type=FIND, p_log_cnt=163, p_db_time=268.958, p_ui_time=0.13, p_user_id=jaeuk.shin |
| 23:51:22.733 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.19 | MenuID=Project Route, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem4 | btnProject |  |
| Model | txtItemId |  |
| layoutControlItem11 | btnItemId |  |
| Project | txtProject |  |
| Period | drpPeriod |  |
| Sales Site | clbSalesSite |  |
| Status | cboStatus |  |
| Div* | cboDivision | Y |
| Input All | btnAllFind |  |

## 그리드

- spdMain / Main: 행 163 · 컬럼 23(보임 20) · 헤더 1단 · 고정 컬럼 5
- spdBOM / BOM Explosion: 행 0 · 컬럼 12(보임 6) · 헤더 1단 · 고정 컬럼 0
- spdPlant / Plant Assign: 행 0 · 컬럼 25(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

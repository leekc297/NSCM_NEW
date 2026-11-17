# AS-IS 실측 요약 — SCP0133

- 실행: 2026-11-12 20:44:05.090 ~ 2026-11-12 20:44:21.513 · 계정 jaeuk.shin · 상태 OK
- 화면: Warehouse Capacity (GSCM.SCP.Master.UIL.SCP0133_WarehouseCapacity)
- 조회 결과: Total : 8 · DB : 0.037s, UI : 0.003s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:44:05.472 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.89 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:44:05.965 | load | GSCM.SCP.Master.WSL | SCP0133_GET_SEARCH_INFO | 46 | 485.12 |  |
| 20:44:06.180 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0133 |
| 20:44:06.203 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.26 | USER_ID= |
| 20:44:06.445 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.84 | p_program_id=SCP0133, p_user_id=jaeuk.shin, p_sheet_name=Warehouse Capacity |
| 20:44:06.452 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.23 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:44:06.465 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.77 | p_program_id=SCP0133, p_user_id=jaeuk.shin, p_sheet_name=Warehouse Item Mapping |
| 20:44:06.472 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.19 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:44:06.601 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 96.47 | MenuID=Warehouse Capacity, CnntCode=0104001, UserID=jaeuk.shin |
| 20:44:06.631 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0133 |
| 20:44:14.711 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.99 | p_program_id=SCP0133, p_user_id=jaeuk.shin, p_sheet_name=Warehouse Capacity |
| 20:44:14.719 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.54 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:44:14.734 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.66 | p_program_id=SCP0133, p_user_id=jaeuk.shin, p_sheet_name=Warehouse Capacity |
| 20:44:14.742 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.61 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:44:14.782 | find | GSCM.SCP.Master.WSL | SCP0133_GET_WAREHOUSE_CAPACITY | 8 | 31.3 | p_division_id=81, p_opmz_plan_gr_id=, p_site_id=, p_stage=, p_wh_nm=, p_from_yyyymmdd=20261109, p_to_yyyymmdd=20271108, p_item_id=, p_valid_yn= |
| 20:44:14.821 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 30.1 | p_menu_id=SCP0133, p_log_type=FIND, p_log_cnt=8, p_db_time=0.037, p_ui_time=0.003, p_user_id=jaeuk.shin |
| 20:44:20.001 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.33 | MenuID=Warehouse Capacity, CnntCode=0104002, UserID=jaeuk.shin |
| 20:44:20.375 | find | GSCM.SCP.Master.WSL | SCP0133_GET_SEARCH_INFO | 46 | 145.56 |  |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Stage | cboStage |  |
| Valid | cboValid |  |
| Period* | dCalendar | Y |
| Name | clbWarehouse |  |
| Model | txtItemId |  |
| lblItemIdButton | btnItemId |  |
| Plan Group | clbPlanGroup |  |
| SCM Site | clbSite |  |

## 그리드

- spdMain / Warehouse Capacity: 행 8 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0
- spdMain / Warehouse Item Mapping: 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0039

- 실행: 2026-11-12 20:03:58.718 ~ 2026-11-12 20:04:20.628 · 계정 jaeuk.shin · 상태 OK
- 화면: Master Validation (GSCM.SCP.Master.UIL.SCP0039_ValidationMaster)
- 조회 결과: Total : 1 · DB : 4.213s, UI : 0.004s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:03:59.043 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.71 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:59.904 | load | GSCM.SCM.Master.WSL | SCM0003_GET_LOOKUP_MASTER_DETAIL | 13 | 856.3 | p_lookup_type=MASTER_VALIDATION |
| 20:04:00.341 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 429.93 | p_user_id= |
| 20:04:00.396 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0039 |
| 20:04:00.418 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.78 | USER_ID= |
| 20:04:00.610 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 114.92 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Validation Info |
| 20:04:00.636 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 4.44 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=BOM |
| 20:04:00.651 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 4.6 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Project Route |
| 20:04:00.675 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 18.5 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Project Route (Elec) |
| 20:04:00.694 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 13.64 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=BOD / BOD Item |
| 20:04:00.715 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 14.41 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=CAPA : Line Assign |
| 20:04:00.736 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 15.41 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=CAPA : Tact Time |
| 20:04:00.756 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 13.1 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Tact Time(OSP) [82] |
| 20:04:00.770 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 8.27 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Outsourcing Capacity [40] |
| 20:04:00.784 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 8.61 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Stock OSP |
| 20:04:00.799 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 9.7 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Plan Group |
| 20:04:00.817 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 12.69 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=Intransit Inventory |
| 20:04:00.835 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 13.03 | p_program_id=SCP0039, p_user_id=jaeuk.shin, p_sheet_name=CAPA : Yield (Formation) |
| 20:04:01.145 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 290.65 | MenuID=Master Validation, CnntCode=0104001, UserID=jaeuk.shin |
| 20:04:01.197 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 9.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0039 |
| 20:04:09.903 | find | GSCM.SCP.Master.WSL | SCP0030_GET_BOD_ITEM | 285381 | 289451.63 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_from_site=AU00,EG00,EG00,EG00,IL00,MI00,AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_8 |
| 20:04:14.338 | find | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_STOCK_OSP | 1 | 4071.73 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:04:14.424 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 73.21 | p_menu_id=SCP0039, p_log_type=FIND, p_log_cnt=1, p_db_time=4.213, p_ui_time=0.004, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Plan Group | clbPlanGroup |  |
| Model / Nickname | txtItemId |  |
| layoutControlItem1 | btnItemId |  |
| Search | btnSearch |  |

## 그리드

- spdMain / Validation Info: 행 12 · 컬럼 10(보임 9) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / BOM: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 3
- spdProjectRouteInfo / Project Route: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / Project Route (Elec): 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / BOD / BOD Item: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / CAPA : Line Assign: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / CAPA : Tact Time: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / Tact Time(OSP) [82]: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / Outsourcing Capacity [40]: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / Stock OSP: 행 1 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / Plan Group: 행 0 · 컬럼 10(보임 9) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / Intransit Inventory: 행 0 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0
- spdProjectRouteInfo / CAPA : Yield (Formation): 행 0 · 컬럼 12(보임 11) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

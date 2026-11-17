# AS-IS 실측 요약 — SCP0085

- 실행: 2026-11-13 04:57:30.701 ~ 2026-11-13 05:00:05.267 · 계정 jaeuk.shin · 상태 OK
- 화면: Ending Inventory (GSCM.SCP.Report.UIL.SCP0085_EndingInventory)
- 조회 결과: Total : 132,922 · DB : 124.081s, UI : 0.411s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:57:31.121 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.46 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:57:31.231 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 106.42 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:57:31.283 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0085 |
| 04:57:31.307 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.32 | USER_ID= |
| 04:57:31.568 | load | GSCM.SCP.Analysis.WSL | SCP0084_GET_MONTH_RANGE | 1 | 126.98 | p_month=12 |
| 04:57:44.901 | load | GSCM.SCP.Master.WSL | SCP0085_GET_SEARCH_INFO | 41 | 13287.51 | P_YYYYMMDD=202609 |
| 04:57:44.977 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 7 | 26.47 | p_lookup_type=ITEM_TYPE |
| 04:57:45.031 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 73 | 33.19 | p_program_id=SCP0085, p_user_id=jaeuk.shin, p_sheet_name=Ending Inventory Main |
| 04:57:45.334 | load | GSCM.SCP.Master.WSL | SCP0085_GET_SEARCH_INFO | 41 | 225.05 | P_YYYYMMDD=202609 |
| 04:57:45.483 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 101.98 | MenuID=Ending Inventory, CnntCode=0104001, UserID=jaeuk.shin |
| 04:57:45.550 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0085 |
| 04:57:54.013 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 73 | 4.59 | p_program_id=SCP0085, p_user_id=jaeuk.shin, p_sheet_name=Ending Inventory Main |
| 04:59:47.069 | find | GSCM.SCP.Analysis.WSL | SCP0085_GET_ENDING_INVENTORY | 132922 | 113022.92 | p_yyyymm=202609, p_division_id=, p_plant_id=, p_item_type=, p_item_id=, p_profit_center=, debug_mode=F |
| 04:59:58.543 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.47 | p_menu_id=SCP0085, p_log_type=FIND, p_log_cnt=132922, p_db_time=124.081, p_ui_time=0.411, p_user_id=jaeuk.shin |
| 05:00:04.214 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 71.51 | MenuID=Ending Inventory, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Month | monthPicker |  |
| Plant | clbPlant |  |
| Material | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutRdoMonth | RdoMonth |  |
| layoutControlItem1 | RdoDate |  |
| Date | datePicker |  |
| layoutControlItem1 | chkDetail |  |
| Profit Center | cboProfit |  |
| Item Type | clbItemType |  |

## 그리드

- spdMain / Ending Inventory Main: 행 132922 · 컬럼 75(보임 39) · 헤더 1단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

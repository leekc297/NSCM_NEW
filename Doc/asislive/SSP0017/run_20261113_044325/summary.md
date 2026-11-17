# AS-IS 실측 요약 — SSP0017

- 실행: 2026-11-13 04:43:25.464 ~ 2026-11-13 04:43:49.854 · 계정 jaeuk.shin · 상태 OK
- 화면: Inventory Raw(Mobility  & IT) (GSCM.SSP.Plan.UIL.SSP0017_InventoryRaw)
- 조회 결과: Total :  · DB : s, UI : 63930141823.613s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "check": "0", "only": "1"}, {"name": "clbDivision", "check": "1", "only": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:43:25.823 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.48 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:43:25.876 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 48.98 | Code=OWMS_STOCK_STATUS, Param1=OWMS_STOCK_STATUS, Param2=KO, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:25.919 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0017 |
| 04:43:25.944 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.31 | USER_ID= |
| 04:43:26.101 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 46.63 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:26.142 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 25.48 | Code=ShipmentRequestPlantSite, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:43:27.166 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 1012.73 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:27.204 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 29.91 | p_program_id=SSP0017, p_user_id=jaeuk.shin, p_sheet_name=Inventory Raw(Mobility & IT) |
| 04:43:27.213 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.52 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:27.236 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 15.74 | Code=OWMS_STOCK_STATUS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:27.379 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 117.13 | MenuID=Inventory Raw(Mobility  & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 04:43:27.421 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0017 |
| 04:43:37.591 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 99 | 131.36 | Code=ShipmentPlanPlantSite, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:43:38.320 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 703.64 | Code=PlanDateShip, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:38.338 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 27 | 4.9 | Code=ShipmentRequestPlantSite, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:43:39.018 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 664.63 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:42.989 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.87 | p_program_id=SSP0017, p_user_id=jaeuk.shin, p_sheet_name=Inventory Raw(Mobility & IT) |
| 04:43:42.998 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.88 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:43.009 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.61 | Code=OWMS_STOCK_STATUS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 04:43:43.606 | find | GSCM.SSP.Plan.WSL | SSP0017_GET_INVENTORY_RAW | 0 | 563.23 | p_division_id=81, p_plant_site=, p_item_id=, p_inventory_type=F,O, p_plan_start_yyyymmdd=20261009, p_user_id=jaeuk.shin, p_program_id=SSP0017, p_sheet_name=Inventory Raw(Mobility & IT) |
| 04:43:43.631 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.73 | p_menu_id=SSP0017, p_log_type=FIND, p_log_cnt=, p_db_time=, p_ui_time=63930141823.613, p_user_id=jaeuk.shin |
| 04:43:49.136 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.34 | MenuID=Inventory Raw(Mobility  & IT), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Model | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| Plan date* | cboPlanDate | Y |
| layoutControlItem10 | btnMeasure |  |
| Div | clbDivision |  |
| Inventory Type | cboInventoryType |  |

## 그리드

- spdMain / Inventory Raw(Mobility & IT): 행 0 · 컬럼 28(보임 27) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

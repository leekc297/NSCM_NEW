# AS-IS 실측 요약 — SSP0012

- 실행: 2026-11-13 00:41:47.542 ~ 2026-11-13 00:43:08.694 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan Detail (GSCM.SSP.Plan.UIL.SSP0012_ShipmentPlanConfirmDetail)
- 조회 결과: Total : 21 · DB : 64.876s, UI : 0.105s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:41:47.899 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 5.74 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:47.906 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.68 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:47.926 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 15.69 | Code=LookupCommon, Param1=CHANGE_REQ_APP_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:47.963 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0012 |
| 00:41:47.986 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.16 | USER_ID= |
| 00:41:48.153 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 99 | 79.9 | Code=ShipmentPlanPlantSite, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:48.184 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.09 | p_from_date=20261113, p_offset_day=55, p_timezone=AS054 |
| 00:41:48.190 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.96 | p_from_date=20261113, p_offset_day=55, p_timezone=AS054 |
| 00:41:48.222 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 27.64 | p_program_id=SSP0012, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Confirm Detail |
| 00:41:48.237 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.54 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:48.478 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 191.21 | MenuID=Shipment Plan Detail, CnntCode=0104001, UserID=jaeuk.shin |
| 00:41:48.638 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0012 |
| 00:41:57.027 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 13.44 | p_program_id=SSP0012, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Confirm Detail |
| 00:41:57.038 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.41 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:01.917 | find | GSCM.SSP.Plan.WSL | SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | 21 | 64859.21 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=, p_item_id=, p_from_yyyymmdd=20261113, p_to_yyyymmdd=20270107, p_Sold_To_Party=, p_Ship_To_Party=, debug_mode=F, p_language=KO |
| 00:43:02.115 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 62.16 | p_menu_id=SSP0012, p_log_type=FIND, p_log_cnt=21, p_db_time=64.876, p_ui_time=0.105, p_user_id=jaeuk.shin |
| 00:43:07.306 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.21 | MenuID=Shipment Plan Detail, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| From Site | clbPlantSite |  |
| Model | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| Period* | drpPeriod | Y |
| Div | clbDivision |  |
| Sold To Party | txtSoldToParty |  |
| Ship To Party | txtShipToParty |  |
| layoutControlItem5 | btnColumn |  |

## 그리드

- spdMain / Shipment Plan Confirm Detail: 행 21 · 컬럼 48(보임 44) · 헤더 2단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

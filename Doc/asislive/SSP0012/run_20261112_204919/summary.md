# AS-IS 실측 요약 — SSP0012

- 실행: 2026-11-12 20:49:19.387 ~ 2026-11-12 20:49:59.793 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan Detail (GSCM.SSP.Plan.UIL.SSP0012_ShipmentPlanConfirmDetail)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:49:19.690 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.5 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:49:19.697 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:49:19.704 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.35 | Code=LookupCommon, Param1=CHANGE_REQ_APP_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:49:19.735 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0012 |
| 20:49:19.758 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.79 | USER_ID= |
| 20:49:19.860 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 99 | 6.86 | Code=ShipmentPlanPlantSite, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:49:19.884 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.37 | p_from_date=20261112, p_offset_day=55, p_timezone=AS054 |
| 20:49:19.891 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.17 | p_from_date=20261112, p_offset_day=55, p_timezone=AS054 |
| 20:49:19.926 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 26.49 | p_program_id=SSP0012, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Confirm Detail |
| 20:49:19.935 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.65 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:49:20.094 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 99.49 | MenuID=Shipment Plan Detail, CnntCode=0104001, UserID=jaeuk.shin |
| 20:49:20.134 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0012 |
| 20:49:28.241 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 4.93 | p_program_id=SSP0012, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Confirm Detail |
| 20:49:28.250 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

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

- spdMain / Shipment Plan Confirm Detail: 행 0 · 컬럼 47(보임 44) · 헤더 2단 · 고정 컬럼 13

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

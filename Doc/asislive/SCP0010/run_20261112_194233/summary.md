# AS-IS 실측 요약 — SCP0010

- 실행: 2026-11-12 19:42:33.195 ~ 2026-11-12 19:43:24.940 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan SEMI (GSCM.SCP.Analysis.UIL.SCP0010_Shipment_Plan_SEMI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:42:34.572 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.62 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:34.614 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2662 | 33.07 | Code=AllPlantSiteDescription, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:34.641 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 4.7 | Code=ShipmentPlanSEMIToStie1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:34.650 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 42 | 5.02 | Code=ToSiteShipmentPlanSEMI1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:34.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 177.39 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:34.967 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 130.48 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:35.111 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 137.44 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:42:36.277 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0010 |
| 19:42:36.315 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.89 | USER_ID= |
| 19:42:36.700 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.37 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:42:36.717 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.99 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:42:36.824 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.53 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 19:42:36.831 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.88 |  |
| 19:42:36.851 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 4.73 | p_division_id=81 |
| 19:42:36.881 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 16.88 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:42:38.834 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 1938.82 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 19:42:42.764 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3311.19 | MenuID=Shipment Plan SEMI, CnntCode=0104001, UserID=jaeuk.shin |
| 19:42:42.955 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 10 | 64.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0010 |
| 19:42:43.758 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.67 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:42:43.865 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 5.0 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 19:42:43.978 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 5.55 | p_division_id=82 |
| 19:42:44.022 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 11.77 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:42:44.033 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.45 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 19:42:52.928 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.36 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:42:52.947 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.7 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperGroup | Y |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Bucket | cboBucketType |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| Model | txtItemId |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutControlItem2 | chkSum |  |
| Electrode | clbElecType |  |
| layoutControlItem3 | btnMeasure |  |
| New | btnNew |  |
| To Site | clbToSite |  |
| From Site | clbFromSite |  |
| lbchkAll | chkAll |  |
| W26 | btnW26 |  |
| W52 | btnW52 |  |
| W84 | btnWLast |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Shipment Plan SEMI: 행 0 · 컬럼 467(보임 63) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

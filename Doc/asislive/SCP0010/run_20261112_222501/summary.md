# AS-IS 실측 요약 — SCP0010

- 실행: 2026-11-12 22:25:01.473 ~ 2026-11-12 22:25:47.208 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan SEMI (GSCM.SCP.Analysis.UIL.SCP0010_Shipment_Plan_SEMI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:25:01.842 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.05 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:01.878 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2662 | 31.28 | Code=AllPlantSiteDescription, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:01.901 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 4.9 | Code=ShipmentPlanSEMIToStie1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:01.911 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 42 | 5.15 | Code=ToSiteShipmentPlanSEMI1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:02.098 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 183.37 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:02.245 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 137.31 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:02.401 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 137.1 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:25:02.464 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0010 |
| 22:25:02.488 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.44 | USER_ID= |
| 22:25:02.641 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.58 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:25:02.651 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.86 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:25:02.718 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.7 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 22:25:02.726 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.99 |  |
| 22:25:02.741 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 4.02 | p_division_id=81 |
| 22:25:02.761 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.74 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:25:02.806 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 31.94 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 22:25:03.128 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 168.04 | MenuID=Shipment Plan SEMI, CnntCode=0104001, UserID=jaeuk.shin |
| 22:25:03.265 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 10 | 67.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0010 |
| 22:25:03.851 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.54 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:25:03.923 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.71 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 22:25:04.001 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.66 | p_division_id=82 |
| 22:25:04.034 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 11.74 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:25:04.045 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 3.93 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 22:25:13.550 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.03 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:25:13.565 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 5.13 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |

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

# AS-IS 실측 요약 — SCP0009

- 실행: 2026-11-12 19:38:25.385 ~ 2026-11-12 19:42:12.281 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG (GSCM.SCP.Analysis.UIL.SCP0009_Shipment_Plan_FG)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:38:25.714 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:25.748 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2662 | 30.55 | Code=AllPlantSiteDescription, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:26.102 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 325.25 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:26.300 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 93 | 172.54 | Code=ToSiteShipmentPlanFG1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:26.340 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 26.61 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:28.847 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 2418.01 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:30.001 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 1148.02 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:30.144 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 135.85 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:30.249 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0009 |
| 19:38:30.274 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.67 | USER_ID= |
| 19:38:30.485 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.58 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:38:30.503 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.32 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:38:30.846 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 334.14 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 19:38:30.878 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.19 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:38:31.303 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 211.19 | p_division_id=81 |
| 19:38:31.366 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 57.07 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 19:38:31.478 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 79.18 |  |
| 19:38:31.528 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 27.93 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 19:38:31.552 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 4.17 | p_division_id=81 |
| 19:38:31.821 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 254.63 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:38:31.940 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 109.7 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 19:38:32.132 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.62 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 19:38:32.153 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.57 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 19:38:32.671 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 447.04 | MenuID=Shipment Plan FG, CnntCode=0104001, UserID=jaeuk.shin |
| 19:38:32.895 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 7.3 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0009 |
| 19:38:42.286 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 16.74 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:38:42.303 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 10.8 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 19:38:42.481 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.84 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 19:38:42.498 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.53 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Project | txtProject |  |
| layoutControlItem9 | chkSum |  |
| Operation Group* | cboBizType | Y |
| Div* | cboDivision | Y |
| layoutControlItem2 | btnProject |  |
| Model | txtItem_Id |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| layoutControlItem4 | btnItem_Id |  |
| Bucket | cboBucketType |  |
| layoutControlItem1 | btnMeasure |  |
| Seq* | cboPlanSeq | Y |
| Unfix | btnUnfix |  |
| Fix | btnFix |  |
| layoutControlItem7 | btnColumn |  |
| Electrode | clbElecType |  |
| New | btnNew |  |
| To Site | clbToSite |  |
| From Site | clbFromSite |  |
| Team | clbTeam |  |
| lEnd Customer | clbCustomer |  |
| W84 | btnWLast |  |
| W26 | btnW26 |  |
| W52 | btnW52 |  |
| lbchkAll | chkAll |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Shipment Request: 행 0 · 컬럼 479(보임 68) · 헤더 3단 · 고정 컬럼 40
- spdPeggingInfo / Pegging Info: 행 0 · 컬럼 25(보임 19) · 헤더 1단 · 고정 컬럼 0
- spdPlanProblem / Plan Problem: 행 0 · 컬럼 13(보임 12) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

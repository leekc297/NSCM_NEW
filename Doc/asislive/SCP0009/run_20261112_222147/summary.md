# AS-IS 실측 요약 — SCP0009

- 실행: 2026-11-12 22:21:47.007 ~ 2026-11-12 22:25:01.109 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG (GSCM.SCP.Analysis.UIL.SCP0009_Shipment_Plan_FG)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:21:47.273 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.42 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:47.311 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2662 | 31.09 | Code=AllPlantSiteDescription, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:47.366 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 33.05 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:47.537 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 93 | 152.59 | Code=ToSiteShipmentPlanFG1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:47.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 22.27 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:54.794 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 7203.42 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:57.013 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 2214.74 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:57.159 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 137.86 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:57.283 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0009 |
| 22:21:57.305 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.57 | USER_ID= |
| 22:21:57.852 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 399.97 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:21:58.580 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 713.93 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:21:59.356 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 767.75 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:21:59.382 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.42 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:21:59.531 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.84 | p_division_id=81 |
| 22:22:00.516 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 979.92 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 22:22:00.769 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 222.49 |  |
| 22:22:00.824 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.69 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:00.839 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.94 | p_division_id=81 |
| 22:22:01.646 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 793.71 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:22:02.294 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 640.61 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 22:22:02.454 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.62 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 22:22:02.468 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.76 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 22:22:03.754 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1233.9 | MenuID=Shipment Plan FG, CnntCode=0104001, UserID=jaeuk.shin |
| 22:22:03.940 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0009 |
| 22:22:14.424 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.51 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:22:14.443 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 11.96 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 22:22:14.609 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 4.96 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 22:22:14.626 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.02 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 22:24:59.465 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHIPMENT_PLAN_FG | 0 | 164806.35 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_electype=, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_fromsite=, p_team_id=, p_tosite=, p_bucket=WEEKLY, p_to_period=20270822, p_chk_all=N, p_program_id=SCP0009, p_sheet_n |
| 22:24:59.595 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 36.14 | p_menu_id=SCP0009, p_log_type=FIND, p_log_cnt=, p_db_time=164.879, p_ui_time=0.035, p_user_id=jaeuk.shin |
| 22:25:00.407 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=Shipment Plan FG, CnntCode=0104002, UserID=jaeuk.shin |

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

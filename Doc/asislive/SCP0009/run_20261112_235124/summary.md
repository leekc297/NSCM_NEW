# AS-IS 실측 요약 — SCP0009

- 실행: 2026-11-12 23:51:24.010 ~ 2026-11-12 23:53:48.737 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG (GSCM.SCP.Analysis.UIL.SCP0009_Shipment_Plan_FG)
- 조회 결과: Total :  · DB : 122.201s, UI : 0.096s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:51:24.454 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.51 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:24.492 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2662 | 32.86 | Code=AllPlantSiteDescription, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:24.843 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 325.66 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:24.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 93 | 3.43 | Code=ToSiteShipmentPlanFG1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:24.901 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 23.57 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:25.399 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 477.61 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:25.705 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 300.99 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:25.843 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 132.14 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:25.931 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0009 |
| 23:51:25.957 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.24 | USER_ID= |
| 23:51:26.211 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 45.62 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:51:26.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 55.17 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:51:26.313 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.56 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 23:51:26.330 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.35 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:51:26.504 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 3.24 | p_division_id=81 |
| 23:51:26.512 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.67 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 23:51:26.593 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 49.8 |  |
| 23:51:26.642 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.59 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 23:51:26.666 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 3.11 | p_division_id=81 |
| 23:51:26.694 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.17 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 23:51:26.762 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 58.79 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 23:51:26.977 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.76 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 23:51:26.994 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.61 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 23:51:27.215 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 113.68 | MenuID=Shipment Plan FG, CnntCode=0104001, UserID=jaeuk.shin |
| 23:51:27.343 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.73 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0009 |
| 23:51:38.271 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.54 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 23:51:38.289 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 9.86 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 23:51:38.476 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 4.44 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 23:51:38.497 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.49 | p_program_id=SCP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 23:53:40.657 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHIPMENT_PLAN_FG | 0 | 122056.44 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_electype=, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_fromsite=, p_team_id=, p_tosite=, p_bucket=WEEKLY, p_to_period=20270822, p_chk_all=N, p_program_id=SCP0009, p_sheet_n |
| 23:53:40.811 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.25 | p_menu_id=SCP0009, p_log_type=FIND, p_log_cnt=, p_db_time=122.201, p_ui_time=0.096, p_user_id=jaeuk.shin |
| 23:53:47.551 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.9 | MenuID=Shipment Plan FG, CnntCode=0104002, UserID=jaeuk.shin |

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

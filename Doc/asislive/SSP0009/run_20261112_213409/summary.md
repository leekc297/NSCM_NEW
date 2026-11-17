# AS-IS 실측 요약 — SSP0009

- 실행: 2026-11-12 21:34:09.001 ~ 2026-11-12 21:34:42.513 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG(SSP) (GSCM.SSP.Plan.UIL.SSP0009_Shipment_Plan_FG)
- 조회 결과: Total :  · DB : 3.113s, UI : 0.015s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:34:09.331 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.38 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:34:09.337 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.18 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:09.397 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 21:34:09.420 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.34 | USER_ID= |
| 21:34:09.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.25 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:34:10.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 693.09 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:10.405 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 124.14 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:10.539 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.22 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:10.557 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.39 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 21:34:10.569 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.51 |  |
| 21:34:10.600 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.85 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 21:34:10.609 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 5.04 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 21:34:10.652 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.99 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 21:34:10.664 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.9 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 21:34:10.694 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=Shipment Plan FG(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 21:34:10.789 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 21:34:19.592 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.7 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:34:20.280 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 679.21 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:20.308 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.81 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:20.336 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.52 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:20.350 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.25 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 21:34:20.377 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.5 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:20.404 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.5 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:20.432 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.77 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:23.383 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 5.21 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:34:24.069 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 680.38 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:24.199 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 126.78 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:24.334 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 131.46 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:27.427 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.37 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:34:28.110 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 677.34 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:28.138 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.91 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:28.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.1 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:28.173 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.83 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 21:34:28.202 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.88 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:34:28.229 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.29 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:28.256 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.4 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:32.550 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.4 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 21:34:32.559 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 4.61 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 21:34:32.600 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.4 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 21:34:32.614 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.5 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 21:34:35.493 | find | GSCM.SSP.Plan.WSL | SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 0 | 2835.81 | p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261203, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_seq=1, p_program_id=SSP0009, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F, p_electrode_type= |
| 21:34:35.729 | find | GSCM.SSP.Plan.WSL | SSP0009_GET_SHIPMENT_PLAN_FG | 0 | 3087.93 | p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261203, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_seq=1, p_program_id=SSP0009, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F, p_electrode_type= |
| 21:34:35.767 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 14.18 | p_menu_id=SSP0009, p_log_type=FIND, p_log_cnt=, p_db_time=3.113, p_ui_time=0.015, p_user_id=jaeuk.shin |
| 21:34:41.845 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.67 | MenuID=Shipment Plan FG(SSP), CnntCode=0104002, UserID=jaeuk.shin |

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
| layoutControlItem1 | btnMeasure |  |
| Seq* | cboPlanSeq | Y |
| Period* | drpPeriod | Y |
| Unfix | btnUnfix |  |
| Fix | btnFix |  |
| layoutControlItem7 | btnColumn |  |
| Electrode | clbElectrode |  |
| Bucket | cboBucketType |  |

## 그리드

- spdMain / Shipment Request: 행 0 · 컬럼 102(보임 72) · 헤더 3단 · 고정 컬럼 32
- spdPeggingInfo / Pegging Info: 행 0 · 컬럼 17(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdPlanProblem / Plan Problem: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

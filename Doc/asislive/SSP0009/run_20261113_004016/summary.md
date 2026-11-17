# AS-IS 실측 요약 — SSP0009

- 실행: 2026-11-13 00:40:16.762 ~ 2026-11-13 00:40:48.738 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG(SSP) (GSCM.SSP.Plan.UIL.SSP0009_Shipment_Plan_FG)
- 조회 결과: Total :  · DB : 3.25s, UI : 0.089s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:40:17.121 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.64 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:40:17.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.27 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:17.190 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 00:40:17.214 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.83 | USER_ID= |
| 00:40:17.363 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.13 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:40:18.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 703.27 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:18.221 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 132.74 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:18.366 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 123.63 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:18.424 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.47 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 00:40:18.439 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.05 |  |
| 00:40:18.488 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.15 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:40:18.525 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 28.51 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 00:40:18.604 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.85 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 00:40:18.620 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.79 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 00:40:18.765 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 101.58 | MenuID=Shipment Plan FG(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 00:40:18.880 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 00:40:27.231 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.45 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:40:27.923 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 684.05 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:27.954 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.75 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:27.983 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.52 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:27.993 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.64 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:40:28.020 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.89 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:28.047 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.19 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:28.075 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.72 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:30.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.61 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:40:31.001 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 698.25 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:31.145 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 125.72 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:31.283 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 125.88 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:34.058 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.13 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:40:34.735 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 657.34 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:34.764 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.69 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:34.800 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.15 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:34.816 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.89 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:40:34.871 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 50.44 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:34.900 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.02 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:34.929 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.24 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:39.030 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.05 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 00:40:39.038 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 3.72 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 00:40:39.077 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.08 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 00:40:39.090 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.61 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 00:40:42.335 | find | GSCM.SSP.Plan.WSL | SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 0 | 3124.49 | p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261203, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_seq=1, p_program_id=SSP0009, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F, p_electrode_type= |
| 00:40:42.336 | find | GSCM.SSP.Plan.WSL | SSP0009_GET_SHIPMENT_PLAN_FG | 0 | 3145.07 | p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261203, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_seq=1, p_program_id=SSP0009, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F, p_electrode_type= |
| 00:40:42.444 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.63 | p_menu_id=SSP0009, p_log_type=FIND, p_log_cnt=, p_db_time=3.25, p_ui_time=0.089, p_user_id=jaeuk.shin |
| 00:40:47.572 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 15.47 | MenuID=Shipment Plan FG(SSP), CnntCode=0104002, UserID=jaeuk.shin |

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

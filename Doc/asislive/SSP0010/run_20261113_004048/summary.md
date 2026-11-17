# AS-IS 실측 요약 — SSP0010

- 실행: 2026-11-13 00:40:48.785 ~ 2026-11-13 00:41:18.832 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan SEMI (SSP) (GSCM.SSP.Plan.UIL.SSP0010_Shipment_Plan_SEMI)
- 조회 결과: Total :  · DB : 1.778s, UI : 0.406s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:40:49.149 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 40.21 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:40:49.167 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.72 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:49.287 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 43.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0010 |
| 00:40:49.356 | load | GSCM.BizService.WSL | SELECT * | 874 | 60.65 | USER_ID= |
| 00:40:49.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.55 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:50.227 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 707.54 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:50.367 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.04 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:50.563 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 186.92 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:50.634 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 28.87 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 00:40:50.651 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.35 |  |
| 00:40:50.730 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.7 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:40:50.789 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 44.57 | p_program_id=SSP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 00:40:51.001 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 158.14 | MenuID=Shipment Plan SEMI (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 00:40:51.142 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0010 |
| 00:40:59.014 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.91 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:59.696 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 675.36 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:59.731 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.16 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:59.764 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 25.36 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:59.776 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.93 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:40:59.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.88 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:40:59.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.89 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:40:59.861 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.13 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:02.175 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.54 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:02.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 649.22 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:02.962 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 126.62 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:03.089 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 122.47 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:05.693 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.93 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:06.394 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 676.43 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:06.422 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.12 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:06.454 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.41 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:06.460 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.85 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:41:06.486 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.73 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:06.514 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.28 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:06.542 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.22 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:10.481 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.04 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 00:41:10.488 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.39 | p_program_id=SSP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 00:41:12.289 | find | GSCM.SSP.Plan.WSL | SSP0010_GET_SHIPMENT_PLAN_SEMI_SSP | 0 | 1662.07 | p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261203, p_division_id=81, p_operation_group=A, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_seq=1, p_program_id=SSP0010, p_sheet_name=CELL, p_user_id=jaeuk.shin, debug_mode=F, p_electrode_type= |
| 00:41:12.749 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 41.8 | p_menu_id=SSP0010, p_log_type=FIND, p_log_cnt=, p_db_time=1.778, p_ui_time=0.406, p_user_id=jaeuk.shin |
| 00:41:17.681 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.95 | MenuID=Shipment Plan SEMI (SSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperGroup | Y |
| Model | txtItemId |  |
| layoutControlItem3 | btnMeasure |  |
| Bucket | cboBucketType |  |
| layoutControlItem4 | btnItem_Id |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| Period* | drpPeriod | Y |
| layoutControlItem2 | chkSum |  |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Electrode | clbElectrode |  |

## 그리드

- spdMain / Shipment Plan SEMI: 행 0 · 컬럼 95(보임 66) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

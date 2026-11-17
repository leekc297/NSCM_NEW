# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-13 05:55:28.805 ~ 2026-11-13 05:55:52.341 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: Total :  · DB : 1.641s, UI : 0.193s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:55:29.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.29 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:55:29.312 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.5 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:55:29.325 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.56 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:55:29.479 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 142.03 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:55:29.871 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:55:29.898 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.53 | USER_ID= |
| 05:55:30.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.25 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:30.078 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.37 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:30.096 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.17 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:55:30.138 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 5.35 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 05:55:30.164 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 14.45 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:55:30.184 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 9.46 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:55:30.417 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.79 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 05:55:30.494 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:55:39.166 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 10.36 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260817, p_offset_month=12, p_timezone=AS054 |
| 05:55:39.199 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 540 | 16.79 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20271107 |
| 05:55:39.235 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.71 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:55:39.537 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 15.64 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 05:55:39.555 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 9.4 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:55:43.889 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.62 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 05:55:43.904 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 8.52 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:55:45.032 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 0 | 874.43 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_iso=F, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:55:45.617 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1479.76 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20261216, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:55:45.660 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1483.44 | p_from_yyyymmdd=20261217, p_to_yyyymmdd=20270416, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:55:45.673 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1474.3 | p_from_yyyymmdd=20270417, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:55:45.890 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.17 | p_menu_id=SCP0016, p_log_type=FIND, p_log_cnt=, p_db_time=1.641, p_ui_time=0.193, p_user_id=jaeuk.shin |
| 05:55:51.685 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.11 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Project | txtProject |  |
| lciSum | chkSum |  |
| Operation Group* | cboBizType | Y |
| Div* | cboDivision | Y |
| layoutControlItem2 | btnProject |  |
| Model | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutControlItem1 | btnMeasure |  |
| Bucket | cboBucketType |  |
| Version* | clbVersion | Y |
| layoutControlItem5 | btnColumn |  |
| Electrode | clbElecType |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Waterfall Shipment Plan: 행 0 · 컬럼 468(보임 328) · 헤더 3단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

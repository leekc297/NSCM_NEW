# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-13 16:52:14.427 ~ 2026-11-13 16:52:40.554 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: Total :  · DB : 2.204s, UI : 0.14s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:52:15.066 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.98 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:52:15.120 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 46.84 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:52:15.127 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.25 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:52:15.614 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 484.07 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:52:15.940 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 14.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 16:52:15.983 | load | GSCM.BizService.WSL | SELECT * | 874 | 34.21 | USER_ID= |
| 16:52:16.200 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.54 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:52:16.275 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 61.88 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:52:16.297 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.34 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:52:16.400 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 64.26 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 16:52:16.452 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 20.28 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 16:52:16.579 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 97.15 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 16:52:16.927 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 103.2 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 16:52:17.082 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 60.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 16:52:26.306 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 17.5 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260817, p_offset_month=12, p_timezone=AS054 |
| 16:52:26.328 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 540 | 15.52 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20271107 |
| 16:52:26.348 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 10.83 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 16:52:26.555 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.71 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 16:52:26.574 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 11.62 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 16:52:31.121 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.33 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 16:52:31.140 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 10.06 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 16:52:33.077 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1691.63 | p_from_yyyymmdd=20261217, p_to_yyyymmdd=20270416, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 16:52:33.179 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1764.29 | p_from_yyyymmdd=20270417, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 16:52:33.182 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1817.5 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20261216, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 16:52:33.473 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 0 | 2073.59 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_iso=F, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 16:52:33.658 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 31.5 | p_menu_id=SCP0016, p_log_type=FIND, p_log_cnt=, p_db_time=2.204, p_ui_time=0.14, p_user_id=jaeuk.shin |
| 16:52:39.901 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.29 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-13 05:29:13.920 ~ 2026-11-13 05:29:47.081 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: Total :  · DB : 9.335s, UI : 0.229s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:29:14.452 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.91 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:14.461 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.43 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:14.468 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.25 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:14.662 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 192.07 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:14.970 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:29:14.995 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.19 | USER_ID= |
| 05:29:15.158 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.34 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:29:15.170 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.67 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:29:15.190 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.23 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:15.259 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 38.57 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 05:29:15.318 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 28.03 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:29:15.355 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 9.45 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:29:15.637 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.01 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 05:29:15.717 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:29:26.960 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 7.55 | p_division_id=82, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 05:29:26.980 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 532 | 14.64 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20271107 |
| 05:29:26.999 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 8.97 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:29:27.210 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 14.94 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 05:29:27.226 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 9.09 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:29:31.244 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.27 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 05:29:31.263 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 9.75 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:29:38.655 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 0 | 7111.19 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=82, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260824, p_electype=, p_iso=F, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:29:40.681 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 9169.73 | p_from_yyyymmdd=20261224, p_to_yyyymmdd=20270423, p_division_id=82, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260824, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:29:40.711 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 9183.58 | p_from_yyyymmdd=20270424, p_to_yyyymmdd=20270822, p_division_id=82, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260824, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:29:40.720 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 9224.96 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20261223, p_division_id=82, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260824, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:29:41.020 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 48.24 | p_menu_id=SCP0016, p_log_type=FIND, p_log_cnt=, p_db_time=9.335, p_ui_time=0.229, p_user_id=jaeuk.shin |
| 05:29:46.303 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.94 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

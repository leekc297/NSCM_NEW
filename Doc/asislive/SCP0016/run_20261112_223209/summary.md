# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-12 22:32:09.647 ~ 2026-11-12 22:32:47.193 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: Total :  · DB : 13.85s, UI : 0.08s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:32:09.929 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.59 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:09.938 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.95 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:09.945 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.95 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:10.088 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 139.03 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:10.133 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 22:32:10.158 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.32 | USER_ID= |
| 22:32:10.261 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.5 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:32:10.275 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.49 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:32:10.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.2 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:10.512 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 205.5 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 22:32:10.531 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.47 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 22:32:10.597 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 54.05 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 22:32:11.291 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 544.78 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 22:32:11.380 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 22:32:20.794 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.58 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260817, p_offset_month=12, p_timezone=AS054 |
| 22:32:20.812 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 540 | 13.17 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20271107 |
| 22:32:20.828 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.16 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 22:32:21.027 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 11.27 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 22:32:21.041 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.89 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 22:32:25.859 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.94 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 22:32:25.873 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.02 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 22:32:37.010 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 0 | 10955.2 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_iso=F, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 22:32:39.813 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 13778.68 | p_from_yyyymmdd=20270417, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 22:32:39.813 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 13729.49 | p_from_yyyymmdd=20261217, p_to_yyyymmdd=20270416, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 22:32:39.860 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 13791.0 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20261216, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 22:32:40.133 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 178.99 | p_menu_id=SCP0016, p_log_type=FIND, p_log_cnt=, p_db_time=13.85, p_ui_time=0.08, p_user_id=jaeuk.shin |
| 22:32:46.496 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.65 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

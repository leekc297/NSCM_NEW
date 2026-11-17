# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-12 21:33:06.959 ~ 2026-11-12 21:33:36.368 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: Total :  · DB : 7.911s, UI : 0.076s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:33:07.269 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.54 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:07.276 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.11 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:07.282 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.17 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:07.422 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 136.87 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:07.474 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 21:33:07.498 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.02 | USER_ID= |
| 21:33:07.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.52 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:07.633 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.07 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:07.653 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.67 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:07.736 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 65.7 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 21:33:07.757 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 14.88 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 21:33:07.780 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.92 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 21:33:08.073 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 143.78 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 21:33:08.143 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 21:33:16.877 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.35 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260817, p_offset_month=12, p_timezone=AS054 |
| 21:33:16.896 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 540 | 13.65 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20271107 |
| 21:33:16.912 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 8.65 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 21:33:17.122 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.13 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 21:33:17.139 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.54 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 21:33:21.424 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.71 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 21:33:21.440 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 8.47 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 21:33:27.953 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 6336.35 | p_from_yyyymmdd=20261217, p_to_yyyymmdd=20270416, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 21:33:27.953 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 6355.57 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20261216, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 21:33:27.953 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 6304.27 | p_from_yyyymmdd=20270417, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 21:33:29.480 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 0 | 7846.26 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_iso=F, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 21:33:29.610 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 42.16 | p_menu_id=SCP0016, p_log_type=FIND, p_log_cnt=, p_db_time=7.911, p_ui_time=0.076, p_user_id=jaeuk.shin |
| 21:33:35.715 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.85 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

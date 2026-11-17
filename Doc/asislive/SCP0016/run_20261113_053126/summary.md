# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-13 05:31:26.735 ~ 2026-11-13 05:31:51.604 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: Total :  · DB : 1.512s, UI : 0.142s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:31:27.163 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.3 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:27.171 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.22 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:27.178 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.16 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:27.314 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 131.95 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:27.638 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 7.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:31:27.665 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.4 | USER_ID= |
| 05:31:27.870 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.4 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:31:27.883 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.37 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:31:27.908 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 4.21 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:27.929 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.43 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 05:31:27.952 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 12.2 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:31:27.969 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 8.22 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:31:28.198 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.64 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 05:31:28.303 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:31:39.390 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.03 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260817, p_offset_month=12, p_timezone=AS054 |
| 05:31:39.410 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 540 | 13.57 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20271107 |
| 05:31:39.424 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.18 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:31:39.649 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.66 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 05:31:39.663 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.28 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:31:43.704 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.83 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 05:31:43.721 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 8.01 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:31:44.758 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 0 | 838.3 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_iso=F, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:31:45.367 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1446.87 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20261216, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:31:45.380 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1459.34 | p_from_yyyymmdd=20270417, p_to_yyyymmdd=20270815, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:31:45.391 | find | GSCM.SCP.Analysis.WSL | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 0 | 1472.44 | p_from_yyyymmdd=20261217, p_to_yyyymmdd=20270416, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0016, p_sheet_name=Shipment Plan FG, p_user_id=jaeuk.shin, debug_mode=F |
| 05:31:45.555 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.17 | p_menu_id=SCP0016, p_log_type=FIND, p_log_cnt=, p_db_time=1.512, p_ui_time=0.142, p_user_id=jaeuk.shin |
| 05:31:50.829 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.64 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

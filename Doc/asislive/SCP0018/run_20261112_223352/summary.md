# AS-IS 실측 요약 — SCP0018

- 실행: 2026-11-12 22:33:52.790 ~ 2026-11-12 22:34:40.573 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan Semi Waterfall (GSCM.SCP.Analysis.UIL.SCP0018_WaterfallShipmentPlanSemi)
- 조회 결과: Total : 131 · DB : 24.481s, UI : 0.254s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:33:53.107 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.48 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:33:53.392 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0018 |
| 22:33:53.419 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.91 | USER_ID= |
| 22:33:53.567 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.29 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:33:53.579 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.45 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:33:53.609 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 23.2 | Code=WaterfallVer_FG2, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:33:53.625 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.34 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:33:53.644 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.69 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 22:33:53.668 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 11.86 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 22:33:53.715 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 36.73 | p_program_id=SCP0018, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 22:33:54.193 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 277.84 | MenuID=Shipment Plan Semi Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 22:33:54.292 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0018 |
| 22:34:03.411 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.76 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260817, p_offset_month=12, p_timezone=AS054 |
| 22:34:07.931 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.11 | p_start_yyyymmdd=20260817, p_end_yyyymmdd=20270815 |
| 22:34:07.941 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 4.84 | p_program_id=SCP0018, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 22:34:32.443 | find | GSCM.SCP.Analysis.WSL | SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL | 131 | 24279.79 | p_from_yyyymmdd=20260817, p_to_yyyymmdd=20270815, p_division_id=81, p_operation_group=A, p_item_id=, p_version_no=SP_W_20260817, p_electype=, p_program_id=SCP0018, p_sheet_name=CELL, p_user_id=jaeuk.shin |
| 22:34:33.194 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 394.38 | p_menu_id=SCP0018, p_log_type=FIND, p_log_cnt=131, p_db_time=24.481, p_ui_time=0.254, p_user_id=jaeuk.shin |
| 22:34:39.794 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.53 | MenuID=Shipment Plan Semi Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| lciSum | chkSum |  |
| Operation Group* | cboOperGroup | Y |
| Bucket | cboBucketType |  |
| Model | txtItemId |  |
| layoutControlItem3 | btnMeasure |  |
| Version* | clbVersion | Y |
| Electrode | clbElecType |  |
| layoutControlItem4 | btnItem_Id |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Waterfall Shipment Plan: 행 131 · 컬럼 465(보임 321) · 헤더 3단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

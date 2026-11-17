# AS-IS 실측 요약 — SCP0025

- 실행: 2026-11-12 19:56:51.049 ~ 2026-11-12 19:57:16.792 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan Fix (GSCM.SCP.Analysis.UIL.SCP0025_ShipmentPlanFix)
- 조회 결과: Total : 50 · DB : 8.507s, UI : 0.474s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:56:51.407 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.99 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:51.442 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0025 |
| 19:56:51.467 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.88 | USER_ID= |
| 19:56:51.570 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.6 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:56:51.588 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.66 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:56:51.596 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.13 |  |
| 19:56:51.613 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.85 | p_division_id=81 |
| 19:56:51.621 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.87 | p_from_date=, p_offset_day=363, p_timezone=AS054 |
| 19:56:51.638 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.71 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271110 |
| 19:56:51.649 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.69 | p_program_id=SCP0025, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Fix |
| 19:56:53.003 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1224.51 | MenuID=Shipment Plan Fix, CnntCode=0104001, UserID=jaeuk.shin |
| 19:56:53.243 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0025 |
| 19:57:01.306 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 15.74 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271110 |
| 19:57:01.320 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.38 | p_program_id=SCP0025, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Fix |
| 19:57:09.895 | find | GSCM.SCP.Analysis.WSL | SCP0025_GET_SHIPMENT_PLAN_FIX | 50 | 8370.0 | p_division_id=81, p_biz_type=P, p_item_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20271110, p_electype=, p_program_id=SCP0025, p_sheet_name=Shipment Plan Fix, p_user_id=jaeuk.shin, debug_mode=T |
| 19:57:10.588 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 163.13 | p_menu_id=SCP0025, p_log_type=FIND, p_log_cnt=50, p_db_time=8.507, p_ui_time=0.474, p_user_id=jaeuk.shin |
| 19:57:16.004 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.54 | MenuID=Shipment Plan Fix, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Operation Group* | cboBizType | Y |
| Div* | cboDivision | Y |
| Bucket | cboBucketType |  |
| Model | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutControlItem9 | chkSum |  |
| Electrode | clbElecType |  |
| Unfix | btnUnfix |  |
| W26 | btnW26 |  |
| W52 | btnW52 |  |
| W84 | btnWLast |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Shipment Plan Fix: 행 50 · 컬럼 461(보임 324) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

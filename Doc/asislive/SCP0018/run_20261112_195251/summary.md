# AS-IS 실측 요약 — SCP0018

- 실행: 2026-11-12 19:52:51.121 ~ 2026-11-12 19:53:53.608 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan Semi Waterfall (GSCM.SCP.Analysis.UIL.SCP0018_WaterfallShipmentPlanSemi)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:52:51.545 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.73 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:52:51.596 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0018 |
| 19:52:51.630 | load | GSCM.BizService.WSL | SELECT * | 874 | 28.09 | USER_ID= |
| 19:52:51.775 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.83 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:52:51.785 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.2 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:53:01.440 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 9640.36 | Code=WaterfallVer_FG2, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:01.461 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 4.36 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:01.511 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.04 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 19:53:01.538 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 17.02 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 19:53:05.692 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 4146.34 | p_program_id=SCP0018, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 19:53:06.237 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 359.6 | MenuID=Shipment Plan Semi Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 19:53:06.366 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0018 |
| 19:53:52.962 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.35 | MenuID=Shipment Plan Semi Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Waterfall Shipment Plan: 행 0 · 컬럼 460(보임 322) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:53:14.965 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

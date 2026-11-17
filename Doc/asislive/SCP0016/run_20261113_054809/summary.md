# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-13 05:48:09.990 ~ 2026-11-13 05:49:03.861 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "clbVersion", "prop": "ControlValues", "value": "SP_W_20260824", "param": "version_no", "from": "SP_W_20260817", "sheet": "main"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:48:10.448 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.43 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:48:10.457 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.51 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:48:10.466 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 5.24 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:48:10.611 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 140.1 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:48:10.937 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:48:10.963 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.63 | USER_ID= |
| 05:48:11.162 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.34 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:48:11.180 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.47 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:48:11.204 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.54 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:48:11.226 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 5.21 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 05:48:11.250 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 13.13 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:48:11.268 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 7.67 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 05:48:11.518 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.43 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 05:48:11.602 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 05:49:03.169 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.64 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Waterfall Shipment Plan: 행 0 · 컬럼 463(보임 327) · 헤더 3단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-13 05:48:25.003 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

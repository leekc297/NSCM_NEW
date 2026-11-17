# AS-IS 실측 요약 — SCP0016

- 실행: 2026-11-12 19:48:20.434 ~ 2026-11-12 19:49:26.741 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG Waterfall (GSCM.SCP.Analysis.UIL.SCP0016_WaterfallShipmentPlanFG)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:48:20.807 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.82 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:48:20.824 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 9.42 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:48:20.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.61 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:48:20.973 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 138.43 | Code=WaterfallVer_FG21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:48:21.025 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 19:48:21.048 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.11 | USER_ID= |
| 19:48:21.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.19 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:48:21.178 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.53 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:48:21.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.73 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:48:21.220 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.77 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 19:48:21.240 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 13.18 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 19:48:21.529 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 277.18 | p_program_id=SCP0016, p_user_id=jaeuk.shin, p_sheet_name=Waterfall Shipment Plan |
| 19:48:22.414 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 727.36 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 19:48:22.545 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0016 |
| 19:49:09.436 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.63 | MenuID=Shipment Plan FG Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Waterfall Shipment Plan: 행 0 · 컬럼 464(보임 327) · 헤더 3단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:48:31.293 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

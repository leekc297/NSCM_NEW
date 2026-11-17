# AS-IS 실측 요약 — SCP0017

- 실행: 2026-11-12 22:32:47.510 ~ 2026-11-12 22:33:37.883 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Waterfall (GSCM.SCP.Analysis.UIL.SCP0017_WaterfallProductionPlan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:32:47.824 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.8 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:47.871 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 64 | 43.48 | Code=PlantSiteProdPlan1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:47.879 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 5.01 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:47.886 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 2.96 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:47.891 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.05 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:48.033 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 138.49 | Code=WaterfallVer21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:48.360 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 228 | 322.73 | Code=LineProdPlanLine1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:48.490 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1812 | 125.06 | Code=LineByOperationAddOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:48.511 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.52 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:32:48.553 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0017 |
| 22:32:48.576 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.78 | USER_ID= |
| 22:32:48.702 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.22 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:32:48.873 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 17.54 | p_start_yyyymmdd=20260101, p_end_yyyymmdd=20261231 |
| 22:32:48.987 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 103.06 | p_program_id=SCP0017, p_user_id=jaeuk.shin, p_sheet_name=MODEL |
| 22:32:49.474 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 358.43 | MenuID=Production Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 22:32:49.581 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0017 |
| 22:33:03.951 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 14.35 | p_start_yyyymmdd=20260101, p_end_yyyymmdd=20261231 |
| 22:33:03.965 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 7.35 | p_program_id=SCP0017, p_user_id=jaeuk.shin, p_sheet_name=MODEL |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Plant Site | clbPlantSite |  |
| Version* | clbVersion | Y |
| Nick Name | txtNickName |  |
| Period* | dCalendar | Y |
| Bucket | cboBucketType |  |
| Electrode | cboElectrode |  |
| Line | clbLine |  |
| Model | txtModelId |  |
| Material | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| layoutControlItem14 | btnMeasure |  |
| layoutControlItem4 | btnColumn |  |
| layoutControlItem8 | chkSum |  |
| layoutControlItem8 | chkALL |  |
| layoutControlItem8 | chkGap |  |
| UOM | clbUOM |  |

## 그리드

- spdMain / MODEL: 행 0 · 컬럼 462(보임 322) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

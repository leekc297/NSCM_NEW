# AS-IS 실측 요약 — SCP0017

- 실행: 2026-11-12 19:49:26.876 ~ 2026-11-12 19:52:50.927 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Waterfall (GSCM.SCP.Analysis.UIL.SCP0017_WaterfallProductionPlan)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:49:27.439 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 38.96 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 64 | 7.86 | Code=PlantSiteProdPlan1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.462 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 6.72 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.470 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.53 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.479 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.29 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.640 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 156.42 | Code=WaterfallVer21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.652 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 228 | 7.63 | Code=LineProdPlanLine1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.691 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1812 | 33.02 | Code=LineByOperationAddOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:27.714 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.09 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:49:27.771 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0017 |
| 19:49:27.794 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.61 | USER_ID= |
| 19:49:27.957 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.53 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:49:28.433 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 15.55 | p_start_yyyymmdd=20260101, p_end_yyyymmdd=20261231 |
| 19:49:38.981 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 10460.84 | p_program_id=SCP0017, p_user_id=jaeuk.shin, p_sheet_name=MODEL |
| 19:51:56.237 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 137113.99 | MenuID=Production Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 19:52:42.768 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 10.79 | MenuID=Production Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Division* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Plant Site | clbPlantSite |  |
| Version* | clbVersion | Y |
| Nick Name | txtNickName |  |
| Period* | dCalendar | Y |
| Bucket | cboBucketType |  |
| Electrode | cboElectrode |  |
| Line      | clbLine |  |
| Model | txtModelId |  |
| Material | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| layoutControlItem10 | btnMeasure |  |
| layoutControlItem5 | btnColumn |  |
| layoutControlItem8 | chkSum |  |
| layoutControlItem8 | chkALL |  |
| layoutControlItem8 | chkGap |  |
| UOM | clbUOM |  |

## 그리드

- spdMain / MODEL: 행 0 · 컬럼 462(보임 324) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:52:04.839 [GSCM] Version* 값은 필수 입력입니다 → default_button(id=1)

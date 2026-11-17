# AS-IS 실측 요약 — SCP0006

- 실행: 2026-11-12 19:35:20.305 ~ 2026-11-12 19:36:20.890 · 계정 jaeuk.shin · 상태 OK
- 화면: Project Route (GSCM.SCP.Master.UIL.SCP0006_ProjectRoute)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:35:20.710 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.39 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:35:21.046 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 330.68 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:35:21.067 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 4.08 | Code=BuildingByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:35:31.468 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 10393.57 | Code=PlantByDivisionOperationItem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:35:31.476 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 16 | 3.77 | Code=PlantSiteOsPack, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:35:31.547 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0006 |
| 19:35:31.570 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.6 | USER_ID= |
| 19:35:39.898 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 29 | 8069.83 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:35:39.921 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 6.02 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:35:40.046 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 22.36 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 19:35:40.125 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 12 | 71.45 | Code=CalendarMonth, Param1=202611, Param2=202710, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:35:40.136 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 3.64 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=BOM Explosion |
| 19:35:40.150 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.74 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Plant Assign |
| 19:35:40.160 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 6.0 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:35:40.252 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 64.03 | MenuID=Project Route, CnntCode=0104001, UserID=jaeuk.shin |
| 19:35:40.319 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0006 |
| 19:35:49.656 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.95 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 19:35:49.674 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 12 | 3.65 | Code=CalendarMonth, Param1=202611, Param2=202710, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem4 | btnProject |  |
| Model | txtItemId |  |
| layoutControlItem11 | btnItemId |  |
| Project | txtProject |  |
| Period | drpPeriod |  |
| Sales Site | clbSalesSite |  |
| Status | cboStatus |  |
| Div* | cboDivision | Y |
| Input All | btnAllFind |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 23(보임 20) · 헤더 1단 · 고정 컬럼 5
- spdBOM / BOM Explosion: 행 0 · 컬럼 12(보임 6) · 헤더 1단 · 고정 컬럼 0
- spdPlant / Plant Assign: 행 0 · 컬럼 25(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

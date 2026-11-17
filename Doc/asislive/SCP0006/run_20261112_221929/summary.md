# AS-IS 실측 요약 — SCP0006

- 실행: 2026-11-12 22:19:29.443 ~ 2026-11-12 22:20:29.885 · 계정 jaeuk.shin · 상태 OK
- 화면: Project Route (GSCM.SCP.Master.UIL.SCP0006_ProjectRoute)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:19:29.951 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 90.91 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:19:30.085 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 124.28 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:19:30.106 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 4.08 | Code=BuildingByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:19:37.907 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 7794.02 | Code=PlantByDivisionOperationItem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:19:37.914 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 16 | 3.51 | Code=PlantSiteOsPack, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:19:37.982 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.61 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0006 |
| 22:19:38.004 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.43 | USER_ID= |
| 22:19:45.577 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 29 | 7333.86 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:19:45.683 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 93.08 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:45.749 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 36.57 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 22:19:45.796 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 12 | 34.51 | Code=CalendarMonth, Param1=202611, Param2=202710, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:45.818 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 3.99 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=BOM Explosion |
| 22:19:45.832 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 3.82 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Plant Assign |
| 22:19:45.842 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.85 | Code=PlantByDivisionOperationItem, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:45.931 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 65.85 | MenuID=Project Route, CnntCode=0104001, UserID=jaeuk.shin |
| 22:19:46.016 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.48 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0006 |
| 22:19:55.931 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.86 | p_program_id=SCP0006, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 22:19:55.965 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 12 | 16.57 | Code=CalendarMonth, Param1=202611, Param2=202710, Param3=, Param4=, Param5=, TimeZone=AS054 |

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

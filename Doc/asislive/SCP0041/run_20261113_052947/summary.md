# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-13 05:29:47.214 ~ 2026-11-13 05:29:59.693 · 계정 jaeuk.shin · 상태 ERROR
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: None · None · 완료 판단 None
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "dCalendar", "prop": "ControlValues", "value": "20260813:20270813", "param": "from_yyyymmdd+to_yyyymmdd", "from": "20261109:20271009", "sheet": "Pack Hold Stock"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:29:47.506 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.34 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:47.515 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 5.19 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:47.522 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.17 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:47.851 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 325.19 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:29:47.910 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:29:47.936 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.34 | USER_ID= |
| 05:29:48.068 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 50.75 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:29:48.098 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 4.52 | p_lookup_type=PACKER_HOLD_STATUS |
| 05:29:48.170 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.95 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:29:48.187 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 3.56 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 05:29:48.197 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.43 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 05:29:48.283 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 61.65 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 05:29:48.334 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:29:58.921 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.06 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Plant Site | clbPlantSite |  |
| Model | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Upload | btnExcelUpload |  |
| Excel Form | formDown |  |
| Period* | dCalendar | Y |
| 관리번호 | txtInspection |  |
| Status | cboStatus |  |
| Cutoff Date | dCalendarCutoff |  |

## 그리드

- spdMain / Osp Stock: 행 0 · 컬럼 15(보임 14) · 헤더 1단 · 고정 컬럼 0
- spdMain / Pack Hold Stock: 행 0 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-13 05:49:04.133 ~ 2026-11-13 05:49:22.665 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total : 127 · DB : 0.067s, UI : 0.014s · 완료 판단 status
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "dCalendar", "prop": "InitValue", "value": "20260813:20270813", "param": "from_yyyymmdd+to_yyyymmdd", "from": "20261109:20271009", "sheet": "Pack Hold Stock"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:49:04.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.17 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:04.461 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.54 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:04.473 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.75 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:04.815 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 336.02 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:04.961 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:49:04.996 | load | GSCM.BizService.WSL | SELECT * | 874 | 23.66 | USER_ID= |
| 05:49:05.081 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 7.76 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:05.105 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.14 | p_lookup_type=PACKER_HOLD_STATUS |
| 05:49:05.171 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.8 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:05.188 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.39 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 05:49:05.203 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 5.83 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 05:49:05.230 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.91 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 05:49:05.400 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 3.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:49:16.378 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 127 | 32.87 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 05:49:16.406 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.14 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=127, p_db_time=0.067, p_ui_time=0.014, p_user_id=jaeuk.shin |
| 05:49:21.968 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.04 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Osp Stock: 행 127 · 컬럼 15(보임 14) · 헤더 1단 · 고정 컬럼 0
- spdMain / Pack Hold Stock: 행 0 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

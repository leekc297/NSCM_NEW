# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-13 05:51:47.356 ~ 2026-11-13 05:52:06.488 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total :  · DB : 0.136s, UI : 0.075s · 완료 판단 status
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "dCalendar", "prop": "InitValue", "value": "20261109:20271009", "param": "from_yyyymmdd+to_yyyymmdd", "from": "20260813:20270813", "sheet": "Osp Stock"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:51:47.829 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.75 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:51:47.841 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.5 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:51:47.851 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.76 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:51:47.878 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 22.75 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:51:48.294 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:51:48.320 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.89 | USER_ID= |
| 05:51:48.456 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.46 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:48.490 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 2.76 | p_lookup_type=PACKER_HOLD_STATUS |
| 05:51:48.554 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.68 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:48.582 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 3.65 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 05:51:48.599 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.54 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 05:51:48.693 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.51 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 05:51:48.751 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 2.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:52:00.068 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 0 | 27.43 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 05:52:00.157 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.45 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=, p_db_time=0.136, p_ui_time=0.075, p_user_id=jaeuk.shin |
| 05:52:05.733 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.92 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

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

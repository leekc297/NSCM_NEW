# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-14 23:43:47.146 ~ 2026-11-14 23:44:05.596 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total :  · DB : 0.188s, UI : 0.074s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:43:47.630 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.56 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:43:47.647 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.45 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:43:47.656 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.48 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:43:47.686 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 24.24 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:43:48.087 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 14.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 23:43:48.162 | load | GSCM.BizService.WSL | SELECT * | 874 | 60.33 | USER_ID= |
| 23:43:48.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 97.35 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:43:48.468 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.33 | p_lookup_type=PACKER_HOLD_STATUS |
| 23:43:48.568 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 21.18 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:43:48.651 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 55.72 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 23:43:48.669 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 7.5 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 23:43:48.833 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 69.14 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 23:43:48.904 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 11.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 23:43:58.321 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 0 | 95.02 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 23:43:58.411 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.42 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=, p_db_time=0.188, p_ui_time=0.074, p_user_id=jaeuk.shin |
| 23:44:04.888 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.57 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

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

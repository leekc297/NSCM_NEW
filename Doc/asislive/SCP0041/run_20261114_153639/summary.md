# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-14 15:36:39.496 ~ 2026-11-14 15:37:00.149 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total :  · DB : 0.14s, UI : 0.075s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 15:36:39.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.57 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:40.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.57 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:40.020 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.65 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:40.048 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 22.28 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:40.918 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.68 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 15:36:40.955 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.66 | USER_ID= |
| 15:36:41.307 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.7 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:36:41.388 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.63 | p_lookup_type=PACKER_HOLD_STATUS |
| 15:36:41.550 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.05 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:36:41.607 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.36 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 15:36:41.644 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.12 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 15:36:41.864 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.01 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 15:36:42.012 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 3.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 15:36:52.755 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 0 | 26.68 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 15:36:52.840 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.03 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=, p_db_time=0.14, p_ui_time=0.075, p_user_id=jaeuk.shin |
| 15:36:59.438 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.74 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(6636)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

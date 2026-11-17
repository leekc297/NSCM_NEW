# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-14 15:25:50.234 ~ 2026-11-14 15:36:23.654 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total :  · DB : 0.134s, UI : 0.073s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 15:36:04.425 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.55 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:04.437 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.83 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:04.445 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.25 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:04.775 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 323.94 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:36:05.151 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 15:36:05.191 | load | GSCM.BizService.WSL | SELECT * | 874 | 24.11 | USER_ID= |
| 15:36:05.408 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 49.26 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:36:05.472 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 4.27 | p_lookup_type=PACKER_HOLD_STATUS |
| 15:36:05.561 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.95 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:36:05.629 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 25.34 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 15:36:05.641 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.17 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 15:36:05.845 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 85.39 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 15:36:05.920 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 15:36:15.300 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 0 | 31.13 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 15:36:15.389 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.3 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=, p_db_time=0.134, p_ui_time=0.073, p_user_id=jaeuk.shin |
| 15:36:16.718 | find | GSCM.SCM.Master.WSL | SCM0001_GET_DIVISION | 14 | 3.36 |  |
| 15:36:16.956 | find | GSCM.SCM.Master.WSL | SCM0002_GET_MATERIAL_BY_DIVISION | 2575 | 107.33 | p_division_id=81, p_operation_group=P, p_item_id=, p_scp_module_type=SCP0013 |

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

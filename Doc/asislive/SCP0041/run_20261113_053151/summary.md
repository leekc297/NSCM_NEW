# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-13 05:31:51.723 ~ 2026-11-13 05:32:10.450 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total : 127 · DB : 0.344s, UI : 0.069s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:31:52.019 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.24 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:52.028 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.01 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:52.036 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 3.93 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:52.062 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 22.48 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:31:52.129 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:31:52.154 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.33 | USER_ID= |
| 05:31:52.326 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.74 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:31:52.359 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 2.98 | p_lookup_type=PACKER_HOLD_STATUS |
| 05:31:52.460 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.83 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:31:52.482 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 5.21 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 05:31:52.498 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.7 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 05:31:52.527 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.97 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 05:31:52.561 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 2.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 05:32:03.924 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 127 | 249.68 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 05:32:04.004 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.61 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=127, p_db_time=0.344, p_ui_time=0.069, p_user_id=jaeuk.shin |
| 05:32:09.738 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.84 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

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

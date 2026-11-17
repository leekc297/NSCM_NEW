# AS-IS 실측 요약 — SCP0041

- 실행: 2026-11-12 18:04:22.477 ~ 2026-11-12 18:04:38.077 · 계정 jaeuk.shin · 상태 OK
- 화면: Stock OSP (GSCM.SCP.Master.UIL.SCP0041_StockOSP)
- 조회 결과: Total :  · DB : 0.173s, UI : 0.07s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:04:22.763 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.06 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:22.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.47 | Code=PlantSiteByDivisionOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:22.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 38 | 4.92 | Code=PlantSitePackerHoldStock1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:22.808 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 22.44 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:22.879 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 18:04:22.905 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.41 | USER_ID= |
| 18:04:23.050 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 45.74 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:23.098 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 5.25 | p_lookup_type=PACKER_HOLD_STATUS |
| 18:04:23.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.96 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:23.219 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 34.42 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Osp Stock |
| 18:04:23.238 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.72 | p_program_id=SCP0041, p_user_id=jaeuk.shin, p_sheet_name=Pack Hold Stock |
| 18:04:24.016 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 748.23 | MenuID=Stock OSP, CnntCode=0104001, UserID=jaeuk.shin |
| 18:04:24.104 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 3 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0041 |
| 18:04:26.534 | load | GSCM.DM.Master.WSL | DMF0003_GET_MKT_FCST_DATA | 1476 | 85404.98 | p_division_id=40, p_scm_site_id=ALL, p_plant_site_id=ALL, p_team_id=ALL, p_customer=ALL, p_biz_type=ALL, p_project_code=, p_item_id=, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_user_group=ADMIN, p_item_type=ALL, p_owner=, p_qty_yn=N, p_cell_yn=N, p_invalid_exec=N, p |
| 18:04:32.371 | find | GSCM.SCP.Master.WSL | SCP0041_GET_STOCK_OSP | 0 | 92.87 | p_division_id=82, p_plant_site_id=CN00249500-P,CN05104100_82-P,KR00697200_82-P,KR00797800-P,KR04851000-P,KR32625300_82-P,PL01279700_82-P,US02182600_82-P,US02279100_82-P,US02562600_82-P,300MS 8ME SBS1_US_LAS,425LM 8ME SBS2_US_LAS,45MG 8ME_US_BJO,8minute Energy_KR_KUV,8minute Energy_US_BJO,8minute Ene |
| 18:04:32.450 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.58 | p_menu_id=SCP0041, p_log_type=FIND, p_log_cnt=, p_db_time=0.173, p_ui_time=0.07, p_user_id=jaeuk.shin |
| 18:04:37.400 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.13 | MenuID=Stock OSP, CnntCode=0104002, UserID=jaeuk.shin |

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

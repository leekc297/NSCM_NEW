# AS-IS 실측 요약 — SCP0102

- 실행: 2026-11-12 20:24:06.052 ~ 2026-11-12 20:25:44.771 · 계정 jaeuk.shin · 상태 OK
- 화면: BOD Validation Report (GSCM.SCP.Report.UIL.SCP0102_BOD_Validation_Report)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:24:06.331 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.62 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:24:06.657 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0102 |
| 20:24:06.687 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.61 | USER_ID= |
| 20:24:07.538 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 34 | 589.91 | Code=ShipmentPlanPlantSite, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:24:12.957 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 5414.83 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:24:24.247 | load | GSCM.SCP.Analysis.WSL | SSP0028_GET_COUNTRY | 8 | 11026.3 |  |
| 20:24:52.893 | load | GSCM.SCP.Analysis.WSL | SSP0028_GET_CITY | 42 | 28623.04 | p_country_parameter=, p_kind=A |
| 20:25:00.020 | load | GSCM.SCP.Analysis.WSL | SSP0028_GET_AREA | 6 | 6986.32 |  |
| 20:25:00.086 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.58 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 20:25:00.094 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.36 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 20:25:00.789 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 677.9 | p_program_id=SCP0102, p_user_id=jaeuk.shin, p_sheet_name=BOD Main |
| 20:25:00.812 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 65 | 4.54 | p_program_id=SCP0102, p_user_id=jaeuk.shin, p_sheet_name=BOD Detail |
| 20:25:04.132 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3191.83 | MenuID=BOD Validation Report, CnntCode=0104001, UserID=jaeuk.shin |
| 20:25:04.539 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.54 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0102 |
| 20:25:12.981 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.62 | p_program_id=SCP0102, p_user_id=jaeuk.shin, p_sheet_name=BOD Main |
| 20:25:12.999 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 65 | 4.67 | p_program_id=SCP0102, p_user_id=jaeuk.shin, p_sheet_name=BOD Detail |
| 20:25:43.046 | find | GSCM.SCP.Analysis.WSL | SCP0102_GET_BOD_VALIDATION_REPORT | 0 | 30015.66 | p_division_id=40, p_from_yyyymmdd=20261001, p_to_yyyymmdd=20261031, p_from_site=, p_to_site=, p_PIVOT_yyyymm=[202610], p_from_country=, p_to_country=, p_from_city=, p_to_city=, p_from_area=, p_to_area= |
| 20:25:43.810 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=BOD Validation Report, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Exfactory Date | drpExfactory |  |
| F.Dest ATA Date | drpFDest |  |
| layoutControlItem16 | usrRadio1 |  |
| layoutControlItem19 | rdoFDest |  |
| layoutControlItem18 | rdoExFactory |  |
| layoutControlItem22 | simpleButton1 |  |
| layoutControlItem24 | btnApproval |  |
| layoutControlItem25 | btn_Search |  |
| Div* | clbDivision_ID | Y |
| From Site | clbFromSite |  |
| To Site | clbToSite |  |
| Exfactory Date | drpPeriod |  |
| From City | cboFromCity |  |
| From 권역 | cboFromArea |  |
| To 권역 | cboToArea |  |
| From Country | cboFromCountry |  |
| To Country | cboToCountry |  |
| 조회구분 | cboInquiryClassification |  |
| To City | cboToCity |  |
| 정확도 | cboAccuracy |  |

## 그리드

- spdMain / BOD Main: 행 0 · 컬럼 18(보임 17) · 헤더 3단 · 고정 컬럼 0
- spdDetail / BOD Detail: 행 0 · 컬럼 66(보임 65) · 헤더 1단 · 고정 컬럼 4

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

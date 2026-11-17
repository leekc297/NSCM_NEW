# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-12 20:44:51.056 ~ 2026-11-12 20:45:08.013 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.949s, UI : 0.042s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:44:51.400 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.88 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:51.408 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.79 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:51.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 85.36 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:51.532 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 20:44:51.556 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.16 | USER_ID= |
| 20:44:51.833 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 3.4 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 20:44:51.896 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 16.6 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 20:44:51.906 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.69 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 20:44:51.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.91 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:52.330 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 327.12 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 20:44:52.411 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 20:45:00.769 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 16.67 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 20:45:00.784 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.66 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 20:45:00.791 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.23 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:01.803 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 916.54 | p_from_yyyymmdd=20261112, p_to_yyyymmdd=20271107, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 20:45:01.862 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 7.6 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.949, p_ui_time=0.042, p_user_id=jaeuk.shin |
| 20:45:07.126 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.5 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Day of the week | cboDayWeek |  |
| Input | btnInput |  |
| Period* | drpPeriod | Y |
| Div | clbDivision |  |
| Input Value | cboInputValue |  |
| Company | cboCompany |  |

## 그리드

- spdMain / Shipment Working Day: 행 0 · 컬럼 364(보임 363) · 헤더 3단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

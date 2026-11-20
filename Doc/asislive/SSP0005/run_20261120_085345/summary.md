# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-20 08:53:45.250 ~ 2026-11-20 08:54:52.906 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.188s, UI : 0.143s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 08:54:02.840 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.89 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:02.850 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.57 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:02.861 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 4.11 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:03.809 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.27 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 08:54:03.851 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.7 | USER_ID= |
| 08:54:04.300 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 5.65 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 08:54:04.407 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 17.7 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 08:54:04.453 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.49 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:54:04.476 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.48 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:04.719 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.44 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 08:54:04.844 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 08:54:13.330 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 15.2 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 08:54:13.351 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.3 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:54:13.362 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.96 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:13.745 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 174.3 | p_from_yyyymmdd=20261120, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:54:13.905 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.47 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.231, p_ui_time=0.136, p_user_id=jaeuk.shin |
| 08:54:25.034 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 14.23 | p_start_yyyymmdd=20261020, p_end_yyyymmdd=20271014 |
| 08:54:25.054 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 7.01 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:54:25.095 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.92 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:25.447 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 175.69 | p_from_yyyymmdd=20261020, p_to_yyyymmdd=20271014, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:54:25.610 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.64 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.188, p_ui_time=0.146, p_user_id=jaeuk.shin |
| 08:54:35.768 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 13.52 | p_start_yyyymmdd=20260820, p_end_yyyymmdd=20270814 |
| 08:54:35.787 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.58 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:54:35.827 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.98 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:36.189 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 174.66 | p_from_yyyymmdd=20260820, p_to_yyyymmdd=20270814, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:54:36.362 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.49 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.196, p_ui_time=0.145, p_user_id=jaeuk.shin |
| 08:54:46.297 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 13.12 | p_start_yyyymmdd=20260520, p_end_yyyymmdd=20270514 |
| 08:54:46.318 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.03 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:54:46.355 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.61 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:54:46.701 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 174.95 | p_from_yyyymmdd=20260520, p_to_yyyymmdd=20270514, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:54:46.861 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.48 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.188, p_ui_time=0.143, p_user_id=jaeuk.shin |

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

- spdMain / Shipment Working Day: 행 0 · 컬럼 363(보임 362) · 헤더 3단 · 고정 컬럼 3

# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-20 05:01:38.587 ~ 2026-11-20 05:02:24.956 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.147s, UI : 0.134s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:01:39.015 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.73 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:39.032 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.17 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:39.042 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.55 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:39.466 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:01:39.496 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.89 | USER_ID= |
| 05:01:39.740 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 5.1 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 05:01:39.823 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 11.81 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 05:01:39.841 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.83 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:01:39.855 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 5.55 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:40.031 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.93 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 05:01:40.096 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:01:48.392 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 11.5 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 05:01:48.413 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.51 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:01:48.425 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 5.99 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:48.685 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.6 | p_from_yyyymmdd=20261120, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:01:48.821 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.51 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.149, p_ui_time=0.119, p_user_id=jaeuk.shin |
| 05:01:58.893 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 14.99 | p_start_yyyymmdd=20261020, p_end_yyyymmdd=20271014 |
| 05:01:58.909 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.59 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:01:58.945 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.37 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:59.171 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 129.8 | p_from_yyyymmdd=20261020, p_to_yyyymmdd=20271014, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:01:59.314 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.67 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.14, p_ui_time=0.127, p_user_id=jaeuk.shin |
| 05:02:08.647 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.27 | p_start_yyyymmdd=20260820, p_end_yyyymmdd=20270814 |
| 05:02:08.665 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.73 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:02:08.693 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.4 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:02:08.901 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.16 | p_from_yyyymmdd=20260820, p_to_yyyymmdd=20270814, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:02:09.030 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.49 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.14, p_ui_time=0.114, p_user_id=jaeuk.shin |
| 05:02:18.689 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 12.66 | p_start_yyyymmdd=20260520, p_end_yyyymmdd=20270514 |
| 05:02:18.709 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.1 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:02:18.736 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.39 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:02:18.951 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.8 | p_from_yyyymmdd=20260520, p_to_yyyymmdd=20270514, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:02:19.104 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.24 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.147, p_ui_time=0.134, p_user_id=jaeuk.shin |
| 05:02:24.170 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.84 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

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

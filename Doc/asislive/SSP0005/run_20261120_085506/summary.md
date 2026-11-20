# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-20 08:55:06.660 ~ 2026-11-20 08:55:57.306 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.139s, UI : 0.157s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 08:55:07.133 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 5.72 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:07.143 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.64 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:07.154 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.6 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:07.634 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 08:55:07.669 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.98 | USER_ID= |
| 08:55:08.161 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 4.62 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 08:55:08.252 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 12.41 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 08:55:08.275 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.19 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:55:08.291 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.13 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:08.553 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.77 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 08:55:08.680 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 6.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 08:55:17.501 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 14.98 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 08:55:17.533 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.91 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:55:17.576 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 5.69 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:17.897 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 131.66 | p_from_yyyymmdd=20261120, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:55:18.044 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.74 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.159, p_ui_time=0.123, p_user_id=jaeuk.shin |
| 08:55:29.189 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 14.18 | p_start_yyyymmdd=20261020, p_end_yyyymmdd=20271014 |
| 08:55:29.207 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.89 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:55:29.243 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.71 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:29.564 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.82 | p_from_yyyymmdd=20261020, p_to_yyyymmdd=20271014, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:55:29.722 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.35 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.143, p_ui_time=0.138, p_user_id=jaeuk.shin |
| 08:55:39.848 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.95 | p_start_yyyymmdd=20260820, p_end_yyyymmdd=20270814 |
| 08:55:39.869 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.51 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:55:39.908 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.56 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:40.220 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.64 | p_from_yyyymmdd=20260820, p_to_yyyymmdd=20270814, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:55:40.388 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.51 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.143, p_ui_time=0.151, p_user_id=jaeuk.shin |
| 08:55:50.699 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 16.41 | p_start_yyyymmdd=20260520, p_end_yyyymmdd=20270514 |
| 08:55:50.722 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.27 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 08:55:50.755 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.9 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 08:55:51.060 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.08 | p_from_yyyymmdd=20260520, p_to_yyyymmdd=20270514, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 08:55:51.240 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.89 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.139, p_ui_time=0.157, p_user_id=jaeuk.shin |
| 08:55:56.606 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.36 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

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

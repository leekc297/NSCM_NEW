# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-20 05:00:12.010 ~ 2026-11-20 05:01:24.996 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.192s, UI : 0.133s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:00:29.003 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.91 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:00:29.018 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.24 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:00:29.033 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.51 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:00:30.440 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:00:30.485 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.27 | USER_ID= |
| 05:00:31.217 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 3.77 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 05:00:32.709 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 27.86 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 05:00:32.803 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 29.16 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:00:32.824 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.62 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:00:33.359 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 100.97 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 05:00:33.558 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:00:42.389 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 14.18 | p_start_yyyymmdd=20261120, p_end_yyyymmdd=20271114 |
| 05:00:42.412 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 7.12 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:00:42.429 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 6.69 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:00:42.710 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 175.84 | p_from_yyyymmdd=20261120, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:00:42.858 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 23.71 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.223, p_ui_time=0.106, p_user_id=jaeuk.shin |
| 05:00:58.588 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 13.48 | p_start_yyyymmdd=20261020, p_end_yyyymmdd=20271014 |
| 05:00:58.607 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.55 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:00:58.641 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.59 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:00:58.926 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 188.33 | p_from_yyyymmdd=20261020, p_to_yyyymmdd=20271014, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:00:59.070 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.8 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.199, p_ui_time=0.129, p_user_id=jaeuk.shin |
| 05:01:08.990 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.65 | p_start_yyyymmdd=20260820, p_end_yyyymmdd=20270814 |
| 05:01:09.011 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.97 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:01:09.043 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.31 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:09.298 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 173.68 | p_from_yyyymmdd=20260820, p_to_yyyymmdd=20270814, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:01:09.425 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.24 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.185, p_ui_time=0.112, p_user_id=jaeuk.shin |
| 05:01:19.159 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 12.2 | p_start_yyyymmdd=20260520, p_end_yyyymmdd=20270514 |
| 05:01:19.181 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 5.13 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:01:19.206 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.92 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:01:19.465 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 175.62 | p_from_yyyymmdd=20260520, p_to_yyyymmdd=20270514, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:01:19.621 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.58 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.192, p_ui_time=0.133, p_user_id=jaeuk.shin |

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

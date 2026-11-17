# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-13 05:33:21.047 ~ 2026-11-13 05:33:39.965 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.451s, UI : 0.154s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:33:21.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.53 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:21.303 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.96 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:21.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.78 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:21.349 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:33:21.374 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.49 | USER_ID= |
| 05:33:21.509 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 3.17 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 05:33:21.543 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 12.32 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:33:21.553 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.37 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:33:21.560 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.45 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:21.703 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 69.74 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 05:33:21.779 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:33:33.053 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 13.32 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:33:33.073 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.3 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:33:33.088 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.76 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:33.627 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 406.29 | p_from_yyyymmdd=20261113, p_to_yyyymmdd=20271107, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:33:33.807 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.74 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.451, p_ui_time=0.154, p_user_id=jaeuk.shin |
| 05:33:39.256 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.1 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

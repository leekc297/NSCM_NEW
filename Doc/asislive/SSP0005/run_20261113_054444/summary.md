# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-13 05:44:44.797 ~ 2026-11-13 05:45:00.820 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.221s, UI : 0.128s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:44:45.185 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.01 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:45.194 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 5.83 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:45.202 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.74 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:45.239 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:44:45.261 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.63 | USER_ID= |
| 05:44:45.396 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 3.98 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 05:44:45.434 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 12.5 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:44:45.445 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.75 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:44:45.452 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.47 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:45.536 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.13 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 05:44:45.577 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 05:44:54.048 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 434 | 13.89 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20271107 |
| 05:44:54.063 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.4 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 05:44:54.070 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.74 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:54.349 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 189.52 | p_from_yyyymmdd=20261113, p_to_yyyymmdd=20271107, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 05:44:54.490 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 6.53 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.221, p_ui_time=0.128, p_user_id=jaeuk.shin |
| 05:45:00.070 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.19 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

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

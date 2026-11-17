# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-15 00:12:22.119 ~ 2026-11-15 00:12:37.875 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.532s, UI : 0.112s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:12:22.601 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.1 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:12:22.608 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.45 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:12:22.690 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 76.8 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:12:22.998 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 00:12:23.027 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.92 | USER_ID= |
| 00:12:23.235 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 3.99 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 00:12:23.306 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 15.78 | p_start_yyyymmdd=20261115, p_end_yyyymmdd=20271114 |
| 00:12:23.321 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.84 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 00:12:23.330 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.24 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:12:23.565 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 63.86 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 00:12:23.623 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 00:12:31.641 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 14.22 | p_start_yyyymmdd=20261115, p_end_yyyymmdd=20271114 |
| 00:12:31.657 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 3.64 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 00:12:31.664 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.53 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:12:32.249 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 483.28 | p_from_yyyymmdd=20261115, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 00:12:32.395 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.71 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.532, p_ui_time=0.112, p_user_id=jaeuk.shin |
| 00:12:37.166 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.57 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Shipment Working Day: 행 0 · 컬럼 368(보임 367) · 헤더 3단 · 고정 컬럼 3

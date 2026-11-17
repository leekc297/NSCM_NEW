# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-14 22:22:46.816 ~ 2026-11-14 22:24:42.033 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.164s, UI : 0.118s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:24:22.443 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.82 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:24:22.454 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.6 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:24:22.461 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.48 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:24:23.260 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 22:24:23.286 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.03 | USER_ID= |
| 22:24:23.911 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 3.3 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 22:24:24.017 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 441 | 12.99 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20271114 |
| 22:24:24.043 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.24 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 22:24:24.065 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.67 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:24:24.521 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.57 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 22:24:24.653 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 22:24:34.755 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 441 | 13.79 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20271114 |
| 22:24:34.773 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.68 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 22:24:34.791 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 5.08 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:24:35.032 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 130.92 | p_from_yyyymmdd=20261114, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 22:24:35.170 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.92 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.164, p_ui_time=0.118, p_user_id=jaeuk.shin |
| 22:24:41.187 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.28 | MenuID=Shipment Working Day, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Shipment Working Day: 행 0 · 컬럼 369(보임 368) · 헤더 3단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(13692)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

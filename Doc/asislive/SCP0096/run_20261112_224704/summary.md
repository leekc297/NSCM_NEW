# AS-IS 실측 요약 — SCP0096

- 실행: 2026-11-12 22:47:04.837 ~ 2026-11-12 22:48:13.076 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day(OSP) (GSCM.SCP.Master.UIL.SCP0096_Shipment_Working_Day_OSP)
- 조회 결과: Total : 1 · DB : 11.392s, UI : 0.124s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:47:05.327 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 28.4 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:47:10.253 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 4920.28 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:47:10.561 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0096 |
| 22:47:10.587 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.37 | USER_ID= |
| 22:47:10.748 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 4.37 | Code=PlantByDivisionOperOsp3, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:47:10.777 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.08 |  |
| 22:47:10.787 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.63 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 22:47:10.812 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.55 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 22:47:12.553 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 1731.21 | p_program_id=SCP0096, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day OSP |
| 22:47:21.159 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8403.28 | MenuID=Shipment Working Day(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 22:47:23.923 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 33.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0096 |
| 22:47:32.712 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 13.11 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 22:47:32.724 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 4.04 | p_program_id=SCP0096, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day OSP |
| 22:47:44.206 | find | GSCM.SCP.Master.WSL | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 1 | 11376.05 | p_division_id=81, p_plant_site_id=KR02239900_81-P, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20271107, debug_mode=F |
| 22:48:03.877 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 19533.16 | p_menu_id=SCP0096, p_log_type=FIND, p_log_cnt=1, p_db_time=11.392, p_ui_time=0.124, p_user_id=jaeuk.shin |
| 22:48:10.141 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.78 | MenuID=Shipment Working Day(OSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Period* | dCalendar | Y |
| Div* | cboDivision | Y |
| layoutSum | chkSum |  |
| Input Value | cboInputValue |  |
| Day of the week | cboDayWeek |  |
| Input | btnInput |  |

## 그리드

- spdMain / Shipment Working Day OSP: 행 1 · 컬럼 443(보임 330) · 헤더 3단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

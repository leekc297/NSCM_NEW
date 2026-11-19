# AS-IS 실측 요약 — SCP0096

- 실행: 2026-11-18 14:33:19.096 ~ 2026-11-18 14:33:56.172 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day(OSP) (GSCM.SCP.Master.UIL.SCP0096_Shipment_Working_Day_OSP)
- 조회 결과: Total : 1 · DB : 0.307s, UI : 0.122s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 14:33:39.948 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 55.44 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 14:33:39.961 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 4.04 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 14:33:40.587 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 25.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0096 |
| 14:33:40.661 | load | GSCM.BizService.WSL | SELECT * | 874 | 59.7 | USER_ID= |
| 14:33:40.937 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 13.28 | Code=PlantByDivisionOperOsp3, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 14:33:41.011 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 20.61 |  |
| 14:33:41.313 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 222.4 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 14:33:41.439 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 436 | 18.92 | p_start_yyyymmdd=20261118, p_end_yyyymmdd=20271114 |
| 14:33:41.517 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 22.01 | p_program_id=SCP0096, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day OSP |
| 14:33:41.870 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 100.17 | MenuID=Shipment Working Day(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 14:33:42.091 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0096 |
| 14:33:49.832 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 436 | 23.92 | p_start_yyyymmdd=20261118, p_end_yyyymmdd=20271114 |
| 14:33:49.851 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 7.26 | p_program_id=SCP0096, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day OSP |
| 14:33:50.261 | find | GSCM.SCP.Master.WSL | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 1 | 286.08 | p_division_id=81, p_plant_site_id=KR02239900_81-P, p_from_yyyymmdd=20261118, p_to_yyyymmdd=20271114, debug_mode=F |
| 14:33:50.435 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 12.35 | p_menu_id=SCP0096, p_log_type=FIND, p_log_cnt=1, p_db_time=0.307, p_ui_time=0.122, p_user_id=jaeuk.shin |

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

- spdMain / Shipment Working Day OSP: 행 1 · 컬럼 444(보임 330) · 헤더 3단 · 고정 컬럼 8

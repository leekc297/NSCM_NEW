# AS-IS 실측 요약 — SCP0019

- 실행: 2026-11-12 19:53:53.765 ~ 2026-11-12 19:54:12.222 · 계정 jaeuk.shin · 상태 OK
- 화면: Work Calendar(OSP) (GSCM.SCP.Master.UIL.SCP0019_WorkingTime)
- 조회 결과: Total : 1 · DB : 1.821s, UI : 0.133s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:53:54.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.67 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:54.141 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.76 | Code=PlantByDivisionOperOsp4, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:54.153 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 8 | 4.55 | Code=LocationGroupByCapaWT, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:54.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 4.29 | Code=BuildingByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:54.260 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 3871 | 88.19 | Code=LineByOperationAddOSP2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:53:54.308 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.6 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:53:54.343 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.65 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0019 |
| 19:53:54.366 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.33 | USER_ID= |
| 19:53:54.496 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.32 |  |
| 19:53:54.526 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.19 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 19:53:54.548 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 11.47 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 19:53:54.558 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 3.39 | p_program_id=SCP0019, p_user_id=jaeuk.shin, p_sheet_name=Working Time |
| 19:53:55.244 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 585.88 | MenuID=Work Calendar(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 19:53:55.331 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0019 |
| 19:54:03.608 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 13.39 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 19:54:03.620 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.02 | p_program_id=SCP0019, p_user_id=jaeuk.shin, p_sheet_name=Working Time |
| 19:54:05.525 | find | GSCM.SCP.Master.WSL | SCP0019_GET_WORKING_TIME | 1 | 1789.44 | p_from_yyyymmdd=20261112, p_to_yyyymmdd=20271107, p_division_id=81, p_plant_site_id=KR02239900_81-P, p_factory_id=, p_operation_id=, p_line_id=, debug_mode=F |
| 19:54:05.849 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 163.05 | p_menu_id=SCP0019, p_log_type=FIND, p_log_cnt=1, p_db_time=1.821, p_ui_time=0.133, p_user_id=jaeuk.shin |
| 19:54:11.245 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.46 | MenuID=Work Calendar(OSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Operation | clbOperation |  |
| Div* | cboDivision | Y |
| Day of the week | cboDayWeek |  |
| Input | btnInput |  |
| Input Value | txtInpuValue |  |
| Building | clbBuilding |  |
| layoutControlItem8 | chkSum |  |
| Line | clbLine |  |
| Bucket | cboBucketType |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Working Time: 행 1 · 컬럼 377(보임 371) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

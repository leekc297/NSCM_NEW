# AS-IS 실측 요약 — SCP0096

- 실행: 2026-11-12 20:17:49.788 ~ 2026-11-12 20:18:49.195 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day(OSP) (GSCM.SCP.Master.UIL.SCP0096_Shipment_Working_Day_OSP)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:17:50.179 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.15 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:17:50.191 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.65 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:17:50.586 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0096 |
| 20:17:50.614 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.44 | USER_ID= |
| 20:17:50.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 4.33 | Code=PlantByDivisionOperOsp3, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:17:50.801 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.87 |  |
| 20:17:50.810 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.85 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=, p_offset_month=12, p_timezone=AS054 |
| 20:17:50.842 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.41 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 20:17:52.933 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 2079.94 | p_program_id=SCP0096, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day OSP |
| 20:18:07.551 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 14432.61 | MenuID=Shipment Working Day(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 20:18:09.628 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0096 |
| 20:18:17.543 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 435 | 12.15 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271107 |
| 20:18:17.559 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.6 | p_program_id=SCP0096, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day OSP |

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

- spdMain / Shipment Working Day OSP: 행 0 · 컬럼 442(보임 331) · 헤더 3단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

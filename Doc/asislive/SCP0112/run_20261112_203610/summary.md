# AS-IS 실측 요약 — SCP0112

- 실행: 2026-11-12 20:36:10.588 ~ 2026-11-12 20:36:36.920 · 계정 jaeuk.shin · 상태 OK
- 화면: Cell Tray Simulation (GSCM.SCP.Report.UIL.SCP0112_CellTraySimulation)
- 조회 결과: Total : 17 · DB : 5.707s, UI : 0.092s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:36:11.007 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 45.95 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:36:11.822 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 809.11 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:36:12.728 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 896.75 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:36:12.738 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 5.34 | Code=PlantByDivisionOperOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:36:13.052 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0112 |
| 20:36:13.079 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.48 | USER_ID= |
| 20:36:13.302 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 12.89 | p_division_id=82, p_plan_cycle=WEEKLY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 20:36:13.361 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 23.55 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 20:36:13.447 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 66.37 | p_program_id=SCP0112, p_user_id=jaeuk.shin, p_sheet_name=Cell Tray Simulation |
| 20:36:14.223 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 576.44 | MenuID=Cell Tray Simulation, CnntCode=0104001, UserID=jaeuk.shin |
| 20:36:14.344 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0112 |
| 20:36:22.346 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 22.19 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 20:36:22.362 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 6.72 | p_program_id=SCP0112, p_user_id=jaeuk.shin, p_sheet_name=Cell Tray Simulation |
| 20:36:28.176 | find | GSCM.SCP.Analysis.WSL | SCP0112_GET_CELL_TRAY_SIMULATION | 17 | 5603.53 | p_division_id=82, p_plan_start_yyyymmdd=20260824, p_plan_type=FN, p_to_site=KR32625300_82-P, p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822 |
| 20:36:28.356 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 73.31 | p_menu_id=SCP0112, p_log_type=FIND, p_log_cnt=17, p_db_time=5.707, p_ui_time=0.092, p_user_id=jaeuk.shin |
| 20:36:31.694 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 69215.08 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 20:36:36.205 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.84 | MenuID=Cell Tray Simulation, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Plan type* | cboPlanType | Y |
| Period* | dCalendar | Y |
| Plan date* | cboPlanDate | Y |
| To Site* | cboToSite | Y |

## 그리드

- spdMain / Cell Tray Simulation: 행 17 · 컬럼 450(보임 64) · 헤더 2단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

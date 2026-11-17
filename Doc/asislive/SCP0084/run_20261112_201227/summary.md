# AS-IS 실측 요약 — SCP0084

- 실행: 2026-11-12 20:12:27.376 ~ 2026-11-12 20:13:05.620 · 계정 jaeuk.shin · 상태 OK
- 화면: Long-term stock (GSCM.SCP.Report.UIL.SCP0084_LongTermStock)
- 조회 결과: Total : 10,274 · DB : 13.235s, UI : 0.107s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:12:27.808 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.75 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:12:36.958 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 9144.88 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:12:37.285 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0084 |
| 20:12:37.312 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.13 | USER_ID= |
| 20:12:37.933 | load | GSCM.SCP.Analysis.WSL | SCP0084_GET_MONTH_RANGE | 1 | 487.07 | p_month=12 |
| 20:12:38.025 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 41.21 | p_program_id=SCP0084, p_user_id=jaeuk.shin, p_sheet_name=Long Term Stock |
| 20:12:38.410 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 258.75 | MenuID=Long-term stock, CnntCode=0104001, UserID=jaeuk.shin |
| 20:12:38.454 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0084 |
| 20:12:46.117 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 6.25 | p_program_id=SCP0084, p_user_id=jaeuk.shin, p_sheet_name=Long Term Stock |
| 20:12:58.918 | find | GSCM.SCP.Analysis.WSL | SCP0084_GET_LONG_TERM_STOCK | 10274 | 12763.81 | p_yyyymm=202609, p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_plant_id=, p_long_term_type_code=, debug_mode=F |
| 20:12:59.497 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.7 | p_menu_id=SCP0084, p_log_type=FIND, p_log_cnt=10274, p_db_time=13.235, p_ui_time=0.107, p_user_id=jaeuk.shin |
| 20:13:04.966 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.21 | MenuID=Long-term stock, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Month | monthPicker |  |
| Long Term Type | cboLongTermType |  |
| Plant | clbPlant |  |

## 그리드

- spdMain / Long Term Stock: 행 10274 · 컬럼 58(보임 46) · 헤더 1단 · 고정 컬럼 9

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

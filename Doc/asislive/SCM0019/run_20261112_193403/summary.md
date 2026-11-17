# AS-IS 실측 요약 — SCM0019

- 실행: 2026-11-12 19:34:03.350 ~ 2026-11-12 19:34:18.657 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP IF Blocking (GSCM.SCM.Master.UIL.SCM0019_SCP_Interface_Blocking)
- 조회 결과: Total : 48 · DB : 0.358s, UI : 0.065s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:34:03.726 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.26 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:03.764 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0019 |
| 19:34:03.787 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.78 | USER_ID= |
| 19:34:03.929 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 55.05 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:03.959 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 5 | 22.64 | p_program_id=SCM0019, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 19:34:04.116 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 130.81 | MenuID=SCP IF Blocking, CnntCode=0104001, UserID=jaeuk.shin |
| 19:34:04.167 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0019 |
| 19:34:12.490 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 5 | 3.68 | p_program_id=SCM0019, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 19:34:12.861 | find | GSCM.SCM.Master.WSL | SCM0019_GET_SCP_INTERFACE_BLOCKING | 48 | 352.23 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_UC, p_from_yyyymmdd=20261109, p_to_yyyymmdd=20261206 |
| 19:34:12.937 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.68 | p_menu_id=SCM0019, p_log_type=FIND, p_log_cnt=48, p_db_time=0.358, p_ui_time=0.065, p_user_id=jaeuk.shin |
| 19:34:17.932 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.93 | MenuID=SCP IF Blocking, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Period* | drpPeriod | Y |

## 그리드

- spdMain / Main: 행 48 · 컬럼 6(보임 5) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

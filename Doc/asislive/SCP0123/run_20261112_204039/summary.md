# AS-IS 실측 요약 — SCP0123

- 실행: 2026-11-12 20:40:39.765 ~ 2026-11-12 20:40:57.446 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Control (GSCM.SCP.Master.UIL.SCP0123_PlanControl)
- 조회 결과: Total : 7 · DB : 0.678s, UI : 0.029s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:40:40.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 27.04 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:41.537 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 1437.79 | Code=OPMZ_DATE_WEEKLY, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:41.838 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2792 | 294.43 | Code=PlanID, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:41.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.21 | Code=LookupCommon, Param1=OPMZ_DIVISION_GM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:40:41.915 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 45.8 | p_user_id= |
| 20:40:41.971 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0123 |
| 20:40:41.994 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.06 | USER_ID= |
| 20:40:42.167 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.31 | p_program_id=SCP0123, p_user_id=jaeuk.shin, p_sheet_name=Plan Control |
| 20:40:42.218 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2792 | 39.21 | Code=PlanID, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:42.260 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 7 | 3.71 | p_program_id=SCP0123, p_user_id=jaeuk.shin, p_sheet_name=Status |
| 20:40:42.338 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 60.85 | MenuID=Plan Control, CnntCode=0104001, UserID=jaeuk.shin |
| 20:40:42.372 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0123 |
| 20:40:50.379 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.12 | p_program_id=SCP0123, p_user_id=jaeuk.shin, p_sheet_name=Plan Control |
| 20:40:50.431 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2792 | 39.79 | Code=PlanID, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:51.174 | find | GSCM.SCP.Master.WSL | SCP0123_GET_PLAN_CONTROL | 7 | 673.94 | p_division_id=81, p_plan_group_id=PG0001, p_plan_start_yyyymmdd=20260824, p_actv_cd=, p_plan_id= |
| 20:40:51.199 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 7 | 3.63 | p_program_id=SCP0123, p_user_id=jaeuk.shin, p_sheet_name=Status |
| 20:40:51.221 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 12.41 | p_menu_id=SCP0123, p_log_type=FIND, p_log_cnt=7, p_db_time=0.678, p_ui_time=0.029, p_user_id=jaeuk.shin |
| 20:40:56.739 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.79 | MenuID=Plan Control, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Date | cboPlanDate |  |
| Div | cboDivision |  |
| Plan Group | cboPlanGroup |  |
| Plan Date | dpPlanDate_Days |  |

## 그리드

- spdMain / Plan Control: 행 7 · 컬럼 23(보임 22) · 헤더 1단 · 고정 컬럼 0
- spdSub / Status: 행 0 · 컬럼 8(보임 7) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

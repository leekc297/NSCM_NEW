# AS-IS 실측 요약 — SCP0122

- 실행: 2026-11-13 05:43:46.392 ~ 2026-11-13 05:44:03.058 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Activity Mgmt (GSCM.SCP.Master.UIL.SCP0122_PlanActivityMgmt)
- 조회 결과: Total : 7 · DB : 0.084s, UI : 0.086s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:43:46.771 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.45 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:46.780 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 4.01 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:46.787 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.29 | Code=LookupCommon, Param1=OPMZ_PRS_CD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:43:47.607 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 813.28 | p_user_id= |
| 05:43:47.689 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 05:43:47.717 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.85 | USER_ID= |
| 05:43:47.916 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.23 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 05:43:47.926 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 5.11 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:48.121 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 168.62 | MenuID=Plan Activity Mgmt, CnntCode=0104001, UserID=jaeuk.shin |
| 05:43:48.177 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 05:43:56.637 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.9 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 05:43:56.646 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.17 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:56.733 | find | GSCM.SCP.Master.WSL | SCP0122_GET_PLAN_ACTIVITY_MGMT | 7 | 78.27 | p_division_id=81, p_plan_group_id=PG0001, p_prs_cd=P001 |
| 05:43:56.834 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 5.84 | p_menu_id=SCP0122, p_log_type=FIND, p_log_cnt=7, p_db_time=0.084, p_ui_time=0.086, p_user_id=jaeuk.shin |
| 05:44:02.367 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.59 | MenuID=Plan Activity Mgmt, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Process | cboPlant |  |
| Plan Group | cboPlanGroup |  |
| Div | cboDivision |  |

## 그리드

- spdMain / Plan Activity Mgmt: 행 7 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

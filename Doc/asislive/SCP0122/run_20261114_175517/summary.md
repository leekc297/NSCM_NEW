# AS-IS 실측 요약 — SCP0122

- 실행: 2026-11-14 17:55:17.736 ~ 2026-11-14 18:00:46.072 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Activity Mgmt (GSCM.SCP.Master.UIL.SCP0122_PlanActivityMgmt)
- 조회 결과: Total : 7 · DB : 0.036s, UI : 0.077s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:00:31.282 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.21 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:00:31.298 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 4.28 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:00:31.314 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.95 | Code=LookupCommon, Param1=OPMZ_PRS_CD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:00:31.616 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 292.68 | p_user_id= |
| 18:00:31.978 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 18:00:32.006 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.08 | USER_ID= |
| 18:00:32.221 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 22.47 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 18:00:32.238 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.38 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:00:32.390 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 59.79 | MenuID=Plan Activity Mgmt, CnntCode=0104001, UserID=jaeuk.shin |
| 18:00:32.438 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.61 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 18:00:40.220 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.94 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 18:00:40.235 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.67 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:00:40.265 | find | GSCM.SCP.Master.WSL | SCP0122_GET_PLAN_ACTIVITY_MGMT | 7 | 3.78 | p_division_id=81, p_plan_group_id=PG0001, p_prs_cd=P001 |
| 18:00:40.364 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.74 | p_menu_id=SCP0122, p_log_type=FIND, p_log_cnt=7, p_db_time=0.036, p_ui_time=0.077, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Process | cboPlant |  |
| Plan Group | cboPlanGroup |  |
| Div | cboDivision |  |

## 그리드

- spdMain / Plan Activity Mgmt: 행 7 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

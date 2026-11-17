# AS-IS 실측 요약 — SCP0124

- 실행: 2026-11-12 20:40:57.567 ~ 2026-11-12 20:41:13.109 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Group Dashboard (GSCM.SCP.Master.UIL.SCP0124_PlanGroupDashboard)
- 조회 결과: Total :  · DB : 0.677s, UI : 0.002s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:40:57.856 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.31 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:57.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 5.47 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:57.873 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.85 | Code=LookupCommon, Param1=OPMZ_PRS_CD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:40:57.923 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 46.01 | p_user_id= |
| 20:40:57.970 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0124 |
| 20:40:57.995 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.71 | USER_ID= |
| 20:40:58.155 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 26.53 | p_program_id=SCP0124, p_user_id=jaeuk.shin, p_sheet_name=Plan Group Dashboard |
| 20:40:58.253 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 68.74 | MenuID=Plan Group Dashboard, CnntCode=0104001, UserID=jaeuk.shin |
| 20:40:58.288 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0124 |
| 20:41:06.244 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.7 | p_program_id=SCP0124, p_user_id=jaeuk.shin, p_sheet_name=Plan Group Dashboard |
| 20:41:06.924 | find | GSCM.SCP.Master.WSL | SCP0124_GET_PLAN_GROUP_DASHBOARD | 0 | 671.95 | p_division_id=81, p_plan_group_id=, p_plant_id=, p_completed_yn=, p_start_date=20261105, p_end_date=20261112 |
| 20:41:06.935 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.78 | p_menu_id=SCP0124, p_log_type=FIND, p_log_cnt=, p_db_time=0.677, p_ui_time=0.002, p_user_id=jaeuk.shin |
| 20:41:12.347 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.52 | MenuID=Plan Group Dashboard, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Completed | cboCompleted |  |
| Plant | clbPlant |  |
| Plan Group | cboPlanGroup |  |
| Period* | dCalendar | Y |
| Div | cboDivision |  |

## 그리드

- spdMain / Plan Group Dashboard: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

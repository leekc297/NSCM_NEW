# AS-IS 실측 요약 — SCP0122

- 실행: 2026-11-14 23:49:54.948 ~ 2026-11-14 23:50:13.294 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Activity Mgmt (GSCM.SCP.Master.UIL.SCP0122_PlanActivityMgmt)
- 조회 결과: Total : 7 · DB : 0.058s, UI : 0.09s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:49:55.427 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.1 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:49:55.460 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 26.88 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:49:55.470 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.55 | Code=LookupCommon, Param1=OPMZ_PRS_CD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:49:55.977 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 502.01 | p_user_id= |
| 23:49:56.297 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 23:49:56.327 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.67 | USER_ID= |
| 23:49:56.521 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 27.11 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 23:49:56.544 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.8 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:49:56.697 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 66.35 | MenuID=Plan Activity Mgmt, CnntCode=0104001, UserID=jaeuk.shin |
| 23:49:56.744 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 23:50:06.055 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 3.48 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 23:50:06.069 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.24 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:50:06.129 | find | GSCM.SCP.Master.WSL | SCP0122_GET_PLAN_ACTIVITY_MGMT | 7 | 34.1 | p_division_id=81, p_plan_group_id=PG0001, p_prs_cd=P001 |
| 23:50:06.226 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.17 | p_menu_id=SCP0122, p_log_type=FIND, p_log_cnt=7, p_db_time=0.058, p_ui_time=0.09, p_user_id=jaeuk.shin |
| 23:50:12.596 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.04 | MenuID=Plan Activity Mgmt, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Process | cboPlant |  |
| Plan Group | cboPlanGroup |  |
| Div | cboDivision |  |

## 그리드

- spdMain / Plan Activity Mgmt: 행 7 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

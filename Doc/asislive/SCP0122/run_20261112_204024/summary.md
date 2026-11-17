# AS-IS 실측 요약 — SCP0122

- 실행: 2026-11-12 20:40:24.623 ~ 2026-11-12 20:40:39.647 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Activity Mgmt (GSCM.SCP.Master.UIL.SCP0122_PlanActivityMgmt)
- 조회 결과: Total : 7 · DB : 0.146s, UI : 0.002s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:40:24.969 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:25.013 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 40.49 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:25.053 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 35.46 | Code=LookupCommon, Param1=OPMZ_PRS_CD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:40:25.103 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 47.01 | p_user_id= |
| 20:40:25.137 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 20:40:25.164 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.83 | USER_ID= |
| 20:40:25.324 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 30.21 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 20:40:25.333 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.39 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:25.818 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 467.29 | MenuID=Plan Activity Mgmt, CnntCode=0104001, UserID=jaeuk.shin |
| 20:40:25.892 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0122 |
| 20:40:33.627 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 15 | 4.65 | p_program_id=SCP0122, p_user_id=jaeuk.shin, p_sheet_name=Plan Activity Mgmt |
| 20:40:33.639 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 9 | 3.2 | Code=ActivityCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:33.788 | find | GSCM.SCP.Master.WSL | SCP0122_GET_PLAN_ACTIVITY_MGMT | 7 | 140.95 | p_division_id=81, p_plan_group_id=PG0001, p_prs_cd=P001 |
| 20:40:33.836 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 38.1 | p_menu_id=SCP0122, p_log_type=FIND, p_log_cnt=7, p_db_time=0.146, p_ui_time=0.002, p_user_id=jaeuk.shin |
| 20:40:34.276 | find | GSCM.BizService.WSL | SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN | 1475 | 213080.07 | p_plan_date=20260914, p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_creation_type=, p_group_code=, p_item_type=, p_item_id=, p_end_month=202611, p_plant_id=, debug_mode=F |
| 20:40:38.973 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.15 | MenuID=Plan Activity Mgmt, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Process | cboPlant |  |
| Plan Group | cboPlanGroup |  |
| Div | cboDivision |  |

## 그리드

- spdMain / Plan Activity Mgmt: 행 7 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

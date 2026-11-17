# AS-IS 실측 요약 — SCP0130

- 실행: 2026-11-12 20:43:14.025 ~ 2026-11-12 20:43:30.490 · 계정 jaeuk.shin · 상태 OK
- 화면: Scheduled Receipt Information (GSCM.SCP.Master.UIL.SCP0130_ScheduledRecieptInformation)
- 조회 결과: Total :  · DB : 0.067s, UI : 0.003s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:43:14.379 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.24 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:14.733 | load | GSCM.SCP.Master.WSL | SCP0130_GET_SEARCH_INFO | 46 | 348.97 | p_division_id=81, p_site_id= |
| 20:43:14.992 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0130 |
| 20:43:15.015 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.93 | USER_ID= |
| 20:43:15.219 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 25.05 | p_program_id=SCP0130, p_user_id=jaeuk.shin, p_sheet_name=Virtual BOM |
| 20:43:15.227 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.52 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:15.237 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.36 | p_program_id=SCP0130, p_user_id=jaeuk.shin, p_sheet_name=Scheduled Reciept Information |
| 20:43:15.245 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.54 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:15.385 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 112.1 | MenuID=Scheduled Receipt Information, CnntCode=0104001, UserID=jaeuk.shin |
| 20:43:15.427 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 6.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0130 |
| 20:43:23.672 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 3.72 | p_program_id=SCP0130, p_user_id=jaeuk.shin, p_sheet_name=Virtual BOM |
| 20:43:23.680 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.7 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:23.696 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 3.92 | p_program_id=SCP0130, p_user_id=jaeuk.shin, p_sheet_name=Virtual BOM |
| 20:43:23.705 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 4.37 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:23.781 | find | GSCM.SCP.Master.WSL | SCP0130_GET_VIRTUAL_BOM | 0 | 63.05 | p_division_id=81, p_plan_group_id=, p_plant_site_id=, p_item_id=, p_item_id_child=, p_valid_yn=, p_from_date=20261109 |
| 20:43:23.815 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 23.88 | p_menu_id=SCP0130, p_log_type=FIND, p_log_cnt=, p_db_time=0.067, p_ui_time=0.003, p_user_id=jaeuk.shin |
| 20:43:29.192 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.73 | MenuID=Scheduled Receipt Information, CnntCode=0104002, UserID=jaeuk.shin |
| 20:43:29.551 | find | GSCM.SCP.Master.WSL | SCP0130_GET_SEARCH_INFO | 46 | 142.52 | p_division_id=81, p_site_id= |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Valid | cboValid |  |
| Child Material | clbChildMaterial |  |
| From Date | datePicker |  |
| Parent Model | txtItemId |  |
| lblItemIdButton | btnItemId |  |
| Plan Group | clbPlanGroup |  |
| Plant Site | clbSite |  |

## 그리드

- spdMain / Virtual BOM: 행 0 · 컬럼 15(보임 14) · 헤더 1단 · 고정 컬럼 0
- spdMain / Scheduled Reciept Information: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0022

- 실행: 2026-11-12 19:54:45.198 ~ 2026-11-12 19:55:09.158 · 계정 jaeuk.shin · 상태 OK
- 화면: Formation (GSCM.SCP.Master.UIL.SCP0022_Formation)
- 조회 결과:  · DB : 1.398s, UI : 0.004s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:54:45.593 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.9 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:45.604 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.18 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:45.953 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0022 |
| 19:54:45.980 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.24 | USER_ID= |
| 19:54:46.257 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 124.6 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation |
| 19:54:46.298 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.88 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation Except |
| 19:54:46.313 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.94 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation Except LT |
| 19:54:47.003 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 600.41 | MenuID=Formation, CnntCode=0104001, UserID=jaeuk.shin |
| 19:54:47.213 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0022 |
| 19:54:55.322 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.06 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation |
| 19:54:55.337 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.98 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation Except |
| 19:54:55.439 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.82 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation Except |
| 19:55:00.625 | find | GSCM.SCP.Master.WSL | SCP0022_GET_FORMATION_EXCEPT | 17 | 5152.96 | p_division_id=81, p_plant_site_id=HQ07-A,HQ11-A,MI00-A,MI02-A,NA00-A,NB01-A,WA00-A, p_item_id= |
| 19:55:00.939 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 224.7 | p_menu_id=SCP0022, p_log_type=FIND, p_log_cnt=, p_db_time=5.176, p_ui_time=0.079, p_user_id=jaeuk.shin |
| 19:55:00.958 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 6.98 | p_program_id=SCP0022, p_user_id=jaeuk.shin, p_sheet_name=Formation Except LT |
| 19:55:02.369 | find | GSCM.SCP.Master.WSL | SCP0022_GET_FORMATION_EXCEPT_LT | 0 | 1393.14 | p_division_id=81, p_plant_site_id=HQ07-A,HQ11-A,MI00-A,MI02-A,NA00-A,NB01-A,WA00-A, p_item_id= |
| 19:55:02.884 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 502.63 | p_menu_id=SCP0022, p_log_type=FIND, p_log_cnt=, p_db_time=1.398, p_ui_time=0.004, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Plant Site | clbPlantSite |  |
| Material | txtItemId |  |
| layoutControlItem4 | btnItemId |  |

## 그리드

- spdMain / Formation: 행 0 · 컬럼 17(보임 15) · 헤더 1단 · 고정 컬럼 0
- spdExcept / Formation Except: 행 17 · 컬럼 21(보임 14) · 헤더 1단 · 고정 컬럼 0
- spdExcept / Formation Except LT: 행 0 · 컬럼 20(보임 19) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

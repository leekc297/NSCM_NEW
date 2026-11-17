# AS-IS 실측 요약 — SCP0023

- 실행: 2026-11-12 19:55:25.221 ~ 2026-11-12 19:56:03.816 · 계정 jaeuk.shin · 상태 OK
- 화면: Outsourcing Capacity (GSCM.SCP.Master.UIL.SCP0023_OutsourcingCapacity)
- 조회 결과: Total : 8 · DB : 20.527s, UI : 0.083s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:55:25.589 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.07 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:55:25.890 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0023 |
| 19:55:25.916 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.22 | USER_ID= |
| 19:55:26.049 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 6.38 | Code=PlantSiteByDivisionOSP, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:55:26.075 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.76 | p_program_id=SCP0023, p_user_id=jaeuk.shin, p_sheet_name=Outsourcing Capacity |
| 19:55:28.835 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2665.87 | MenuID=Outsourcing Capacity, CnntCode=0104001, UserID=jaeuk.shin |
| 19:55:29.553 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0023 |
| 19:55:37.297 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.55 | p_program_id=SCP0023, p_user_id=jaeuk.shin, p_sheet_name=Outsourcing Capacity |
| 19:55:57.830 | find | GSCM.SCP.Master.WSL | SCP0023_GET_OUTSOURCING_CAPA | 8 | 20422.71 | p_division_id=81, p_plant_site_id=KR02239900_81-P, p_item_id=, p_valid=, debug_mode=, p_nick_name= |
| 19:55:58.123 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 195.52 | p_menu_id=SCP0023, p_log_type=FIND, p_log_cnt=8, p_db_time=20.527, p_ui_time=0.083, p_user_id=jaeuk.shin |
| 19:56:03.046 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.67 | MenuID=Outsourcing Capacity, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Plant Site | clbPlantSite |  |
| Model | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Outsourcing Capacity: 행 8 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

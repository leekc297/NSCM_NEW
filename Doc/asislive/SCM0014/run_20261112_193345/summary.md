# AS-IS 실측 요약 — SCM0014

- 실행: 2026-11-12 19:33:45.558 ~ 2026-11-12 19:34:03.245 · 계정 jaeuk.shin · 상태 OK
- 화면: Intransit Inventory (GSCM.SCM.Validation.UIL.SCM0014_ValidationShipmentResult)
- 조회 결과: Total :  · DB : 0.867s, UI : 0.076s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:33:45.984 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.03 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:33:46.049 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0014 |
| 19:33:46.073 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.9 | USER_ID= |
| 19:33:46.287 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 49.2 | Code=LookupCommon, Param1=SHIPMENT_RESULT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:33:47.881 | load | GSCM.SCM.Validation.WSL | select	CONVERT(varchar(8) , DATEADD(DAY, -1, (convert(varchar(8), [dbo].[FN_MULTY_TIME](@p_timezone),112))), 112)+':'+ | 1 | 47.77 | p_timezone=AS054 |
| 19:33:47.938 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 23.49 | p_program_id=SCM0014, p_user_id=jaeuk.shin, p_sheet_name=Validation Shipment Rsult |
| 19:33:48.041 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 52.78 | MenuID=Intransit Inventory, CnntCode=0104001, UserID=jaeuk.shin |
| 19:33:48.102 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0014 |
| 19:33:56.493 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 4.09 | p_program_id=SCM0014, p_user_id=jaeuk.shin, p_sheet_name=Validation Shipment Rsult |
| 19:33:57.370 | find | GSCM.SCM.Validation.WSL | SCM0014_GET_VALIDATION_SHIPMENT_RESULT | 0 | 787.46 | p_division_id=81, p_plant_site_id=, p_sales_site_id=, p_project_code=, p_item_id=, p_from_yyyymmdd=20261111, p_to_yyyymmdd=20261111, p_result_type=I |
| 19:33:57.472 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 18.59 | p_menu_id=SCM0014, p_log_type=FIND, p_log_cnt=, p_db_time=0.867, p_ui_time=0.076, p_user_id=jaeuk.shin |
| 19:34:02.565 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.87 | MenuID=Intransit Inventory, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Project | txtProject |  |
| Model | txtItemId |  |
| layoutControlItem3 | btnItemId |  |
| Result Type | cboResultType |  |
| layoutControlItem2 | btnProjectID |  |
| Div | cboDivision |  |
| Plant Site | txtPlantSite |  |
| Sales Site | txtSaleSite |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Validation Shipment Rsult: 행 0 · 컬럼 24(보임 23) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

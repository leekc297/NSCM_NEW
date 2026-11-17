# AS-IS 실측 요약 — SCP0132

- 실행: 2026-11-12 20:43:48.344 ~ 2026-11-12 20:44:04.961 · 계정 jaeuk.shin · 상태 OK
- 화면: Constraint Of Shipment Qty (GSCM.SCP.Master.UIL.SCP0132_ConstraintOfShipmentQty)
- 조회 결과: Total : 288 · DB : 0.088s, UI : 0.007s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:43:48.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.09 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:49.312 | load | GSCM.SCP.Master.WSL | SCP0132_GET_SEARCH_INFO | 46 | 685.45 |  |
| 20:43:49.523 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0132 |
| 20:43:49.547 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.39 | USER_ID= |
| 20:43:50.317 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 5.16 | p_program_id=SCP0132, p_user_id=jaeuk.shin, p_sheet_name=Constraint Of Shipment Qty |
| 20:43:50.325 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.63 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:50.402 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 46.3 | MenuID=Constraint Of Shipment Qty, CnntCode=0104001, UserID=jaeuk.shin |
| 20:43:50.460 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0132 |
| 20:43:58.680 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 5.32 | p_program_id=SCP0132, p_user_id=jaeuk.shin, p_sheet_name=Constraint Of Shipment Qty |
| 20:43:58.690 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.73 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:43:58.783 | find | GSCM.SCP.Master.WSL | SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY | 288 | 75.87 | p_division_id=81, p_plan_group_id=, p_from_site_id=, p_to_site_id=, p_mdl_gr_nm=, p_item_id=, p_stage=, p_from_yyyymmdd=20261109, p_to_yyyymmdd=20271108, p_valid_yn= |
| 20:43:58.821 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 13.23 | p_menu_id=SCP0132, p_log_type=FIND, p_log_cnt=288, p_db_time=0.088, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 20:44:04.095 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.54 | MenuID=Constraint Of Shipment Qty, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Model | txtItemId |  |
| lblItemIdButton | btnItemId |  |
| Period* | dCalendar | Y |
| Model Group | clbModelGroup |  |
| Valid | cboValid |  |
| Stage | clbStage |  |
| Plan Group | clbPlanGroup |  |
| From Site | clbFromSite |  |
| To Site | clbToSite |  |

## 그리드

- spdMain / Constraint Of Shipment Qty: 행 288 · 컬럼 24(보임 23) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

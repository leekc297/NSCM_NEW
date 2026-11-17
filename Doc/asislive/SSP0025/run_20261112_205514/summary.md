# AS-IS 실측 요약 — SSP0025

- 실행: 2026-11-12 20:55:14.758 ~ 2026-11-12 20:55:29.601 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Requestor PIC (GSCM.SSP.Plan.UIL.SSP0025_ShipmentRequestorPIC)
- 조회 결과: Total : 16 · DB : 0.16s, UI : 0.003s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:55:15.019 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 8.51 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:15.056 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0025 |
| 20:55:15.079 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.89 | USER_ID= |
| 20:55:15.169 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 5.62 | Code=PlantCell, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:15.185 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.72 | p_program_id=SSP0025, p_user_id=jaeuk.shin, p_sheet_name=Shipment Requestor PIC |
| 20:55:15.304 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 97.11 | MenuID=Shipment Requestor PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 20:55:15.342 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0025 |
| 20:55:23.293 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.85 | p_program_id=SSP0025, p_user_id=jaeuk.shin, p_sheet_name=Shipment Requestor PIC |
| 20:55:23.466 | find | GSCM.SSP.Plan.WSL | SSP0025_GET_SHIPMENT_REQUESTOR_PIC | 16 | 154.39 | p_division_id=81, p_plant_site=, p_item_id=, p_nick_name=, p_model_id=, p_language=KO |
| 20:55:23.479 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.66 | p_menu_id=SSP0025, p_log_type=FIND, p_log_cnt=16, p_db_time=0.16, p_ui_time=0.003, p_user_id=jaeuk.shin |
| 20:55:28.916 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.91 | MenuID=Shipment Requestor PIC, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Plant Site | clbFromSite |  |
| Material | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Nick Name | txtNickName |  |
| Model | txtModelId |  |
| layoutControlItem1 | btnModelId |  |

## 그리드

- spdMain / Shipment Requestor PIC: 행 16 · 컬럼 21(보임 19) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

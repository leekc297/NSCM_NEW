# AS-IS 실측 요약 — SSP0025

- 실행: 2026-11-15 05:05:06.996 ~ 2026-11-15 05:14:40.943 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Requestor PIC (GSCM.SSP.Plan.UIL.SSP0025_ShipmentRequestorPIC)
- 조회 결과: Total : 16 · DB : 0.063s, UI : 0.066s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:14:24.714 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.43 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:14:25.145 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0025 |
| 05:14:25.166 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.87 | USER_ID= |
| 05:14:25.338 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.04 | Code=PlantCell, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:14:25.401 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 24.52 | p_program_id=SSP0025, p_user_id=jaeuk.shin, p_sheet_name=Shipment Requestor PIC |
| 05:14:25.574 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 52.59 | MenuID=Shipment Requestor PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 05:14:25.655 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0025 |
| 05:14:34.487 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.19 | p_program_id=SSP0025, p_user_id=jaeuk.shin, p_sheet_name=Shipment Requestor PIC |
| 05:14:34.549 | find | GSCM.SSP.Plan.WSL | SSP0025_GET_SHIPMENT_REQUESTOR_PIC | 16 | 9.13 | p_division_id=81, p_plant_site=, p_item_id=, p_nick_name=, p_model_id=, p_language=KO |
| 05:14:34.652 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.12 | p_menu_id=SSP0025, p_log_type=FIND, p_log_cnt=16, p_db_time=0.063, p_ui_time=0.066, p_user_id=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(23844)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

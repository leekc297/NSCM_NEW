# AS-IS 실측 요약 — SSP0024

- 실행: 2026-11-13 05:47:07.916 ~ 2026-11-13 05:47:25.650 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Master Electrode (GSCM.SSP.Plan.UIL.SSP0024_ShipmentMasterElectrode)
- 조회 결과: Total : 190 · DB : 1.572s, UI : 0.08s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:47:08.290 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.66 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.301 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 6.41 | Code=PlantSiteByFactoryEEOperation, Param1=40,81,82,81_UC, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.316 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 5.84 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.324 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.15 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.334 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 327 | 6.33 | Code=BuildingForShipMasterElec, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.346 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.64 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.380 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0024 |
| 05:47:08.407 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.93 | USER_ID= |
| 05:47:08.486 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.83 | Code=PlantSiteByFactoryEEOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.500 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.66 | p_program_id=SSP0024, p_user_id=jaeuk.shin, p_sheet_name=Ship Master Elec |
| 05:47:08.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.38 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.519 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 4.18 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.527 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.06 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.541 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.41 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.549 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.46 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:08.641 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.18 | MenuID=Shipment Master Electrode, CnntCode=0104001, UserID=jaeuk.shin |
| 05:47:08.695 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0024 |
| 05:47:17.330 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 7.77 | p_program_id=SSP0024, p_user_id=jaeuk.shin, p_sheet_name=Ship Master Elec |
| 05:47:17.350 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 6.29 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:17.363 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 5.86 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:17.372 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.25 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:17.383 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.35 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:17.399 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.65 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:18.964 | find | GSCM.SSP.Plan.WSL | SSP0024_GET_SHIP_MASTER | 190 | 1547.47 | p_division_id=81, p_plant_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_material_id=, p_nick_name=, p_model_id= |
| 05:47:19.071 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.35 | p_menu_id=SSP0024, p_log_type=FIND, p_log_cnt=190, p_db_time=1.572, p_ui_time=0.08, p_user_id=jaeuk.shin |
| 05:47:24.784 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.48 | MenuID=Shipment Master Electrode, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | cboPlantSite |  |
| Div | cboDivision |  |
| Material | txtMaterialId |  |
| layoutControlItem5 | btnMaterialId |  |
| Nick Name | txtNickName |  |
| layoutControlItem4 | btnModelId |  |
| Model | txtModelId |  |

## 그리드

- spdMain / Ship Master Elec: 행 190 · 컬럼 26(보임 25) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

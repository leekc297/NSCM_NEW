# AS-IS 실측 요약 — SSP0024

- 실행: 2026-11-12 20:54:58.390 ~ 2026-11-12 20:55:14.636 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Master Electrode (GSCM.SSP.Plan.UIL.SSP0024_ShipmentMasterElectrode)
- 조회 결과: Total : 190 · DB : 1.239s, UI : 0.007s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:54:58.724 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 5.26 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.733 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 5.57 | Code=PlantSiteByFactoryEEOperation, Param1=40,81,82,81_UC, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.742 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 5.49 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.751 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.91 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.761 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 327 | 7.94 | Code=BuildingForShipMasterElec, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.771 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.05 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.804 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0024 |
| 20:54:58.831 | load | GSCM.BizService.WSL | SELECT * | 874 | 23.02 | USER_ID= |
| 20:54:58.922 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.82 | Code=PlantSiteByFactoryEEOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.957 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 23.73 | p_program_id=SSP0024, p_user_id=jaeuk.shin, p_sheet_name=Ship Master Elec |
| 20:54:58.968 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.11 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.981 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 7.03 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:58.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 6.16 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:59.006 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.36 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:59.014 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.08 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:59.131 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 103.2 | MenuID=Shipment Master Electrode, CnntCode=0104001, UserID=jaeuk.shin |
| 20:54:59.168 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0024 |
| 20:55:07.407 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.62 | p_program_id=SSP0024, p_user_id=jaeuk.shin, p_sheet_name=Ship Master Elec |
| 20:55:07.420 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 8.41 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:07.431 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 5.08 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:07.440 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.77 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:07.452 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 6.41 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:07.463 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.7 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:08.700 | find | GSCM.SSP.Plan.WSL | SSP0024_GET_SHIP_MASTER | 190 | 1230.38 | p_division_id=81, p_plant_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_material_id=, p_nick_name=, p_model_id= |
| 20:55:08.723 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 6.52 | p_menu_id=SSP0024, p_log_type=FIND, p_log_cnt=190, p_db_time=1.239, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 20:55:13.931 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.7 | MenuID=Shipment Master Electrode, CnntCode=0104002, UserID=jaeuk.shin |

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

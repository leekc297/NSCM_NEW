# AS-IS 실측 요약 — SSP0024

- 실행: 2026-11-15 03:14:52.598 ~ 2026-11-15 03:15:23.480 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Master Electrode (GSCM.SSP.Plan.UIL.SSP0024_ShipmentMasterElectrode)
- 조회 결과: Total : 190 · DB : 0.192s, UI : 0.062s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 03:15:07.083 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.94 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.092 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 4.33 | Code=PlantSiteByFactoryEEOperation, Param1=40,81,82,81_UC, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.092 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.49 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.104 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 5.1 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.120 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 327 | 7.63 | Code=BuildingForShipMasterElec, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.123 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.1 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.487 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0024 |
| 03:15:07.519 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.41 | USER_ID= |
| 03:15:07.681 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.93 | Code=PlantSiteByFactoryEEOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.752 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 31.57 | p_program_id=SSP0024, p_user_id=jaeuk.shin, p_sheet_name=Ship Master Elec |
| 03:15:07.767 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.02 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.775 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.41 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.786 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.2 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.793 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.23 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:07.797 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.74 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:08.007 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 120.69 | MenuID=Shipment Master Electrode, CnntCode=0104001, UserID=jaeuk.shin |
| 03:15:08.061 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0024 |
| 03:15:16.820 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 6.85 | p_program_id=SSP0024, p_user_id=jaeuk.shin, p_sheet_name=Ship Master Elec |
| 03:15:16.826 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.71 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:16.838 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 4.11 | Code=ElectrodePostOperCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:16.849 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.7 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:16.856 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.7 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:16.865 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.44 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 03:15:17.048 | find | GSCM.SSP.Plan.WSL | SSP0024_GET_SHIP_MASTER | 190 | 159.35 | p_division_id=81, p_plant_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_material_id=, p_nick_name=, p_model_id= |
| 03:15:17.137 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.44 | p_menu_id=SSP0024, p_log_type=FIND, p_log_cnt=190, p_db_time=0.192, p_ui_time=0.062, p_user_id=jaeuk.shin |

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

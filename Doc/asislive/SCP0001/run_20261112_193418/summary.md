# AS-IS 실측 요약 — SCP0001

- 실행: 2026-11-12 19:34:18.758 ~ 2026-11-12 19:34:34.886 · 계정 jaeuk.shin · 상태 OK
- 화면: Plant Site (GSCM.SCP.Master.UIL.SCP0001_PlantSite)
- 조회 결과: Total : 97 · DB : 0.05s, UI : 0.29s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:34:19.170 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 58.26 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.181 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 4.64 | Code=PlantSiteByDivision1Ex, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.207 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 22.87 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.262 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 38.01 | Code=LookupCommon, Param1=COUNTRY_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.291 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 25.67 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.318 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 23.79 | Code=LookupCommon, Param1=FP_PLAN_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.336 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 15.2 | Code=LookupCommon, Param1=DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.343 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 122 | 3.93 | Code=BuildingByPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.351 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 3.65 | Code=BuildingByPlant1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.388 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 22.06 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.466 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 74.41 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.527 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 6784 | 43.53 | Code=StorageID1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.576 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 3.94 | Code=Location, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:19.584 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 18 | 3.66 | Code=Location1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.791 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 305 | 202.9 | Code=OperationByBuilding1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.800 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 78 | 3.52 | Code=PlantByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.844 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 6784 | 41.64 | Code=StorageByDivPlant1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:19.918 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0001 |
| 19:34:19.941 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.27 | USER_ID= |
| 19:34:20.072 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 56.73 | Code=SiteByEndCustomer, Param1=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, Param2=ALL, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 19:34:20.122 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 4.46 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Plant Site |
| 19:34:20.130 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.33 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.141 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.8 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.173 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 65 | 28.53 | Code=LookupCommon, Param1=FROZEN_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.195 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.69 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Location |
| 19:34:20.203 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 3.44 | Code=Location, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.209 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 122 | 3.54 | Code=BuildingByPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.254 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 60 | 35.4 | Code=OperationByBuilding, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.261 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.53 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 30.38 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.330 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.52 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Customer |
| 19:34:20.347 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.53 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Location(OSP) |
| 19:34:20.357 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.85 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.389 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 28.85 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.418 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.91 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:20.520 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 77.03 | MenuID=Plant Site, CnntCode=0104001, UserID=jaeuk.shin |
| 19:34:20.568 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0001 |
| 19:34:28.523 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 3.98 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Plant Site |
| 19:34:28.534 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.33 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.545 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.84 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.556 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 65 | 5.22 | Code=LookupCommon, Param1=FROZEN_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.617 | find | GSCM.SCP.Master.WSL | SCP0001_GET_PLANT_SITE | 97 | 16.36 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_plant_id=, p_scm_site_id=, p_osp_yn=None, p_valid_yn=Y, p_new_yn=None |
| 19:34:28.793 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.22 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Location |
| 19:34:28.801 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.04 | Code=Location, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.810 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 122 | 4.33 | Code=BuildingByPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.849 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 60 | 35.19 | Code=OperationByBuilding, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.856 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.14 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.888 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 29.16 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:28.921 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.21 | p_menu_id=SCP0001, p_log_type=FIND, p_log_cnt=97, p_db_time=0.05, p_ui_time=0.29, p_user_id=jaeuk.shin |
| 19:34:34.105 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.87 | MenuID=Plant Site, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Valid | cboValid |  |
| Outsourcing | cboOutsourcing |  |
| Div | clbDivision |  |
| Plant/Vendor | txtPlantVendor |  |
| Plant Site | txtPlantSite |  |

## 그리드

- spdMain / Plant Site: 행 97 · 컬럼 31(보임 27) · 헤더 1단 · 고정 컬럼 0
- spdSub / Location: 행 0 · 컬럼 19(보임 14) · 헤더 1단 · 고정 컬럼 0
- spdSub / Customer: 행 0 · 컬럼 13(보임 12) · 헤더 1단 · 고정 컬럼 0
- spdSub / Location(OSP): 행 0 · 컬럼 13(보임 11) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

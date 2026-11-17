# AS-IS 실측 요약 — SCP0001

- 실행: 2026-11-12 18:03:53.975 ~ 2026-11-12 18:04:22.423 · 계정 jaeuk.shin · 상태 OK
- 화면: Plant Site (GSCM.SCP.Master.UIL.SCP0001_PlantSite)
- 조회 결과: Total : 97 · DB : 5.78s, UI : 0.36s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:03:54.725 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.17 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:54.742 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 6.09 | Code=PlantSiteByDivision1Ex, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:54.773 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 25.77 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:54.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.72 | Code=LookupCommon, Param1=COUNTRY_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:54.815 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.69 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:54.822 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.08 | Code=LookupCommon, Param1=FP_PLAN_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:55.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 252.79 | Code=LookupCommon, Param1=DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:55.086 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 122 | 3.79 | Code=BuildingByPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:55.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 4.05 | Code=BuildingByPlant1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:55.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 196.29 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:55.820 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 523.1 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:55.883 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 6784 | 43.9 | Code=StorageID1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:56.171 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 209.68 | Code=Location, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:56.179 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 18 | 3.79 | Code=Location1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:57.585 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 305 | 1401.29 | Code=OperationByBuilding1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:57.719 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 78 | 128.77 | Code=PlantByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:57.766 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 6784 | 42.79 | Code=StorageByDivPlant1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:03:58.261 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0001 |
| 18:03:58.291 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.22 | USER_ID= |
| 18:03:58.667 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 57.8 | Code=SiteByEndCustomer, Param1=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, Param2=ALL, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 18:03:59.058 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 174.22 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Plant Site |
| 18:03:59.073 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.28 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.093 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.76 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.195 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 65 | 97.68 | Code=LookupCommon, Param1=FROZEN_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.227 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.25 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Location |
| 18:03:59.235 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 3.49 | Code=Location, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.243 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 122 | 3.87 | Code=BuildingByPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.287 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 60 | 39.36 | Code=OperationByBuilding, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.77 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.330 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 30.23 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.369 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.22 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Customer |
| 18:03:59.386 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.63 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Location(OSP) |
| 18:03:59.394 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.46 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.426 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 29.2 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:59.464 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.22 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:01.257 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1693.8 | MenuID=Plant Site, CnntCode=0104001, UserID=jaeuk.shin |
| 18:04:01.642 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 197.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0001 |
| 18:04:10.287 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 4.07 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Plant Site |
| 18:04:10.296 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.4 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:10.318 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.22 | Code=PlantByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:10.327 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 65 | 4.66 | Code=LookupCommon, Param1=FROZEN_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:16.122 | find | GSCM.SCP.Master.WSL | SCP0001_GET_PLANT_SITE | 97 | 5740.51 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_plant_id=, p_scm_site_id=, p_osp_yn=None, p_valid_yn=Y, p_new_yn=None |
| 18:04:16.363 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.28 | p_program_id=SCP0001, p_user_id=jaeuk.shin, p_sheet_name=Location |
| 18:04:16.372 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.32 | Code=Location, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:16.381 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 122 | 3.92 | Code=BuildingByPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:16.421 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 60 | 35.73 | Code=OperationByBuilding, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:16.428 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.59 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:16.463 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4068 | 29.73 | Code=StorageID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:16.623 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 125.93 | p_menu_id=SCP0001, p_log_type=FIND, p_log_cnt=97, p_db_time=5.78, p_ui_time=0.36, p_user_id=jaeuk.shin |
| 18:04:21.763 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.82 | MenuID=Plant Site, CnntCode=0104002, UserID=jaeuk.shin |

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

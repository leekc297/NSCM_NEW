# AS-IS 실측 요약 — SCP0046

- 실행: 2026-11-12 20:05:13.963 ~ 2026-11-12 20:06:06.663 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Allocation (GSCM.SCP.Master.UIL.SCP0046_ModelAllocation)
- 조회 결과: Total : 1 · DB : 34.256s, UI : 0.113s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:05:14.248 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.69 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:05:14.256 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 3.98 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:05:14.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1665 | 50.05 | Code=LineByOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:05:14.324 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.23 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:05:14.377 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1665 | 49.87 | Code=LineByOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:05:14.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 4.57 | Code=PlantSiteByDivision1Ex, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:05:14.445 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0046 |
| 20:05:14.468 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.05 | USER_ID= |
| 20:05:14.680 | load | GSCM.SCM.Master.WSL | SCM0001_GET_WEEK_MONDAY_PERIOD | 1 | 7.03 | p_from_date=, p_offset_day=370, p_timezone=AS054 |
| 20:05:14.697 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 446 | 12.49 | p_start_yyyymmdd=20261109, p_end_yyyymmdd=20271114 |
| 20:05:14.963 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 258.96 | p_program_id=SCP0046, p_user_id=jaeuk.shin, p_sheet_name=Model Allocation |
| 20:05:14.976 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.56 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:05:15.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 93.37 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:05:16.549 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1361.82 | MenuID=Model Allocation, CnntCode=0104001, UserID=jaeuk.shin |
| 20:05:16.679 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0046 |
| 20:05:19.782 | load | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_INTRANSIT_INVENTORY | 0 | 69426.5 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:05:24.806 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 446 | 13.82 | p_start_yyyymmdd=20261109, p_end_yyyymmdd=20271114 |
| 20:05:24.817 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.67 | p_program_id=SCP0046, p_user_id=jaeuk.shin, p_sheet_name=Model Allocation |
| 20:05:24.826 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.37 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:05:24.904 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 74.97 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:05:49.744 | find | GSCM.SCM.Master.WSL | SCP0006_GET_PROJECT_ROUTE_SITE | 0 | 1800023.76 | p_division_id=81, p_scm_site_id=, p_project_code=, p_item_id=, p_from_yyyymm=202611, p_to_yyyymm=202710, p_status=None, debug_mode=F |
| 20:05:53.038 | find | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_PROJECT_ROUTE_ELEC | 0 | 102735.66 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:05:59.269 | find | GSCM.SCP.Master.WSL | SCP0046_GET_MODEL_ALLOCATION | 1 | 34161.6 | p_division_id=81, p_cell_plant_site_id=HQ07-A,HQ11-A,MI00-A,MI02-A,NA00-A,NB01-A,WA00-A, p_cell_item_id=, p_cell_line_id=A1A03,A1A04,A1A05,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A02,A4A03,A4A04,A4A05,A4A06 |
| 20:05:59.429 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 38.0 | p_menu_id=SCP0046, p_log_type=FIND, p_log_cnt=1, p_db_time=34.256, p_ui_time=0.113, p_user_id=jaeuk.shin |
| 20:06:05.174 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.34 | MenuID=Model Allocation, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| PKG Site | clbPKGSite |  |
| Material | txtCellItemId |  |
| layoutControlItem5 | btnItemId |  |
| Supply Site | clbSupplySite |  |
| PKG Line | clbPKGLine |  |
| Div* | clbDivision | Y |
| Period* | drpPeriod | Y |
| Supply Line | clbSupplyLine |  |

## 그리드

- spdMain / Model Allocation: 행 1 · 컬럼 457(보임 329) · 헤더 3단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

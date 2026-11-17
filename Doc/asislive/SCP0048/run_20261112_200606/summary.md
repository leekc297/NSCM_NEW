# AS-IS 실측 요약 — SCP0048

- 실행: 2026-11-12 20:06:06.843 ~ 2026-11-12 20:06:51.174 · 계정 jaeuk.shin · 상태 OK
- 화면: ProjectRoute (Warranty) (GSCM.SCP.Master.UIL.SCP0048_ProjectRoute_Warranty)
- 조회 결과: Total : 1,119 · DB : 24.8s, UI : 2.416s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:06:07.117 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.7 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:06:07.168 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0048 |
| 20:06:07.192 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.59 | USER_ID= |
| 20:06:07.322 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.74 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:07.330 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.05 | Code=PlantSiteByDivision, Param1=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:07.353 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 97 | 5.44 | Code=ElecRoutePlantByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:06:07.362 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.81 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:07.773 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 404.43 | p_program_id=SCP0048, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 20:06:08.745 | load | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_BOM | 0 | 118405.56 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:06:08.868 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1051.64 | MenuID=ProjectRoute (Warranty), CnntCode=0104001, UserID=jaeuk.shin |
| 20:06:08.881 | load | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_PROJECT_ROUTE | 0 | 118646.52 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:06:09.040 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0048 |
| 20:06:09.144 | load | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_LINE_ASSIGN | 0 | 118821.26 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:06:09.540 | load | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_BOD | 0 | 119304.85 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:06:17.108 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 4.23 | p_program_id=SCP0048, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 20:06:41.266 | find | GSCM.SCP.Master.WSL | SCP0048_GET_PROJECTROUTE_WARRANTY | 1119 | 24141.2 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_valid_flag=None, p_to_yyyymm=, p_from_yyyymm=, p_item_id=, p_operation_group=P,A,E, p_plant_site=None |
| 20:06:44.352 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.77 | p_menu_id=SCP0048, p_log_type=FIND, p_log_cnt=1119, p_db_time=24.8, p_ui_time=2.416, p_user_id=jaeuk.shin |
| 20:06:50.219 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.02 | MenuID=ProjectRoute (Warranty), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| layoutControlItem11 | btnItemId |  |
| Valid | cboValid |  |
| Operation Group | cboOperationGroup |  |
| Model | txtItemId |  |
| Div | clbDivision |  |

## 그리드

- spdMain / Main: 행 1119 · 컬럼 31(보임 14) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

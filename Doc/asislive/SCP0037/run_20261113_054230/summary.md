# AS-IS 실측 요약 — SCP0037

- 실행: 2026-11-13 05:42:30.908 ~ 2026-11-13 05:42:50.309 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation LT (GSCM.SCP.Master.UIL.SCP0037_OperationLT)
- 조회 결과: Total : 328 · DB : 3.885s, UI : 0.07s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:42:31.290 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.46 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:42:31.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.8 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:42:31.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 5.69 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:31.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.7 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:42:31.362 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.88 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:31.385 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 6.0 | Code=PlantByDivisionOperOsp21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:42:31.418 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 05:42:31.442 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.49 | USER_ID= |
| 05:42:31.541 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.89 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 05:42:31.550 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.16 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:31.559 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.87 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:31.699 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 115.59 | MenuID=Operation LT, CnntCode=0104001, UserID=jaeuk.shin |
| 05:42:31.788 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 05:42:39.953 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.14 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 05:42:39.965 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 7.59 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:39.974 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.21 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:43.845 | find | GSCM.SCP.Master.WSL | SCP0037_GET_OPERATION_LT | 328 | 3858.49 | p_division_id=81, p_scm_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_item_id=, p_scm_valid_yn=None, p_lt_operation=SLITTING |
| 05:42:43.952 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 10.04 | p_menu_id=SCP0037, p_log_type=FIND, p_log_cnt=328, p_db_time=3.885, p_ui_time=0.07, p_user_id=jaeuk.shin |
| 05:42:49.631 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.22 | MenuID=Operation LT, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Div | cboDivision |  |
| Site Item Valid | cboValid |  |
| Material | txtItemId |  |
| layoutControlItem5 | btnItemId |  |
| LT Operation | cboLTOperation |  |

## 그리드

- spdMain / Operation LT: 행 328 · 컬럼 14(보임 12) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

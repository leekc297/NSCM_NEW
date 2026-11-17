# AS-IS 실측 요약 — SCP0037

- 실행: 2026-11-13 00:18:35.126 ~ 2026-11-13 00:18:50.126 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation LT (GSCM.SCP.Master.UIL.SCP0037_OperationLT)
- 조회 결과: Total : 328 · DB : 0.173s, UI : 0.071s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:18:35.559 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.35 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:35.567 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.53 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:35.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.73 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:35.582 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.12 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:35.589 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.61 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:35.599 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.43 | Code=PlantByDivisionOperOsp21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:35.632 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 00:18:35.671 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.53 | USER_ID= |
| 00:18:35.851 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 47.7 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 00:18:35.861 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.69 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:35.870 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.11 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:36.100 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 194.0 | MenuID=Operation LT, CnntCode=0104001, UserID=jaeuk.shin |
| 00:18:36.149 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.6 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 00:18:43.968 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.5 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 00:18:43.978 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.78 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:43.985 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.3 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:44.142 | find | GSCM.SCP.Master.WSL | SCP0037_GET_OPERATION_LT | 328 | 143.83 | p_division_id=81, p_scm_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_item_id=, p_scm_valid_yn=None, p_lt_operation=SLITTING |
| 00:18:44.251 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 8.8 | p_menu_id=SCP0037, p_log_type=FIND, p_log_cnt=328, p_db_time=0.173, p_ui_time=0.071, p_user_id=jaeuk.shin |
| 00:18:49.255 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.96 | MenuID=Operation LT, CnntCode=0104002, UserID=jaeuk.shin |

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

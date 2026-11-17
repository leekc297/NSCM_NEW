# AS-IS 실측 요약 — SCP0037

- 실행: 2026-11-14 23:37:01.287 ~ 2026-11-14 23:37:22.981 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation LT (GSCM.SCP.Master.UIL.SCP0037_OperationLT)
- 조회 결과: Total : 328 · DB : 2.924s, UI : 0.077s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:37:01.862 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.64 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:37:01.875 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.49 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:37:01.886 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.72 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:37:01.896 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 3.9 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:37:01.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.63 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:37:01.911 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.62 | Code=PlantByDivisionOperOsp21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:37:02.235 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 23:37:02.263 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.45 | USER_ID= |
| 23:37:02.519 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 34.65 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 23:37:02.533 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.44 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:37:02.545 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.02 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:37:03.374 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 726.04 | MenuID=Operation LT, CnntCode=0104001, UserID=jaeuk.shin |
| 23:37:03.506 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 23:37:12.806 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.2 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 23:37:12.822 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.61 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:37:12.836 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.43 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:37:15.713 | find | GSCM.SCP.Master.WSL | SCP0037_GET_OPERATION_LT | 328 | 2853.27 | p_division_id=81, p_scm_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_item_id=, p_scm_valid_yn=None, p_lt_operation=SLITTING |
| 23:37:15.925 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 65.78 | p_menu_id=SCP0037, p_log_type=FIND, p_log_cnt=328, p_db_time=2.924, p_ui_time=0.077, p_user_id=jaeuk.shin |
| 23:37:22.268 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.55 | MenuID=Operation LT, CnntCode=0104002, UserID=jaeuk.shin |

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

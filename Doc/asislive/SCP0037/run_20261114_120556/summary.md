# AS-IS 실측 요약 — SCP0037

- 실행: 2026-11-14 12:05:56.308 ~ 2026-11-14 12:09:26.016 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation LT (GSCM.SCP.Master.UIL.SCP0037_OperationLT)
- 조회 결과: Total : 328 · DB : 0.076s, UI : 0.065s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 12:09:08.567 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.9 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:09:08.580 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.01 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:09:08.590 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.17 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:09:08.599 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 3.95 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:09:08.607 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.15 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:09:08.619 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.55 | Code=PlantByDivisionOperOsp21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:09:09.356 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 12:09:09.390 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.88 | USER_ID= |
| 12:09:09.801 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 23.19 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 12:09:09.821 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.66 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:09:09.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.16 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:09:10.168 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 101.88 | MenuID=Operation LT, CnntCode=0104001, UserID=jaeuk.shin |
| 12:09:10.273 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.57 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 12:09:19.555 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.54 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 12:09:19.566 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 6.22 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:09:19.574 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.46 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:09:19.631 | find | GSCM.SCP.Master.WSL | SCP0037_GET_OPERATION_LT | 328 | 37.01 | p_division_id=81, p_scm_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_item_id=, p_scm_valid_yn=None, p_lt_operation=SLITTING |
| 12:09:19.736 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.29 | p_menu_id=SCP0037, p_log_type=FIND, p_log_cnt=328, p_db_time=0.076, p_ui_time=0.065, p_user_id=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(30924)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

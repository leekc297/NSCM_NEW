# AS-IS 실측 요약 — SCP0033

- 실행: 2026-11-14 23:32:30.813 ~ 2026-11-14 23:33:34.410 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Semi Dept Day (GSCM.SCP.Master.UIL.SCP0033_Shipment_semi_dept_day)
- 조회 결과: Total : 54 · DB : 0.71s, UI : 0.076s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:32:31.364 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.28 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:32:55.945 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 24560.55 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:32:56.294 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 23:32:56.322 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.47 | USER_ID= |
| 23:33:14.826 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 18355.45 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 23:33:14.837 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.44 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:33:14.850 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.51 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:33:15.587 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 596.49 | MenuID=Shipment Semi Dept Day, CnntCode=0104001, UserID=jaeuk.shin |
| 23:33:15.869 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 23:33:24.986 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 3.71 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 23:33:24.991 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.1 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:33:25.002 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.1 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:33:25.707 | find | GSCM.SCP.Master.WSL | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | 54 | 606.55 | p_division_id=81,40,82,EE,81_UC,EE_UC,81_HM,EE_HM,81_ST,EE_ST,81_HD,EE_HD,81_HG,EE_HG, p_item_id=, p_valid= |
| 23:33:26.724 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 924.15 | p_menu_id=SCP0033, p_log_type=FIND, p_log_cnt=54, p_db_time=0.71, p_ui_time=0.076, p_user_id=jaeuk.shin |
| 23:33:33.099 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.68 | MenuID=Shipment Semi Dept Day, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Model | txtItemId |  |
| Valid | cboValidYN |  |

## 그리드

- spdMain / Shipment Semi Dept Day: 행 54 · 컬럼 12(보임 10) · 헤더 1단 · 고정 컬럼 0

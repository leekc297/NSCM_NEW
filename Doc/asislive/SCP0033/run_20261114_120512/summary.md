# AS-IS 실측 요약 — SCP0033

- 실행: 2026-11-14 12:05:12.877 ~ 2026-11-14 12:05:31.594 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Semi Dept Day (GSCM.SCP.Master.UIL.SCP0033_Shipment_semi_dept_day)
- 조회 결과: Total : 54 · DB : 0.122s, UI : 0.075s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 12:05:13.534 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.94 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:05:13.589 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 44.86 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:05:14.346 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 12:05:14.387 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.71 | USER_ID= |
| 12:05:14.747 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 31.63 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 12:05:14.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 19.56 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:05:14.796 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.57 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:05:15.135 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 111.45 | MenuID=Shipment Semi Dept Day, CnntCode=0104001, UserID=jaeuk.shin |
| 12:05:15.259 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 28.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 12:05:24.428 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 4.56 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 12:05:24.440 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.43 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:05:24.449 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.43 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:05:24.597 | find | GSCM.SCP.Master.WSL | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | 54 | 5.92 | p_division_id=81,40,82,EE,81_UC,EE_UC,81_HM,EE_HM,81_ST,EE_ST,81_HD,EE_HD,81_HG,EE_HG, p_item_id=, p_valid= |
| 12:05:24.687 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.18 | p_menu_id=SCP0033, p_log_type=FIND, p_log_cnt=54, p_db_time=0.122, p_ui_time=0.075, p_user_id=jaeuk.shin |
| 12:05:30.719 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.39 | MenuID=Shipment Semi Dept Day, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Model | txtItemId |  |
| Valid | cboValidYN |  |

## 그리드

- spdMain / Shipment Semi Dept Day: 행 54 · 컬럼 12(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(30924)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

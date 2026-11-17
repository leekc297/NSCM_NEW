# AS-IS 실측 요약 — SCP0033

- 실행: 2026-11-13 05:42:14.215 ~ 2026-11-13 05:42:30.664 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Semi Dept Day (GSCM.SCP.Master.UIL.SCP0033_Shipment_semi_dept_day)
- 조회 결과: Total : 54 · DB : 1.26s, UI : 0.12s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:42:14.628 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.21 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:42:14.640 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 7.65 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:14.670 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 05:42:14.695 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.98 | USER_ID= |
| 05:42:14.762 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 4.96 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 05:42:14.771 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.97 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:14.780 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.7 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:14.913 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 114.03 | MenuID=Shipment Semi Dept Day, CnntCode=0104001, UserID=jaeuk.shin |
| 05:42:14.969 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 05:42:23.070 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 4.43 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 05:42:23.081 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.41 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:23.089 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 5.1 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:24.351 | find | GSCM.SCP.Master.WSL | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | 54 | 1154.35 | p_division_id=81,40,82,EE,81_UC,EE_UC,81_HM,EE_HM,81_ST,EE_ST,81_HD,EE_HD,81_HG,EE_HG, p_item_id=, p_valid= |
| 05:42:24.505 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 10.15 | p_menu_id=SCP0033, p_log_type=FIND, p_log_cnt=54, p_db_time=1.26, p_ui_time=0.12, p_user_id=jaeuk.shin |
| 05:42:29.959 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.57 | MenuID=Shipment Semi Dept Day, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Model | txtItemId |  |
| Valid | cboValidYN |  |

## 그리드

- spdMain / Shipment Semi Dept Day: 행 54 · 컬럼 12(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

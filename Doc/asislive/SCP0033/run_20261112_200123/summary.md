# AS-IS 실측 요약 — SCP0033

- 실행: 2026-11-12 20:01:23.717 ~ 2026-11-12 20:02:08.491 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Semi Dept Day (GSCM.SCP.Master.UIL.SCP0033_Shipment_semi_dept_day)
- 조회 결과: Total : 54 · DB : 22.114s, UI : 0.099s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:01:24.084 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.04 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:01:24.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.24 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:01:24.396 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 20:01:24.422 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.53 | USER_ID= |
| 20:01:24.771 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 211.08 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 20:01:24.785 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.46 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:01:24.794 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.53 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:01:29.026 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4134.74 | MenuID=Shipment Semi Dept Day, CnntCode=0104001, UserID=jaeuk.shin |
| 20:01:29.137 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0033 |
| 20:01:36.980 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 4.74 | p_program_id=SCP0033, p_user_id=jaeuk.shin, p_sheet_name=Shipment Semi Dept Day |
| 20:01:36.987 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.26 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:01:36.994 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.4 | Code=LookupCommon, Param1=DEPARTURE_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:01:59.107 | find | GSCM.SCP.Master.WSL | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | 54 | 22010.5 | p_division_id=81,40,82,EE,81_UC,EE_UC,81_HM,EE_HM,81_ST,EE_ST,81_HD,EE_HD,81_HG,EE_HG, p_item_id=, p_valid= |
| 20:01:59.619 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 400.15 | p_menu_id=SCP0033, p_log_type=FIND, p_log_cnt=54, p_db_time=22.114, p_ui_time=0.099, p_user_id=jaeuk.shin |
| 20:02:01.929 | find | GSCM.SCP.Master.WSL | SCP0020_GET_TACT_TIME_OSP | 855 | 459604.72 | p_division_id=82, p_plant_site_id=, p_line_id=, p_operation_group_id=P, p_item_id=, debug_mode=F |
| 20:02:07.345 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.49 | MenuID=Shipment Semi Dept Day, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| Model | txtItemId |  |
| Valid | cboValidYN |  |

## 그리드

- spdMain / Shipment Semi Dept Day: 행 54 · 컬럼 12(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

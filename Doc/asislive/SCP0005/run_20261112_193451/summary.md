# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-12 19:34:51.241 ~ 2026-11-12 19:35:20.180 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,036 · DB : 0.773s, UI : 13.622s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:34:51.663 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 43.26 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:51.673 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.4 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:51.684 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.31 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:51.720 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 19:34:51.744 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.65 | USER_ID= |
| 19:34:51.825 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 4.92 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 19:34:51.853 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 22.89 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:51.861 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.57 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:51.982 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.74 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 19:34:52.027 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.81 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 19:34:59.730 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 4.73 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 19:34:59.737 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.43 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:59.751 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.49 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:35:00.257 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8036 | 357.84 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 19:35:00.629 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 706.23 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 19:35:14.184 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.52 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8036, p_db_time=0.773, p_ui_time=13.622, p_user_id=jaeuk.shin |
| 19:35:19.272 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.73 | MenuID=Distribution Route, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem6 | btnToSrch |  |
| layoutControlItem7 | btnFromSrch |  |
| Valid | cboValidYN |  |
| Trans Mode | clbTransMode |  |
| From Country | txtFromCountry |  |
| From City | txtFromCity |  |
| To Country | txtToCountry |  |
| To City | txtToCity |  |
| layoutControlItem9 | btnEaxel_Upload |  |
| layoutControlItem10 | btnExcel_Form |  |

## 그리드

- spdMain / Distribution Route: 행 8036 · 컬럼 40(보임 39) · 헤더 2단 · 고정 컬럼 2

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

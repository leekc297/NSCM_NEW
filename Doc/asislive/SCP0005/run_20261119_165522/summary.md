# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-19 16:55:22.832 ~ 2026-11-19 16:56:38.645 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:55:39.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 46.94 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:39.076 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 5.29 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:39.091 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.15 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:39.695 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 16:55:39.728 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.38 | USER_ID= |
| 16:55:39.980 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 25.33 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 16:55:40.039 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 45.24 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:40.071 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.45 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:40.345 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.29 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 16:55:40.474 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 27.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 16:55:48.071 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 6.18 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 16:55:48.083 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.34 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:48.095 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.43 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:55:48.709 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8036 | 499.49 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 16:55:48.862 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 634.95 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 16:56:36.994 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.51 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8036, p_db_time=1.033, p_ui_time=47.778, p_user_id=jaeuk.shin |

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

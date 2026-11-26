# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-26 00:53:54.665 ~ 2026-11-26 00:54:50.920 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,076 · DB : 1.043s, UI : 16.537s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:54:16.483 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 78.83 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:16.491 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.86 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:16.680 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 180.47 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:17.268 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 26.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 00:54:17.351 | load | GSCM.BizService.WSL | SELECT * | 874 | 72.73 | USER_ID= |
| 00:54:17.701 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 125.71 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 00:54:17.766 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 53.41 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:17.776 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.01 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:18.305 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 349.45 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 00:54:18.780 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 225.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 00:54:26.088 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 6.05 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 00:54:26.098 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.52 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:26.105 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.54 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:54:26.844 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8076 | 586.22 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 00:54:26.897 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 631.59 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 00:54:44.121 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 388.09 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8076, p_db_time=1.043, p_ui_time=16.537, p_user_id=jaeuk.shin |

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

- spdMain / Distribution Route: 행 8076 · 컬럼 40(보임 39) · 헤더 2단 · 고정 컬럼 2

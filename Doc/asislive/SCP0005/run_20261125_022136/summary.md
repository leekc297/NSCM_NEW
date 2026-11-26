# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-25 02:21:36.118 ~ 2026-11-25 02:22:30.837 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,036 · DB : 0.969s, UI : 14.904s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 02:21:57.896 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.15 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:21:57.903 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.04 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:21:57.913 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.52 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:21:58.477 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 02:21:58.510 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.13 | USER_ID= |
| 02:21:58.856 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 159.65 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 02:21:58.928 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 63.44 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:21:58.940 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.39 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:21:59.613 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 538.45 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 02:21:59.856 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 69.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 02:22:07.260 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 7.19 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 02:22:07.269 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.36 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:22:07.276 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.02 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:22:07.942 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8036 | 527.26 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 02:22:08.066 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 635.3 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 02:22:23.899 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 705.58 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8036, p_db_time=0.969, p_ui_time=14.904, p_user_id=jaeuk.shin |

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

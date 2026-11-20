# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-20 07:27:08.960 ~ 2026-11-20 07:27:55.640 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,036 · DB : 1.05s, UI : 14.91s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 07:27:24.531 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.65 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:24.543 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.4 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:24.558 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.39 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:25.279 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.44 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 07:27:25.310 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.82 | USER_ID= |
| 07:27:25.506 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 5.68 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 07:27:25.524 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.1 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:25.535 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.39 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:25.692 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.68 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 07:27:25.765 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 07:27:33.787 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 5.76 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 07:27:33.798 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.43 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:33.808 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.41 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:27:34.495 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8036 | 522.95 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 07:27:34.621 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 631.8 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 07:27:49.840 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.4 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8036, p_db_time=1.05, p_ui_time=14.91, p_user_id=jaeuk.shin |

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

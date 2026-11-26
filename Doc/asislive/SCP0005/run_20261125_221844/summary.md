# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-25 22:18:44.592 ~ 2026-11-25 22:19:48.833 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,076 · DB : 1.299s, UI : 21.781s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:19:07.169 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.64 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:07.181 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.85 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:07.465 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 273.05 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:08.219 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 45.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 22:19:08.356 | load | GSCM.BizService.WSL | SELECT * | 874 | 124.92 | USER_ID= |
| 22:19:08.959 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 323.66 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 22:19:09.060 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 88.8 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:09.072 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.28 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:09.775 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 477.64 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 22:19:10.351 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 415.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 22:19:18.087 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 6.87 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 22:19:18.099 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.64 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:18.108 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.4 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:19:18.914 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 621.81 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 22:19:18.927 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8076 | 649.66 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 22:19:41.390 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 146.49 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8076, p_db_time=1.299, p_ui_time=21.781, p_user_id=jaeuk.shin |

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

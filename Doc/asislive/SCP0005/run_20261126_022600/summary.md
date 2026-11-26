# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-26 02:26:00.287 ~ 2026-11-26 02:26:53.981 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,076 · DB : 1.203s, UI : 14.88s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 02:26:20.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 92.37 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:20.782 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.27 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:20.916 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 126.85 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:21.491 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 57.48 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 02:26:21.710 | load | GSCM.BizService.WSL | SELECT * | 874 | 205.93 | USER_ID= |
| 02:26:22.065 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 159.2 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 02:26:22.187 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 110.73 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:22.201 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 6.22 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:22.727 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 357.17 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 02:26:22.870 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 55.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 02:26:30.326 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 5.94 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 02:26:30.336 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.35 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:30.347 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.8 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:26:31.000 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 495.46 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 02:26:31.208 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8076 | 717.72 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 02:26:47.107 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 628.24 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8076, p_db_time=1.203, p_ui_time=14.88, p_user_id=jaeuk.shin |

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

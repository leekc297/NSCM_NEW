# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-25 07:30:24.668 ~ 2026-11-25 07:31:15.485 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,036 · DB : 1.038s, UI : 12.846s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 07:30:43.816 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.59 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:43.825 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.07 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:44.004 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 171.7 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:44.661 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 116.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 07:30:44.818 | load | GSCM.BizService.WSL | SELECT * | 874 | 146.96 | USER_ID= |
| 07:30:45.128 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 95.69 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 07:30:45.231 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 91.19 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:45.241 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.74 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:45.741 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 329.23 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 07:30:46.702 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 868.31 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 07:30:54.421 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 6.76 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 07:30:54.431 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.66 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:54.438 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.19 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:30:55.143 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8036 | 506.99 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 07:30:55.239 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 634.56 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 07:31:08.451 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 82.61 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8036, p_db_time=1.038, p_ui_time=12.846, p_user_id=jaeuk.shin |

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

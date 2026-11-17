# AS-IS 실측 요약 — SCP0005

- 실행: 2026-11-14 07:23:44.647 ~ 2026-11-14 07:24:35.030 · 계정 jaeuk.shin · 상태 OK
- 화면: Distribution Route (GSCM.SCP.Master.UIL.SCP0005_DistributionRoute)
- 조회 결과: Total : 8,036 · DB : 0.922s, UI : 15.155s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 07:24:01.894 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.78 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:01.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.65 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:01.926 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.63 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:03.004 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.61 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 07:24:03.035 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.14 | USER_ID= |
| 07:24:03.439 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 6.12 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 07:24:03.455 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.49 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:03.478 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.4 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:03.825 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 52.41 | MenuID=Distribution Route, CnntCode=0104001, UserID=jaeuk.shin |
| 07:24:03.976 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 24.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0005 |
| 07:24:12.651 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 5.97 | p_program_id=SCP0005, p_user_id=jaeuk.shin, p_sheet_name=Distribution Route |
| 07:24:12.660 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.43 | Code=LookupCommon, Param1=LT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:12.676 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.31 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:24:13.373 | find | GSCM.SCP.Master.WSL | SCP0005_GET_DISTRIBUTION_ROUTE | 8036 | 502.28 | p_from_country=, p_from_city=, p_to_country=, p_to_city=, p_transport_mode=, p_valid_yn= |
| 07:24:13.521 | find | GSCM.SCP.Master.WSL | SCP0005_GET_COUNTRY_CITY | 89426 | 636.41 | p_country=, p_city=, p_city_name=, debug_mode=F |
| 07:24:28.841 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.35 | p_menu_id=SCP0005, p_log_type=FIND, p_log_cnt=8036, p_db_time=0.922, p_ui_time=15.155, p_user_id=jaeuk.shin |

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

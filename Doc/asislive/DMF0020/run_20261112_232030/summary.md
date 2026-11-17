# AS-IS 실측 요약 — DMF0020

- 실행: 2026-11-12 23:20:30.622 ~ 2026-11-12 23:21:27.089 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Price (GSCM.DM.Master.UIL.DMF0020_SalesFuturePrice)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:20:31.593 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0020 |
| 23:20:31.621 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.06 | USER_ID= |
| 23:20:31.950 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.61 | p_created_by=jaeuk.shin, p_month=6 |
| 23:20:32.624 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 662.92 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 23:20:32.785 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 12.24 | Code=UpperDeptId, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.326 | load | GSCM.DM.Master.WSL | DMF0020_GET_MEASURE_COUNTINFO | 4 | 36.68 |  |
| 23:20:33.381 | load | GSCM.DM.Master.WSL | DMF0020_GET_FUTUREPRICE_INFO | 1872 | 49.39 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270401 |
| 23:20:33.417 | load | GSCM.DM.Master.WSL | DMF0020_GET_WEEKDATA | 7 | 18.13 | p_yyyymmdd=20261112 |
| 23:20:33.457 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 35.84 |  |
| 23:20:33.589 | load | GSCM.DM.Master.WSL | DMF0020_GET_SPREAD_TITLE | 51 | 98.34 | p_start_dt=20261101, p_end_dt=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 23:20:33.604 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.64 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.649 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.35 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.769 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 108.59 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.851 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 72.06 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.874 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.53 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.883 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.42 | Code=FCST_TYPE_NOT_FREE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.891 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.16 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.899 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.48 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:33.907 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 3.6 | Code=Measure, Param1=DMF0020, Param2=Sales Price, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:20:34.101 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.37 | MenuID=Sales Price, CnntCode=0104001, UserID=jaeuk.shin |
| 23:20:34.217 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0020 |
| 23:21:19.470 | find | GSCM.DM.Master.WSL | DMF0020_GET_SCM_MST_FUTURE_PRICE | 8260 | 33957.31 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_plant_site_id=ALL, p_project_code=, p_item_id=, p_customer_project_code=, p_customer_model=, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_biztype=ALL, p_created_by=jaeuk.shin, p_userinfo=ADMIN, p_owner=, p_over_range=N, |
| 23:21:20.382 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 51.98 | p_menu_id=DMF0020, p_log_type=FIND, p_log_cnt=, p_db_time=34.696, p_ui_time=0.121, p_user_id=jaeuk.shin |
| 23:21:20.537 | find | GSCM.DM.Master.WSL | DMF0020_GET_FUTUREPRICE_INFO | 1872 | 150.29 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270401 |
| 23:21:26.393 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.61 | MenuID=Sales Price, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbEndCustomer |  |
| Period | drpDateTime |  |
| Sales Site | clbSalesSite |  |
| layoutControlItem1 | btnItemId |  |
| Model / Nickname | umltModel |  |
| Project | umltProject |  |
| layoutControlItem3 | usrButton1 |  |
| Plant Site | clbPlantSite |  |
| Biz.Type | clbBizType |  |
| Exchange Rate | btnExchangeRate |  |
| Batch Job | btnBatch |  |
| Div | clbDivisions |  |
| layoutControlItem2 | btnOwner |  |
| Owner | txtOwner |  |
| layoutControlItem8 | btnColumn |  |
| Bucket | cboBucketType |  |
| layoutControlItem9 | usrDiscard |  |
| layoutControlItem10 | checkInvalidExec |  |
| Price일괄입력 | btnSavePricePeriod |  |
| Version | txtVersion |  |
| layoutControlItem7 | btnSPVer |  |
| Upload | btnExcelUpload |  |
| Excel Form | btnTemplate |  |

## 그리드

- spdMain / Sales Price: 행 8260 · 컬럼 53(보임 45) · 헤더 3단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

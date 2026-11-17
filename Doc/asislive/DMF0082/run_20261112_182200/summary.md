# AS-IS 실측 요약 — DMF0082

- 실행: 2026-11-12 18:22:00.617 ~ 2026-11-12 18:22:51.251 · 계정 jaeuk.shin · 상태 OK
- 화면: Fcst&Price MGMT (GSCM.DM.Plan.UIL.DMF0082_FcstNPrice_Mgmt)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:22:01.024 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0082 |
| 18:22:01.047 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.22 | USER_ID= |
| 18:22:01.326 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.26 | p_created_by=jaeuk.shin, p_month=6 |
| 18:22:01.441 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 5.16 |  |
| 18:22:01.510 | load | GSCM.DM.Master.WSL | DMF0082_POPUP_GET_FUTUREPRICE_INFO | 1872 | 43.19 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270401 |
| 18:22:01.679 | load | GSCM.DM.Master.WSL | DMF0082_GET_SPREAD_TITLE | 234 | 146.88 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 18:22:01.727 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 39.42 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:01.846 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 111.0 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:01.928 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 73.66 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:01.953 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.59 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:01.960 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 3.31 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:01.968 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.35 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:09.929 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 7955.06 | Code=CELL_PROD_SITE_ID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:09.936 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.5 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:09.970 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 27.8 | Code=Measure, Param1=DMF0082, Param2=FcstNPrice, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:10.212 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.18 | MenuID=Fcst&Price MGMT, CnntCode=0104001, UserID=jaeuk.shin |
| 18:22:10.288 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0082 |
| 18:22:19.448 | find | GSCM.DM.Master.WSL | DMF0082_GET_SPREAD_TITLE | 234 | 14.11 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 18:22:19.514 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 41.88 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:19.625 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 106.8 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:19.712 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 77.44 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:19.735 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.8 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:19.744 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 4.54 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:19.753 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.57 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:20.538 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 780.31 | Code=CELL_PROD_SITE_ID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:20.545 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.06 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:22:20.557 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 4.13 | Code=Measure, Param1=DMF0082, Param2=FcstNPrice, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz Type | clbBizType |  |
| Sales Site | clbSalesSite |  |
| Bucket | cboBucketType |  |
| Div | clbDivision |  |
| Period | drpPeriod |  |
| Version | txtVersion |  |
| Model / Nickname | txtItemId |  |
| layoutControlItem1 | btnItemId |  |
| Price일괄입력 | btnSavePricePeriod |  |
| layoutControlItem7 | btnVersion |  |
| layoutControlItem5 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Exchange Rate | btnExchangeRate |  |
| layoutControlItem2 | cboQty |  |
| layoutControlItem3 | chkSum |  |

## 그리드

- spdMain / FcstNPrice: 행 0 · 컬럼 235(보임 47) · 헤더 3단 · 고정 컬럼 18

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

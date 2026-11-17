# AS-IS 실측 요약 — DMF0020

- 실행: 2026-11-12 21:35:09.101 ~ 2026-11-12 21:35:55.386 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Price (GSCM.DM.Master.UIL.DMF0020_SalesFuturePrice)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:35:09.805 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0020 |
| 21:35:09.833 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.34 | USER_ID= |
| 21:35:10.165 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 108.93 | p_created_by=jaeuk.shin, p_month=6 |
| 21:35:10.868 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 690.14 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 21:35:10.952 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 11.41 | Code=UpperDeptId, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.234 | load | GSCM.DM.Master.WSL | DMF0020_GET_MEASURE_COUNTINFO | 4 | 25.09 |  |
| 21:35:11.339 | load | GSCM.DM.Master.WSL | DMF0020_GET_FUTUREPRICE_INFO | 1872 | 101.69 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270401 |
| 21:35:11.379 | load | GSCM.DM.Master.WSL | DMF0020_GET_WEEKDATA | 7 | 25.14 | p_yyyymmdd=20261112 |
| 21:35:11.386 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 3.15 |  |
| 21:35:11.541 | load | GSCM.DM.Master.WSL | DMF0020_GET_SPREAD_TITLE | 51 | 139.98 | p_start_dt=20261101, p_end_dt=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 21:35:11.554 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.4 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.598 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.37 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.716 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 109.45 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.802 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 78.16 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.824 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.79 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.831 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.24 | Code=FCST_TYPE_NOT_FREE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.841 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 6.82 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 19.93 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:11.874 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 4.42 | Code=Measure, Param1=DMF0020, Param2=Sales Price, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:35:12.071 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 81.32 | MenuID=Sales Price, CnntCode=0104001, UserID=jaeuk.shin |
| 21:35:12.169 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0020 |

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

- spdMain / Sales Price: 행 0 · 컬럼 52(보임 45) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

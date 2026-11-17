# AS-IS 실측 요약 — DMF0020

- 실행: 2026-11-12 18:09:05.189 ~ 2026-11-12 18:09:48.469 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Price (GSCM.DM.Master.UIL.DMF0020_SalesFuturePrice)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:09:05.629 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0020 |
| 18:09:05.654 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.01 | USER_ID= |
| 18:09:05.934 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 9.81 | p_created_by=jaeuk.shin, p_month=6 |
| 18:09:05.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 12.64 | Code=UpperDeptId, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:06.284 | load | GSCM.DM.Master.WSL | DMF0020_GET_MEASURE_COUNTINFO | 4 | 4.66 |  |
| 18:09:06.834 | load | GSCM.DM.Master.WSL | DMF0020_GET_FUTUREPRICE_INFO | 1872 | 544.11 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270401 |
| 18:09:06.881 | load | GSCM.DM.Master.WSL | DMF0020_GET_WEEKDATA | 7 | 32.22 | p_yyyymmdd=20261112 |
| 18:09:06.887 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 2.88 |  |
| 18:09:07.443 | load | GSCM.DM.Master.WSL | DMF0020_GET_SPREAD_TITLE | 51 | 538.94 | p_start_dt=20261101, p_end_dt=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 18:09:07.459 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 6.98 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.503 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.27 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.612 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 103.72 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.691 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 69.35 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.718 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.56 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.727 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.64 | Code=FCST_TYPE_NOT_FREE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.736 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.3 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.744 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.13 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:07.752 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 3.57 | Code=Measure, Param1=DMF0020, Param2=Sales Price, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:09:08.144 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 295.99 | MenuID=Sales Price, CnntCode=0104001, UserID=jaeuk.shin |
| 18:09:08.259 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0020 |

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

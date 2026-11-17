# AS-IS 실측 요약 — DMF0048

- 실행: 2026-11-12 18:16:35.568 ~ 2026-11-12 18:17:17.020 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Monitoring (GSCM.DM.Plan.UIL.DMF0048_SalesMonitoring)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:16:35.950 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0048 |
| 18:16:35.977 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.28 | USER_ID= |
| 18:16:36.396 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 3.3 |  |
| 18:16:36.423 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 9.56 | p_created_by=jaeuk.shin, p_month=6 |
| 18:16:36.431 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.57 | p_lookup_type=ITEM_TYPE_CODE |
| 18:16:36.445 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 19 | 5.31 | Code=SALES_PLAN_ITEM_ID, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.454 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.31 | Code=CURRENCY_LIST, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.710 | load | GSCM.DM.Master.WSL | DMF0048_GET_SPREAD_TITLE | 230 | 246.4 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=DAILY |
| 18:16:36.722 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.44 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.819 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 93.75 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2519 | 81.08 | Code=SiteByEndCustomer_InnerCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.932 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.69 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.940 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.71 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.949 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.47 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:36.957 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.53 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:37.011 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 41 | 49.49 | Code=Measure, Param1=DMF0048, Param2=Sales Monitoring, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:37.363 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 228.05 | MenuID=Sales Monitoring, CnntCode=0104001, UserID=jaeuk.shin |
| 18:16:37.445 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0048 |
| 18:16:46.010 | find | GSCM.DM.Master.WSL | DMF0048_GET_SPREAD_TITLE | 49 | 8.92 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 18:16:46.020 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.112 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 89.48 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.188 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2519 | 64.27 | Code=SiteByEndCustomer_InnerCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.203 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.57 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.220 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.34 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.223 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.42 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.235 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 4.17 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:46.245 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 41 | 3.96 | Code=Measure, Param1=DMF0048, Param2=Sales Monitoring, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz.Type | clbBizType |  |
| Sales Site | clbSalesSite |  |
| Project | txtProject |  |
| layoutControlItem3 | btnProject |  |
| item0 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Plant Site | clbPlantSite |  |
| layoutControlItem5 | chkSum |  |
| layoutControlItem2 | btnItemId |  |
| Bucket | cboBucketType |  |
| Period | drpPeriod |  |
| Item Type | clbItemType |  |
| Div | clbDivision |  |
| Model / Nickname | txtItemId |  |
| Owner | txtOwner |  |
| layoutControlItem6 | btnOwner |  |
| layoutControlItem8 | InternalYN |  |
| . | cboCellQty |  |
| layoutControlItem7 | chkColor |  |

## 그리드

- spdMain / Sales Monitoring: 행 0 · 컬럼 50(보임 19) · 헤더 3단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

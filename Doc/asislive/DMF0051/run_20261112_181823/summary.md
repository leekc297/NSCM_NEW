# AS-IS 실측 요약 — DMF0051

- 실행: 2026-11-12 18:18:23.968 ~ 2026-11-12 18:18:45.201 · 계정 jaeuk.shin · 상태 OK
- 화면: Biz Plan Waterfall (GSCM.DM.Plan.UIL.DMF0051_BizPlanWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:18:24.446 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0051 |
| 18:18:24.472 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.28 | USER_ID= |
| 18:18:24.627 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.28 | p_created_by=jaeuk.shin, p_month=6 |
| 18:18:24.663 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.56 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:24.984 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 3.28 | p_lookup_type=BUCKET2_TYPE_CODE |
| 18:18:25.008 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 4.0 | p_lookup_type=ITEM_TYPE_CODE |
| 18:18:25.018 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.39 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:25.047 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.23 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:25.065 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.19 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:25.086 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 2.93 |  |
| 18:18:25.197 | load | GSCM.DM.Master.WSL | DMF0051_GET_SPREAD_TITLE | 23 | 91.31 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 18:18:25.243 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.14 | Code=DeptId, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:25.361 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 110.44 | Code=EndCustomerByDivision40, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:25.555 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1138 | 181.12 | Code=SiteByEndCustomer, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:25.569 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.67 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_INCOTERMS, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:18:25.578 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.2 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:18:25.591 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 5.38 | Code=DMF0051_BP_Measure, Param1=40, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 18:18:25.719 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 92.21 | MenuID=Biz Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 18:18:25.841 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0051 |
| 18:18:44.513 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.45 | MenuID=Biz Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz.Type | clbBizType |  |
| Sales Site | clbSalesSite |  |
| Model / Nickname | txtItemId |  |
| layoutControlItem3 | btnProject |  |
| layoutControlItem1 | btnItemId |  |
| layoutControlItem2 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Period* | drpPeriod | Y |
| Project | txtProject |  |
| Plant Site | clbPlantSite |  |
| Version* | txtVersion | Y |
| layoutControlItem6 | btnVersion |  |
| KRW | cboKRW |  |
| USD | cboUSD |  |
| LOC | cboLOC |  |
| layoutControlItem5 | chkSum |  |
| Item Type | clbItemType |  |
| Bucket | cboBucketType |  |
| layoutControlItem7 | chkMem |  |
| Div | clbDivision |  |
| Owner | txtOwner |  |
| layoutControlItem8 | usrButton1 |  |
| QTY | cboQTY |  |
| layoutControlItem7 | cbxQty |  |
| . | cboCellQty |  |

## 그리드

- spdMain / Biz Plan Waterfall: 행 0 · 컬럼 24(보임 18) · 헤더 3단 · 고정 컬럼 13

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:18:35.481 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

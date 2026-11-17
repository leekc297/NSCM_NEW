# AS-IS 실측 요약 — DMF0051

- 실행: 2026-11-12 21:41:23.292 ~ 2026-11-12 21:41:48.927 · 계정 jaeuk.shin · 상태 OK
- 화면: Biz Plan Waterfall (GSCM.DM.Plan.UIL.DMF0051_BizPlanWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:41:23.634 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0051 |
| 21:41:23.659 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.12 | USER_ID= |
| 21:41:23.829 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.26 | p_created_by=jaeuk.shin, p_month=6 |
| 21:41:23.856 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.51 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.138 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 3.62 | p_lookup_type=BUCKET2_TYPE_CODE |
| 21:41:24.159 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.2 | p_lookup_type=ITEM_TYPE_CODE |
| 21:41:24.171 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.45 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.189 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.89 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.207 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.69 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.225 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 4.28 |  |
| 21:41:24.309 | load | GSCM.DM.Master.WSL | DMF0051_GET_SPREAD_TITLE | 23 | 65.57 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 21:41:24.355 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 39.78 | Code=DeptId, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.475 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 114.58 | Code=EndCustomerByDivision40, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.602 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1138 | 117.22 | Code=SiteByEndCustomer, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:41:24.633 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 21.23 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_INCOTERMS, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 21:41:24.640 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.29 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 21:41:24.648 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.72 | Code=DMF0051_BP_Measure, Param1=40, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 21:41:24.702 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 20.95 | MenuID=Biz Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 21:41:24.796 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0051 |
| 21:41:48.246 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.3 | MenuID=Biz Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 21:41:35.482 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

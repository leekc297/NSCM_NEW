# AS-IS 실측 요약 — DMF0022

- 실행: 2026-11-12 21:36:11.557 ~ 2026-11-12 21:37:05.884 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Plan Waterfall (GSCM.DM.Plan.UIL.DMF0022_SalesPlanWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:36:12.379 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 21:36:12.409 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.51 | USER_ID= |
| 21:36:12.695 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.63 | p_created_by=jaeuk.shin, p_month=6 |
| 21:36:13.401 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 689.43 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 21:36:13.852 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 59.23 |  |
| 21:36:13.882 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.48 | p_lookup_type=ITEM_TYPE_CODE |
| 21:36:13.921 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 32.5 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:13.938 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.31 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:13.958 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.35 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.054 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 81.78 |  |
| 21:36:14.181 | load | GSCM.DM.Master.WSL | DMF0022_GET_SPREAD_TITLE | 231 | 99.96 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=DAILY |
| 21:36:14.200 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.61 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.246 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.46 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.356 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 104.21 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.371 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.74 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.378 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.67 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.388 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.59 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 59.09 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.543 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 48 | 86.94 | Code=Measure, Param1=DMF0022, Param2=Sales Plan Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:36:14.911 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 173.87 | MenuID=Sales Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 21:36:15.052 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.61 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 21:37:05.132 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.33 | MenuID=Sales Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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
| layoutControlItem7 | InternalYN |  |
| . | cboCellQty |  |

## 그리드

- spdMain / Sales Plan Waterfall: 행 0 · 컬럼 232(보임 20) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 21:36:25.703 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

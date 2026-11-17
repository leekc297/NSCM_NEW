# AS-IS 실측 요약 — DMF0022

- 실행: 2026-11-12 18:11:19.510 ~ 2026-11-12 18:12:12.884 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Plan Waterfall (GSCM.DM.Plan.UIL.DMF0022_SalesPlanWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:11:20.193 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 18:11:20.220 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.97 | USER_ID= |
| 18:11:20.512 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.45 | p_created_by=jaeuk.shin, p_month=6 |
| 18:11:21.408 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 884.51 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:11:21.780 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 49.93 |  |
| 18:11:21.835 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.11 | p_lookup_type=ITEM_TYPE_CODE |
| 18:11:21.846 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.56 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:21.876 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.13 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:21.902 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.5 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:21.964 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 42.13 |  |
| 18:11:22.792 | load | GSCM.DM.Master.WSL | DMF0022_GET_SPREAD_TITLE | 231 | 798.27 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=DAILY |
| 18:11:22.810 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.05 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:22.854 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.26 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:22.967 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 107.02 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:22.980 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.65 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:22.987 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.96 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:22.994 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.54 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:23.055 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 58.01 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:23.119 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 48 | 59.46 | Code=Measure, Param1=DMF0022, Param2=Sales Plan Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:11:24.019 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 673.86 | MenuID=Sales Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 18:11:24.192 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 18:12:12.140 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.38 | MenuID=Sales Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 18:11:34.528 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

# AS-IS 실측 요약 — DMF0022

- 실행: 2026-11-12 23:16:53.041 ~ 2026-11-12 23:19:26.523 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Plan Waterfall (GSCM.DM.Plan.UIL.DMF0022_SalesPlanWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": null, "opener": "btnVersion_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:16:53.797 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 23:16:53.825 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.17 | USER_ID= |
| 23:16:54.058 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 9.78 | p_created_by=jaeuk.shin, p_month=6 |
| 23:16:54.722 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 653.11 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 23:16:55.222 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 3.18 |  |
| 23:16:55.248 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.34 | p_lookup_type=ITEM_TYPE_CODE |
| 23:16:55.259 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.55 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.276 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.05 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.01 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.316 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 3.5 |  |
| 23:16:55.351 | load | GSCM.DM.Master.WSL | DMF0022_GET_SPREAD_TITLE | 231 | 13.68 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=DAILY |
| 23:16:55.368 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.19 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.412 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.35 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.523 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 104.68 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.538 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.15 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.546 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.81 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.06 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.560 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.75 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.568 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 48 | 4.03 | Code=Measure, Param1=DMF0022, Param2=Sales Plan Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:16:55.793 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.17 | MenuID=Sales Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 23:16:55.938 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 23:17:06.827 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.41 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:17:06.847 | load | GSCM.SCM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 0 | 3.45 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0073, p_sheet_name=SalesPriceVersionPopup, p_division_id=40 |
| 23:19:25.790 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.96 | MenuID=Sales Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 23:18:46.557 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

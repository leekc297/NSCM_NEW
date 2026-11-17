# AS-IS 실측 요약 — DMF0022

- 실행: 2026-11-12 23:13:43.954 ~ 2026-11-12 23:15:56.924 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Plan Waterfall (GSCM.DM.Plan.UIL.DMF0022_SalesPlanWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": "ExceptionDialog", "opener": "btnVersion_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:13:44.695 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 21.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 23:13:44.755 | load | GSCM.BizService.WSL | SELECT * | 874 | 51.0 | USER_ID= |
| 23:13:45.916 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 939.99 | p_created_by=jaeuk.shin, p_month=6 |
| 23:13:57.450 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 11522.69 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 23:13:57.923 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 130.72 |  |
| 23:13:58.013 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 61.33 | p_lookup_type=ITEM_TYPE_CODE |
| 23:13:58.050 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 30.21 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:13:58.092 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 25.97 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:13:58.144 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 35.97 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:13:58.204 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 45.99 |  |
| 23:13:58.472 | load | GSCM.DM.Master.WSL | DMF0022_GET_SPREAD_TITLE | 231 | 236.16 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=DAILY |
| 23:13:58.487 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.145 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 1652.72 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.279 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 129.61 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.44 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 31.0 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.416 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 84.44 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.502 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 83.25 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:00.559 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 48 | 51.99 | Code=Measure, Param1=DMF0022, Param2=Sales Plan Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:01.012 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 275.94 | MenuID=Sales Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 23:14:01.231 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 144.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0022 |
| 23:14:11.452 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.67 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:14:11.796 | load | GSCM.SCM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 0 | 326.85 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0073, p_sheet_name=SalesPriceVersionPopup, p_division_id=40 |
| 23:15:56.281 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.34 | MenuID=Sales Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 23:15:16.703 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

# AS-IS 실측 요약 — DMF0042

- 실행: 2026-11-12 18:13:44.046 ~ 2026-11-12 18:14:26.086 · 계정 jaeuk.shin · 상태 OK
- 화면: Business Plan (GSCM.DM.Plan.UIL.DMF0042_BizPlan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:13:44.376 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0042 |
| 18:13:44.402 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.49 | USER_ID= |
| 18:13:44.595 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.71 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:44.650 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.58 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 18:13:44.668 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.04 | p_lookup_type=DM_YN |
| 18:13:44.780 | load | GSCM.SCM.Master.WSL | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 12 | 98.41 | p_division_id=81 |
| 18:13:44.897 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 108.72 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 18:13:44.907 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.64 | Code=DMF0042_BP_Measure, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:45.230 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 300.08 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 18:13:45.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 25.26 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 18:13:45.308 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 2.98 | p_lookup_type=BUCKET2_TYPE_CODE |
| 18:13:45.339 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.54 | p_created_by=jaeuk.shin, p_month=7 |
| 18:13:45.352 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 5.23 | p_lookup_type=ITEM_TYPE_CODE |
| 18:13:45.359 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.49 | Code=CURRENCY_LIST, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:45.801 | load | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 18 | 411.8 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=81 |
| 18:13:45.811 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.02 | Code=incotermsEdit, Param1=81, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:13:45.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 17.6 | Code=DM_LOOKUP_DIV, Param1=81, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:13:45.842 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.39 | Code=DMF0042_BP_Measure, Param1=81, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 18:13:46.219 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 341.38 | MenuID=Business Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 18:13:46.371 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0042 |
| 18:13:55.222 | find | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 18 | 14.7 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=81 |
| 18:13:55.239 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.26 | Code=incotermsEdit, Param1=81, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:13:55.247 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.47 | Code=DM_LOOKUP_DIV, Param1=81, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:13:55.256 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.59 | Code=DMF0042_BP_Measure, Param1=81, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |

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
| Div | clbDivision |  |
| Model / Nickname | txtItemId |  |
| Owner | txtOwner |  |
| layoutControlItem6 | btnOwner |  |
| Item Type | clbItemType |  |
| Period | drpPeriod |  |
| Set Price | btnSetPrice |  |
| Exchange Rate | btnExchangeRate |  |
| Ver. Cutoff | btnCutOff |  |
| Bucket | cboBucketType |  |
| Closed | cboClosed |  |
| . | cboQty |  |
| Replace | btnReplace |  |

## 그리드

- spdMain / Biz Plan: 행 0 · 컬럼 19(보임 18) · 헤더 3단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — DMF0042

- 실행: 2026-11-26 22:34:44.270 ~ 2026-11-26 22:51:05.311 · 계정 jaeuk.shin · 상태 OK
- 화면: Business Plan (GSCM.DM.Plan.UIL.DMF0042_BizPlan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:34:46.196 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 135.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0042 |
| 22:34:46.723 | load | GSCM.BizService.WSL | SELECT * | 874 | 504.69 | USER_ID= |
| 22:34:47.477 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 163.55 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:00.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 12733.98 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:35:00.651 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 309.24 | p_lookup_type=DM_YN |
| 22:35:11.884 | load | GSCM.SCM.Master.WSL | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 12 | 11212.46 | p_division_id=81 |
| 22:35:12.665 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 174 | 780.59 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 22:35:13.073 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 390.52 | Code=DMF0042_BP_Measure, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:14.540 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 453 | 1427.4 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 22:35:15.039 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 396.49 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:35:15.909 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 854.75 | p_lookup_type=BUCKET2_TYPE_CODE |
| 22:35:16.846 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 871.07 | p_created_by=jaeuk.shin, p_month=7 |
| 22:35:16.856 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 4.52 | p_lookup_type=ITEM_TYPE_CODE |
| 22:35:16.977 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 111.81 | Code=CURRENCY_LIST, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:18.218 | load | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 18 | 1193.62 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=81 |
| 22:35:19.090 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 851.62 | Code=incotermsEdit, Param1=81, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:35:21.884 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 2787.4 | Code=DM_LOOKUP_DIV, Param1=81, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:35:21.903 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 6.82 | Code=DMF0042_BP_Measure, Param1=81, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 22:35:25.611 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3424.15 | MenuID=Business Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 22:35:29.109 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3210.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0042 |
| 22:35:39.422 | find | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 18 | 29.63 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=81 |
| 22:35:39.463 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.46 | Code=incotermsEdit, Param1=81, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:35:39.478 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 6.64 | Code=DM_LOOKUP_DIV, Param1=81, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:35:39.506 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 6.49 | Code=DMF0042_BP_Measure, Param1=81, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 22:37:25.446 | find | GSCM.DM.Master.WSL | DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 0 | 105778.45 | p_division_id=81, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261123, p_to_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_userinfo=ADMIN, p_owner=, p_qty_yn=N |
| 22:44:21.323 | find | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 18 | 41.16 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=81 |
| 22:44:21.358 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 22.23 | Code=incotermsEdit, Param1=81, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:44:21.378 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 11.82 | Code=DM_LOOKUP_DIV, Param1=81, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:44:21.400 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 10.59 | Code=DMF0042_BP_Measure, Param1=81, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 22:45:38.252 | find | GSCM.DM.Master.WSL | DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 0 | 76702.95 | p_division_id=81, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261123, p_to_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_userinfo=ADMIN, p_owner=, p_qty_yn=N |
| 22:46:10.820 | find | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 18 | 22.67 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=81 |
| 22:46:10.838 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 5.14 | Code=incotermsEdit, Param1=81, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:46:10.860 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 8.37 | Code=DM_LOOKUP_DIV, Param1=81, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:46:10.892 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 6.57 | Code=DMF0042_BP_Measure, Param1=81, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 22:47:24.829 | find | GSCM.DM.Master.WSL | DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 0 | 73770.7 | p_division_id=81, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261123, p_to_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_userinfo=ADMIN, p_owner=, p_qty_yn=N |
| 22:47:57.380 | find | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 25 | 26.64 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=40 |
| 22:48:01.146 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 3750.35 | Code=DeptId, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:03.699 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1100 | 2536.59 | Code=EndCustomerByDivision40, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:05.646 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1163 | 1923.12 | Code=SiteByEndCustomer, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:05.672 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.4 | Code=incotermsEdit, Param1=40, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:48:05.965 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 287.91 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:48:05.981 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.87 | Code=DMF0042_BP_Measure, Param1=40, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 22:48:05.996 | find | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 7 | 3.33 | CODE=DM_CELL_PROD_SITE, PARAM1=ALL, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 22:48:10.518 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4514.15 | Code=TeambyDivision, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:48:10.594 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 52.69 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:10.878 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 888 | 270.96 | Code=EndCustomerByDivision40, Param1=40, Param2=71059518,71067310,70090866,58124984,58260040,70090867,58099468,58666055,70618872,71060790,58520274,70021343,70318556,70000478,70267799,70174158, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 22:48:10.916 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 7.48 | Code=DMF0042_BP_Measure, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:17.093 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1143 | 5999.39 | Code=SiteByEndCustomer, Param1=40, Param2=-,1X Technologies,ABS,Acculon Energy,ACE KR,Acell,Acell Electronic,acer,acer(개발),Aeon Motor,Aima,Aimsak,Airbus,Airwheel,AJ상사,Akasol,Akku,Alelion,All Good Energy,AllCell,Also,Amara Raja Batteries,Amazon,Amazon Prime Air,Amazon Web Services,Ambrane,Ample,Anand |
| 22:48:17.444 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 126.17 | Code=FromSiteByDivision, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:48:17.590 | find | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 103.9 | p_lookup_type=BUCKET2_TYPE_CODE |
| 22:48:17.777 | find | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 171.92 | p_created_by=jaeuk.shin, p_month=7 |
| 22:48:17.920 | find | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 134.2 | p_lookup_type=ITEM_TYPE_CODE |
| 22:48:18.111 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 179.37 | Code=CURRENCY_LIST, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:21.510 | find | GSCM.DM.Master.WSL | DMF0042_GET_SPREAD_TITLE | 25 | 34.38 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_division_id=40 |
| 22:48:21.616 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 101.72 | Code=DeptId, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:21.936 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1100 | 298.76 | Code=EndCustomerByDivision40, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:22.346 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1163 | 378.82 | Code=SiteByEndCustomer, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:22.381 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.41 | Code=incotermsEdit, Param1=40, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:48:22.399 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 10.0 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 22:48:22.411 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 7.49 | Code=DMF0042_BP_Measure, Param1=40, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 22:48:22.446 | find | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 7 | 3.64 | CODE=DM_CELL_PROD_SITE, PARAM1=ALL, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 22:50:30.930 | find | GSCM.DM.Master.WSL | DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 7564 | 128354.14 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261123, p_to_yyyymmdd=20270531, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_userinfo=ADMIN, p_owner=, p_qty_yn=N |
| 22:51:03.142 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 379.15 | MenuID=Business Plan, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Biz Plan: 행 7564 · 컬럼 27(보임 25) · 헤더 3단 · 고정 컬럼 15

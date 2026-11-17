# AS-IS 실측 요약 — DMF0051

- 실행: 2026-11-12 23:28:45.920 ~ 2026-11-12 23:29:46.022 · 계정 jaeuk.shin · 상태 OK
- 화면: Biz Plan Waterfall (GSCM.DM.Plan.UIL.DMF0051_BizPlanWaterfall)
- 조회 결과:  · DB : 33.609s, UI : 0.012s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": "SCM0002_VersionByWaterfallPopup", "opener": "btnVersion_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:28:46.271 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0051 |
| 23:28:46.295 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.38 | USER_ID= |
| 23:28:46.435 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 9.48 | p_created_by=jaeuk.shin, p_month=6 |
| 23:28:46.463 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.52 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:46.725 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 3.1 | p_lookup_type=BUCKET2_TYPE_CODE |
| 23:28:46.743 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 2.92 | p_lookup_type=ITEM_TYPE_CODE |
| 23:28:46.753 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.54 | Code=SALES_PLAN_AMOUNT_KRW, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:46.770 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.5 | Code=SALES_PLAN_AMOUNT_USD, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:46.788 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.78 | Code=SALES_PLAN_AMOUNT_LOC, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:46.804 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 2.67 |  |
| 23:28:46.900 | load | GSCM.DM.Master.WSL | DMF0051_GET_SPREAD_TITLE | 23 | 76.73 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 23:28:46.947 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 39.59 | Code=DeptId, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:47.069 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 116.69 | Code=EndCustomerByDivision40, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:47.202 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1138 | 122.44 | Code=SiteByEndCustomer, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:47.232 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 20.45 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_INCOTERMS, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:28:47.240 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.35 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:28:47.249 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.78 | Code=DMF0051_BP_Measure, Param1=40, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:28:47.383 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 102.32 | MenuID=Biz Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 23:28:47.476 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.3 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0051 |
| 23:28:57.881 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.53 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:57.958 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 50.39 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_version_type=BP_M,ME_S, p_version_no= |
| 23:29:04.944 | find | GSCM.DM.Master.WSL | DMF0051_GET_SPREAD_TITLE | 23 | 13.31 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 23:29:04.994 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.55 | Code=DeptId, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:29:05.109 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 109.82 | Code=EndCustomerByDivision40, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:29:05.235 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1138 | 116.72 | Code=SiteByEndCustomer, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:29:05.251 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.99 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_INCOTERMS, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:29:05.261 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.45 | Code=DM_LOOKUP_DIV, Param1=40, Param2=BP_FCST_TYPE, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:29:05.271 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.88 | Code=DMF0051_BP_Measure, Param1=40, Param2=900, Param3=900, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:29:38.463 | find | GSCM.DM.Master.WSL | DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL | 9450 | 33180.56 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261109, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_owner=, p_version_type=Current, p_cell_yn=N, |
| 23:29:38.907 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 2.59 | p_menu_id=DMF0051, p_log_type=FIND, p_log_cnt=, p_db_time=33.609, p_ui_time=0.012, p_user_id=jaeuk.shin |
| 23:29:45.416 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.2 | MenuID=Biz Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Biz Plan Waterfall: 행 9450 · 컬럼 25(보임 18) · 헤더 3단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

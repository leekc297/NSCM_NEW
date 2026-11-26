# AS-IS 실측 요약 — DMF0082

- 실행: 2026-11-24 18:57:51.410 ~ 2026-11-24 19:11:44.569 · 계정 jaeuk.shin · 상태 OK
- 화면: Fcst&Price MGMT (GSCM.DM.Plan.UIL.DMF0082_FcstNPrice_Mgmt)
- 조회 결과: Total : 7,341 · DB : 634.565s, UI : 26.483s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:57:53.273 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 538.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0082 |
| 18:57:53.630 | load | GSCM.BizService.WSL | SELECT * | 874 | 343.47 | USER_ID= |
| 18:58:15.687 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 21838.7 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:58:18.322 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 1592.78 | p_created_by=jaeuk.shin, p_month=6 |
| 18:58:18.689 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 260.9 |  |
| 18:58:19.287 | load | GSCM.DM.Master.WSL | DMF0082_POPUP_GET_FUTUREPRICE_INFO | 1872 | 497.79 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270401 |
| 18:58:21.474 | load | GSCM.DM.Master.WSL | DMF0082_GET_SPREAD_TITLE | 234 | 2037.32 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 18:58:24.635 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 3048.94 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:58:26.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 1349.08 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:58:26.923 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 841.37 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:58:27.010 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 71.55 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:58:27.088 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 73.91 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:58:27.292 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 201.06 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:13.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 46697.14 | Code=CELL_PROD_SITE_ID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:14.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 84.69 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:14.588 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 496.01 | Code=Measure, Param1=DMF0082, Param2=FcstNPrice, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:15.466 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 543.11 | MenuID=Fcst&Price MGMT, CnntCode=0104001, UserID=jaeuk.shin |
| 18:59:16.036 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 262.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0082 |
| 18:59:25.854 | find | GSCM.DM.Master.WSL | DMF0082_GET_SPREAD_TITLE | 234 | 44.35 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40 |
| 18:59:26.254 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 366.55 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:27.452 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 1114.88 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:28.027 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 554.58 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:28.148 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 12.07 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:28.156 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 9.56 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:28.177 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 12.31 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:34.536 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 6349.32 | Code=CELL_PROD_SITE_ID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:34.556 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 10.35 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:59:34.567 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 5.25 | Code=Measure, Param1=DMF0082, Param2=FcstNPrice, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:10:08.291 | find | GSCM.DM.Master.WSL | DMF0082_GET_MAIN_DATA | 7341 | 633481.28 | p_division_id=40, p_team_id=ALL, p_customer=ALL, p_biz_type=ALL, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_scm_site_id=ALL, p_item_id=, p_version_type=Current, p_qty_yn=N, p_created_by=jaeuk.shin, p_user_group=ADMIN |
| 19:10:35.774 | find | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 1 | 24340.96 | CODE=DM_CUSTOMS_HANDBOOK, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 19:10:35.811 | find | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 12 | 3.3 | CODE=FCST_TYPE, PARAM1=ADMIN, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 19:10:36.799 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 914.33 | p_menu_id=DMF0082, p_log_type=FIND, p_log_cnt=7341, p_db_time=634.565, p_ui_time=26.483, p_user_id=jaeuk.shin |
| 19:11:33.507 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 56701.92 | Code=DefaultBucketDay, Param1=40, Param2=WEEKLY, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:11:42.029 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1787.77 | MenuID=Fcst&Price MGMT, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz Type | clbBizType |  |
| Sales Site | clbSalesSite |  |
| Bucket | cboBucketType |  |
| Div | clbDivision |  |
| Period | drpPeriod |  |
| Version | txtVersion |  |
| Model / Nickname | txtItemId |  |
| layoutControlItem1 | btnItemId |  |
| Price일괄입력 | btnSavePricePeriod |  |
| layoutControlItem7 | btnVersion |  |
| layoutControlItem5 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Exchange Rate | btnExchangeRate |  |
| layoutControlItem2 | cboQty |  |
| layoutControlItem3 | chkSum |  |

## 그리드

- spdMain / FcstNPrice: 행 7341 · 컬럼 236(보임 47) · 헤더 3단 · 고정 컬럼 19

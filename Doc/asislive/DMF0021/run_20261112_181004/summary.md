# AS-IS 실측 요약 — DMF0021

- 실행: 2026-11-12 18:10:04.469 ~ 2026-11-12 18:11:03.198 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Plan (GSCM.DM.Plan.UIL.DMF0021_SalesPlan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:10:05.248 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0021 |
| 18:10:05.278 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.04 | USER_ID= |
| 18:10:06.434 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 882.89 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:10:06.794 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 4.46 |  |
| 18:10:06.829 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 9.95 | p_created_by=jaeuk.shin, p_month=6 |
| 18:10:06.851 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 2.99 | p_lookup_type=ITEM_TYPE_CODE |
| 18:10:07.142 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 19 | 283.32 | Code=SALES_PLAN_ITEM_ID, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:07.149 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.53 | Code=CURRENCY_LIST, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:07.902 | load | GSCM.SCM.Master.WSL | DMF0021_GET_SALES_PLAN_MEASUREINFO | 1 | 739.66 |  |
| 18:10:08.187 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 1 | 280.09 | CODE=DM_CUSTOMS_HANDBOOK, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 18:10:08.195 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 12 | 3.09 | CODE=FCST_TYPE, PARAM1=ADMIN, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 18:10:13.411 | load | GSCM.DM.Master.WSL | DMF0021_GET_SPREAD_TITLE | 230 | 5198.95 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=DAILY |
| 18:10:13.435 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.88 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:13.482 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 41.45 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:14.043 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2519 | 554.64 | Code=SiteByEndCustomer_InnerCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:14.065 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.44 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:14.073 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:14.082 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.52 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:14.189 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 49 | 101.98 | Code=Measure, Param1=DMF0021, Param2=Sales Plan, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:15.296 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 886.31 | MenuID=Sales Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 18:10:15.469 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0021 |
| 18:10:24.037 | find | GSCM.DM.Master.WSL | DMF0021_GET_SPREAD_TITLE | 49 | 8.89 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 18:10:24.049 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.41 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:24.094 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 42.52 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:24.169 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2519 | 70.14 | Code=SiteByEndCustomer_InnerCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:24.192 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.32 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:24.199 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.13 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:24.205 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.86 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:24.213 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 49 | 3.47 | Code=Measure, Param1=DMF0021, Param2=Sales Plan, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:10:30.687 | find | GSCM.DM.Master.WSL | DMF0020_GET_SCM_MST_FUTURE_PRICE | 8260 | 72658.32 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_plant_site_id=ALL, p_project_code=, p_item_id=, p_customer_project_code=, p_customer_model=, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_biztype=ALL, p_created_by=jaeuk.shin, p_userinfo=ADMIN, p_owner=, p_over_range=N, |

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
| Bucket | cboBucketType |  |
| Period | drpPeriod |  |
| Item Type | clbItemType |  |
| Div | clbDivision |  |
| Model / Nickname | txtItemId |  |
| Owner | txtOwner |  |
| layoutControlItem6 | btnOwner |  |
| layoutControlItem8 | InternalYN |  |
| . | cboCellQty |  |
| layoutControlItem7 | chkColor |  |

## 그리드

- spdMain / Sales Plan: 행 0 · 컬럼 50(보임 19) · 헤더 3단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

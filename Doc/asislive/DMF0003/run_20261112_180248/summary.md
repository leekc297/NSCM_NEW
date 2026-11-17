# AS-IS 실측 요약 — DMF0003

- 실행: 2026-11-12 18:02:48.050 ~ 2026-11-12 18:03:31.947 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST (GSCM.DM.Plan.UIL.DMF0003_MktFcst)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:02:49.051 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0003 |
| 18:02:49.077 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.13 | USER_ID= |
| 18:02:50.098 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 737.23 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:02:50.511 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 4.78 |  |
| 18:02:50.593 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 43.95 | p_created_by=jaeuk.shin, p_month=6 |
| 18:02:50.602 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.55 | p_lookup_type=ITEM_TYPE_CODE |
| 18:02:50.680 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 1294 | 64.14 | CODE=SiteByEndCustomer40, PARAM1=ALL, PARAM2=ALL, PARAM3=ADMIN, PARAM4=jaeuk.shin, PARAM5=N |
| 18:02:50.717 | load | GSCM.DM.Master.WSL | DMF0003_GET_SPREAD_TITLE | 237 | 14.04 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_user_group=ADMIN, p_type=LOAD |
| 18:02:50.843 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 102.04 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:50.931 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 73.24 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:50.956 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.31 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:50.964 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 5.3 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:50.972 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.27 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:51.017 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 41.36 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:51.036 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 46 | 10.81 | Code=Measure, Param1=DMF0003, Param2=Mkt Fcst, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:02:51.294 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.91 | MenuID=MKT FCST, CnntCode=0104001, UserID=jaeuk.shin |
| 18:02:51.415 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 6.4 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0003 |
| 18:03:00.695 | find | GSCM.DM.Master.WSL | DMF0003_GET_SPREAD_TITLE | 237 | 16.55 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_user_group=ADMIN, p_type= |
| 18:03:00.825 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 105.14 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:00.904 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 68.79 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:00.923 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.35 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:00.931 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 5.28 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:00.940 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.3 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:00.993 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 41.16 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:03:01.010 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 46 | 9.89 | Code=Measure, Param1=DMF0003, Param2=Mkt Fcst, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz Type | clbBizType |  |
| Period | drpPeriod |  |
| Sales Site | clbSalesSite |  |
| Model / Nickname | txtItemId |  |
| Project | txtProject |  |
| layoutControlItem3 | btnProject |  |
| layoutControlItem1 | btnItemId |  |
| Bucket | cboBucketType |  |
| layoutControlItem2 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Plant Site | clbPlantSite |  |
| layoutControlItem5 | chkSum |  |
| Item Type | clbItemType |  |
| Div | clbDivision |  |
| Owner | txtOwner |  |
| layoutControlItem8 | btnOwner |  |
| . | cboQty |  |
| Master Chg | btnIncotermsChg |  |
| . | cboCellQty |  |
| layoutControlItem11 | checkInvalidExec |  |
| lciASCheck | cboAS |  |
| layoutControlItem6 | chkColor |  |
| Sender Code | clbEDISender |  |

## 그리드

- spdMain / Mkt Fcst: 행 0 · 컬럼 238(보임 50) · 헤더 3단 · 고정 컬럼 21

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

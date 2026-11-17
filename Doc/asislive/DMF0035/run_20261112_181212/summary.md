# AS-IS 실측 요약 — DMF0035

- 실행: 2026-11-12 18:12:12.947 ~ 2026-11-12 18:13:08.834 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST Waterfall (GSCM.DM.Plan.UIL.DMF0035_MktFcstWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:12:13.398 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0035 |
| 18:12:13.421 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.18 | USER_ID= |
| 18:12:13.928 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 3.5 |  |
| 18:12:13.964 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 11.57 | p_created_by=jaeuk.shin, p_month=6 |
| 18:12:13.972 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.33 | p_lookup_type=ITEM_TYPE_CODE |
| 18:12:13.984 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 3.01 |  |
| 18:12:14.638 | load | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 611.94 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 18:12:14.646 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.06 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:14.726 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 75.05 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:14.737 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.27 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:14.807 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 65.01 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:14.826 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 14.04 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:14.943 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 66.25 | LOGTYPE=SpeedUp, NOTE=DMF0035
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:12:15.076 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 132.73 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:12:15.096 | load | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 15.5 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 18:12:15.105 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.97 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:15.162 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 52.89 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:15.175 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.25 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:15.194 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 14.61 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:15.209 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 10.11 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:12:15.640 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 280.12 | LOGTYPE=SpeedUp, NOTE=DMF0035
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:12:15.674 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.29 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:12:16.172 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 475.87 | MenuID=MKT FCST Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 18:12:16.318 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0035 |
| 18:12:56.092 | find | GSCM.DM.Master.WSL | DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | 2033 | 151842.81 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261109, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_userinfo=ADMIN, p_owner=, p_internal_yn=N, p |
| 18:13:08.129 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.21 | MenuID=MKT FCST Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| End Customer | clbCustomer |  |
| Sales Site | clbSalesSite |  |
| Project | txtProject |  |
| layoutControlItem1 | btnItemId |  |
| Bucket | cboBucketType |  |
| layoutControlItem2 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Plant Site | clbPlantSite |  |
| Version* | txtVersion | Y |
| layoutControlItem5 | chkSum |  |
| layoutControlItem6 | btnVersion |  |
| Period* | drpPeriod | Y |
| Team | clbTeam |  |
| layoutControlItem3 | btnProject |  |
| Model / Nickname | txtItemId |  |
| Item Type | clbItemType |  |
| Div* | cboDivision | Y |
| Owner | txtOwner |  |
| layoutControlItem7 | btnOwner |  |
| QTY | cboQTY |  |
| layoutControlItem8 | chkColor |  |
| layoutControlItem9 | cboCellQty |  |
| Sender Code | clbEDISender |  |
| Biz Type | clbBizType |  |
| Redraw | btnDrawTest |  |

## 그리드

- spdMain / Mkt Fcst Waterfall: 행 0 · 컬럼 50(보임 19) · 헤더 3단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:12:26.164 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

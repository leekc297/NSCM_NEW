# AS-IS 실측 요약 — DMF0053

- 실행: 2026-11-12 18:18:45.294 ~ 2026-11-12 18:19:25.913 · 계정 jaeuk.shin · 상태 OK
- 화면: Customer FCST Waterfall (GSCM.DM.Plan.UIL.DMF0053_CustFcstWaterfall)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:18:45.678 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0053 |
| 18:18:45.703 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.0 | USER_ID= |
| 18:18:46.074 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 3.31 |  |
| 18:18:46.104 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.21 | p_created_by=jaeuk.shin, p_month=6 |
| 18:18:46.119 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 9.96 | p_created_by=jaeuk.shin, p_month=1 |
| 18:18:46.125 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.5 | p_lookup_type=ITEM_TYPE_CODE |
| 18:18:46.138 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 3.48 |  |
| 18:18:46.259 | load | GSCM.DM.Master.WSL | DMF0053_GET_SPREAD_TITLE | 51 | 89.58 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 18:18:46.271 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:46.280 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.7 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:46.289 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 24 | 3.61 | Code=Measure, Param1=DMF0053, Param2=CUST Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:46.329 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.09 | LOGTYPE=SpeedUp, NOTE=DMF0053
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:18:46.370 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.83 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:18:46.385 | load | GSCM.DM.Master.WSL | DMF0053_GET_SPREAD_TITLE | 51 | 11.03 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 18:18:46.398 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.79 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:46.406 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.18 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:46.416 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 24 | 3.36 | Code=Measure, Param1=DMF0053, Param2=CUST Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:46.662 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.54 | LOGTYPE=SpeedUp, NOTE=DMF0053
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:18:46.695 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.41 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:18:46.775 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 57.1 | MenuID=Customer FCST Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 18:18:46.870 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0053 |
| 18:18:55.000 | find | GSCM.DM.Master.WSL | DMF0053_GET_SPREAD_TITLE | 51 | 15.98 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_bucket=MONTHLY |
| 18:18:55.011 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.38 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:55.024 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.33 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:18:55.034 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 24 | 4.51 | Code=Measure, Param1=DMF0053, Param2=CUST Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Sales Site | clbSalesSite |  |
| Project | txtProject |  |
| Plant Site | clbPlantSite |  |
| Team | clbTeam |  |
| Model / Nickname | txtItemId |  |
| layoutControlItem2 | btnColumn |  |
| layoutControlItem1 | btnItemId |  |
| Div* | cboDivision | Y |
| Biz Type | clbBizType |  |
| Period* | drpPeriod | Y |
| Item Type | clbItemType |  |
| End Customer | clbCustomer |  |
| layoutControlItem3 | btnProject |  |
| Bucket | cboBucketType |  |
| Owner | txtOwner |  |
| layoutControlItem7 | btnOwner |  |
| Input Date* | drpCreateDate | Y |
| layoutControlItem4 | btnMeasure |  |
| QTY | cboQTY |  |
| layoutControlItem5 | chkSum |  |
| Date* | txtVersion | Y |
| layoutControlItem6 | btnVersion |  |

## 그리드

- spdMain / CUST Fcst Waterfall: 행 0 · 컬럼 52(보임 21) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

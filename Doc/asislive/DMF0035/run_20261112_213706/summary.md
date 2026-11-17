# AS-IS 실측 요약 — DMF0035

- 실행: 2026-11-12 21:37:06.259 ~ 2026-11-12 21:38:00.341 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST Waterfall (GSCM.DM.Plan.UIL.DMF0035_MktFcstWaterfall)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:37:06.658 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0035 |
| 21:37:06.683 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.52 | USER_ID= |
| 21:37:07.297 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 2.97 |  |
| 21:37:07.350 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 13.63 | p_created_by=jaeuk.shin, p_month=6 |
| 21:37:07.362 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 2.82 | p_lookup_type=ITEM_TYPE_CODE |
| 21:37:07.372 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 2.99 |  |
| 21:37:07.545 | load | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 128.87 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 21:37:07.553 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.49 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:07.632 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 73.56 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:07.645 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.25 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:07.665 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 14.79 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:09.760 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 2090.1 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:09.867 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 67.32 | LOGTYPE=SpeedUp, NOTE=DMF0035
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:37:09.932 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.9 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:37:09.951 | load | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 14.34 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 21:37:09.960 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.73 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:10.032 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 68.26 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:10.045 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.04 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:10.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 14.52 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:10.080 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 11.17 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:37:10.326 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 118.92 | LOGTYPE=SpeedUp, NOTE=DMF0035
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:37:10.340 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.48 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:37:10.557 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 197.67 | MenuID=MKT FCST Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 21:37:10.674 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.78 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0035 |
| 21:37:59.612 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.23 | MenuID=MKT FCST Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 21:37:21.259 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

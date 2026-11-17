# AS-IS 실측 요약 — DMF0040

- 실행: 2026-11-12 21:38:00.580 ~ 2026-11-12 21:38:52.389 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST Comparison (GSCM.DM.Plan.UIL.DMF0040_MktFcst_Comparison)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:38:00.920 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.57 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0040 |
| 21:38:00.945 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.0 | USER_ID= |
| 21:38:01.347 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 3.06 |  |
| 21:38:01.377 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.74 | p_created_by=jaeuk.shin, p_month=6 |
| 21:38:01.385 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 2.86 | p_lookup_type=ITEM_TYPE_CODE |
| 21:38:01.394 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 2.74 |  |
| 21:38:01.432 | load | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 14.42 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 21:38:01.443 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.26 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:38:01.519 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 72.67 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:38:01.643 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.41 | LOGTYPE=SpeedUp, NOTE=DMF0040
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:38:01.762 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 118.0 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:38:01.779 | load | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 14.07 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 21:38:01.792 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.18 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:38:01.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 68.73 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:38:02.121 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 94.33 | LOGTYPE=SpeedUp, NOTE=DMF0040
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:38:02.244 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 123.27 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:38:02.608 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 357.55 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 21:38:02.615 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 4.62 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 21:38:02.792 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 156.98 | MenuID=MKT FCST Comparison, CnntCode=0104001, UserID=jaeuk.shin |
| 21:38:02.895 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0040 |
| 21:38:51.666 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.3 | MenuID=MKT FCST Comparison, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| End Customer | clbCustomer |  |
| Sales Site | clbSalesSite |  |
| Project | txtProject |  |
| layoutControlItem1 | btnItemId |  |
| Bucket | cboBucketType |  |
| layoutControlItem2 | btnColumn |  |
| Plant Site | clbPlantSite |  |
| Version* | txtVersion | Y |
| layoutControlItem5 | chkSum |  |
| layoutControlItem6 | btnVersion |  |
| Period* | drpPeriod | Y |
| Biz Type | clbBizType |  |
| Team | clbTeam |  |
| layoutControlItem3 | btnProject |  |
| Model / Nickname | txtItemId |  |
| Item Type | clbItemType |  |
| Div* | cboDivision | Y |
| Owner | txtOwner |  |
| layoutControlItem7 | btnOwner |  |
| QTY | cboQTY |  |
| . | cboCellQty |  |
| . | cboDiff |  |

## 그리드

- spdMain / Mkt Fcst Waterfall: 행 0 · 컬럼 225(보임 13) · 헤더 3단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 21:38:12.880 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

# AS-IS 실측 요약 — DMF0040

- 실행: 2026-11-12 18:13:08.907 ~ 2026-11-12 18:13:43.936 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST Comparison (GSCM.DM.Plan.UIL.DMF0040_MktFcst_Comparison)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:13:09.298 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0040 |
| 18:13:09.321 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.9 | USER_ID= |
| 18:13:09.891 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 3.13 |  |
| 18:13:09.945 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.63 | p_created_by=jaeuk.shin, p_month=6 |
| 18:13:09.955 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.11 | p_lookup_type=ITEM_TYPE_CODE |
| 18:13:09.973 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 3.46 |  |
| 18:13:10.445 | load | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 430.16 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 18:13:10.458 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.14 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:10.548 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 85.22 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:10.699 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 13.98 | LOGTYPE=SpeedUp, NOTE=DMF0040
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:13:10.710 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.37 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:13:10.746 | load | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 30.73 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 18:13:10.760 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.07 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:10.844 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 79.93 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:13:11.104 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 36.2 | LOGTYPE=SpeedUp, NOTE=DMF0040
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:13:11.252 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 147.3 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:13:12.734 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 1476.32 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 18:13:12.745 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 4.83 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 18:13:13.136 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 367.12 | MenuID=MKT FCST Comparison, CnntCode=0104001, UserID=jaeuk.shin |
| 18:13:13.260 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.73 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0040 |
| 18:13:43.266 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.75 | MenuID=MKT FCST Comparison, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 18:13:22.720 [GSCM] Version 값은 필수 입력입니다 → default_button(id=1)

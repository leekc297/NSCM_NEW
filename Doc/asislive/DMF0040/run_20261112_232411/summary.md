# AS-IS 실측 요약 — DMF0040

- 실행: 2026-11-12 23:24:11.658 ~ 2026-11-12 23:27:13.865 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST Comparison (GSCM.DM.Plan.UIL.DMF0040_MktFcst_Comparison)
- 조회 결과: Total : 292 · DB : 155.148s, UI : 0.342s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": "DMF0000_VersionByWaterfallPopup", "opener": "btnVersion_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:24:12.334 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0040 |
| 23:24:12.361 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.0 | USER_ID= |
| 23:24:13.027 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 2.48 |  |
| 23:24:13.068 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.11 | p_created_by=jaeuk.shin, p_month=6 |
| 23:24:13.075 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 2.63 | p_lookup_type=ITEM_TYPE_CODE |
| 23:24:13.086 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 2.63 |  |
| 23:24:13.440 | load | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 325.02 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 23:24:13.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.2 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:13.512 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 56.63 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:13.719 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 91.47 | LOGTYPE=SpeedUp, NOTE=DMF0040
division_id_changed
start
, USER_ID=jaeuk.shin |
| 23:24:13.727 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 8.11 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:24:13.748 | load | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 18.01 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 23:24:13.759 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.4 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:13.842 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 78.74 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:14.062 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 17.23 | LOGTYPE=SpeedUp, NOTE=DMF0040
division_id_changed
end
, USER_ID=jaeuk.shin |
| 23:24:14.203 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 140.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:24:14.212 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 4.87 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 23:24:14.220 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 4.52 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 23:24:14.508 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 269.34 | MenuID=MKT FCST Comparison, CnntCode=0104001, UserID=jaeuk.shin |
| 23:24:14.612 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0040 |
| 23:24:23.848 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.8 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:23.892 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 5.23 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_W, p_version_no= |
| 23:24:31.169 | find | GSCM.DM.Master.WSL | DMF0040_GET_SPREAD_TITLE | 224 | 13.88 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 23:24:31.181 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.41 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:31.253 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 68.07 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:06.459 | find | GSCM.DM.Master.WSL | DMF0040_GET_MKT_FCST_COMPARISON | 292 | 155095.32 | p_division_id=81, p_scm_site_id=ALL, p_plant_site_id=ALL, p_team_id=ALL, p_customer=ALL, p_biz_type=ALL, p_project_code=, p_item_id=, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_version_no=Current, p_item_type=ALL, p_owner=, p_diff_only=False, p_bucket=MONTHLY |
| 23:27:06.848 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.69 | p_menu_id=DMF0040, p_log_type=FIND, p_log_cnt=292, p_db_time=155.148, p_ui_time=0.342, p_user_id=jaeuk.shin |
| 23:27:13.150 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.3 | MenuID=MKT FCST Comparison, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Mkt Fcst Waterfall: 행 292 · 컬럼 226(보임 13) · 헤더 3단 · 고정 컬럼 9

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

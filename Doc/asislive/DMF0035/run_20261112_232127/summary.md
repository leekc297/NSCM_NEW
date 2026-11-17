# AS-IS 실측 요약 — DMF0035

- 실행: 2026-11-12 23:21:27.572 ~ 2026-11-12 23:24:11.161 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST Waterfall (GSCM.DM.Plan.UIL.DMF0035_MktFcstWaterfall)
- 조회 결과: Total : 319 · DB : 133.12s, UI : 0.196s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": "SCM0002_VersionByWaterfallPopup", "opener": "btnVersion_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:21:27.911 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0035 |
| 23:21:27.935 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.53 | USER_ID= |
| 23:21:28.407 | load | GSCM.DM.Master.WSL | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 4 | 4.75 |  |
| 23:21:28.438 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.06 | p_created_by=jaeuk.shin, p_month=6 |
| 23:21:28.446 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.42 | p_lookup_type=ITEM_TYPE_CODE |
| 23:21:28.459 | load | GSCM.DM.Master.WSL | DMF0003_GET_QTY_TYPE_CODE | 4 | 5.19 |  |
| 23:21:28.609 | load | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 115.76 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 23:21:28.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.66 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:28.688 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 65.02 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:28.706 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.96 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:28.726 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 15.33 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:30.603 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 1870.93 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:30.792 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 150.38 | LOGTYPE=SpeedUp, NOTE=DMF0035
division_id_changed
start
, USER_ID=jaeuk.shin |
| 23:21:30.937 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 145.67 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:21:30.956 | load | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 14.56 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 23:21:30.965 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.15 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:31.048 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 79.01 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:31.059 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.3 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:31.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 14.65 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:31.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 10.33 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:31.290 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 62.39 | LOGTYPE=SpeedUp, NOTE=DMF0035
division_id_changed
end
, USER_ID=jaeuk.shin |
| 23:21:31.394 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 103.41 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:21:31.652 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 228.62 | MenuID=MKT FCST Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 23:21:31.762 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0035 |
| 23:21:41.953 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.49 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:42.559 | load | GSCM.SCM.Master.WSL | SCM0002_GET_VERSIONBYWATERFALLPOPUP | 1 | 576.84 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_version_type=MF_SF_W,ME_S, p_version_no= |
| 23:21:50.321 | find | GSCM.DM.Master.WSL | DMF0035_GET_SPREAD_TITLE | 49 | 14.53 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81, p_bucket=MONTHLY |
| 23:21:50.330 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.33 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:50.409 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 74.7 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:50.421 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.84 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:50.440 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 111 | 14.41 | Code=PlantSitebyEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:21:50.459 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 10.47 | Code=Measure, Param1=DMF0035, Param2=Mkt Fcst Waterfall, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:24:03.481 | find | GSCM.DM.Master.WSL | DMF0035_GET_MKT_FCST_WATERFALL | 319 | 132985.3 | p_division_id=81, p_scm_site_id=ALL, p_plant_site_id=ALL, p_dept_id=ALL, p_end_customer=ALL, p_biz_type=ALL, p_project_code=, p_item_id=, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_version_no=Current, p_item_type=ALL, p_owner=, p_bucket=MONTHLY, p_user_dept_id=58183 |
| 23:24:03.894 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 86.94 | p_menu_id=DMF0035, p_log_type=FIND, p_log_cnt=319, p_db_time=133.12, p_ui_time=0.196, p_user_id=jaeuk.shin |
| 23:24:10.306 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.36 | MenuID=MKT FCST Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Mkt Fcst Waterfall: 행 319 · 컬럼 51(보임 19) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

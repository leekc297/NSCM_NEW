# AS-IS 실측 요약 — DMF0049

- 실행: 2026-11-12 23:28:13.994 ~ 2026-11-12 23:28:45.563 · 계정 jaeuk.shin · 상태 OK
- 화면: ETC Sales Reports (GSCM.DM.Plan.UIL.DMF0049_Sales_ETC_Reports)
- 조회 결과:  · DB : 6.451s, UI : 0.078s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtSPVersion", "popup": "DMF0044_United_VersionPopup", "opener": "btnSPVer_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:28:14.284 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0049 |
| 23:28:14.307 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.44 | USER_ID= |
| 23:28:14.382 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.67 | LOGTYPE=SpeedUp, NOTE=DMF0049
division_id_changed
start
, USER_ID=jaeuk.shin |
| 23:28:14.426 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.07 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:28:14.462 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 5.84 | p_lookup_type=MDF_TYPE |
| 23:28:14.509 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.51 | LOGTYPE=SpeedUp, NOTE=DMF0049
division_id_changed
end
, USER_ID=jaeuk.shin |
| 23:28:14.514 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.93 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:28:14.524 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 42 | 5.03 | CODE=CALENDAR_YYYY, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 23:28:14.653 | load | GSCM.DM.Master.WSL | DMF0049_GET_MEASURE | 3 | 21.17 | p_division_id=40 |
| 23:28:14.660 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 11 | 3.29 | p_lookup_type=DM_COMPANY |
| 23:28:14.739 | load | GSCM.DM.Master.WSL | DMF0049_GET_SPREAD_TITLE | 41 | 71.96 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 23:28:14.767 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 21.84 | Code=DMF0044_MDF_DEPARTMENT, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.791 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 17.45 | Code=DMF0044_DEPARTMENT_TEAM2, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.804 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.77 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.820 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 8.38 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.872 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 43.14 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_MODEL, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.878 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.51 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.886 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.2 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.896 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 5.2 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.907 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 7.01 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_BIZ_TYPE, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 4.3 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.924 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 4.83 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.933 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.76 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.943 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.69 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:14.956 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.49 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:15.074 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 99.96 | MenuID=ETC Sales Reports, CnntCode=0104001, UserID=jaeuk.shin |
| 23:28:15.114 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0049 |
| 23:28:24.083 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.42 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:24.118 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 2.82 | p_lookup_type=MDF_TYPE_SP_POPUP |
| 23:28:24.172 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 12 | 6.94 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0044, p_sheet_name=MDFVerpopup, p_division_id=40 |
| 23:28:24.192 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 12 | 6.91 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0044, p_sheet_name=MDFVerpopup, p_division_id=40 |
| 23:28:24.208 | load | GSCM.DM.Master.WSL | DMF0044_GET_SALES_VERSION_POPUP | 1 | 7.03 | p_division_id=40, p_sdt=20261012, p_edt=20270412, p_version_type=REPORT_SP_W, p_Description= |
| 23:28:31.432 | find | GSCM.DM.Master.WSL | DMF0049_GET_SPREAD_TITLE | 41 | 9.94 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 23:28:31.446 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.19 | Code=DMF0044_MDF_DEPARTMENT, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.455 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 4.6 | Code=DMF0044_DEPARTMENT_TEAM2, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.468 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.28 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.483 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.8 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.495 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 3.87 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_MODEL, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.505 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.81 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.514 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.27 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.523 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 6.21 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.532 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.84 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_BIZ_TYPE, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.543 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 6.0 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.555 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 5.33 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.564 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.86 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.573 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.04 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:31.584 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 4.2 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:28:38.122 | find | GSCM.DM.Master.WSL | DMF0049_GET_SALES_ETC_REPORTS_DATA | 0 | 6443.94 | division_id=40, p_mdf_type=REPORT_SP_W, p_yyyy=2026, p_sp_version_no=R_S_20261028_V003, p_user_group=ADMIN, p_created_by=jaeuk.shin |
| 23:28:38.212 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.38 | p_menu_id=DMF0049, p_log_type=FIND, p_log_cnt=, p_db_time=6.451, p_ui_time=0.078, p_user_id=jaeuk.shin |
| 23:28:44.814 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.8 | MenuID=ETC Sales Reports, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| SP Version | txtSPVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Report Type | clbType |  |
| Year | usrYear |  |
| layoutControlItem4 | btnMeasure |  |
| Div | clbDivision |  |
| Plan/Result | clbPlanResult |  |

## 그리드

- spdMain / MDF Reports: 행 0 · 컬럼 42(보임 39) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

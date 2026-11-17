# AS-IS 실측 요약 — DMF0049

- 실행: 2026-11-12 18:17:33.320 ~ 2026-11-12 18:18:23.892 · 계정 jaeuk.shin · 상태 OK
- 화면: ETC Sales Reports (GSCM.DM.Plan.UIL.DMF0049_Sales_ETC_Reports)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:17:33.971 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0049 |
| 18:17:34.002 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.46 | USER_ID= |
| 18:17:34.416 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 263.96 | LOGTYPE=SpeedUp, NOTE=DMF0049
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:17:34.508 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 93.34 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:17:35.471 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 939.62 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:17:35.583 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.98 | p_lookup_type=MDF_TYPE |
| 18:17:35.814 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 199.27 | LOGTYPE=SpeedUp, NOTE=DMF0049
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:17:35.826 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.62 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:17:35.836 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 42 | 5.95 | CODE=CALENDAR_YYYY, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 18:17:35.976 | load | GSCM.DM.Master.WSL | DMF0049_GET_MEASURE | 3 | 8.27 | p_division_id=40 |
| 18:17:35.989 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 11 | 4.16 | p_lookup_type=DM_COMPANY |
| 18:17:36.148 | load | GSCM.DM.Master.WSL | DMF0049_GET_SPREAD_TITLE | 41 | 147.7 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 18:17:36.191 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 32.54 | Code=DMF0044_MDF_DEPARTMENT, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.228 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 30.24 | Code=DMF0044_DEPARTMENT_TEAM2, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.241 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.36 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.258 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 8.98 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.286 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 18.73 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_MODEL, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.294 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.63 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.302 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.99 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.311 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 4.54 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.318 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.39 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_BIZ_TYPE, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.66 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.339 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 4.09 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.349 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 5.67 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.358 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 5.0 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:36.368 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.73 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:17:37.416 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 950.55 | MenuID=ETC Sales Reports, CnntCode=0104001, UserID=jaeuk.shin |
| 18:17:37.491 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0049 |
| 18:17:45.815 | find | GSCM.DM.Master.WSL | DMF0048_GET_DM_PLN_SALES_MONITORING | 1131 | 59541.47 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_now_yyyymmdd=20261112, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biztype=ALL, p_owner=, p_internal_yn=N, p_userinfo=ADMIN, p |
| 18:18:23.237 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.13 | MenuID=ETC Sales Reports, CnntCode=0104002, UserID=jaeuk.shin |

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

## 대화상자

- 2026-11-12 18:17:45.526 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)

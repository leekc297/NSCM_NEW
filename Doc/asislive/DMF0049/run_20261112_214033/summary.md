# AS-IS 실측 요약 — DMF0049

- 실행: 2026-11-12 21:40:33.427 ~ 2026-11-12 21:41:23.034 · 계정 jaeuk.shin · 상태 OK
- 화면: ETC Sales Reports (GSCM.DM.Plan.UIL.DMF0049_Sales_ETC_Reports)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:40:33.779 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0049 |
| 21:40:33.803 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.0 | USER_ID= |
| 21:40:33.868 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.11 | LOGTYPE=SpeedUp, NOTE=DMF0049
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:40:33.904 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.01 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:40:33.929 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.06 | p_lookup_type=MDF_TYPE |
| 21:40:33.984 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.42 | LOGTYPE=SpeedUp, NOTE=DMF0049
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:40:33.989 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.27 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:40:33.998 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 42 | 4.99 | CODE=CALENDAR_YYYY, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 21:40:34.111 | load | GSCM.DM.Master.WSL | DMF0049_GET_MEASURE | 3 | 38.91 | p_division_id=40 |
| 21:40:34.118 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 11 | 2.88 | p_lookup_type=DM_COMPANY |
| 21:40:34.182 | load | GSCM.DM.Master.WSL | DMF0049_GET_SPREAD_TITLE | 41 | 58.25 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 21:40:34.208 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 20.92 | Code=DMF0044_MDF_DEPARTMENT, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.234 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 17.29 | Code=DMF0044_DEPARTMENT_TEAM2, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.248 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.54 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.264 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.15 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.279 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 36 | 5.73 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_MODEL, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 5.44 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.57 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.303 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.5 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.28 | Code=DM_LOOKUP_DIV, Param1=40, Param2=DM_SR_ETC_BIZ_TYPE, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.316 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.42 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.325 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.6 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.332 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.02 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.342 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 6.1 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.352 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.43 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:40:34.420 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 51.2 | MenuID=ETC Sales Reports, CnntCode=0104001, UserID=jaeuk.shin |
| 21:40:34.452 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0049 |
| 21:41:22.344 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.33 | MenuID=ETC Sales Reports, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 21:40:43.643 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)

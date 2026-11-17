# AS-IS 실측 요약 — DMF0044

- 실행: 2026-11-12 21:39:43.232 ~ 2026-11-12 21:40:33.186 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Reports (GSCM.DM.Plan.UIL.DMF0044_Sales_Reports)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:39:43.668 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0044 |
| 21:39:43.691 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.61 | USER_ID= |
| 21:39:43.787 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.8 | LOGTYPE=SpeedUp, NOTE=DMF0044
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:39:43.791 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.93 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:39:43.820 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.41 | LOGTYPE=SpeedUp, NOTE=DMF0044
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:39:43.824 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.65 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:39:43.867 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 39.24 | p_lookup_type=MDF_TYPE |
| 21:39:43.942 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 42 | 64.86 | CODE=CALENDAR_YYYY, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 21:39:44.032 | load | GSCM.DM.Master.WSL | DMF0044_GET_MEASURE | 2 | 24.45 | p_Data_Type= |
| 21:39:44.039 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 3.07 | p_lookup_type=MDF_TYPE2 |
| 21:39:44.052 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 11 | 2.97 | p_lookup_type=DM_COMPANY |
| 21:39:44.144 | load | GSCM.DM.Master.WSL | DMF0044_GET_SPREAD_TITLE | 43 | 86.08 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 21:39:44.158 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 5.26 | p_program_id=DMF0044, p_user_id=jaeuk.shin, p_sheet_name=MDF Reports |
| 21:39:44.185 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 20.32 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.222 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 24.75 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.249 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 20.15 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.274 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 19.76 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.283 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 5.12 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.65 | Code=CURRENCY_LIST, Param1=, Param2=160, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 21:39:44.301 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.69 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.76 | Code=DM_LOOKUP_DIV, Param1=40, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 21:39:44.315 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.61 | Code=DM_BIZ_TYPE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.323 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.75 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.354 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 28.57 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.400 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 40.72 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.408 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.39 | Code=DMF0044_MDF_MEASURE, Param1=, Param2=600, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 21:39:44.414 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.23 | Code=FCST_TYPE, Param1=, Param2=60, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 21:39:44.423 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.18 | Code=DM_LOOKUP_DIV, Param1=DM_ITEM_USE, Param2=, Param3=40, Param4=, Param5=Y, TimeZone=AS054 |
| 21:39:44.448 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 6.76 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.462 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.26 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.474 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.42 | Code=CUST_GROUP_DTL, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.482 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.41 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.489 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.99 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.64 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 21:39:44.505 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 4.36 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.512 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.38 | Code=DM_LOOKUP_DIV, Param1=40, Param2=40, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 21:39:44.519 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.39 | Code=DM_BIZ_TYPE, Param1=40, Param2=40, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.526 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.68 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.534 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.49 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.542 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.14 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:39:44.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.69 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 21:39:44.662 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 93.43 | MenuID=Sales Reports, CnntCode=0104001, UserID=jaeuk.shin |
| 21:39:44.698 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.73 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0044 |
| 21:40:32.510 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.47 | MenuID=Sales Reports, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| SP Version | txtSPVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Report Type | clbType |  |
| Year | usrYear |  |
| Data Type | usrDataType |  |
| layoutControlItem4 | btnMeasure |  |
| Exchange Rate | btnExchangeRate |  |
| Div | clbDivision |  |
| Text 입력 | btnTextbox |  |

## 그리드

- spdMain / MDF Reports: 행 0 · 컬럼 44(보임 43) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 21:39:54.270 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)

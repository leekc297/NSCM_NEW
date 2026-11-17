# AS-IS 실측 요약 — DMF0044

- 실행: 2026-11-12 18:16:11.014 ~ 2026-11-12 18:16:35.489 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Reports (GSCM.DM.Plan.UIL.DMF0044_Sales_Reports)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:16:11.455 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0044 |
| 18:16:11.478 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.54 | USER_ID= |
| 18:16:11.626 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 61.15 | LOGTYPE=SpeedUp, NOTE=DMF0044
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:16:11.638 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.62 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:16:12.335 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 685.16 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:16:12.483 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 42.52 | LOGTYPE=SpeedUp, NOTE=DMF0044
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:16:12.504 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.72 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:16:12.558 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 47.23 | p_lookup_type=MDF_TYPE |
| 18:16:12.579 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 42 | 5.3 | CODE=CALENDAR_YYYY, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 18:16:12.718 | load | GSCM.DM.Master.WSL | DMF0044_GET_MEASURE | 2 | 4.88 | p_Data_Type= |
| 18:16:12.724 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 3.26 | p_lookup_type=MDF_TYPE2 |
| 18:16:12.757 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 11 | 3.05 | p_lookup_type=DM_COMPANY |
| 18:16:13.141 | load | GSCM.DM.Master.WSL | DMF0044_GET_SPREAD_TITLE | 43 | 375.77 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 18:16:13.152 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 4.58 | p_program_id=DMF0044, p_user_id=jaeuk.shin, p_sheet_name=MDF Reports |
| 18:16:13.174 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 8.06 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.188 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.99 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.200 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.88 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.214 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.48 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.223 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.03 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.231 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.72 | Code=CURRENCY_LIST, Param1=, Param2=160, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 18:16:13.243 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.63 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.253 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.49 | Code=DM_LOOKUP_DIV, Param1=40, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:16:13.260 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.65 | Code=DM_BIZ_TYPE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.269 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.79 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.278 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.81 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.287 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.68 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.297 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.94 | Code=DMF0044_MDF_MEASURE, Param1=, Param2=600, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 18:16:13.306 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.88 | Code=FCST_TYPE, Param1=, Param2=60, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:16:13.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.94 | Code=DM_LOOKUP_DIV, Param1=DM_ITEM_USE, Param2=, Param3=40, Param4=, Param5=Y, TimeZone=AS054 |
| 18:16:13.342 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.55 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.361 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 7.52 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.383 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.48 | Code=CUST_GROUP_DTL, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.395 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.47 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.403 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.56 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.415 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.37 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 18:16:13.423 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 4.11 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.431 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.31 | Code=DM_LOOKUP_DIV, Param1=40, Param2=40, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 18:16:13.439 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.45 | Code=DM_BIZ_TYPE, Param1=40, Param2=40, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.444 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 5.86 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.456 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.77 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.470 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 8.7 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:16:13.475 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.6 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 18:16:13.770 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 269.17 | MenuID=Sales Reports, CnntCode=0104001, UserID=jaeuk.shin |
| 18:16:13.839 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.48 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0044 |
| 18:16:34.800 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.06 | MenuID=Sales Reports, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 18:16:21.935 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)

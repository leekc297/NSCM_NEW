# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-12 20:51:00.160 ~ 2026-11-12 20:51:52.646 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:51:00.595 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 20:51:00.618 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.31 | USER_ID= |
| 20:51:00.874 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.16 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:51:00.903 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.23 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:51:01.353 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 443.51 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:51:01.503 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.16 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:51:01.541 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.27 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:51:02.249 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 656.59 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:02.258 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.16 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:51:02.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 643.5 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:02.913 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.11 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 20:51:02.921 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.96 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 20:51:02.932 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.83 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 20:51:02.939 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.78 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 20:51:02.947 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.8 |  |
| 20:51:02.987 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.22 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.015 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 23.5 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 20:51:03.048 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.99 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.057 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 3.78 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 20:51:03.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 15.71 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.108 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.31 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.116 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.08 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 20:51:03.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.52 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.135 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.53 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.146 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.3 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.172 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.31 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.180 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 3.77 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 20:51:03.190 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.12 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.216 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 21.19 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.225 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.51 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.244 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 9.58 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.253 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.42 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 20:51:03.262 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.98 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.278 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.6 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.286 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.33 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 20:51:03.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.31 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.312 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.81 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.320 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.87 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 20:51:03.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.0 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.343 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.76 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.351 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.26 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 20:51:03.359 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.71 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.373 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 9.02 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.387 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 9.9 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:51:03.418 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 23.54 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.433 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.63 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.441 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.89 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 20:51:03.448 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.32 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.462 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.29 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.469 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.86 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:51:03.484 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.02 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.492 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.71 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 20:51:03.500 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.61 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.516 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.54 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:03.523 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.78 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 20:51:03.530 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.2 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:03.623 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 70.39 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 20:51:03.688 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 2.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 20:51:50.667 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.86 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 20:51:50.680 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 3.95 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:51:51.348 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 663.93 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.356 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.3 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 20:51:51.363 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.55 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 20:51:51.380 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.83 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.393 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.52 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 20:51:51.403 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.45 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.417 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 6.95 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.429 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.85 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.460 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 11.08 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.469 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.77 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 20:51:51.478 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.62 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.496 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 9.59 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.506 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.75 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 20:51:51.517 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.76 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.534 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.42 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.543 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.94 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 20:51:51.551 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.566 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.87 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.574 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.94 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 20:51:51.582 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.32 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.597 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 9.34 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.607 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 3.81 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:51:51.618 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.26 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.649 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 20.26 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.657 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.8 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 20:51:51.666 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.23 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.682 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 8.48 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.691 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.66 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:51:51.710 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 9.0 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.719 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.9 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 20:51:51.729 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.74 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.748 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 40 | 10.24 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20261213 |
| 20:51:51.757 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.64 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 20:51:51.766 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.77 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.779 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.44 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:51.950 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 163.2 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Shipment Date | drpPeriod2 |  |
| Requestor | txtRequestor |  |
| layoutControlItem9 | btnRequestor |  |
| Model | txtModel2 |  |
| layoutControlItem5 | btnItemID2 |  |
| Result Type | clbResultType |  |
| Shipment Date | drpPeriod3 |  |
| layoutControlItem6 | btnSearch |  |
| Lot ID | txtLotID |  |
| From Site | clbPlantSite |  |
| Plan date* | cboPlanDate | Y |
| Period* | drpPeriod | Y |
| layoutControlItem10 | btnMeasure |  |
| Bucket | cboBucketType |  |
| layoutControlItem8 | chkSum |  |
| Div* | clbDivision | Y |
| layoutControlItem8 | chkMyModel |  |
| layoutControlItem2 | btnItemId |  |
| Model | txtItemId |  |
| layoutControlItem8 | chkPartLeader |  |
| layoutControlItem8 | chkTeamLeader |  |
| layoutControlItem8 | chkDelegateeModel |  |

## 그리드

- spdMain / Shipment PSI(Mobility & IT): 행 0 · 컬럼 58(보임 42) · 헤더 3단 · 고정 컬럼 17
- spdMain / Shipment PSI(Packer): 행 0 · 컬럼 55(보임 40) · 헤더 3단 · 고정 컬럼 15
- spdDetail / Shipment Confirm Detail: 행 0 · 컬럼 68(보임 39) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Shipment Request Detail: 행 0 · 컬럼 35(보임 34) · 헤더 1단 · 고정 컬럼 0
- spdDetail / W/H stock: 행 0 · 컬럼 20(보임 19) · 헤더 1단 · 고정 컬럼 0
- spdDetail / W/H stock Detail: 행 0 · 컬럼 26(보임 25) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Hold stock: 행 0 · 컬럼 13(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Hold stock Detail: 행 0 · 컬럼 13(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Stock Detail: 행 0 · 컬럼 27(보임 26) · 헤더 1단 · 고정 컬럼 0
- spdDetail / SCS Stock Detail: 행 0 · 컬럼 10(보임 9) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Stock Location Detail: 행 0 · 컬럼 21(보임 20) · 헤더 1단 · 고정 컬럼 0
- spdDetail / WH In Plan Detail: 행 0 · 컬럼 13(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Shipment Result: 행 0 · 컬럼 20(보임 19) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 20:51:12.890 [GSCM] Plan date* 값은 필수 입력입니다 → default_button(id=1)

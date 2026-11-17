# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-14 23:18:32.984 ~ 2026-11-14 23:19:45.622 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "index": "1"}, {"name": "clbDivision", "index": "0"}, {"name": "clbDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:18:34.390 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 23:18:34.437 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.75 | USER_ID= |
| 23:18:35.083 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 84.33 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 23:18:35.090 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.9 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:18:35.572 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 439.21 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 23:18:36.045 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.81 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 23:18:36.045 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.72 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:18:36.849 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 693.78 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:36.862 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.43 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:18:37.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 642.24 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:37.542 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 5.03 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:18:37.542 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.58 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:18:37.578 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.22 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:18:37.590 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.37 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:18:37.600 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.07 |  |
| 23:18:37.698 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.39 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:37.737 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 27.32 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 23:18:37.843 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.04 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 23:18:37.843 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.08 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:37.874 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 3.84 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:37.937 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.22 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:37.954 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.04 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 23:18:37.970 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.38 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:37.985 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.57 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:37.986 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.33 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.062 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.84 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.078 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.14 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 23:18:38.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.75 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 22.24 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.138 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.67 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.164 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.12 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.175 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.38 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 23:18:38.190 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.85 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.221 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.32 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.234 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.0 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 23:18:38.250 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.32 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.269 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.85 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.288 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.99 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 23:18:38.301 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.72 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.326 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.87 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.332 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.06 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 23:18:38.348 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.364 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.31 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.379 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.38 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 23:18:38.404 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 14.45 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.439 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.68 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.447 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.06 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 23:18:38.460 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.34 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.477 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.5 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.492 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.2 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 23:18:38.527 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.05 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.541 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 23:18:38.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.572 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.65 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 23:18:38.572 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.23 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20261215 |
| 23:18:38.588 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.27 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:38.992 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 98.59 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 23:18:39.217 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 3.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 23:18:48.935 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 4.47 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:18:49.576 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 641.78 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:49.594 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.78 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:18:49.608 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.28 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:18:49.624 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 6.18 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:18:49.641 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.09 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:18:54.273 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 5.04 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:18:54.913 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 636.69 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:18:54.913 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.0 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:18:54.931 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.99 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:18:59.735 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 4.98 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:19:00.388 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 645.41 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:00.400 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.68 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:19:00.410 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.63 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 23:19:00.440 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.81 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:19:00.453 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.44 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:19:07.351 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.97 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:07.359 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.84 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 23:19:07.399 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.31 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:07.413 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.59 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 23:19:07.429 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.23 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:07.429 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.12 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:07.457 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.28 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:09.015 | find | GSCM.SSP.Plan.WSL | SSP0015_GET_SHIPMENT_PSI | 0 | 1499.74 | p_division_id=81, p_from_site=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261109, p_user_id=jaeuk.shin, p_myModelChk=N, p_program_id=SSP0015, p_sheet_name=Shipment PSI(Mobility & IT), debug_mode=F, p_seq=1, p_partLeaderChk=N, p_teamLeaderCh |
| 23:19:43.457 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.41 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 23:19:43.504 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 4.34 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:19:44.141 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 632.86 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.141 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.08 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:19:44.157 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.09 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:19:44.175 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.95 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:19:44.189 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.16 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 23:19:44.205 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.22 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.220 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 7.58 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 23:19:44.241 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.21 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.255 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.88 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.270 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.76 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.332 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.8 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.339 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.5 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 23:19:44.349 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.57 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.378 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.72 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.390 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.5 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 23:19:44.400 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.64 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.422 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.19 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.438 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.53 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 23:19:44.449 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.78 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.469 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.97 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.473 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.24 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 23:19:44.492 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.79 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.502 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.06 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.526 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 5.6 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 23:19:44.539 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.65 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.561 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.28 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.571 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.83 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 23:19:44.581 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.45 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.600 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.44 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.611 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.41 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 23:19:44.643 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.76 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.652 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.12 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 23:19:44.664 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.53 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.674 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.22 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 23:19:44.699 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.3 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 23:19:44.709 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.727 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.51 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:19:44.752 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 10.48 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

- spdMain / Shipment PSI(Mobility & IT): 행 0 · 컬럼 59(보임 42) · 헤더 3단 · 고정 컬럼 17
- spdMain / Shipment PSI(Packer): 행 0 · 컬럼 56(보임 40) · 헤더 3단 · 고정 컬럼 15
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

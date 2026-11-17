# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-13 05:33:40.087 ~ 2026-11-13 05:34:45.513 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "index": "1"}, {"name": "clbDivision", "index": "0"}, {"name": "clbDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:33:40.461 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:33:40.486 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.78 | USER_ID= |
| 05:33:40.714 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.01 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:33:40.744 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.06 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:33:40.802 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 50.68 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:33:40.806 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:33:41.509 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 640.33 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:41.520 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.06 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:33:42.173 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 648.44 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.182 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.28 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:33:42.188 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.4 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:33:42.202 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.31 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:33:42.208 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.64 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:33:42.222 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.35 |  |
| 05:33:42.261 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.95 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.272 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.22 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:33:42.310 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.81 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.319 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.32 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 05:33:42.338 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 3.61 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.368 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.29 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.379 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 4.88 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:33:42.389 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.61 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.400 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.46 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.414 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.19 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.448 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.51 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.456 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 3.84 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 05:33:42.468 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.53 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.476 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.29 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.483 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.43 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.501 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.12 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.508 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.54 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:33:42.517 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.46 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.533 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.06 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.541 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.02 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:33:42.554 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 9.67 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.573 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.47 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.580 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.75 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:33:42.588 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.19 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.607 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.27 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.615 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.9 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:33:42.622 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.44 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.637 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 7.93 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.645 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:33:42.656 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.24 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.672 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.28 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.680 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.69 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:33:42.689 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.05 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.702 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.42 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.710 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.93 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:33:42.729 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.91 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.743 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 9.88 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:33:42.750 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.29 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.766 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.05 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:33:42.774 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.7 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:33:42.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.24 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:42.905 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 103.52 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 05:33:42.999 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 11.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:33:56.239 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 3.88 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:33:56.883 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 640.9 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:56.892 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.83 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:33:56.902 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.8 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:33:56.926 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.3 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:33:56.936 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.48 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:33:59.731 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.15 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:34:00.399 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 663.82 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:00.407 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.72 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:00.415 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.69 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:03.054 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 4.05 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:34:03.729 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 671.78 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:03.737 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.85 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:34:03.744 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.84 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:34:03.757 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.84 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:03.764 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.81 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:08.036 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.63 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:08.045 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.15 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:34:08.079 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.0 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:08.097 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 6.66 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:34:08.107 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.4 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:08.117 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.25 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:08.126 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.12 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:10.424 | find | GSCM.SSP.Plan.WSL | SSP0015_GET_SHIPMENT_PSI | 0 | 2277.51 | p_division_id=81, p_from_site=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261109, p_user_id=jaeuk.shin, p_myModelChk=N, p_program_id=SSP0015, p_sheet_name=Shipment PSI(Mobility & IT), debug_mode=F, p_seq=1, p_partLeaderChk=N, p_teamLeaderCh |
| 05:34:43.731 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.8 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 05:34:43.796 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 3.86 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:34:44.439 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 639.13 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.445 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.88 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:44.451 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.62 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:44.462 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.77 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:44.467 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.72 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:34:44.479 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.17 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.492 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.48 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:34:44.501 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.01 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.509 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.522 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.23 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.562 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.84 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.570 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.62 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:34:44.579 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.1 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.596 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.19 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.604 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.8 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:34:44.613 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.29 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.633 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.27 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.643 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.6 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:34:44.649 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.12 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.666 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.7 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.675 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.8 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:34:44.682 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.13 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.696 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.09 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.703 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 3.86 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:34:44.712 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.08 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.730 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.18 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.738 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:34:44.747 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.23 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.761 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.38 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.768 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.51 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:34:44.786 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.92 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.795 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.92 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:34:44.803 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.98 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.819 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.95 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:34:44.827 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.35 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:34:44.834 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.38 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.844 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.83 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:44.862 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 10.96 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

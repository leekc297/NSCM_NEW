# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-13 00:43:08.795 ~ 2026-11-13 00:44:14.848 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "index": "1"}, {"name": "clbDivision", "index": "0"}, {"name": "clbDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:43:09.235 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 00:43:09.257 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.0 | USER_ID= |
| 00:43:09.537 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 101.45 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 00:43:09.607 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 69.13 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:43:11.375 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 1741.09 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 00:43:11.564 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 21.13 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 00:43:11.799 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 234.37 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:43:12.616 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 665.42 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:12.633 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 5.03 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:43:13.326 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 682.76 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.338 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.08 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:13.344 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.74 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:13.364 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.03 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:13.371 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.87 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:13.382 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.32 |  |
| 00:43:13.424 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.73 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.464 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 30.56 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 00:43:13.497 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.18 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.506 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 5.42 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 00:43:13.571 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 59.63 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.601 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.32 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.612 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 6.27 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 00:43:13.621 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.53 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.630 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.86 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.640 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.1 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.671 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.44 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.678 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.29 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 00:43:13.687 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.55 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.721 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 30.06 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.741 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.55 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.773 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.26 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.786 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.59 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 00:43:13.799 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.86 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.824 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.01 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.836 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.61 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 00:43:13.847 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.83 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.869 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.38 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.879 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.69 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 00:43:13.886 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.61 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.905 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.16 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.919 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.44 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 00:43:13.933 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.96 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:13.952 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.7 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:13.964 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.17 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 00:43:14.019 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 50.35 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:14.047 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.46 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:14.058 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.07 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 00:43:14.071 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.4 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:14.089 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.71 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:14.098 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.43 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 00:43:14.116 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.79 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:14.122 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.53 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 00:43:14.129 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.15 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:14.145 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.82 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 00:43:14.155 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.16 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 00:43:14.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.5 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:14.427 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 236.3 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 00:43:14.503 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 00:43:22.414 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.43 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:43:23.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 672.0 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:23.105 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.4 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:23.119 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.06 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:23.143 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.99 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:43:23.151 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.74 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:43:25.424 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.84 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:43:26.088 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 657.64 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:26.094 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.84 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:43:26.100 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.0 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:43:28.594 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 4.28 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:43:29.324 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 726.6 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:29.333 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.13 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:29.343 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.92 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 00:43:29.362 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.82 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:43:29.371 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.18 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:43:33.362 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.92 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:43:33.371 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 3.89 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 00:43:33.403 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.02 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:43:33.421 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 6.98 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 00:43:33.430 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.49 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:33.438 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.53 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:33.447 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.9 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:43:39.007 | find | GSCM.SSP.Plan.WSL | SSP0015_GET_SHIPMENT_PSI | 0 | 5536.3 | p_division_id=81, p_from_site=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261109, p_user_id=jaeuk.shin, p_myModelChk=N, p_program_id=SSP0015, p_sheet_name=Shipment PSI(Mobility & IT), debug_mode=F, p_seq=1, p_partLeaderChk=N, p_teamLeaderCh |
| 00:44:12.459 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.9 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 00:44:12.750 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 4.08 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:44:13.431 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 678.42 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.447 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.15 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:44:13.458 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.23 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:44:13.479 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.72 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:44:13.487 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.92 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 00:44:13.502 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.98 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.517 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 7.14 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 00:44:13.527 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.13 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.538 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.47 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.552 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.29 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.592 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.34 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.606 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.56 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 00:44:13.619 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.72 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.639 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.18 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.652 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.99 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 00:44:13.665 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.25 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.684 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.51 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.701 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.96 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 00:44:13.710 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.01 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.727 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.94 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.737 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.44 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 00:44:13.748 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.47 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.766 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.75 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.776 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 5.57 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 00:44:13.785 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.11 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.803 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.33 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.811 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.36 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 00:44:13.822 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.8 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.835 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.01 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.843 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.25 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 00:44:13.859 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.29 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.868 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.18 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 00:44:13.875 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.17 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.889 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.5 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 00:44:13.898 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.89 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 00:44:13.907 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.69 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.920 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.24 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:13.940 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 10.88 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

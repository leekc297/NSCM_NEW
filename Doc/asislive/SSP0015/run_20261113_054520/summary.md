# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-13 05:45:20.754 ~ 2026-11-13 05:46:17.627 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "index": "1"}, {"name": "clbDivision", "index": "0"}, {"name": "clbDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:45:21.165 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:45:21.187 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.87 | USER_ID= |
| 05:45:21.352 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 21.09 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:45:21.447 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 94.58 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:45:21.532 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 67.63 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:45:21.547 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.25 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:45:22.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 676.26 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:22.311 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 8.62 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:45:23.013 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 689.99 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.028 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.71 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:23.042 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.16 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:23.061 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.83 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:23.069 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.58 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:23.086 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 6.26 |  |
| 05:45:23.135 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.71 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.145 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.3 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:45:23.184 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.1 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.195 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.91 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 05:45:23.213 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 3.6 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.241 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.84 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.251 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.1 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:45:23.262 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.8 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.273 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.286 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.33 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.312 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.88 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.320 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.99 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 05:45:23.331 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.53 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.339 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.85 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.348 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.76 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.367 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.13 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.378 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.89 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:45:23.390 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.62 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.407 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.06 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.416 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.0 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:45:23.423 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.82 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.440 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.32 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.450 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:45:23.457 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.62 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.475 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.12 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.483 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.2 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:45:23.493 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.64 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.515 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 14.27 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.523 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 3.89 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:45:23.532 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.46 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.555 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 15.78 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.566 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 6.28 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:45:23.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.14 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.588 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.25 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.597 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.66 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:45:23.615 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.5 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.622 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.47 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:45:23.630 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.83 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.644 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.32 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:45:23.654 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.08 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:45:23.663 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.65 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:23.693 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.31 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 05:45:23.761 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 5.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:45:31.983 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.44 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:45:32.686 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 693.3 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:32.700 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.32 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:32.714 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.27 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:32.726 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.79 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:45:32.732 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.75 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:45:35.535 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.48 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:45:36.205 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 660.77 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:36.220 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.64 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:45:36.237 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 5.42 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:45:39.256 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.97 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:45:39.946 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 680.58 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:39.953 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.39 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:39.959 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.85 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:45:39.974 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.69 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:45:39.981 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.11 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:45:44.225 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.32 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:45:44.240 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.85 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:45:44.306 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 28.03 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:45:44.330 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 6.07 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:45:44.347 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.94 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:44.361 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.08 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:44.374 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.84 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:45.949 | find | GSCM.SSP.Plan.WSL | SSP0015_GET_SHIPMENT_PSI | 0 | 1553.68 | p_division_id=81, p_from_site=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261109, p_user_id=jaeuk.shin, p_myModelChk=N, p_program_id=SSP0015, p_sheet_name=Shipment PSI(Mobility & IT), debug_mode=F, p_seq=1, p_partLeaderChk=N, p_teamLeaderCh |
| 05:46:15.522 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.15 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 05:46:15.613 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 6.02 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:46:16.292 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 675.8 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.332 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.96 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:46:16.340 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.97 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:46:16.352 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.11 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:46:16.359 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.94 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:46:16.371 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.47 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.383 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.76 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:46:16.395 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.4 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.409 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.99 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.422 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.31 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.454 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.32 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.462 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.64 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:46:16.474 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 6.22 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.490 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.55 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.502 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.73 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:46:16.516 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.56 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.538 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.08 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.551 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.46 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:46:16.562 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.74 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.581 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.97 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.593 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.26 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:46:16.606 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.65 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.626 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.6 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.635 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.26 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:46:16.651 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.99 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.673 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.32 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.681 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.99 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:46:16.691 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.14 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.705 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.02 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.712 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.56 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:16.733 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.52 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.740 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.64 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:46:16.750 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.39 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.770 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 14.53 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:46:16.782 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.59 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:46:16.794 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.05 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.807 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.46 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:16.824 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 10.58 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

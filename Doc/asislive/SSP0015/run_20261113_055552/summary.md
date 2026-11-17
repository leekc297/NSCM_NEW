# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-13 05:55:52.602 ~ 2026-11-13 05:56:50.258 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "index": "1"}, {"name": "clbDivision", "index": "0"}, {"name": "clbDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:55:53.015 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:55:53.041 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.16 | USER_ID= |
| 05:55:53.198 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.98 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:55:53.228 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.87 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:55:53.686 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 442.44 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:55:53.877 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.22 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:55:53.899 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.96 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:55:54.609 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 666.12 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:54.620 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 5.08 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:55:55.303 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 680.5 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.323 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 6.26 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:55:55.340 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.88 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:55:55.384 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 7.95 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:55:55.395 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.0 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:55:55.437 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 5.94 |  |
| 05:55:55.547 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 12.91 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.558 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 5.37 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:55:55.608 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.62 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.617 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 5.07 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 05:55:55.629 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 3.58 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.665 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.87 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.676 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 6.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:55:55.694 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.2 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.710 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.89 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.724 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.29 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.755 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.38 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.763 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.74 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 05:55:55.773 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.7 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.780 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.39 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.787 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.5 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.806 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.75 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.817 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.14 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:55:55.827 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.72 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.848 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.62 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.857 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.42 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:55:55.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.16 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.888 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 17.18 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.896 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.95 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:55:55.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.21 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.919 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.33 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.927 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.44 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:55:55.936 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.68 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.952 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.87 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.961 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 3.72 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:55:55.970 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.54 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:55.986 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.3 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:55.994 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.61 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:55:56.002 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.1 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:56.018 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.97 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:56.025 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.2 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:55:56.043 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.6 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:56.051 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.38 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:55:56.059 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.47 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:56.075 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.06 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:55:56.085 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.48 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:55:56.094 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.2 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:55:56.123 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.85 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 05:55:56.187 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:56:04.536 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.43 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:56:05.205 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 659.62 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:05.211 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.61 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:56:05.218 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.22 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:56:05.231 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.58 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:05.237 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.52 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:08.044 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.18 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:56:08.692 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 642.96 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:08.705 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.83 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:08.719 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.16 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:11.549 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.06 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:56:12.227 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 666.7 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:12.243 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.75 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:56:12.259 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.15 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:56:12.301 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.18 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:12.323 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.82 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:16.906 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.59 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:16.937 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 25.32 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:56:16.973 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.22 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:17.011 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 31.07 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:56:17.020 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.92 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:17.030 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.17 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:17.069 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 31.43 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:18.542 | find | GSCM.SSP.Plan.WSL | SSP0015_GET_SHIPMENT_PSI | 0 | 1399.26 | p_division_id=81, p_from_site=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261109, p_user_id=jaeuk.shin, p_myModelChk=N, p_program_id=SSP0015, p_sheet_name=Shipment PSI(Mobility & IT), debug_mode=F, p_seq=1, p_partLeaderChk=N, p_teamLeaderCh |
| 05:56:48.329 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.18 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 05:56:48.365 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.37 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:56:49.027 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 657.42 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.034 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.63 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:49.041 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.55 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:49.052 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.21 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:49.059 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.78 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 05:56:49.072 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.21 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.085 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.26 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:56:49.097 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.32 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.109 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.39 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.119 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.32 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.150 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.71 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.160 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.76 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:56:49.169 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.95 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.185 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.68 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.193 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.86 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:56:49.202 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.26 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.218 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.05 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.228 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.4 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:56:49.235 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.252 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.08 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.261 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.53 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:56:49.269 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.36 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.285 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.69 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.293 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.66 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:56:49.302 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.67 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.320 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.71 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.331 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 5.58 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:56:49.344 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.17 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.364 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 12.7 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.375 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.94 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:56:49.397 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.37 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.405 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.08 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:56:49.430 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 17.75 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.454 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.14 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 05:56:49.467 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.67 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:56:49.483 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.29 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.499 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.96 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:56:49.517 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 9.8 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

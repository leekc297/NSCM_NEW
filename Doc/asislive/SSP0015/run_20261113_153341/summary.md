# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-13 15:33:41.850 ~ 2026-11-13 15:34:46.350 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbDivision", "index": "1"}, {"name": "clbDivision", "index": "0"}, {"name": "clbDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 15:33:42.837 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 15:33:42.874 | load | GSCM.BizService.WSL | SELECT * | 874 | 26.83 | USER_ID= |
| 15:33:43.209 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 84.16 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 15:33:43.223 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.67 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 15:33:44.081 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 835.23 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 15:33:44.396 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 6.73 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 15:33:44.402 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.68 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 15:33:45.173 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 716.67 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:45.189 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 5.92 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:33:45.913 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 717.15 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:45.952 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.06 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:33:45.966 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 5.49 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:33:45.986 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 6.13 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:33:45.996 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.52 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:33:46.038 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 5.47 |  |
| 15:33:46.146 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.11 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.221 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 34.09 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 15:33:46.269 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.43 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.285 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 8.54 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 15:33:46.299 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 4.47 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.332 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.81 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.346 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 7.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 15:33:46.360 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.4 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.375 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.85 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.391 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.75 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.442 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.77 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.460 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 7.6 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 15:33:46.480 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.49 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.43 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.513 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.91 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.542 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 12.21 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.555 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 6.13 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 15:33:46.566 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.23 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.592 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.6 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.604 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.42 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 15:33:46.616 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.94 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.636 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.49 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.646 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.31 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 15:33:46.659 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.47 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.678 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.02 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.689 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.86 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 15:33:46.700 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.04 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.719 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.91 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.729 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.42 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 15:33:46.745 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.22 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.764 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.05 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.777 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 6.31 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 15:33:46.787 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.56 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.803 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.09 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.818 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.24 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 15:33:46.845 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.82 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.858 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.28 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 15:33:46.870 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.72 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:46.893 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.91 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 15:33:46.905 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.86 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 15:33:46.917 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.69 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:47.225 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 108.75 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 15:33:47.438 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 2.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 15:33:56.972 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.73 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:33:57.657 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 677.87 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:33:57.671 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 7.73 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:33:57.683 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 5.21 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:33:57.714 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.17 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:33:57.730 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 6.56 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:00.876 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 5.3 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:34:01.606 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 723.4 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:01.615 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.03 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:01.624 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.81 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:04.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 5.02 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:34:05.666 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 750.06 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:05.680 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.49 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:34:05.698 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.1 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 15:34:05.723 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.31 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:05.736 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.03 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:10.925 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.71 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:10.940 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 6.18 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 15:34:10.994 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.91 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:11.015 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 7.02 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 15:34:11.032 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.71 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:11.047 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.2 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:11.067 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.69 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:11.463 | find | GSCM.SSP.Plan.WSL | SSP0015_GET_SHIPMENT_PSI | 0 | 325.63 | p_division_id=81, p_from_site=, p_item_id=, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261109, p_user_id=jaeuk.shin, p_myModelChk=N, p_program_id=SSP0015, p_sheet_name=Shipment PSI(Mobility & IT), debug_mode=F, p_seq=1, p_partLeaderChk=N, p_teamLeaderCh |
| 15:34:43.815 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.38 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 15:34:43.873 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 13 | 3.72 | Code=ShipmentRequestPlantSite, Param1=81, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 15:34:44.576 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 696.42 | Code=PlanDateShip, Param1=81, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:44.651 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 17.96 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:44.694 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.96 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:44.735 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 5.65 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:44.750 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.57 | p_from_date=20261009, p_offset_day=31, p_timezone=AS054 |
| 15:34:44.768 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.37 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:44.785 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 7.09 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 15:34:44.799 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.78 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:44.814 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.75 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:44.829 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.04 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:44.894 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.59 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:44.907 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.06 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 15:34:44.918 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.46 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:44.942 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.63 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:44.955 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.06 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 15:34:44.968 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.21 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:44.996 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.47 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.007 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.49 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 15:34:45.019 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.01 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.045 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.05 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.062 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.31 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 15:34:45.076 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.16 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.107 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 12.59 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.123 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 5.42 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 15:34:45.146 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.96 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.178 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.29 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.194 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.59 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 15:34:45.205 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.68 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.227 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.11 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.239 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.21 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 15:34:45.267 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.71 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.281 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.4 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 15:34:45.297 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.41 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.325 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.34 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261109 |
| 15:34:45.339 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.66 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 15:34:45.363 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.68 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.403 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.55 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 15:34:45.424 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 10.59 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

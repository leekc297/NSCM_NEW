# AS-IS 실측 요약 — SSP0015

- 실행: 2026-11-13 05:49:42.613 ~ 2026-11-13 05:50:43.979 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0015_ShipmentPSI)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "clbDivision", "prop": "ControlValues", "value": "40", "param": "division_id", "from": "81", "sheet": "main"}, {"name": "dp2", "prop": "Value", "value": "20261110", "param": "to_yyyymmdd", "from": "20261109", "sheet": "main"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:49:43.053 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:49:43.080 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.34 | USER_ID= |
| 05:49:43.255 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.04 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:49:43.259 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.59 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:49:43.739 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 465.73 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:49:43.906 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.49 | LOGTYPE=SpeedUp, NOTE=SSP0015
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:49:43.912 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.0 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:49:44.589 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 643.57 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:44.599 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 3.81 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:45.247 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 644.59 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.264 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.0 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:49:45.275 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.6 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:49:45.289 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.37 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:49:45.297 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.86 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:49:45.308 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 7.04 |  |
| 05:49:45.361 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 23.89 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.370 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 4.52 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Mobility & IT) |
| 05:49:45.403 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.99 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.412 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.94 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment PSI(Packer) |
| 05:49:45.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 3.95 | Code=Measure, Param1=SSP0015, Param2=Shipment PSI(Packer), Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.446 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.06 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.456 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 5.02 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:49:45.466 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.46 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.477 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.36 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.486 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.42 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.517 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.01 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.528 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 5.98 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 05:49:45.537 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.41 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.546 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.63 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.553 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.99 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.571 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.71 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.581 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.6 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:49:45.592 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.66 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.612 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.5 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.622 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.76 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:49:45.633 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.98 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.654 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.92 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.664 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.8 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:49:45.675 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.03 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.694 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.04 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.706 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.22 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:49:45.715 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.23 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.734 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.69 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.747 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 4.59 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:49:45.756 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.92 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.772 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.87 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.783 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 5.08 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:49:45.794 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.71 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.813 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 10.75 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.823 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.33 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:49:45.847 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 11.3 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.859 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.72 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:49:45.868 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.27 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.886 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.89 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:49:45.895 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.46 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:49:45.906 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.07 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:45.931 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.18 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 05:49:46.019 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 9 | 6.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0015 |
| 05:50:41.878 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.81 | MenuID=Shipment Plan(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 05:50:41.891 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 4.09 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:50:42.545 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 650.08 | Code=PlanDateShip, Param1=40, Param2=A, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.564 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.57 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:50:42.577 | find | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.11 | p_from_date=, p_offset_day=31, p_timezone=AS054 |
| 05:50:42.607 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.02 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.638 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 67 | 6.06 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Confirm Detail |
| 05:50:42.664 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 10.87 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.678 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.06 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.693 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.34 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.735 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.49 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.750 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 7.29 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock |
| 05:50:42.762 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.57 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.780 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.14 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.792 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.59 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=W/H stock Detail |
| 05:50:42.804 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.54 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.825 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.85 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.834 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.63 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock |
| 05:50:42.852 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 10.5 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.872 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.88 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.883 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.04 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Hold stock Detail |
| 05:50:42.894 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.2 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.914 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.72 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.926 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 26 | 6.26 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 05:50:42.940 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.27 | Code=LookupCommon, Param1=MES_CHANGE_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.959 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.1 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:42.968 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.24 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=SCS Stock Detail |
| 05:50:42.976 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.2 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:42.991 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 9.34 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:43.001 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.46 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:50:43.024 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 12.81 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:43.038 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.89 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=WH In Plan Detail |
| 05:50:43.046 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.67 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:43.061 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 41 | 8.83 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20261214 |
| 05:50:43.071 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.05 | p_program_id=SSP0015, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:50:43.082 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.01 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:43.094 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.16 | Code=LookupCommon, Param1=SSP_SHIPMENT_RESULT_TYPE_PACKER, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:43.204 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 105.2 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |

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

## 대화상자

- 2026-11-13 05:50:03.701 [GSCM] Plan date* 값은 필수 입력입니다 → default_button(id=1)

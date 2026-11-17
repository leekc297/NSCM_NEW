# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-13 05:50:44.184 ~ 2026-11-13 05:51:09.984 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 1.628s, UI : 0.031s · 완료 판단 status
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "clbCompany_ID", "prop": "ControlValues", "value": "minyonglee1", "param": "param2", "from": "HQ00", "sheet": "division"}, {"name": "dp2", "prop": "Value", "value": "20261113", "param": "to_yyyymmdd", "from": "20261204", "sheet": "main"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:50:44.587 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 05:50:44.611 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.57 | USER_ID= |
| 05:50:44.766 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.87 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:50:44.799 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.98 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:50:45.267 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 463.14 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:50:45.454 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.09 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:50:45.458 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.44 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:50:45.480 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 16.13 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:50:45.519 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 5.76 |  |
| 05:50:45.556 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.38 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.565 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.39 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:50:45.587 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.9 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.596 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.82 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:50:45.612 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.62 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:45.625 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.39 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:45.635 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.5 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:45.658 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.81 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.666 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.29 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:50:45.682 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.43 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.691 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.52 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:50:45.700 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.06 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:45.715 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.74 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.722 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.54 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 05:50:45.739 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.71 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.746 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.05 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 05:50:45.763 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.17 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:45.771 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.25 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:50:45.778 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.24 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:45.795 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 4.9 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 05:50:45.868 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 60.14 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:50:46.073 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.71 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:46.082 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.86 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:50:46.100 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.02 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:46.111 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.83 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:50:46.121 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.44 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.149 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 12.85 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.166 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 6.16 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.188 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.71 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:46.196 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.36 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:50:46.213 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.42 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:50:46.221 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.05 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:50:46.229 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.01 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.248 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.19 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.257 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.14 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:50:46.296 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.75 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.309 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 8.87 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:50:46.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.04 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.329 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.34 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.339 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.9 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.364 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.76 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.372 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.61 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:50:46.389 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.7 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.396 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.18 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:50:46.405 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.0 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.421 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.14 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.452 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 3.86 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 05:50:46.485 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 26.8 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:50:46.513 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.76 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.523 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.38 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:50:46.541 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.97 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.551 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.81 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:50:46.559 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.44 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.571 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.94 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.582 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.43 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.605 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.51 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.613 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.85 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:50:46.630 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.04 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.637 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.09 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:50:46.646 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.04 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.663 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.99 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.671 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.68 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:50:46.706 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.15 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.716 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.86 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:50:46.726 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.09 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.737 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.15 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.746 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.55 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.769 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.26 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.778 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.92 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:50:46.796 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.96 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.803 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.08 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:50:46.812 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.93 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.829 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.55 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:50:46.874 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 11.13 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 05:50:46.940 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 05:51:01.392 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 24.33 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:51:01.424 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.92 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:51:01.437 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.07 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:51:01.476 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.04 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:51:01.485 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.77 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:51:01.493 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.47 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:01.511 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.33 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:51:01.526 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 8.23 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:51:01.536 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.67 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:01.550 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.39 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:01.560 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.67 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:01.583 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.05 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:51:01.594 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:51:01.614 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.08 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:51:01.625 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.21 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:51:01.636 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.59 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:03.249 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 1601.59 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 05:51:03.313 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.99 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=1.628, p_ui_time=0.031, p_user_id=jaeuk.shin |
| 05:51:09.298 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.99 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Shipment Date | drpPeriod2 |  |
| Requestor | txtRequestor |  |
| layoutControlItem9 | btnRequestor |  |
| layoutControlItem5 | btnItemID2 |  |
| layoutControlItem6 | btnSearch |  |
| Model | txtModel2 |  |
| Shipment Date | drpPeriod3 |  |
| Result Type | clbResultType |  |
| Box ID | txtBoxID |  |
| From Site | clbPlantSite |  |
| layoutControlItem10 | btnMeasure |  |
| layoutControlItem8 | chkSum |  |
| Div* | clbDivision_ID | Y |
| layoutControlItem2 | btnItemId |  |
| Model | txtItemId |  |
| Company* | clbCompany_ID | Y |
| Period* | drpPeriod | Y |
| Plan date* | cboPlanDate | Y |
| Simulation | btnSimulation |  |
| Bucket | cboBucketType |  |
| lblSql | chkSql |  |

## 그리드

- spdMain / Shipment Plan: 행 108 · 컬럼 85(보임 64) · 헤더 3단 · 고정 컬럼 14
- spdDetail / Shipment Plan Detail: 행 0 · 컬럼 70(보임 42) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Stock Location Detail: 행 0 · 컬럼 21(보임 20) · 헤더 1단 · 고정 컬럼 0
- spdDetail / oWMS Detail: 행 0 · 컬럼 26(보임 25) · 헤더 1단 · 고정 컬럼 0
- spdDetail / MES Stock: 행 0 · 컬럼 10(보임 9) · 헤더 1단 · 고정 컬럼 0
- spdDetail / MES Stock Detail: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Shipment Result: 행 0 · 컬럼 19(보임 18) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

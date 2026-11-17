# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-15 02:40:20.968 ~ 2026-11-15 02:41:34.096 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 02:40:45.679 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 02:40:45.716 | load | GSCM.BizService.WSL | SELECT * | 874 | 24.35 | USER_ID= |
| 02:40:45.992 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 47.26 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
start
, USER_ID=jaeuk.shin |
| 02:40:45.992 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.97 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 02:40:46.466 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 447.75 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 02:40:46.616 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.01 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
end
, USER_ID=jaeuk.shin |
| 02:40:46.622 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.75 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 02:40:46.670 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 14.78 | Param1=ADMIN, Param2=jaeuk.shin |
| 02:40:46.724 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.6 |  |
| 02:40:46.792 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.31 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:46.837 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 25.9 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 02:40:46.867 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.61 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:46.879 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.32 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:46.879 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.88 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 02:40:46.898 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.22 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:46.908 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.3 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:46.945 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.57 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:46.954 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.32 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 02:40:46.971 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.93 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:46.971 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.97 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:46.989 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.31 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.008 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.45 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.010 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.94 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 02:40:47.023 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.16 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.037 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.69 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 02:40:47.054 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.36 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.055 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.72 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 02:40:47.067 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.07 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.081 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 6.33 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 02:40:47.157 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 60.56 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:40:47.258 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.43 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.273 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.3 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 02:40:47.290 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.85 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 02:40:47.290 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.3 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.307 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.61 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.325 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.34 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.337 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.23 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.360 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.47 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.367 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.97 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 02:40:47.386 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.46 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 02:40:47.390 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.79 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:47.398 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.17 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.418 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.64 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 02:40:47.418 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.38 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.461 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.37 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.466 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.71 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 02:40:47.483 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.21 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.497 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.34 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.497 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.39 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.530 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.56 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.539 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.91 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 02:40:47.554 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.34 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.562 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.17 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.562 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.69 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:47.587 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.26 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.617 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 5.63 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 02:40:47.648 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.76 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:40:47.679 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.75 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.687 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.04 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 02:40:47.703 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.74 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.710 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.51 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 02:40:47.725 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.65 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.735 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.58 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.741 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.56 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.768 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.56 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.773 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.19 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 02:40:47.798 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.62 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.807 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.18 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:47.813 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.41 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.829 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.73 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.839 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.95 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 02:40:47.876 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.88 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.884 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.91 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 02:40:47.898 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.02 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.31 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.68 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.939 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.83 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.951 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.14 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 02:40:47.963 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.44 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:47.970 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.15 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:47.970 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.88 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:47.991 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.41 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:48.209 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 88.51 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 02:40:48.296 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 02:40:56.885 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.33 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:40:56.968 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.67 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:56.980 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.18 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 02:40:57.044 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.72 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:57.052 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.2 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:57.061 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.47 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:57.074 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.65 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:57.089 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.72 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:57.089 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.07 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 02:40:57.117 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.45 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:57.121 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:40:57.143 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.47 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:57.154 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.39 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 02:40:57.169 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.77 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 02:40:57.179 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.19 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 02:40:57.185 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.78 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 02:41:28.648 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 31432.97 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 02:41:28.789 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 29.11 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=31.495, p_ui_time=0.081, p_user_id=jaeuk.shin |

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

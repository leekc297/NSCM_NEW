# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-12 17:47:48.859 ~ 2026-11-12 17:48:29.244 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 1.704s, UI : 0.092s

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 17:48:06.348 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.3 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 17:48:06.388 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.2 | USER_ID= |
| 17:48:07.435 | load | GSCM.BizService.WSL | -- Temp Table | 12 | 442.07 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 17:48:07.853 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 13.74 | Param1=ADMIN, Param2=jaeuk.shin |
| 17:48:07.965 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.31 |  |
| 17:48:08.078 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.05 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.120 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.95 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:48:08.173 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.72 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.186 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 6.85 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:48:08.204 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.99 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:08.246 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.14 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:08.263 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.25 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:08.314 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.59 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.326 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.46 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:48:08.354 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.21 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.367 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.96 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:08.390 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.81 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:08.414 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.26 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.423 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.29 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 17:48:08.442 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.54 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.453 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.43 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 17:48:08.473 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.16 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.484 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.57 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 17:48:08.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.53 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:08.557 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 5.84 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 17:48:08.644 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 62.17 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:48:08.956 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.8 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:08.967 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.6 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:48:08.994 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.73 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:09.015 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.41 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:48:09.028 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.76 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.045 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.65 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.061 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.78 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.107 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.54 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:09.117 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.02 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:48:09.143 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.72 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:48:09.153 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.01 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:09.166 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.8 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.199 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.38 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.223 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.19 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:48:09.294 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.17 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.309 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.28 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:48:09.324 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.47 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.346 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.67 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.364 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.48 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.404 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.07 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.415 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.89 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:48:09.442 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.22 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.453 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.86 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:09.466 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.09 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.490 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.92 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.555 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 4.78 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 17:48:09.592 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.73 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:48:09.647 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.97 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.661 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.33 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:48:09.686 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.92 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.705 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.18 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:48:09.718 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.97 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.743 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.51 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.758 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.62 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.799 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.76 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.813 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.62 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:48:09.840 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.2 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.851 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.19 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:09.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.52 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:09.913 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.88 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:09.934 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.76 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:48:10.018 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.09 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:10.032 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.85 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:48:10.047 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 6.01 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:10.069 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.91 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:10.089 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.79 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:10.132 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.71 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:10.143 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.11 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:48:10.173 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 14.17 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:10.185 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.68 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:10.202 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.05 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:10.225 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.75 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:10.488 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.32 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 17:48:10.716 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 17:48:20.792 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.84 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:48:20.898 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.55 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:20.910 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.76 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:48:20.952 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.62 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:20.964 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 6.15 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:20.975 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.34 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:20.995 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.89 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:21.011 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.62 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:48:21.024 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.85 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:21.042 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.25 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:21.057 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.42 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:21.085 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.41 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:21.097 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.66 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:48:21.115 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.89 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:48:21.125 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.19 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:48:21.135 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.74 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:48:22.818 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 1668.05 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 17:48:22.973 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 30.71 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=1.704, p_ui_time=0.092, p_user_id=jaeuk.shin |

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

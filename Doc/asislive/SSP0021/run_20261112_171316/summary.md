# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-12 17:13:16.072 ~ 2026-11-12 17:13:56.276 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 1.791s, UI : 0.093s

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 17:13:37.236 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 17:13:37.268 | load | GSCM.BizService.WSL | SELECT * | 874 | 23.18 | USER_ID= |
| 17:13:38.075 | load | GSCM.BizService.WSL | -- Temp Table | 12 | 454.55 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 17:13:38.302 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 15.5 | Param1=ADMIN, Param2=jaeuk.shin |
| 17:13:38.364 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.53 |  |
| 17:13:38.429 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.7 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.459 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.44 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:13:38.484 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.03 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.498 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 10.94 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:13:38.508 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.12 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.521 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.58 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.533 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.66 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.563 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.59 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.572 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.38 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:13:38.589 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.15 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.597 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.17 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:38.607 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.62 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.626 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.83 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.634 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.78 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 17:13:38.648 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.23 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.656 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.51 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 17:13:38.670 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.41 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.677 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.76 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 17:13:38.684 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.34 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.698 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 5.99 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 17:13:38.783 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 62.7 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:13:38.881 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.91 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.889 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.89 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:13:38.906 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.26 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.917 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.48 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:13:38.926 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.52 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.939 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.87 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.948 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.52 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:38.970 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.83 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:38.978 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.91 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:13:38.994 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.19 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:13:39.002 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.95 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:39.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.13 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.025 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.75 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.033 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.3 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:13:39.065 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.98 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.076 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.31 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:13:39.085 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.17 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.099 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.4 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.111 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.51 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.134 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.94 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.143 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.3 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:13:39.166 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 11.04 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.175 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.19 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:39.184 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.89 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.204 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.66 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.234 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 5.53 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 17:13:39.267 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 24.15 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:13:39.309 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.28 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.319 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.72 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:13:39.334 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.3 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.344 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.73 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:13:39.357 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.36 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.370 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.23 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.383 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.83 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.411 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.86 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.420 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.83 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:13:39.442 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.97 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.452 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.12 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:39.463 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.03 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.484 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.26 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.493 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.09 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:13:39.535 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.43 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.546 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.11 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:13:39.556 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.96 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.570 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.82 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.582 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.37 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.612 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.42 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.621 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.06 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:13:39.639 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.21 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.648 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.25 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:39.657 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.55 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:39.678 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.11 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:39.795 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.42 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 17:13:39.888 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 17:13:48.398 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.7 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:13:48.520 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.98 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:48.532 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.28 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:13:48.577 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.29 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:48.586 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.92 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:48.596 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.25 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:48.613 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.55 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:48.623 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.38 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:13:48.634 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.68 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:48.665 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.72 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:48.676 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.4 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:48.698 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.01 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:48.707 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.94 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:13:48.724 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.1 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:13:48.732 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.92 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:13:48.741 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.74 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:13:50.523 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 1767.47 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 17:13:50.678 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 42.38 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=1.791, p_ui_time=0.093, p_user_id=jaeuk.shin |

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

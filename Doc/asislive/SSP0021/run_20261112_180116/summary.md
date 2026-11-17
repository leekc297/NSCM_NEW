# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-12 18:01:16.064 ~ 2026-11-12 18:01:54.252 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 1.676s, UI : 0.112s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:01:35.800 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 18:01:35.827 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.19 | USER_ID= |
| 18:01:36.564 | load | GSCM.BizService.WSL | -- Temp Table | 12 | 440.22 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 18:01:36.778 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 14.38 | Param1=ADMIN, Param2=jaeuk.shin |
| 18:01:36.837 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.13 |  |
| 18:01:36.906 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.12 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:36.942 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 6.13 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:01:36.971 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.4 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:36.983 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 7.26 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:01:36.991 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.88 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.007 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.66 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.021 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.66 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.049 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.59 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.059 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 6.64 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:01:37.078 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.63 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.088 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.65 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:37.100 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.72 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.120 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 12.1 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.132 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 6.82 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 18:01:37.148 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.79 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.157 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.24 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 18:01:37.173 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 11.12 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.182 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 5.69 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 18:01:37.190 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.68 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.205 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 6.23 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 18:01:37.278 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 60.61 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:01:37.384 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.34 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.392 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.06 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:01:37.408 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.75 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.419 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:01:37.428 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.36 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.439 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.21 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.448 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.46 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.473 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.09 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.481 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.36 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:01:37.496 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.49 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:01:37.504 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.82 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:37.511 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.59 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.529 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.63 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.536 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.68 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:01:37.571 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.92 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.584 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 8.14 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:01:37.594 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.01 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.603 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.16 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.613 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.38 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.633 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.78 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.643 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 6.04 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:01:37.659 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.64 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.666 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.22 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:37.675 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.43 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.691 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.64 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.721 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 4.82 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 18:01:37.750 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.15 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:01:37.788 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.21 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.796 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.06 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:01:37.811 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.38 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.823 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.18 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:01:37.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.1 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.843 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.83 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.852 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.46 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.873 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.07 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.881 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.62 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:01:37.898 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.2 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.907 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.08 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:37.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.95 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:37.930 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.31 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.937 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.68 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:01:37.975 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.89 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:37.989 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 8.81 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:01:37.998 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.19 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:38.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.38 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:38.020 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.86 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:38.042 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.42 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:38.050 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.62 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:01:38.066 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.57 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:38.075 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.89 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:38.084 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.3 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:38.100 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.47 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:38.210 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.56 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 18:01:38.318 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 18:01:46.547 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.76 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:01:46.649 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.13 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:46.659 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.67 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:01:46.712 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.79 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:46.719 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.9 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:46.729 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.92 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:46.745 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.17 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:46.761 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:01:46.769 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.46 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:46.780 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.49 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:46.789 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.35 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:46.816 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.57 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:46.825 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.76 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:01:46.840 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.19 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:01:46.849 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.09 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:01:46.856 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.23 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:01:48.518 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 1648.24 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 18:01:48.660 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.69 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=1.676, p_ui_time=0.112, p_user_id=jaeuk.shin |

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

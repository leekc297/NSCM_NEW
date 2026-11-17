# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-12 17:36:14.794 ~ 2026-11-12 17:36:53.798 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 1.704s, UI : 0.097s

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 17:36:33.400 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 17:36:33.435 | load | GSCM.BizService.WSL | SELECT * | 874 | 23.76 | USER_ID= |
| 17:36:34.459 | load | GSCM.BizService.WSL | -- Temp Table | 12 | 447.04 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 17:36:34.936 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 15.66 | Param1=ADMIN, Param2=jaeuk.shin |
| 17:36:35.010 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.24 |  |
| 17:36:35.080 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.12 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.117 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.93 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:36:35.166 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 11.23 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.181 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 6.83 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:36:35.196 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.99 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.221 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.54 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.238 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 6.58 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.279 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.42 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.291 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.28 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:36:35.316 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.08 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.329 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.67 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:35.349 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.76 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.373 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.24 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.384 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.06 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 17:36:35.403 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.72 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.411 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.96 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 17:36:35.429 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.55 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.438 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.14 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 17:36:35.449 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.85 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.472 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 7.15 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 17:36:35.578 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 61.84 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:36:35.721 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.76 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.732 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.07 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:36:35.751 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.6 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.767 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.47 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:36:35.780 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.21 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.798 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.88 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.814 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.81 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.852 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.67 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.862 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.18 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:36:35.884 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.88 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 17:36:35.895 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:35.906 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.49 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:35.931 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.11 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:35.946 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.0 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:36:36.008 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.44 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.023 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.17 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:36:36.039 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.88 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.058 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.78 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.076 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.14 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.110 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.91 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.122 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.44 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:36:36.143 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.71 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.154 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.02 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:36.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.41 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.184 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.65 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.225 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 5.36 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 17:36:36.261 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.58 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:36:36.309 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.17 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.323 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 7.05 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:36:36.350 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.65 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.364 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.89 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:36:36.378 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.86 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.394 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.82 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.407 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.432 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.78 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.445 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.98 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:36:36.466 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.95 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.476 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.46 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:36.489 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.41 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.510 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.38 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.520 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:36:36.560 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.48 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.573 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.47 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:36:36.585 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.99 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.600 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.62 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.613 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.86 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.637 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.08 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.649 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.07 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:36:36.671 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.04 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.683 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.27 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:36.697 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.87 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:36.718 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.68 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:36.859 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.43 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 17:36:36.971 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 17:36:45.669 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 24.07 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:36:45.775 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.01 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:45.787 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.43 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 17:36:45.828 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.91 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:45.839 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.53 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:45.851 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.94 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:45.873 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.84 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:45.889 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 7.2 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 17:36:45.901 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.2 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:45.917 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.17 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:45.929 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.85 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:45.966 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.25 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:45.976 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.49 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 17:36:45.995 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.54 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 17:36:46.006 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.21 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 17:36:46.016 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.58 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:36:47.705 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 1669.31 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 17:36:47.962 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 127.09 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=1.704, p_ui_time=0.097, p_user_id=jaeuk.shin |

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

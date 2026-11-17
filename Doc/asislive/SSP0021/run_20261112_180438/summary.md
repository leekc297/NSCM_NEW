# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-12 18:04:38.154 ~ 2026-11-12 18:04:57.178 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 1.707s, UI : 0.085s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:04:38.522 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 18:04:38.547 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.32 | USER_ID= |
| 18:04:39.350 | load | GSCM.BizService.WSL | -- Temp Table | 12 | 447.25 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 18:04:39.574 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 13.28 | Param1=ADMIN, Param2=jaeuk.shin |
| 18:04:39.625 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.08 |  |
| 18:04:39.671 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.65 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.680 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.33 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:04:39.701 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.43 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.710 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.08 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:04:39.722 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.86 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:39.742 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.29 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:39.753 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.06 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:39.791 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.53 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.798 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.75 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:04:39.820 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.74 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.827 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.78 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:39.835 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.41 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:39.854 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.44 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.861 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.67 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 18:04:39.874 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.28 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.882 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.62 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 18:04:39.898 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.78 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:39.904 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.59 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 18:04:39.914 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.02 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:39.932 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 5.19 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 18:04:40.010 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 61.89 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:40.116 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.31 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:40.124 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:04:40.143 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.27 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:40.154 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.6 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:04:40.163 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.2 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.173 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.04 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.184 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.46 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.207 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.45 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:40.214 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.77 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:04:40.231 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.44 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 18:04:40.239 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.49 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:40.248 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.74 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.270 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.92 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.276 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.67 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:04:40.313 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.16 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.324 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 6.08 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:04:40.333 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.31 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.343 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.35 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.353 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.49 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.378 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.07 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.386 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.93 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:04:40.406 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.41 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.413 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.51 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:40.424 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.75 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.440 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.48 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.475 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 3.97 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 18:04:40.508 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.31 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:40.550 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.26 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.558 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.63 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:04:40.578 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 11.85 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.590 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.74 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:04:40.599 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.99 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.611 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.71 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.623 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.13 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.652 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.42 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.660 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.24 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:04:40.680 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.18 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.690 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.26 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:40.699 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.08 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.715 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.53 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.723 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.06 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:04:40.771 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.68 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.781 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.22 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:04:40.792 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.55 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.6 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.815 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.33 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.836 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.1 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.844 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.77 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:04:40.863 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.56 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.871 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.67 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:40.879 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.26 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:40.895 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.01 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:40.946 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 12.79 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 18:04:41.023 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 18:04:49.571 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 24.69 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:04:49.662 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.4 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:49.675 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.78 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 18:04:49.718 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.95 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:49.727 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.47 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:49.737 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.71 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:49.758 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.42 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:49.768 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.09 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 18:04:49.778 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.52 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:49.800 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.14 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:49.812 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.75 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:49.840 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.02 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:49.849 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.4 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 18:04:49.866 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.12 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 18:04:49.875 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.77 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 18:04:49.883 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.69 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:04:51.582 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 1690.44 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 18:04:51.688 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.87 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=1.707, p_ui_time=0.085, p_user_id=jaeuk.shin |
| 18:04:56.491 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.73 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104002, UserID=jaeuk.shin |

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

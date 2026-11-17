# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-13 05:46:17.812 ~ 2026-11-13 05:47:07.682 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: Total : 108 · DB : 30.723s, UI : 0.097s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:46:18.186 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 05:46:18.211 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.79 | USER_ID= |
| 05:46:18.368 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.6 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:46:18.405 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.69 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:46:18.858 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 441.94 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:46:19.102 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.57 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:46:19.108 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.26 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:46:19.154 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 39.59 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:46:19.234 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.61 |  |
| 05:46:19.284 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.74 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.293 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.34 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:46:19.322 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.48 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.337 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 6.96 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:46:19.367 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.52 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.383 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.06 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.414 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.75 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.449 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.84 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.458 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:19.483 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.15 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.497 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.67 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:19.512 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.44 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.533 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.55 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.544 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 4.56 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 05:46:19.561 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.03 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.574 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 05:46:19.602 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.52 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.616 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 5.46 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 05:46:19.634 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.35 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.675 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 14.1 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 05:46:19.754 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 62.06 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:46:19.891 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 11.66 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.901 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.25 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:46:19.924 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 12.54 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:19.939 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.78 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:46:19.961 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 8.15 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.987 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.39 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:19.998 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.023 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.29 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:20.033 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.9 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:20.049 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.52 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 05:46:20.058 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.7 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:20.067 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.82 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.087 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.37 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.095 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.54 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:46:20.129 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.51 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.140 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 6.42 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:46:20.148 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.77 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.160 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.22 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.171 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.47 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.195 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.95 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.203 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.27 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:20.224 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.25 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.237 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 7.49 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:20.247 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.48 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.269 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.23 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.305 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 5.19 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 05:46:20.335 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 25.13 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:46:20.372 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.54 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.382 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.85 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:46:20.401 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.95 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.414 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.35 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:46:20.426 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.5 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.443 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.92 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.455 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.98 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.479 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.64 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.488 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.75 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:20.505 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.67 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.514 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.14 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:20.524 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.51 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.544 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.82 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.555 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.92 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:46:20.591 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.69 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.600 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.59 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:46:20.610 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.92 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.621 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.8 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.632 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.23 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.653 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.99 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.661 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.49 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:20.689 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 17.43 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.698 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.47 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:20.709 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.73 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:20.730 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.27 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:20.853 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.91 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 05:46:20.927 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 05:46:29.680 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 25.22 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:46:29.778 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.73 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:29.788 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.57 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 05:46:29.827 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.36 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:29.835 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.65 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:29.861 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 19.41 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:29.884 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.12 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:29.898 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.79 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 05:46:29.910 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.41 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:29.925 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.53 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:29.934 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.29 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:46:29.957 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.43 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:29.967 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 6.13 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 05:46:29.984 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.89 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 05:46:29.995 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 6.03 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 05:46:30.003 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.4 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:00.708 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 30696.47 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 05:47:00.842 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.57 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=30.723, p_ui_time=0.097, p_user_id=jaeuk.shin |
| 05:47:06.967 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.48 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104002, UserID=jaeuk.shin |

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

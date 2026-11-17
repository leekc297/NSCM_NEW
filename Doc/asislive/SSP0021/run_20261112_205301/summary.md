# AS-IS 실측 요약 — SSP0021

- 실행: 2026-11-12 20:53:01.559 ~ 2026-11-12 20:53:49.681 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Auto & ESS) (GSCM.SSP.Plan.UIL.SSP0021_ShipmentPlan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:53:02.021 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 20:53:02.045 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.63 | USER_ID= |
| 20:53:02.204 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.98 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:53:02.293 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 88.46 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:53:02.723 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 424.31 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:53:02.872 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.22 | LOGTYPE=SpeedUp, NOTE=SSP0021
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:53:02.877 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.33 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:53:02.899 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_DIVISION | 5 | 17.32 | Param1=ADMIN, Param2=jaeuk.shin |
| 20:53:02.928 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.27 |  |
| 20:53:02.962 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 12.19 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.017 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 51.38 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 20:53:03.059 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 30.83 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.067 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.72 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:53:03.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.29 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.091 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.05 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.102 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.28 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.127 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.8 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.136 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.71 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:53:03.154 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.95 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.165 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 8.11 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:03.174 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.67 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.191 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.96 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.198 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.98 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock |
| 20:53:03.212 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.59 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.219 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.86 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=MES Stock Detail |
| 20:53:03.236 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.78 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.244 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.29 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 20:53:03.252 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.06 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.270 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 20 | 6.47 | Param1=81, Param2=, Param3=ADMIN, Param4=jaeuk.shin |
| 20:53:03.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 62.8 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:53:03.438 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.75 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.445 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.32 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 20:53:03.463 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.48 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.475 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.45 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:53:03.485 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.56 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.64 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.506 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.38 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.529 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.53 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.536 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.97 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:53:03.558 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.57 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:03.566 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.99 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:03.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.29 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.598 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.89 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.606 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.82 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 20:53:03.640 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.44 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.649 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.8 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:53:03.658 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.56 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.671 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.95 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.682 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.05 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.707 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.21 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.716 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.61 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:53:03.732 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.7 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.743 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 7.26 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:03.752 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.47 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.769 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.82 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.797 | load | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_FROM_SITE | 6 | 5.84 | Param1=81, Param2=HQ00, Param3=ADMIN, Param4=jaeuk.shin |
| 20:53:03.827 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.74 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:53:03.854 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.9 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.863 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.02 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 20:53:03.881 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.33 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.891 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 4.71 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:53:03.900 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.14 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.912 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.65 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.924 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.51 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:03.947 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.45 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.955 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.69 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:53:03.973 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.43 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:03.981 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.8 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:03.991 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.65 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:04.008 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.58 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:04.017 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.62 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 20:53:04.071 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.02 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:04.081 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 5.5 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:53:04.095 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 5.15 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:04.115 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.19 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:04.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.99 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:04.149 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.91 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:04.158 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 4.06 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:53:04.174 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.75 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:04.182 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.94 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:04.191 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.5 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:04.206 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.18 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:04.327 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.47 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 20:53:04.403 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0021 |
| 20:53:13.075 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.24 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:53:13.108 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 12.01 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:13.118 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.85 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan |
| 20:53:13.153 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.47 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:13.162 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.29 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:13.170 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.26 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:13.192 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.24 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:13.203 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 69 | 6.24 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:53:13.213 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.8 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:13.224 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.56 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:13.236 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.73 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:13.259 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.38 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:13.266 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.94 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=Stock Location Detail |
| 20:53:13.286 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.93 | p_start_yyyymmdd=20261010, p_end_yyyymmdd=20261204 |
| 20:53:13.295 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.08 | p_program_id=SSP0021, p_user_id=jaeuk.shin, p_sheet_name=oWMS Detail |
| 20:53:13.303 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.24 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:43.344 | find | GSCM.SSP.Plan.WSL | SSP0021_GET_SHIPMENT_PLAN | 108 | 30032.15 | p_division_id=81, p_company_id=HQ00, p_from_site=HQ05-W,HQ07-A,HQ07-P,HQ11-A,HQ11-P,KR02239900_81-P, p_plan_start_yyyymmdd=20261010, p_from_yyyymmdd=20261010, p_to_yyyymmdd=20261204, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0021, p_sheet_name=Shipment Plan, p_real_flag=Y |
| 20:53:43.426 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 46.88 | p_menu_id=SSP0021, p_log_type=FIND, p_log_cnt=, p_db_time=30.047, p_ui_time=0.02, p_user_id=jaeuk.shin |
| 20:53:48.919 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 10.56 | MenuID=Shipment Plan(Auto & ESS), CnntCode=0104002, UserID=jaeuk.shin |

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

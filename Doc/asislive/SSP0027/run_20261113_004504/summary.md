# AS-IS 실측 요약 — SSP0027

- 실행: 2026-11-13 00:45:04.448 ~ 2026-11-13 00:47:28.378 · 계정 jaeuk.shin · 상태 OK
- 화면: Purchasing PSI(ESS) (GSCM.SSP.Plan.UIL.SSP0027_ShipmentPlanEss)
- 조회 결과: Total : 1,750 · DB : 13.228s, UI : 0.019s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:45:04.794 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0027 |
| 00:45:04.818 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.05 | USER_ID= |
| 00:45:05.027 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.64 | LOGTYPE=SpeedUp, NOTE=SSP0027
division_id_changed
start
, USER_ID=jaeuk.shin |
| 00:45:05.033 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.78 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:45:05.452 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 410.46 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 00:45:05.629 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.93 | LOGTYPE=SpeedUp, NOTE=SSP0027
division_id_changed
end
, USER_ID=jaeuk.shin |
| 00:45:05.633 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.44 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:45:05.645 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.49 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.650 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.06 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.656 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.68 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.661 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.78 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.666 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.69 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.671 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.66 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.677 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.71 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.682 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.62 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:05.692 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.62 |  |
| 00:45:05.738 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.28 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:05.818 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 74.05 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 00:45:05.839 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.24 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:05.846 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 64 | 4.38 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 00:45:05.857 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.67 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:45:05.872 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.36 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:45:05.881 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.33 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:45:05.909 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.24 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:05.916 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 40 | 4.04 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=PR PO Detail |
| 00:45:05.942 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 12.83 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:05.949 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.88 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Netting History |
| 00:45:05.966 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.71 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:05.975 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.77 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 00:45:05.983 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.54 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:45:05.999 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.12 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:06.006 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.8 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Monthly(BOH) |
| 00:45:06.024 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.46 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:06.036 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.66 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Daily(BOH) |
| 00:45:06.048 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.71 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:06.054 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 3.62 | Code=Com_FromSite, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:45:06.060 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.45 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:06.066 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.83 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:06.071 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.66 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:06.076 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.73 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:06.082 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.94 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:06.087 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.76 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:46.483 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 46 | 40387.78 | Code=Plan_Infor_ESS, Param1=82, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:45:46.554 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 64.08 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:45:46.758 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.21 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 00:45:46.765 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.54 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 00:45:46.784 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 9.15 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 00:45:46.791 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.97 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 00:45:46.836 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 9.12 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 00:45:46.847 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 5.3 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 00:45:46.855 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 3.24 | Code=Com_FromSite, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:45:46.860 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.79 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:46.866 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.86 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:46.871 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.71 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:46.876 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.84 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:46.882 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.79 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:45:46.887 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 2.72 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 00:46:26.000 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 46 | 39105.98 | Code=Plan_Infor_ESS, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:46:26.026 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 22.96 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:46:26.074 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 9.84 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 00:46:26.084 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.62 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 00:46:26.101 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 8.94 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 00:46:26.110 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.65 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 00:46:26.162 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 9.99 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 00:46:26.387 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 213.02 | MenuID=Purchasing PSI(ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 00:46:26.476 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0027 |
| 00:47:07.213 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 46 | 32043.42 | Code=Plan_Infor_ESS, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:47:07.260 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 10.18 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 00:47:07.271 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 4.18 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 00:47:20.317 | find | GSCM.SSP.Plan.WSL | SSP0027_GET_SHIPMENT_PLAN | 1750 | 13002.63 | p_division_id=82, p_company_id=HQ00, p_from_site=KR04851000-P, p_plan_start_yyyymmdd=20240125, p_from_yyyymmdd=20240125, p_to_yyyymmdd=20240418, p_project_code=, p_item_id=, p_user_id=jaeuk.shin, p_program_id=SSP0027, p_sheet_name=Purchasing PSI(ESS), p_real_flag=Y |
| 00:47:20.565 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.07 | p_menu_id=SSP0027, p_log_type=FIND, p_log_cnt=, p_db_time=13.228, p_ui_time=0.019, p_user_id=jaeuk.shin |
| 00:47:27.117 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.27 | MenuID=Purchasing PSI(ESS), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Shipment Date | drpPeriod2 |  |
| Requestor | txtRequestor |  |
| layoutControlItem9 | btnRequestor |  |
| layoutControlItem5 | btnItemID2 |  |
| layoutControlItem6 | btnSearch |  |
| Model | txtModel2 |  |
| Result Type | clbResultType |  |
| Project | txtProjectCode |  |
| Storage | clbStorageId |  |
| Plan date* | cboPlanDate21 | Y |
| PR No | txtPrNo |  |
| From Site | clbPlantSite |  |
| layoutControlItem10 | btnMeasure |  |
| layoutControlItem8 | chkSum |  |
| Div* | clbDivision_ID | Y |
| layoutControlItem2 | btnItemId |  |
| Model | txtItemId |  |
| Company* | clbCompany_ID | Y |
| Period* | drpPeriod | Y |
| Plan date* | cboPlanDate | Y |
| Monthly BOH | btnSimulation |  |
| Bucket | cboBucketType |  |
| Project | txtProject |  |
| Confirm | btnConfirm |  |

## 그리드

- spdMain / Purchasing PSI(ESS): 행 1750 · 컬럼 116(보임 94) · 헤더 3단 · 고정 컬럼 9
- spdDetail / Shipment Plan Detail: 행 0 · 컬럼 65(보임 37) · 헤더 1단 · 고정 컬럼 0
- spdDetail / PR PO Detail: 행 0 · 컬럼 41(보임 40) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Netting History: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Shipment Result: 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Monthly(BOH): 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Daily(BOH): 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

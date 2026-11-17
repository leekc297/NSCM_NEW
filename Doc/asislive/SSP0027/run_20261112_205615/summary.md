# AS-IS 실측 요약 — SSP0027

- 실행: 2026-11-12 20:56:15.656 ~ 2026-11-12 20:58:45.686 · 계정 jaeuk.shin · 상태 OK
- 화면: Purchasing PSI(ESS) (GSCM.SSP.Plan.UIL.SSP0027_ShipmentPlanEss)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:56:15.931 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0027 |
| 20:56:15.957 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.38 | USER_ID= |
| 20:56:16.157 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.03 | LOGTYPE=SpeedUp, NOTE=SSP0027
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:56:16.194 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.51 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:56:16.630 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 430.25 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:56:16.808 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 25.68 | LOGTYPE=SpeedUp, NOTE=SSP0027
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:56:16.815 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.39 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:56:16.993 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 169.9 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.001 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.28 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.011 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 5.4 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.018 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.06 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.027 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.63 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.035 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 5.89 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.046 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 5.8 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.053 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.36 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.064 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.5 |  |
| 20:56:17.134 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.91 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.188 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 48.73 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 20:56:17.207 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.71 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.216 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 64 | 5.23 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:56:17.226 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.88 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:56:17.243 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.92 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:56:17.255 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.11 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:56:17.288 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.65 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.296 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 40 | 5.05 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=PR PO Detail |
| 20:56:17.315 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.23 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.324 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 6.02 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Netting History |
| 20:56:17.339 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.86 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.347 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.98 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 20:56:17.361 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 6.48 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:56:17.377 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 9.6 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.387 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 5.83 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Monthly(BOH) |
| 20:56:17.401 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 8.53 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:17.410 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 5.36 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Daily(BOH) |
| 20:56:17.423 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.08 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:17.432 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 5.66 | Code=Com_FromSite, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:56:17.440 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.78 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:17.448 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.99 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:17.455 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.31 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:17.462 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.05 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:17.468 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.42 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:17.474 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.72 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:58.156 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 46 | 40670.72 | Code=Plan_Infor_ESS, Param1=82, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:56:58.224 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 62.03 | Code=Plan_Infor, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:56:58.438 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 0 | 10.24 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:56:58.447 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 4.49 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 20:56:58.465 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 10.06 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 20:56:58.478 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 7.55 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 20:56:58.523 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 10.36 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 20:56:58.532 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.98 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=ESOC |
| 20:56:58.548 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 7.06 | Code=Com_FromSite, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:56:58.557 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 5.47 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:58.565 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 4.27 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:58.571 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.12 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:58.581 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 7.8 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:58.588 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.99 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:56:58.594 | load | GSCM.SSP.Plan.WSL | SSP0002_GET_NERP_CODE | 1 | 3.8 | P_PROCEDURE_KEY=SSP0027_ShipmentPlanEss.cs, P_SEQUENCE=KR012031P |
| 20:57:29.942 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 46 | 31342.67 | Code=Plan_Infor_ESS, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:57:29.972 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 23.71 | Code=Plan_Infor, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:57:30.017 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 9.62 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 20:57:30.029 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 5.82 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 20:57:30.049 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 11.12 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 20:57:30.058 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 4.57 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |
| 20:57:30.113 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 11.84 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 20:57:30.220 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 94.26 | MenuID=Purchasing PSI(ESS), CnntCode=0104001, UserID=jaeuk.shin |
| 20:57:30.316 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.6 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0027 |
| 20:58:13.408 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 46 | 34063.1 | Code=Plan_Infor_ESS, Param1=82, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:58:13.447 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 104 | 12.02 | p_start_yyyymmdd=20240125, p_end_yyyymmdd=20240418 |
| 20:58:13.461 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 3.46 | p_program_id=SSP0027, p_user_id=jaeuk.shin, p_sheet_name=Purchasing PSI(ESS) |

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

- spdMain / Purchasing PSI(ESS): 행 0 · 컬럼 115(보임 94) · 헤더 3단 · 고정 컬럼 8
- spdDetail / Shipment Plan Detail: 행 0 · 컬럼 65(보임 37) · 헤더 1단 · 고정 컬럼 0
- spdDetail / PR PO Detail: 행 0 · 컬럼 41(보임 40) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Netting History: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Shipment Result: 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Monthly(BOH): 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Daily(BOH): 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

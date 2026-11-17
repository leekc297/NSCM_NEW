# AS-IS 실측 요약 — SSP0023

- 실행: 2026-11-12 20:54:28.101 ~ 2026-11-12 20:54:58.241 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Electrode) (GSCM.SSP.Plan.UIL.SSP0023_ShipmentPlanElectrode)
- 조회 결과: Total : 308 · DB : 12.476s, UI : 0.088s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:54:28.479 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0023 |
| 20:54:28.514 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.48 | USER_ID= |
| 20:54:28.720 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.89 | LOGTYPE=SpeedUp, NOTE=SSP0023
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:54:28.801 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 81.63 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:54:28.863 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 50.74 | LOGTYPE=SpeedUp, NOTE=SSP0023
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:54:28.868 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.74 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:54:28.905 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.89 |  |
| 20:54:28.938 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 4.69 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:54:28.970 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 27.38 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 20:54:28.990 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 4.8 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:54:28.998 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 71 | 4.76 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 20:54:29.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.34 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:29.023 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.92 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:29.032 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.46 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:29.043 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.58 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:29.053 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.67 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:29.073 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 3.1 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:54:29.079 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 3.66 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:54:29.095 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 3.15 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:54:29.103 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 5.24 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 20:54:29.111 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.86 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:54:29.120 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 3.45 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:54:29.127 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.4 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail Excel |
| 20:54:29.137 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 3.72 | Code=Com_FromSitePlantEE, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:54:29.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 21.09 | Code=Plan_InforElectrode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:54:29.283 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 2.92 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:54:29.290 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.03 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 20:54:29.313 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 8.25 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:29.324 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 5.27 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 20:54:29.424 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 7.83 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:29.433 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.31 | Code=Com_FromSitePlantEE, Param1=40, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:54:29.452 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 13.02 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:54:29.480 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 8.24 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:29.492 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.68 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 20:54:29.513 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 8.11 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:29.522 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.44 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 20:54:29.626 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 8.19 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:29.766 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 123.84 | MenuID=Shipment Plan(Electrode), CnntCode=0104001, UserID=jaeuk.shin |
| 20:54:29.859 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0023 |
| 20:54:39.115 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 12.52 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:54:39.144 | find | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 9.31 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:39.159 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 8.58 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 20:54:51.669 | find | GSCM.SSP.Plan.WSL | SSP0023_GET_SHIPMENT_PLAN | 308 | 12391.82 | P_DIVISION_ID=40, P_COMPANY_ID=HQ00, P_FROM_SITE=, P_PLAN_START_YYYYMMDD=20261010, P_FROM_YYYYMMDD=20260928, P_TO_YYYYMMDD=20261204, P_MODEL_ID=, P_ITEM_ID=, P_NICK_NAME=, P_USER_ID=jaeuk.shin, P_PROGRAM_ID=SSP0023, P_SHEET_NAME=Shipment Plan(Electrode), P_REAL_FLAG=Y, P_MY_MODEL_CHK=N, P_PART_LEADE |
| 20:54:51.847 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.16 | p_menu_id=SSP0023, p_log_type=FIND, p_log_cnt=308, p_db_time=12.476, p_ui_time=0.088, p_user_id=jaeuk.shin |
| 20:54:57.380 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.2 | MenuID=Shipment Plan(Electrode), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Shipment Date | drpPeriod2 |  |
| Requestor | txtRequestor |  |
| layoutRequestorBtn | btnRequestor |  |
| layoutSearchBtn | btnSearch |  |
| Lot ID | txtLotID |  |
| Material | txtItemId2 |  |
| layoutMaterialBtn | btnItemId2 |  |
| Shipment Date | drpPeriod3 |  |
| Result Type | clbResultType |  |
| Nick Name | txtNickName2 |  |
| Model | txtModel2 |  |
| From Site | clbFromSite |  |
| layoutControlItem10 | btnMeasure |  |
| layoutControlItem8 | chkSum |  |
| Div* | clbDivision_ID | Y |
| Material | txtItemId |  |
| Company* | clbCompany_ID | Y |
| Period* | drpPeriod | Y |
| Plan date* | cboPlanDate | Y |
| Bucket | cboBucketType |  |
| layoutControlItem15 | rdButton2 |  |
| layoutControlItem16 | rdButton1 |  |
| layoutControlItem19 | rdButton3 |  |
| UOM Type | usrLabel1 |  |
| layoutControlItem2 | btnItemId |  |
| layoutControlItem18 | chkMyModel |  |
| layoutControlItem22 | chkTeamLeader |  |
| layoutControlItem23 | chkDelegateeModel |  |
| layoutControlItem5 | chkPastPeriod |  |
| layoutControlItem21 | chkPartLeader |  |
| Model | txtModelId |  |
| Nick Name | textNickName |  |
| Simulation | btnSimulation |  |
| Excel Form | formDown |  |
| Upload | btnExcelUpload |  |

## 그리드

- spdMain / Shipment Plan(Electrode): 행 308 · 컬럼 282(보임 69) · 헤더 3단 · 고정 컬럼 26
- spdDetail / Shipment Plan Detail: 행 0 · 컬럼 72(보임 41) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Stock Detail: 행 0 · 컬럼 29(보임 28) · 헤더 3단 · 고정 컬럼 0
- spdDetail / Shipment Result: 행 0 · 컬럼 18(보임 17) · 헤더 1단 · 고정 컬럼 0
- spdSub / Shipment Plan Detail Excel: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

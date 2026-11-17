# AS-IS 실측 요약 — SSP0023

- 실행: 2026-11-15 01:50:36.633 ~ 2026-11-15 01:51:01.260 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan(Electrode) (GSCM.SSP.Plan.UIL.SSP0023_ShipmentPlanElectrode)
- 조회 결과: Total : 308 · DB : 4.118s, UI : 0.187s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 01:50:37.665 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0023 |
| 01:50:37.690 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.7 | USER_ID= |
| 01:50:38.066 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 45.88 | LOGTYPE=SpeedUp, NOTE=SSP0023
division_id_changed
start
, USER_ID=jaeuk.shin |
| 01:50:38.080 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.69 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 01:50:38.701 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 599.37 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 01:50:38.945 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.18 | LOGTYPE=SpeedUp, NOTE=SSP0023
division_id_changed
end
, USER_ID=jaeuk.shin |
| 01:50:38.956 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.69 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 01:50:39.054 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.92 |  |
| 01:50:39.115 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 2.96 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 01:50:39.149 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 25.03 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 01:50:39.186 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 3.03 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 01:50:39.195 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 71 | 4.54 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail |
| 01:50:39.208 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.37 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:50:39.217 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.24 | Code=DomExpTypeCode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:50:39.225 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.22 | Code=ElectrodePackageType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:50:39.238 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.82 | Code=BuildingByPlantSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:50:39.262 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 16.88 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:50:39.295 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 2.69 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 01:50:39.303 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 3.97 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 01:50:39.316 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 2.79 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 01:50:39.326 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 3.73 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result |
| 01:50:39.335 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.28 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:50:39.345 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 3.26 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 01:50:39.349 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.57 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Detail Excel |
| 01:50:39.369 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 3.31 | Code=Com_FromSitePlantEE, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:50:39.397 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 18.82 | Code=Plan_InforElectrode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:50:39.535 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 0 | 2.88 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 01:50:39.542 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.26 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 01:50:39.567 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 6.36 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 01:50:39.576 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.92 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 01:50:39.718 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 6.81 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 01:50:39.738 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.2 | Code=Com_FromSitePlantEE, Param1=40, Param2=HQ00, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:50:39.757 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 10.72 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:50:39.796 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 6.37 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 01:50:39.807 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.76 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 01:50:39.829 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 7.51 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 01:50:39.840 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.01 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 01:50:39.990 | load | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 6.9 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 01:50:40.249 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 113.68 | MenuID=Shipment Plan(Electrode), CnntCode=0104001, UserID=jaeuk.shin |
| 01:50:40.400 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0023 |
| 01:50:49.984 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 10.78 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:50:50.070 | find | GSCM.SSP.Plan.WSL | SSP0023_GET_SHEET_CALENDAR_3SPAN | 255 | 6.58 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 01:50:50.087 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.65 | p_program_id=SSP0023, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan(Electrode) |
| 01:50:54.220 | find | GSCM.SSP.Plan.WSL | SSP0023_GET_SHIPMENT_PLAN | 308 | 3999.74 | P_DIVISION_ID=40, P_COMPANY_ID=HQ00, P_FROM_SITE=, P_PLAN_START_YYYYMMDD=20261010, P_FROM_YYYYMMDD=20260928, P_TO_YYYYMMDD=20261204, P_MODEL_ID=, P_ITEM_ID=, P_NICK_NAME=, P_USER_ID=jaeuk.shin, P_PROGRAM_ID=SSP0023, P_SHEET_NAME=Shipment Plan(Electrode), P_REAL_FLAG=Y, P_MY_MODEL_CHK=N, P_PART_LEADE |
| 01:50:54.508 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 2.99 | p_menu_id=SSP0023, p_log_type=FIND, p_log_cnt=308, p_db_time=4.118, p_ui_time=0.187, p_user_id=jaeuk.shin |
| 01:51:00.502 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.66 | MenuID=Shipment Plan(Electrode), CnntCode=0104002, UserID=jaeuk.shin |

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

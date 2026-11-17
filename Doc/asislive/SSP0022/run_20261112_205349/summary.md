# AS-IS 실측 요약 — SSP0022

- 실행: 2026-11-12 20:53:49.809 ~ 2026-11-12 20:54:27.967 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Request(Electrode) (GSCM.SSP.Plan.UIL.SSP0022_ShipmentRequestElectrode)
- 조회 결과: Total : 384 · DB : 20.515s, UI : 0.138s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:53:50.274 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0022 |
| 20:53:50.297 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.13 | USER_ID= |
| 20:53:50.444 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.84 | LOGTYPE=SpeedUp, NOTE=SSP0022
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:53:50.475 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.08 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:53:50.544 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 57.09 | LOGTYPE=SpeedUp, NOTE=SSP0022
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:53:50.549 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.64 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:53:50.593 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.99 |  |
| 20:53:50.765 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 0 | 148.41 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:50.800 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 31.0 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request(Electrode) |
| 20:53:50.821 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 0 | 5.18 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:50.830 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 4.81 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:53:50.850 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 0 | 4.37 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:50.858 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 4.71 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 20:53:50.868 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.76 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:50.876 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.42 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:50.889 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 0 | 4.32 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:50.899 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 8.15 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail Excel |
| 20:53:50.913 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 6.78 | Code=PlantEE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:51.427 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 505.94 | Code=Plan_InforElectrode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:53:51.511 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 0 | 4.07 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:51.519 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 5.24 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request(Electrode) |
| 20:53:51.539 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 0 | 5.36 | p_start_yyyymmdd=20130712, p_end_yyyymmdd=19990101 |
| 20:53:51.548 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 5.16 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:53:51.571 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 7.14 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.583 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 5.98 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request(Electrode) |
| 20:53:51.654 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 6.5 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.664 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 4.09 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:53:51.682 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 7.0 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.694 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 5.33 | Code=PlantEE, Param1=40, Param2=HQ00, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:53:51.713 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 14.08 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:53:51.739 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 6.54 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.751 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 4.2 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request(Electrode) |
| 20:53:51.770 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 6.67 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.780 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 4.14 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:53:51.800 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 7.11 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.814 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 6.73 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request(Electrode) |
| 20:53:51.885 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 9.37 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:51.897 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 5.79 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:53:51.919 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 8.14 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:53:52.010 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 76.0 | MenuID=Shipment Request(Electrode), CnntCode=0104001, UserID=jaeuk.shin |
| 20:53:52.094 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0022 |
| 20:54:00.953 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 12.84 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:54:00.980 | find | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 7.19 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:54:00.993 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 6.37 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request(Electrode) |
| 20:54:21.472 | find | GSCM.SSP.Plan.WSL | SSP0022_GET_SHIPMENT_PSI | 384 | 20412.61 | P_DIVISION_ID=40, P_COMPANY_ID=HQ00, P_PLANT_ID=, P_CELL_TYPE=, P_PLAN_START_YYYYMMDD=20261010, P_FROM_YYYYMMDD=20260928, P_TO_YYYYMMDD=20261204, P_MODEL_ID=, P_ITEM_ID=, P_NICK_NAME=, P_USER_ID=jaeuk.shin, P_PROGRAM_ID=SSP0022, P_SHEET_NAME=Shipment Request(Electrode), P_REAL_FLAG=Y, P_MY_MODEL_CHK |
| 20:54:21.720 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 6.95 | p_menu_id=SSP0022, p_log_type=FIND, p_log_cnt=384, p_db_time=20.515, p_ui_time=0.138, p_user_id=jaeuk.shin |
| 20:54:27.059 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.98 | MenuID=Shipment Request(Electrode), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem5 | btnItemID2 |  |
| layoutControlItem6 | btnSearch |  |
| Material | txtItemld2 |  |
| Lot ID | txtLotID |  |
| Nick Name | textNickName2 |  |
| Requestor | txtRequestor |  |
| Shipment ETA | drpPeriod2 |  |
| layoutControlItem28 | btnRequestor |  |
| Model | txtModelId2 |  |
| Plant | clbPlantSite |  |
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
| layoutControlItem23 | lblUOMType |  |
| layoutControlItem18 | rdButton3 |  |
| layoutControlItem22 | chkPastPeriod |  |
| Cell Type | clbCellType |  |
| layoutControlItem2 | btnItemId |  |
| Nick Name | textNickName |  |
| layoutControlItem11 | chkMyModel |  |
| layoutControlItem14 | chkPartLeader |  |
| layoutControlItem19 | chkTeamLeader |  |
| layoutControlItem24 | chkDelegateModel |  |
| layoutControlItem21 | btnModelId |  |
| Model | txtModelId |  |
| Upload | btnExcelUpload |  |
| Excel Form | formDown |  |

## 그리드

- spdMain / Shipment Request(Electrode): 행 384 · 컬럼 288(보임 78) · 헤더 3단 · 고정 컬럼 33
- spdDetail / Stock Detail: 행 0 · 컬럼 29(보임 28) · 헤더 3단 · 고정 컬럼 0
- spdDetail / Shipment Request Detail: 행 0 · 컬럼 30(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdSub / Shipment Request Detail Excel: 행 0 · 컬럼 10(보임 9) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

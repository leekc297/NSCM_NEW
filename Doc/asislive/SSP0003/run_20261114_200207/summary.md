# AS-IS 실측 요약 — SSP0003

- 실행: 2026-11-14 20:02:07.031 ~ 2026-11-14 20:02:46.097 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm (GSCM.SSP.Plan.UIL.SSP0003_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 0.347s, UI : 0.122s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:02:23.885 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 20:02:23.921 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.08 | USER_ID= |
| 20:02:24.343 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.51 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:02:24.377 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.11 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:02:24.845 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 431.21 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:02:25.217 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 50 | 11.44 | Code=Plan_InforElectrode, Param1=HQ00, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:02:25.320 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_SHEET_CALENDAR_3SPAN | 255 | 8.17 | p_start_yyyymmdd=20260928, p_end_yyyymmdd=20261204 |
| 20:02:25.336 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 28 | 5.45 | p_program_id=SSP0022, p_user_id=jaeuk.shin, p_sheet_name=Stock Detail |
| 20:02:25.365 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_STOCK_DETAIL | 0 | 7.11 | P_DIVISION_ID=40, P_COMPANY_ID=HQ00, P_PLAN_START_YYYYMMDD=20261010, P_FROM_YYYYMMDD=20261010, P_TO_YYYYMMDD=20261204, P_PLANT_ID=HQ10,HQ06, P_CELL_TYPE=, P_LOT_ID=, P_ITEM_ID=, P_MODEL_ID=, P_NICK_NAME=, P_USER_ID=jaeuk.shin, P_PROGRAM_ID=SSP0022, P_SHEET_NAME=Stock Detail, P_REAL_FLAG=Y, P_MY_MODE |
| 20:02:25.454 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 28.11 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:02:25.459 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.37 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:02:25.461 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.84 | p_menu_id=SSP0022, p_log_type=FIND, p_log_cnt=, p_db_time=0.02, p_ui_time=0.079, p_user_id=jaeuk.shin |
| 20:02:25.508 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.33 | Param1=ADMIN, Param2=jaeuk.shin |
| 20:02:25.673 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 99 | 28.97 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 20:02:25.745 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.55 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 20:02:25.806 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 21.37 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 20:02:25.826 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.89 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:25.841 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 5.24 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:25.855 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.88 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:25.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 42.81 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:26.180 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 45.06 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:26.422 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 43.22 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:26.636 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 5.84 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 20:02:26.652 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.89 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:26.686 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.87 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:27.021 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 89.52 | MenuID=Shipment Change Request Confirm, CnntCode=0104001, UserID=jaeuk.shin |
| 20:02:27.215 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 20:02:36.746 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 5.04 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 20:02:36.759 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.69 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:36.773 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.82 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:36.779 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.62 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:36.833 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.48 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:37.016 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.4 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:37.205 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.65 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:37.688 | find | GSCM.BizService.WSL | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 117.34 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_82-W,HQ05-W,H |
| 20:02:37.793 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 6.27 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 20:02:37.805 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.61 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:37.821 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.63 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:37.845 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.46 | p_menu_id=SSP0003, p_log_type=FIND, p_log_cnt=, p_db_time=0.347, p_ui_time=0.122, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivision |  |
| layoutControlItem10 | btnSelfReject |  |
| Request Date | drpPeriod |  |
| From Site | clbFromSite |  |
| Status | cboStatus |  |
| layoutControlItem10 | btnReject |  |
| layoutControlItem10 | btnApproval |  |
| layoutControlItem13 | btnRequestUser |  |
| Requestor | txtRequest |  |
| Model | txtItemID |  |
| layoutControlItem2 | btnItemId |  |
| Change Type | cboChangeType |  |
| Request No | txtRequestNo |  |
| Requestor | txtRequestor |  |
| Dept Name | txtRequestDeptName |  |
| Approval | txtApproval |  |
| Dept Name | txtAppDeptName |  |
| Reason Detail | txtReasonDetail |  |
| layoutControlItem3 | usrLabel2 |  |
| Title | txtTitle |  |
| Change Reason | txtChangeReason |  |
| Reject Reason | txtRejectReason |  |

## 그리드

- spdMain / Shipment Change Request Confirm: 행 0 · 컬럼 23(보임 19) · 헤더 1단 · 고정 컬럼 7
- txtApprovalDeptName / Shipment Change Request Confirm Detail: 행 0 · 컬럼 55(보임 29) · 헤더 2단 · 고정 컬럼 9

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(14428)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

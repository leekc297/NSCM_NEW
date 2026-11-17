# AS-IS 실측 요약 — SSP0003

- 실행: 2026-11-13 05:32:55.920 ~ 2026-11-13 05:33:20.869 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm (GSCM.SSP.Plan.UIL.SSP0003_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 3.381s, UI : 0.131s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:32:56.336 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 05:32:56.360 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.75 | USER_ID= |
| 05:32:56.519 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 47.87 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:32:56.526 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.88 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:32:57.618 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 1069.11 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:32:57.975 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 6.73 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:32:57.979 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.99 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:32:58.000 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.44 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:32:58.055 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 99 | 7.94 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 05:32:58.085 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.94 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 05:32:58.097 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.64 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 05:32:58.106 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.73 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.113 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.97 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.97 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.172 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.73 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.304 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 42.3 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.427 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.44 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.518 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 5.36 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 05:32:58.527 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.29 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.544 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.35 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:58.660 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 93.59 | MenuID=Shipment Change Request Confirm, CnntCode=0104001, UserID=jaeuk.shin |
| 05:32:58.808 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 05:33:10.564 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.21 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 05:33:10.581 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.9 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:10.594 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.43 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:10.603 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.72 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:10.651 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 42.06 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:10.787 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.79 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:10.910 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.66 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:14.325 | find | GSCM.BizService.WSL | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 3216.93 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_82-W,HQ05-W,H |
| 05:33:14.452 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 5.17 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 05:33:14.465 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.04 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:14.493 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.6 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:33:14.515 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.43 | p_menu_id=SSP0003, p_log_type=FIND, p_log_cnt=, p_db_time=3.381, p_ui_time=0.131, p_user_id=jaeuk.shin |
| 05:33:20.150 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.24 | MenuID=Shipment Change Request Confirm, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

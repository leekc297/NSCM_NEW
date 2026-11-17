# AS-IS 실측 요약 — SSP0003

- 실행: 2026-11-15 00:07:04.607 ~ 2026-11-15 00:07:24.896 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm (GSCM.SSP.Plan.UIL.SSP0003_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 2.979s, UI : 0.123s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:07:05.455 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 00:07:05.480 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.06 | USER_ID= |
| 00:07:05.724 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 48.24 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
start
, USER_ID=jaeuk.shin |
| 00:07:05.729 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.56 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:07:06.179 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 432.14 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 00:07:06.433 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.69 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
end
, USER_ID=jaeuk.shin |
| 00:07:06.433 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.59 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:07:06.464 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.32 | Param1=ADMIN, Param2=jaeuk.shin |
| 00:07:06.527 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 99 | 7.85 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 00:07:06.560 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.1 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 00:07:06.600 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 24.56 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 00:07:06.607 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.41 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:06.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.47 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:06.624 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.5 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:06.674 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 42.56 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:06.830 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 43.53 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:06.962 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.79 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:07.064 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 4.72 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 00:07:07.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.25 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:07.087 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.27 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:07.299 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 98.09 | MenuID=Shipment Change Request Confirm, CnntCode=0104001, UserID=jaeuk.shin |
| 00:07:07.384 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 00:07:15.640 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.57 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 00:07:15.650 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.32 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:15.650 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.34 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:15.666 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.13 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:15.711 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.61 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:15.824 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.49 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:15.957 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 43.25 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:18.999 | find | GSCM.BizService.WSL | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 2829.22 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_82-W,HQ05-W,H |
| 00:07:19.099 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 6.98 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 00:07:19.109 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:19.129 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.58 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:07:19.147 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.59 | p_menu_id=SSP0003, p_log_type=FIND, p_log_cnt=, p_db_time=2.979, p_ui_time=0.123, p_user_id=jaeuk.shin |
| 00:07:24.152 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 45.16 | MenuID=Shipment Change Request Confirm, CnntCode=0104002, UserID=jaeuk.shin |

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

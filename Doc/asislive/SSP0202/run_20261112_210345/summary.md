# AS-IS 실측 요약 — SSP0202

- 실행: 2026-11-12 21:03:45.179 ~ 2026-11-12 21:04:12.310 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm(Packer) (GSCM.SSP.Plan.UIL.SSP0202_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 5.387s, UI : 0.103s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:03:45.663 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0202 |
| 21:03:45.692 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.61 | USER_ID= |
| 21:03:46.684 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 718.46 | LOGTYPE=SpeedUp, NOTE=SSP0202
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:03:46.775 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 90.19 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:03:47.178 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 176.77 | LOGTYPE=SpeedUp, NOTE=SSP0202
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:03:47.896 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 717.54 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:03:48.093 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 101.86 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.127 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.18 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 21:03:48.231 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 82.11 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 21:03:48.242 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.24 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.251 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.41 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.260 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.22 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.306 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.6 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.65 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.707 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 46.94 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:48.861 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 50 | 4.89 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 21:03:48.874 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.79 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:50.264 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1312.81 | MenuID=Shipment Change Request Confirm(Packer), CnntCode=0104001, UserID=jaeuk.shin |
| 21:03:50.511 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 4 | 2.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0202 |
| 21:03:51.560 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 108.85 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:03:51.679 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 100.52 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:04:00.138 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.92 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 21:04:00.146 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.17 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:00.153 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.46 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:00.159 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.13 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:00.203 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.92 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:00.325 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 43.07 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:00.474 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 42.27 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:05.904 | find | GSCM.SSP.Plan.WSL | SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 5221.96 | p_division_id=40, p_from_site=, p_request_id=, p_from_yyyymmdd=20261029, p_to_yyyymmdd=20261112, p_status=, p_language=KO, p_item_id=, p_change_type= |
| 21:04:06.007 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 50 | 4.31 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 21:04:06.020 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.61 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:04:06.096 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 54.35 | p_menu_id=SSP0202, p_log_type=FIND, p_log_cnt=, p_db_time=5.387, p_ui_time=0.103, p_user_id=jaeuk.shin |
| 21:04:11.406 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.29 | MenuID=Shipment Change Request Confirm(Packer), CnntCode=0104002, UserID=jaeuk.shin |

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
- txtApprovalDeptName / Shipment Change Request Confirm Detail: 행 0 · 컬럼 51(보임 25) · 헤더 2단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

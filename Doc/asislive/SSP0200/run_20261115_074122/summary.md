# AS-IS 실측 요약 — SSP0200

- 실행: 2026-11-15 07:41:22.048 ~ 2026-11-15 07:41:44.235 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request (GSCM.SSP.Plan.UIL.SSP0200_ShipmentChangeRequest)
- 조회 결과: Total :  · DB : 1.543s, UI : 0.013s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 07:41:23.079 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 07:41:23.111 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.56 | USER_ID= |
| 07:41:23.359 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.78 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
start
, USER_ID=jaeuk.shin |
| 07:41:23.394 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.47 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 07:41:23.849 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 438.28 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 07:41:24.058 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.01 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
end
, USER_ID=jaeuk.shin |
| 07:41:24.058 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.54 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 07:41:24.156 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.52 | Param1=ADMIN, Param2=jaeuk.shin |
| 07:41:24.196 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 34 | 5.82 | p_division_id=40, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 07:41:24.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 87.31 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 07:41:24.554 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.65 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 07:41:24.584 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 4.97 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 07:41:24.598 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.33 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:24.609 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.3 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:24.622 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.36 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:24.631 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.33 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:24.663 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 5.05 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 07:41:24.673 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.36 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:24.837 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.5 | MenuID=Shipment Change Request, CnntCode=0104001, UserID=jaeuk.shin |
| 07:41:24.957 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 07:41:35.275 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.28 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:35.275 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 4.31 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 07:41:35.294 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.18 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:35.302 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.55 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:35.306 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.38 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:35.415 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 6.19 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 07:41:35.426 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.23 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:41:35.562 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 101.61 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261115, p_to_yyyymmdd=20261215, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |
| 07:41:36.997 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 0 | 1580.84 | p_division_id=40, p_from_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261115, p_to_yyyymmdd=20261215, p_change_type=C, p_status=, p_language=KO, debug_mode=F, p_to_site=, p_confirm_id= |
| 07:41:37.020 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.22 | p_menu_id=SSP0200, p_log_type=FIND, p_log_cnt=, p_db_time=1.543, p_ui_time=0.013, p_user_id=jaeuk.shin |
| 07:41:43.547 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 11.15 | MenuID=Shipment Change Request, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| From Site | clbFromSite |  |
| Status | cboStatus |  |
| Shipment Date | drpPeriod |  |
| Model | txtRequest |  |
| layoutControlItem2 | btnItemId |  |
| Change Type | cboChangeType |  |
| SO No | txtSoNo |  |
| To Site | clbToSite |  |
| New | btnNew |  |
| Div | clbDivision_ID |  |
| Confirm Id | txtConfirmId |  |
| CheckSingleProcess | chkSingleProcess |  |
| Insert(Multi) | btnInsertMultiple |  |
| layoutControlItem2 | btnAdd |  |
| lcDel | btnDel |  |
| layoutControlItem2 | btnCancel |  |
| lcDate | dtDate |  |
| layoutControlItem2 | btnChangeRe2 |  |
| layoutControlItem2 | btnSave |  |
| Request No | txtRequestNo |  |
| Requestor | txtRequestor |  |
| Dept Name | txtRequestDeptName |  |
| Dept Name | txtAppDeptName |  |
| Reason Detail* | txtReasonDetail | Y |
| lcAppDept | btnApprovalUser |  |
| layoutControlItem3 | usrLabel2 |  |
| Title* | txtTitle | Y |
| Change Reason* | cboChangeReason | Y |
| Approval* | txtApproval | Y |

## 그리드

- spdMain / Shipment Change Request: 행 0 · 컬럼 61(보임 34) · 헤더 1단 · 고정 컬럼 6
- spdSub / Change Request: 행 0 · 컬럼 57(보임 26) · 헤더 2단 · 고정 컬럼 14

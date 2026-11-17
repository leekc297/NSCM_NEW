# AS-IS 실측 요약 — SSP0201

- 실행: 2026-11-12 21:02:38.460 ~ 2026-11-12 21:03:45.041 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request(Packer) (GSCM.SSP.Plan.UIL.SSP0201_ShipmentChangeRequest)
- 조회 결과: Total :  · DB : 40.904s, UI : 0.066s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:02:39.179 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0201 |
| 21:02:39.207 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.41 | USER_ID= |
| 21:02:40.732 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 1352.64 | LOGTYPE=SpeedUp, NOTE=SSP0201
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:02:41.172 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 439.02 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:02:41.611 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 422.33 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 21:02:42.598 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 837.35 | LOGTYPE=SpeedUp, NOTE=SSP0201
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:02:44.319 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1720.06 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:02:44.480 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 102.55 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:02:44.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 91.31 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:02:44.802 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 8.2 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 21:02:45.300 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 57 | 480.8 | p_program_id=SSP0201, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 21:02:45.310 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.17 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:45.320 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.1 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:45.329 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.7 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:45.337 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.58 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:45.364 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 58 | 4.88 | p_program_id=SSP0201, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 21:02:45.373 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.64 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:48.580 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3104.15 | MenuID=Shipment Change Request(Packer), CnntCode=0104001, UserID=jaeuk.shin |
| 21:02:49.223 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0201 |
| 21:02:57.500 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 57 | 4.24 | p_program_id=SSP0201, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 21:02:57.508 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.29 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:57.517 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.89 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:57.524 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.46 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:57.531 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.41 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:02:57.565 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 58 | 4.23 | p_program_id=SSP0201, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 21:02:57.574 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.26 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:03:16.947 | find | GSCM.BizService.WSL | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 19343.76 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20261212, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |
| 21:03:38.493 | find | GSCM.BizService.WSL | SSP0201_GET_SHIPMENT_CHANGE_REQUEST | 0 | 40927.99 | p_division_id=40, p_from_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20261212, p_change_type=C, p_status=, p_language=KO, debug_mode=F, p_to_site=, p_confirm_id= |
| 21:03:38.648 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 78.19 | p_menu_id=SSP0201, p_log_type=FIND, p_log_cnt=, p_db_time=40.904, p_ui_time=0.066, p_user_id=jaeuk.shin |
| 21:03:44.139 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.62 | MenuID=Shipment Change Request(Packer), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| From Site | clbFromSite |  |
| layoutControlItem10 | btnChangeRe |  |
| Status | cboStatus |  |
| Shipment Date | drpPeriod |  |
| Model | txtRequest |  |
| layoutControlItem2 | btnItemId |  |
| Change Type | cboChangeType |  |
| SO No | txtSoNo |  |
| To Site | clbToSite |  |
| NEW | btnNew |  |
| Div | clbDivision_ID |  |
| Confirm Id | txtConfirmId |  |
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

- spdMain / Shipment Change Request: 행 0 · 컬럼 58(보임 31) · 헤더 1단 · 고정 컬럼 4
- spdSub / Change Request: 행 0 · 컬럼 59(보임 28) · 헤더 2단 · 고정 컬럼 13

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

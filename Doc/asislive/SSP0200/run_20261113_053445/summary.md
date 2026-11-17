# AS-IS 실측 요약 — SSP0200

- 실행: 2026-11-13 05:34:45.641 ~ 2026-11-13 05:35:23.530 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request (GSCM.SSP.Plan.UIL.SSP0200_ShipmentChangeRequest)
- 조회 결과: Total : 1 · DB : 18.194s, UI : 0.019s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:34:46.093 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 05:34:46.115 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.29 | USER_ID= |
| 05:34:46.275 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.99 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:34:46.299 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.14 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:34:46.348 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 41.39 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:34:46.352 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:34:46.435 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.75 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:34:46.479 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 34 | 6.21 | p_division_id=40, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 05:34:46.646 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 162.48 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:34:46.810 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.36 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 05:34:46.826 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 4.21 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 05:34:46.835 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.38 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:46.842 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.17 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:46.851 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.45 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:46.857 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 2.87 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:46.886 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 4.04 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 05:34:46.896 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:47.033 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 93.04 | MenuID=Shipment Change Request, CnntCode=0104001, UserID=jaeuk.shin |
| 05:34:47.171 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.5 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 05:34:58.413 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 4.65 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 05:34:58.421 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.28 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:58.429 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.43 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:58.435 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.21 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:58.443 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.48 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:34:58.560 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 5.14 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 05:34:58.590 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 22.08 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:35:05.589 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 6968.58 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261111, p_to_yyyymmdd=20261211, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |
| 05:35:16.795 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 1 | 18237.56 | p_division_id=40, p_from_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261111, p_to_yyyymmdd=20261211, p_change_type=C, p_status=, p_language=KO, debug_mode=F, p_to_site=, p_confirm_id= |
| 05:35:16.839 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.89 | p_menu_id=SSP0200, p_log_type=FIND, p_log_cnt=1, p_db_time=18.194, p_ui_time=0.019, p_user_id=jaeuk.shin |
| 05:35:22.813 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.46 | MenuID=Shipment Change Request, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Shipment Change Request: 행 1 · 컬럼 61(보임 34) · 헤더 1단 · 고정 컬럼 6
- spdSub / Change Request: 행 0 · 컬럼 57(보임 26) · 헤더 2단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

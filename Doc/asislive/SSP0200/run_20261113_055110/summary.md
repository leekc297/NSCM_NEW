# AS-IS 실측 요약 — SSP0200

- 실행: 2026-11-13 05:51:10.202 ~ 2026-11-13 05:51:32.605 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request (GSCM.SSP.Plan.UIL.SSP0200_ShipmentChangeRequest)
- 조회 결과: Total : 1 · DB : 3.004s, UI : 0.006s · 완료 판단 status
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "drpPeriod", "prop": "InitValue", "value": "20261111:20261211", "param": "from_yyyymmdd+to_yyyymmdd", "from": "20261113:20261213", "sheet": "sub"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:51:10.607 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 05:51:10.633 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.43 | USER_ID= |
| 05:51:10.746 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.76 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:51:10.786 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.58 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:51:10.856 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 56.6 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:51:10.860 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:51:10.927 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.69 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:51:10.961 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 34 | 6.2 | p_division_id=40, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 05:51:11.057 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 92.46 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:51:11.223 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.75 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 05:51:11.239 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 4.06 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 05:51:11.247 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.27 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:11.255 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.24 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:11.262 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.06 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:11.268 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.27 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:11.294 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 4.62 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 05:51:11.304 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.64 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:11.334 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.21 | MenuID=Shipment Change Request, CnntCode=0104001, UserID=jaeuk.shin |
| 05:51:11.402 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 05:51:23.245 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 4.54 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 05:51:23.256 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.03 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:23.264 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.67 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:23.272 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 5.17 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:23.281 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.42 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:23.322 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 6.15 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 05:51:23.365 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 35.54 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:23.681 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 290.58 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261111, p_to_yyyymmdd=20261211, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |
| 05:51:26.380 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 1 | 3061.58 | p_division_id=40, p_from_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261111, p_to_yyyymmdd=20261211, p_change_type=C, p_status=, p_language=KO, debug_mode=F, p_to_site=, p_confirm_id= |
| 05:51:26.400 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 5.03 | p_menu_id=SSP0200, p_log_type=FIND, p_log_cnt=1, p_db_time=3.004, p_ui_time=0.006, p_user_id=jaeuk.shin |
| 05:51:31.822 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.75 | MenuID=Shipment Change Request, CnntCode=0104002, UserID=jaeuk.shin |

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

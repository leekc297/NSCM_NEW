# AS-IS 실측 요약 — SSP0200

- 실행: 2026-11-13 05:47:25.876 ~ 2026-11-13 05:47:53.331 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request (GSCM.SSP.Plan.UIL.SSP0200_ShipmentChangeRequest)
- 조회 결과: Total :  · DB : 10.475s, UI : 0.102s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:47:26.220 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 05:47:26.243 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.98 | USER_ID= |
| 05:47:26.363 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.54 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:47:26.418 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 53.38 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:47:26.463 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 38.71 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:47:26.467 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.67 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:47:26.541 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.15 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:47:26.577 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 34 | 6.76 | p_division_id=40, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 05:47:26.681 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 101.76 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:47:26.865 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.79 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 05:47:26.881 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 5.56 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 05:47:26.890 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.6 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:26.900 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 5.97 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:26.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.77 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:26.917 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.95 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:26.942 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 5.32 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 05:47:26.952 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.66 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:26.989 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.44 | MenuID=Shipment Change Request, CnntCode=0104001, UserID=jaeuk.shin |
| 05:47:27.066 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 05:47:36.194 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 5.15 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 05:47:36.203 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.47 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:36.210 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.28 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:36.219 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 5.17 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:36.229 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.4 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:36.345 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 4.27 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 05:47:36.370 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 19.08 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:47:46.609 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 10213.5 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261113, p_to_yyyymmdd=20261213, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |
| 05:47:46.627 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 0 | 10283.6 | p_division_id=40, p_from_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261113, p_to_yyyymmdd=20261213, p_change_type=C, p_status=, p_language=KO, debug_mode=F, p_to_site=, p_confirm_id= |
| 05:47:46.977 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.69 | p_menu_id=SSP0200, p_log_type=FIND, p_log_cnt=, p_db_time=10.475, p_ui_time=0.102, p_user_id=jaeuk.shin |
| 05:47:52.481 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.68 | MenuID=Shipment Change Request, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SSP0200

- 실행: 2026-11-15 06:48:03.216 ~ 2026-11-15 06:50:43.938 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request (GSCM.SSP.Plan.UIL.SSP0200_ShipmentChangeRequest)
- 조회 결과: Total :  · DB : 9.904s, UI : 0.019s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 06:50:15.235 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 06:50:15.259 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.82 | USER_ID= |
| 06:50:15.474 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.16 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
start
, USER_ID=jaeuk.shin |
| 06:50:15.510 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.04 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 06:50:15.906 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 387.45 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 06:50:16.072 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 17.42 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
end
, USER_ID=jaeuk.shin |
| 06:50:16.082 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 06:50:16.161 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.37 | Param1=ADMIN, Param2=jaeuk.shin |
| 06:50:16.199 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 34 | 6.07 | p_division_id=40, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 06:50:16.289 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 87.94 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 06:50:16.515 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.28 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 06:50:16.560 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 27.89 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 06:50:16.572 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.23 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:16.580 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.33 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:16.587 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.34 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:16.598 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.34 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:16.619 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 4.25 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 06:50:16.626 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.28 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:16.852 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 103.37 | MenuID=Shipment Change Request, CnntCode=0104001, UserID=jaeuk.shin |
| 06:50:16.937 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 06:50:26.827 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 5.01 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 06:50:26.839 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.49 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:26.852 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.36 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:26.855 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.43 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:26.865 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.35 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:26.977 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 4.39 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 06:50:26.998 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 21.33 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 06:50:34.699 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 7666.27 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261115, p_to_yyyymmdd=20261215, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |
| 06:50:36.918 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 0 | 9943.28 | p_division_id=40, p_from_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261115, p_to_yyyymmdd=20261215, p_change_type=C, p_status=, p_language=KO, debug_mode=F, p_to_site=, p_confirm_id= |
| 06:50:36.959 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.0 | p_menu_id=SSP0200, p_log_type=FIND, p_log_cnt=, p_db_time=9.904, p_ui_time=0.019, p_user_id=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(12768)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

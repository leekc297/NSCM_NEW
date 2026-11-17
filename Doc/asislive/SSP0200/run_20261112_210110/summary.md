# AS-IS 실측 요약 — SSP0200

- 실행: 2026-11-12 21:01:10.958 ~ 2026-11-12 21:02:22.659 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request (GSCM.SSP.Plan.UIL.SSP0200_ShipmentChangeRequest)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:01:11.600 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 21:01:11.626 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.62 | USER_ID= |
| 21:01:14.520 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 2713.88 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
start
, USER_ID=jaeuk.shin |
| 21:01:14.961 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 440.77 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:01:15.401 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 424.68 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 21:01:16.512 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 941.44 | LOGTYPE=SpeedUp, NOTE=SSP0200
division_id_changed
end
, USER_ID=jaeuk.shin |
| 21:01:17.958 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 1445.82 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 21:01:18.042 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.5 | Param1=ADMIN, Param2=jaeuk.shin |
| 21:01:18.080 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 34 | 6.89 | p_division_id=40, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 21:01:18.177 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1336 | 93.32 | Code=ShipmentPlanToSite, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:01:18.328 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.4 | p_from_date=, p_offset_day=30, p_timezone=AS054 |
| 21:01:18.514 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 167.5 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 21:01:18.533 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.09 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:18.543 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.71 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:18.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.51 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:18.568 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.34 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:18.597 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 6.43 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 21:01:18.606 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.71 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:22.752 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4045.09 | MenuID=Shipment Change Request, CnntCode=0104001, UserID=jaeuk.shin |
| 21:01:23.172 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0200 |
| 21:01:31.797 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 60 | 5.53 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request |
| 21:01:31.809 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.32 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:31.818 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.97 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:31.825 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.82 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:31.836 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.54 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:31.953 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 56 | 5.49 | p_program_id=SSP0200, p_user_id=jaeuk.shin, p_sheet_name=Change Request |
| 21:01:31.982 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 23.12 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:01:50.970 | find | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 0 | 18960.06 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_bod_id=, p_incoterms=, p_transport_mode=, p_project_code=, p_fcst_type=, p_confirm_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20261212, p_change_request_no=, p_request_user_id=jaeuk.shin, p_request_status=D, p_language=KO, p_c |

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

# AS-IS 실측 요약 — SSP0202

- 실행: 2026-11-12 17:43:17.191 ~ 2026-11-12 17:43:51.963 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm(Packer) (GSCM.SSP.Plan.UIL.SSP0202_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 2.509s, UI : 0.122s

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 17:43:32.557 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0202 |
| 17:43:32.596 | load | GSCM.BizService.WSL | SELECT * | 874 | 27.28 | USER_ID= |
| 17:43:33.465 | load | GSCM.BizService.WSL | -- Temp Table | 12 | 520.41 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 17:43:34.049 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 131.69 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.101 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.14 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 17:43:34.169 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 31.91 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 17:43:34.184 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.36 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.196 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.63 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.206 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.64 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.258 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 45.41 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.440 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.5 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.605 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 44.5 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.751 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 50 | 7.14 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 17:43:34.775 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.99 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:34.943 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 48.87 | MenuID=Shipment Change Request Confirm(Packer), CnntCode=0104001, UserID=jaeuk.shin |
| 17:43:35.053 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 4 | 3.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0202 |
| 17:43:35.674 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 99.81 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 17:43:35.788 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 102.48 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 17:43:43.232 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 6.59 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 17:43:43.247 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.91 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:43.257 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.85 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:43.270 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.52 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:43.358 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 79.51 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:43.518 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.94 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:43.697 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 46.77 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:46.303 | find | GSCM.SSP.Plan.WSL | SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 2272.72 | p_division_id=40, p_from_site=, p_request_id=, p_from_yyyymmdd=20261029, p_to_yyyymmdd=20261112, p_status=, p_language=KO, p_item_id=, p_change_type= |
| 17:43:46.418 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 50 | 6.75 | p_program_id=SSP0202, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 17:43:46.429 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.45 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 17:43:46.486 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 21.45 | p_menu_id=SSP0202, p_log_type=FIND, p_log_cnt=, p_db_time=2.509, p_ui_time=0.122, p_user_id=jaeuk.shin |

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

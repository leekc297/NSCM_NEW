# AS-IS 실측 요약 — SSP0003

- 실행: 2026-11-12 20:44:21.667 ~ 2026-11-12 20:44:50.919 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm (GSCM.SSP.Plan.UIL.SSP0003_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 9.578s, UI : 0.055s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:44:22.046 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 20:44:22.071 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.31 | USER_ID= |
| 20:44:22.253 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 61.21 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:44:22.325 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 69.83 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:44:23.628 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 1285.09 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:44:23.942 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 68.09 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:44:23.960 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.4 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:44:24.605 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 633.45 | Param1=ADMIN, Param2=jaeuk.shin |
| 20:44:24.692 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 99 | 33.25 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 20:44:24.723 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.4 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 20:44:24.837 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 104.44 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 20:44:24.847 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.85 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:24.856 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.5 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:24.869 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.58 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:24.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.95 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:25.041 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.28 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:25.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.9 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:25.274 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 6.41 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 20:44:25.284 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.4 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:25.303 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.35 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:25.558 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 230.55 | MenuID=Shipment Change Request Confirm, CnntCode=0104001, UserID=jaeuk.shin |
| 20:44:25.642 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 20:44:34.419 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.81 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 20:44:34.434 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.26 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:34.445 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.43 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:34.454 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.74 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:34.499 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.3 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:34.641 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.92 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:34.785 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.2 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:44.440 | find | GSCM.BizService.WSL | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 9431.1 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_82-W,HQ05-W,H |
| 20:44:44.479 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 4.34 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 20:44:44.489 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.38 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:44.515 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.57 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:44:44.538 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 11.84 | p_menu_id=SSP0003, p_log_type=FIND, p_log_cnt=, p_db_time=9.578, p_ui_time=0.055, p_user_id=jaeuk.shin |
| 20:44:49.989 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.64 | MenuID=Shipment Change Request Confirm, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

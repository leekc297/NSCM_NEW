# AS-IS 실측 요약 — SSP0003

- 실행: 2026-11-13 05:44:25.007 ~ 2026-11-13 05:44:44.621 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm (GSCM.SSP.Plan.UIL.SSP0003_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 1.591s, UI : 0.138s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:44:25.425 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 05:44:25.449 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.62 | USER_ID= |
| 05:44:25.723 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 124.94 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:44:25.734 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:44:26.215 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 445.68 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:44:26.472 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 17.88 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:44:26.484 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.41 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:44:26.503 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 4.76 | Param1=ADMIN, Param2=jaeuk.shin |
| 05:44:26.580 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 99 | 8.09 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 05:44:26.618 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.94 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 05:44:26.633 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 5.27 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 05:44:26.642 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.63 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:26.650 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.84 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:26.664 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.57 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:26.711 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 43.89 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:26.845 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.4 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:26.968 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.86 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:27.227 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 5.0 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 05:44:27.236 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.99 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:27.255 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 6.06 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:27.288 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.32 | MenuID=Shipment Change Request Confirm, CnntCode=0104001, UserID=jaeuk.shin |
| 05:44:27.358 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 05:44:36.049 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.69 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 05:44:36.059 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.28 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:36.091 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 27.61 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:36.104 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.77 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:36.150 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.87 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:36.273 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.48 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:36.401 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.98 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:38.044 | find | GSCM.BizService.WSL | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 1427.65 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_82-W,HQ05-W,H |
| 05:44:38.158 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 6.2 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 05:44:38.172 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.97 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:38.203 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.91 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:44:38.223 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.74 | p_menu_id=SSP0003, p_log_type=FIND, p_log_cnt=, p_db_time=1.591, p_ui_time=0.138, p_user_id=jaeuk.shin |
| 05:44:43.853 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.76 | MenuID=Shipment Change Request Confirm, CnntCode=0104002, UserID=jaeuk.shin |

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

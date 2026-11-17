# AS-IS 실측 요약 — SSP0003

- 실행: 2026-11-14 20:03:02.078 ~ 2026-11-14 20:03:23.604 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change Request Confirm (GSCM.SSP.Plan.UIL.SSP0003_ShipmentChangeRequestConfirm)
- 조회 결과: Total :  · DB : 0.396s, UI : 0.138s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:03:03.357 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 20:03:03.389 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.13 | USER_ID= |
| 20:03:03.830 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 6.2 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:03:03.878 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.16 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:03:04.344 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 432.16 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:03:04.988 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 19.81 | LOGTYPE=SpeedUp, NOTE=SSP0003
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:03:04.988 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.02 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:03:05.040 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_DIVISION | 12 | 5.36 | Param1=ADMIN, Param2=jaeuk.shin |
| 20:03:05.214 | load | GSCM.BizService.WSL | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 99 | 8.47 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_now_group_id=ADMIN, p_user_id=jaeuk.shin |
| 20:03:05.275 | load | GSCM.BizService.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.63 | p_from_date=, p_offset_day=-14, p_timezone=AS054 |
| 20:03:05.326 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.63 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 20:03:05.347 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.84 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:05.357 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.84 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:05.368 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.83 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:05.417 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 41.32 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:05.778 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 125.65 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:06.062 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 75.92 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:06.319 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 37.67 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 20:03:06.340 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.67 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:06.384 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 13.46 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:06.661 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 32.54 | MenuID=Shipment Change Request Confirm, CnntCode=0104001, UserID=jaeuk.shin |
| 20:03:06.863 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 31.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0003 |
| 20:03:15.268 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 51.5 | MenuID=Shipment Request(Electrode), CnntCode=0104002, UserID=jaeuk.shin |
| 20:03:16.020 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.3 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm |
| 20:03:16.025 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.71 | Code=LookupCommon, Param1=CHANGE_REQ_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:16.040 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.63 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:16.052 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.58 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:16.105 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 46.79 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:16.284 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 42.3 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:16.482 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21363 | 40.99 | Code=Dept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:16.961 | find | GSCM.BizService.WSL | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 0 | 118.43 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=AZ00-A,AZ00-E,CN00249500-P,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,CN05104100_82-P,EG01_81-W,EG01_82-W,GM00-A,GM00-E,GM01-A,GM01-E,HD00-A,HD00-E,HD00-P,HG00-A,HG00-E,HM00-A,HM00-E,HQ05_40-W,HQ05_82-W,HQ05-W,H |
| 20:03:17.088 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 54 | 4.8 | p_program_id=SSP0003, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change Request Confirm Detail |
| 20:03:17.103 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.62 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:17.134 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.45 | Code=LookupCommon, Param1=CHANGE_REQ_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:17.164 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.98 | p_menu_id=SSP0003, p_log_type=FIND, p_log_cnt=, p_db_time=0.396, p_ui_time=0.138, p_user_id=jaeuk.shin |
| 20:03:22.882 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.93 | MenuID=Shipment Change Request Confirm, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(14428)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SSP0013

- 실행: 2026-11-12 20:50:15.381 ~ 2026-11-12 20:50:40.170 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan Adjustment (GSCM.SSP.Plan.UIL.SSP0013_ShipmentPlanAdjustment)
- 조회 결과: Total :  · DB : 8.271s, UI : 0.118s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:50:15.718 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.18 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:50:15.726 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 3.46 | Code=CHANGE_REASON_CODE_ALL, Param1=CHANGE_REASON_CODE, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.733 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.41 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.739 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.35 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.746 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.53 | Code=LookupCommon, Param1=CHANGE_REQ_DAY, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.753 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.2 | Code=LookupCommon, Param1=SHIPMENT_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.765 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.7 | Code=LookupCommon, Param1=MY_MODEL_DEFAULT_CHECK, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 3.07 | Code=CompanyID, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:50:15.782 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 6.64 | Code=LookupCommon3, Param1=OWMS_STOCK_STATUS, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:15.809 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 22.57 | Code=SHIPMENT_PERIOD_DAY, Param1=SHIPMENT_PERIOD_DAY, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:50:16.180 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0013 |
| 20:50:16.213 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.8 | USER_ID= |
| 20:50:16.522 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 3.72 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:50:16.822 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1325 | 295.84 | Code=SSPToSiteByDivision, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:50:17.012 | load | GSCM.SCP.Master.WSL | SELECT | 1 | 4.9 |  |
| 20:50:17.049 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 61 | 22.12 | p_program_id=SSP0013, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Adjustment |
| 20:50:17.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.88 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:17.075 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.05 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:17.087 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.94 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:17.113 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.58 | p_program_id=SSP0013, p_user_id=jaeuk.shin, p_sheet_name=Stock information |
| 20:50:17.122 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.35 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:17.140 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 4.12 | p_program_id=SSP0013, p_user_id=jaeuk.shin, p_sheet_name=Stock information Detail |
| 20:50:17.149 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.84 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:17.294 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 63.25 | MenuID=Shipment Plan Adjustment, CnntCode=0104001, UserID=jaeuk.shin |
| 20:50:17.392 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0013 |
| 20:50:25.822 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 61 | 9.39 | p_program_id=SSP0013, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan Adjustment |
| 20:50:25.834 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.58 | Code=LookupCommon, Param1=SHIPMENT_STATUS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:25.843 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.65 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:25.860 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 7.63 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:34.136 | find | GSCM.SSP.Plan.WSL | SSP0013_GET_SHIPMENT_PLAN_CHANGE | 0 | 8253.07 | p_division_id=40, p_from_site=, p_to_site=, p_erp_so_no=, p_item_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20261212, p_status=, p_language=KO, debug_mode=F, p_change_type=C,P, p_checked=None, p_myModelChk=Y, p_user_id=jaeuk.shin |
| 20:50:34.222 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 25 | 3.55 | p_program_id=SSP0013, p_user_id=jaeuk.shin, p_sheet_name=Stock information Detail |
| 20:50:34.230 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.17 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:34.245 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.58 | p_program_id=SSP0013, p_user_id=jaeuk.shin, p_sheet_name=Stock information |
| 20:50:34.253 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.1 | Code=LookupCommon3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:34.270 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.2 | p_menu_id=SSP0013, p_log_type=FIND, p_log_cnt=, p_db_time=8.271, p_ui_time=0.118, p_user_id=jaeuk.shin |
| 20:50:39.442 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.72 | MenuID=Shipment Plan Adjustment, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| From Site | clbFromSite |  |
| Status | cboStatus |  |
| Shipment Date | drpPeriod |  |
| Model | txtRequest |  |
| layoutControlItem2 | btnItemId |  |
| Shipment Type | cboChangeType |  |
| SO No | txtSoNo |  |
| To Site | clbToSite |  |
| Div* | cboDivision | Y |
| layoutControlItem8 | chkMyModel |  |
| Checked | cboChecked |  |
| layoutControlItem2 | btnChecked |  |
| Model | txtModel2 |  |
| layoutControlItem5 | btnItemID2 |  |
| layoutControlItem6 | btnSearch |  |
| Created Date | txtCreateDate |  |

## 그리드

- spdMain / Shipment Plan Adjustment: 행 0 · 컬럼 62(보임 34) · 헤더 1단 · 고정 컬럼 0
- spdSub / Stock information: 행 0 · 컬럼 20(보임 19) · 헤더 1단 · 고정 컬럼 0
- spdSub / Stock information Detail: 행 0 · 컬럼 26(보임 25) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

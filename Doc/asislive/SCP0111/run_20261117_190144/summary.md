# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-17 19:01:44.968 ~ 2026-11-17 19:02:04.282 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: Total : 1,712 · DB : 0.344s, UI : 0.095s · 완료 판단 status
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "cboPlanDate", "prop": "ControlValues", "value": "20260907", "param": "plan_start_yyyymmdd", "from": "20260817", "sheet": "main"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:01:45.450 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.41 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:01:45.636 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 183 | 177.62 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:01:45.775 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 567 | 130.38 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:01:45.917 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 569 | 132.45 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:01:45.934 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.94 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:01:46.010 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 67.1 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:01:46.377 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 19:01:46.408 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.25 | USER_ID= |
| 19:01:46.623 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 5.94 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:01:46.633 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.13 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:01:46.643 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.22 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:01:46.677 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.41 |  |
| 19:01:46.698 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.76 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 19:01:46.718 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.81 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:01:46.745 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 3.38 |  |
| 19:01:46.830 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.4 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 19:01:46.893 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 19:01:57.980 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.09 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 19:01:58.001 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 5.31 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:01:58.268 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 259.56 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 19:01:58.454 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.25 | p_menu_id=SCP0111, p_log_type=FIND, p_log_cnt=1712, p_db_time=0.344, p_ui_time=0.095, p_user_id=jaeuk.shin |
| 19:02:03.563 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.0 | MenuID=Integration PSI, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Cell Model | txtCellItemId |  |
| Plan date* | cboPlanDate | Y |
| layoutControlItem3 | btnNickName |  |
| Model | txtItemId |  |
| layoutControlItem1 | btnItemId |  |
| layoutControlItem4 | btnCellItem_Id |  |
| Nick Name | txtNickName |  |
| Period | cmbFromMonth |  |
| Plan type | cboPlanType |  |
| ~ | cmbToMonth |  |
| layoutControlItem6 | chkQty |  |

## 그리드

- spdMain / Integration PSI: 행 1712 · 컬럼 30(보임 28) · 헤더 1단 · 고정 컬럼 20

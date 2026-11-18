# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-17 18:48:41.624 ~ 2026-11-17 18:49:04.655 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: Total : 1,712 · DB : 2.864s, UI : 0.099s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:48:42.270 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.65 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:48:42.534 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 183 | 250.96 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:48:42.831 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 567 | 287.61 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:48:42.982 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 569 | 135.2 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:48:43.000 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.84 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:48:43.635 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 624.16 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:48:44.268 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 18:48:44.299 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.67 | USER_ID= |
| 18:48:44.674 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 46.28 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 18:48:44.700 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.46 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:48:44.726 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.39 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:48:46.292 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 30.16 |  |
| 18:48:46.392 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 24.18 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 18:48:46.420 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.21 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:48:46.622 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 75.9 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 18:48:46.726 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 18:48:47.626 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 44.04 |  |
| 18:48:55.516 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 5.96 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 18:48:55.542 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.51 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:48:58.336 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 2769.27 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 18:48:58.538 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 20.29 | p_menu_id=SCP0111, p_log_type=FIND, p_log_cnt=1712, p_db_time=2.864, p_ui_time=0.099, p_user_id=jaeuk.shin |
| 18:49:03.981 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.41 | MenuID=Integration PSI, CnntCode=0104002, UserID=jaeuk.shin |

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

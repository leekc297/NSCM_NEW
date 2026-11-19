# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-19 12:13:14.605 ~ 2026-11-19 12:13:49.473 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: Total : 1,712 · DB : 0.368s, UI : 0.109s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 12:13:31.579 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.98 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:13:31.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 183 | 178.06 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:13:31.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 567 | 132.28 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:13:32.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 569 | 134.6 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:13:32.084 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.18 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:13:32.154 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 62.76 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:13:32.901 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 25.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 12:13:32.945 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.97 | USER_ID= |
| 12:13:33.236 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 5.42 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 12:13:33.272 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 28.56 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:13:33.282 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.05 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:13:33.351 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 5.45 |  |
| 12:13:33.678 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 273.55 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 12:13:33.715 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.2 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:13:33.774 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 5.15 |  |
| 12:13:34.383 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 547.09 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 12:13:34.610 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 102.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 12:13:43.579 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 6.49 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 12:13:43.603 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.1 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 12:13:43.882 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 268.6 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 12:13:44.125 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 30.02 | p_menu_id=SCP0111, p_log_type=FIND, p_log_cnt=1712, p_db_time=0.368, p_ui_time=0.109, p_user_id=jaeuk.shin |

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

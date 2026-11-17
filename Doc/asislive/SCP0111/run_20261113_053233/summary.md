# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-13 05:32:33.536 ~ 2026-11-13 05:32:55.716 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: Total : 1,712 · DB : 2.512s, UI : 0.092s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:32:33.923 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.88 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:34.109 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 181.14 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:34.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 214.51 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:34.471 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 135.69 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:34.483 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.49 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:34.619 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 132.48 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:34.681 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 05:32:34.706 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.28 | USER_ID= |
| 05:32:34.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 44.19 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:34.938 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 48.25 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:34.951 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.67 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:35.012 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.78 |  |
| 05:32:35.023 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.56 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 05:32:35.037 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.6 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:35.105 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 57.27 |  |
| 05:32:35.150 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 91.19 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 05:32:35.206 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 05:32:46.798 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.9 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 05:32:46.813 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.11 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:32:49.260 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 2442.5 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 05:32:49.429 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.54 | p_menu_id=SCP0111, p_log_type=FIND, p_log_cnt=1712, p_db_time=2.512, p_ui_time=0.092, p_user_id=jaeuk.shin |
| 05:32:55.062 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.41 | MenuID=Integration PSI, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

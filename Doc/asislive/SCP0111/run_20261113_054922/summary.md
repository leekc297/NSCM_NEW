# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-13 05:49:22.823 ~ 2026-11-13 05:49:42.477 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: Total : 1,712 · DB : 0.357s, UI : 0.016s · 완료 판단 status
- 조건: 시나리오 {"rule": "tobe", "set": [{"name": "cboPlanDate", "prop": "ControlValues", "value": "20260907", "param": "plan_start_yyyymmdd", "from": "20260817", "sheet": "main"}], "then_fill": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:49:23.211 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.99 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:23.400 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 184.1 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:23.541 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 135.09 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:23.685 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 135.58 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:23.708 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.2 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:23.776 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 65.68 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:23.842 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 05:49:23.870 | load | GSCM.BizService.WSL | SELECT * | 874 | 23.7 | USER_ID= |
| 05:49:24.052 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 6.12 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:49:24.060 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 3.73 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:24.072 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 8.19 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:24.124 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.02 |  |
| 05:49:24.135 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.7 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 05:49:24.151 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.15 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:24.169 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 3.48 |  |
| 05:49:24.182 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.68 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 05:49:24.219 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 05:49:35.691 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.7 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 05:49:35.707 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.44 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:49:36.018 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 306.89 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 05:49:36.094 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.9 | p_menu_id=SCP0111, p_log_type=FIND, p_log_cnt=1712, p_db_time=0.357, p_ui_time=0.016, p_user_id=jaeuk.shin |
| 05:49:41.784 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.39 | MenuID=Integration PSI, CnntCode=0104002, UserID=jaeuk.shin |

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

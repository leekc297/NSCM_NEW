# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-13 00:38:21.391 ~ 2026-11-13 00:38:40.444 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: Total : 1,712 · DB : 2.457s, UI : 0.084s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:38:21.863 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.86 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:22.072 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 203.85 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:22.232 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 153.09 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:22.407 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 155.47 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:22.462 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 42.85 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:22.536 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 69.52 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:22.669 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 22.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 00:38:22.705 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.56 | USER_ID= |
| 00:38:22.844 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 5.54 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:22.876 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 28.87 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:22.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.23 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:22.926 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.56 |  |
| 00:38:22.968 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 18.32 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 00:38:22.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.36 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:23.034 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 29.57 |  |
| 00:38:23.116 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 92.91 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 00:38:23.208 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 00:38:31.842 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 5.74 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 00:38:31.857 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.75 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:34.269 | find | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 2405.35 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 00:38:34.409 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.46 | p_menu_id=SCP0111, p_log_type=FIND, p_log_cnt=1712, p_db_time=2.457, p_ui_time=0.084, p_user_id=jaeuk.shin |
| 00:38:39.370 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.82 | MenuID=Integration PSI, CnntCode=0104002, UserID=jaeuk.shin |

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

# AS-IS 실측 요약 — SSP0020

- 실행: 2026-11-17 20:02:35.069 ~ 2026-11-17 20:03:04.714 · 계정 jaeuk.shin · 상태 OK
- 화면: Delegate (GSCM.SSP.Plan.UIL.SSP0020_Delegate)
- 조회 결과: Total : 1 · DB : 0.029s, UI : 0.081s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:02:49.696 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 4.09 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:02:50.139 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 20:02:50.178 | load | GSCM.BizService.WSL | SELECT * | 874 | 28.28 | USER_ID= |
| 20:02:50.476 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 28.52 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 20:02:50.500 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 9.36 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 20:02:50.611 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 7.85 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 20:02:50.903 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 115.95 | MenuID=Delegate, CnntCode=0104001, UserID=jaeuk.shin |
| 20:02:50.998 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 20:02:51.943 | load | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 115.31 | p_user_id=jaeuk.shin, p_language=KO |
| 20:02:51.990 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 5.48 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=1.355, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 20:02:58.927 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 6.66 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 20:02:58.964 | find | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 7.15 | p_user_id=jaeuk.shin, p_language=KO |
| 20:02:59.072 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.57 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=0.029, p_ui_time=0.081, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Delegatee* | txtDelegatee | Y |
| layoutControlItem2 | btnDelegatee |  |
| layoutControlItem1 | chkAll |  |
| Period* | drpPeriod | Y |
| layoutControlItem4 | clbDivision |  |
| UnSet | btnUnSet |  |
| SAVE | btnSave |  |
| layoutControlItem3 | usrLabel1 |  |
| layoutControlItem10 | btnMeasure |  |

## 그리드

- spdMain / Delegate: 행 1 · 컬럼 9(보임 8) · 헤더 1단 · 고정 컬럼 0
- spdMain / Delegated List: 행 1 · 컬럼 9(보임 7) · 헤더 1단 · 고정 컬럼 0

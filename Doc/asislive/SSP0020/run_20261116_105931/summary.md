# AS-IS 실측 요약 — SSP0020

- 실행: 2026-11-16 10:59:31.927 ~ 2026-11-16 11:00:00.950 · 계정 jaeuk.shin · 상태 OK
- 화면: Delegate (GSCM.SSP.Plan.UIL.SSP0020_Delegate)
- 조회 결과: Total : 1 · DB : 0.034s, UI : 0.114s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 10:59:45.408 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.41 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:45.808 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 10:59:45.836 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.94 | USER_ID= |
| 10:59:46.091 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 7.26 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 10:59:46.107 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 5.23 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 10:59:46.274 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 6.57 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 10:59:46.314 | load | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 4.88 | p_user_id=jaeuk.shin, p_language=KO |
| 10:59:46.412 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 10.72 | MenuID=Delegate, CnntCode=0104001, UserID=jaeuk.shin |
| 10:59:46.488 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 10:59:46.661 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.2 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=0.371, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 10:59:54.622 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 5.97 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 10:59:54.683 | find | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 4.88 | p_user_id=jaeuk.shin, p_language=KO |
| 10:59:54.830 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.88 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=0.034, p_ui_time=0.114, p_user_id=jaeuk.shin |

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

# AS-IS 실측 요약 — SSP0020

- 실행: 2026-11-26 17:13:27.394 ~ 2026-11-26 17:14:23.133 · 계정 jaeuk.shin · 상태 OK
- 화면: Delegate (GSCM.SSP.Plan.UIL.SSP0020_Delegate)
- 조회 결과: Total : 1 · DB : 0.027s, UI : 0.082s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 17:13:55.756 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 1539.81 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:13:57.346 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 326.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 17:13:57.537 | load | GSCM.BizService.WSL | SELECT * | 874 | 168.02 | USER_ID= |
| 17:14:01.127 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 2876.91 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 17:14:01.187 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 13.35 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 17:14:01.377 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 12.93 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 17:14:02.507 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 799.61 | MenuID=Delegate, CnntCode=0104001, UserID=jaeuk.shin |
| 17:14:03.346 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 455.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 17:14:07.095 | load | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 5597.38 | p_user_id=jaeuk.shin, p_language=KO |
| 17:14:07.386 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 244.7 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=5.718, p_ui_time=0.02, p_user_id=jaeuk.shin |
| 17:14:14.169 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 23.54 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 17:14:14.227 | find | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 17.1 | p_user_id=jaeuk.shin, p_language=KO |
| 17:14:15.335 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 1018.02 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=0.027, p_ui_time=0.082, p_user_id=jaeuk.shin |

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

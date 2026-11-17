# AS-IS 실측 요약 — SSP0020

- 실행: 2026-11-15 10:44:15.868 ~ 2026-11-15 10:44:32.427 · 계정 jaeuk.shin · 상태 OK
- 화면: Delegate (GSCM.SSP.Plan.UIL.SSP0020_Delegate)
- 조회 결과: Total : 1 · DB : 0.019s, UI : 0.093s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 10:44:16.247 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.2 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:44:16.572 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 10:44:16.608 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.02 | USER_ID= |
| 10:44:16.809 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 3.62 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 10:44:16.817 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 3.59 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 10:44:16.979 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 3.6 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegated List |
| 10:44:17.009 | load | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 3.6 | p_user_id=jaeuk.shin, p_language=KO |
| 10:44:17.111 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.53 | MenuID=Delegate, CnntCode=0104001, UserID=jaeuk.shin |
| 10:44:17.185 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0020 |
| 10:44:18.261 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 932.59 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=0.336, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 10:44:25.705 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 8 | 3.62 | p_program_id=SSP0020, p_user_id=jaeuk.shin, p_sheet_name=Delegate |
| 10:44:25.745 | find | GSCM.SSP.Plan.WSL | SSP0020_GET_DELEGATE | 1 | 3.44 | p_user_id=jaeuk.shin, p_language=KO |
| 10:44:25.863 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.84 | p_menu_id=SSP0020, p_log_type=FIND, p_log_cnt=1, p_db_time=0.019, p_ui_time=0.093, p_user_id=jaeuk.shin |
| 10:44:31.732 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.61 | MenuID=Delegate, CnntCode=0104002, UserID=jaeuk.shin |

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

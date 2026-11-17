# AS-IS 실측 요약 — SCP0080

- 실행: 2026-11-12 20:11:28.472 ~ 2026-11-12 20:12:09.946 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Code Master (GSCM.SCP.Master.UIL.SCP0080_GroupCodeManagement)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:11:28.951 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 138 | 133.87 | Code=OperationForPlanDivisionId1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:11:28.976 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.04 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:11:29.088 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0080 |
| 20:11:29.113 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.3 | USER_ID= |
| 20:11:29.326 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 35.49 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81 |
| 20:11:29.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.55 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.352 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.15 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.360 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.03 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.369 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.53 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.378 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.63 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.385 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.29 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.75 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.406 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.59 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.418 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 5.57 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_UC |
| 20:11:29.429 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.44 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.452 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 17.03 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.459 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.5 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.466 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.23 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.474 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.55 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.481 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.26 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.488 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.41 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.500 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.32 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.509 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 4.7 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_HM |
| 20:11:29.521 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.42 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.530 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.03 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.539 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.53 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.547 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.64 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.556 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.24 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.564 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.17 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.571 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.24 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.583 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 2.98 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.592 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 4.35 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_ST |
| 20:11:29.605 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.17 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.611 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.14 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.16 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.626 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.19 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.635 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.02 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.641 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.88 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.648 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.37 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.658 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.06 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.668 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.25 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 40 |
| 20:11:29.679 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.16 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.686 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.37 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.694 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.25 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.701 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.26 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.708 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.03 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.715 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.27 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.724 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.11 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 82 |
| 20:11:29.735 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.21 | Code=ESS_CATEGORY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.744 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.73 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.750 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.35 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.757 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.47 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.764 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.32 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.771 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.48 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.777 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.87 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:29.787 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.09 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management |
| 20:11:30.131 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 310.52 | MenuID=Model Code Master, CnntCode=0104001, UserID=jaeuk.shin |
| 20:11:30.188 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0080 |
| 20:11:38.307 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 5.11 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81 |
| 20:11:38.321 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.74 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.347 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.84 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.355 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.43 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.364 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.19 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.377 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.18 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.384 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.15 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.391 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.14 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:11:38.404 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.53 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Model | txtModel |  |
| NickName | txtNickname |  |
| Operation | clbOperation |  |
| layoutControlItem1 | chkFCST |  |
| layoutControlItem2 | chkProduction |  |
| Div* | cboDivision | Y |
| layoutControlItem1 | chkActive |  |
| layoutControlItem1 | chkBOM |  |

## 그리드

- spd81_ST / Group Code Management - 81_ST: 행 0 · 컬럼 45(보임 35) · 헤더 2단 · 고정 컬럼 9
- spd81_UC / Group Code Management - 81_UC: 행 0 · 컬럼 45(보임 35) · 헤더 2단 · 고정 컬럼 9
- spd81_HM / Group Code Management - 81_HM: 행 0 · 컬럼 45(보임 35) · 헤더 2단 · 고정 컬럼 9
- spd82 / Group Code Management - 82: 행 0 · 컬럼 35(보임 34) · 헤더 2단 · 고정 컬럼 9
- spd81 / Group Code Management - 81: 행 0 · 컬럼 45(보임 35) · 헤더 2단 · 고정 컬럼 9
- spd40 / Group Code Management - 40: 행 0 · 컬럼 35(보임 34) · 헤더 2단 · 고정 컬럼 6
- spdEtc / Group Code Management: 행 0 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 5

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0080

- 실행: 2026-11-13 00:21:27.893 ~ 2026-11-13 00:29:53.447 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Code Master (GSCM.SCP.Master.UIL.SCP0080_GroupCodeManagement)
- 조회 결과: Total : 4,526 · DB : 488.665s, UI : 0.575s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:21:28.367 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 138 | 114.82 | Code=OperationForPlanDivisionId1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:21:28.392 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.46 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:21:28.498 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0080 |
| 00:21:28.521 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.82 | USER_ID= |
| 00:21:28.675 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 28.73 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81 |
| 00:21:28.713 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 30.15 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.762 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 44.13 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.774 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.83 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.95 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.788 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.22 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.795 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.09 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.801 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.06 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.811 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.12 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.821 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 5.48 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_UC |
| 00:21:28.834 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.19 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.839 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.96 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.846 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.2 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.853 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.41 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.862 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.33 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.869 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.13 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.876 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.04 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.887 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.1 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.897 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 4.5 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_HM |
| 00:21:28.909 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.43 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.919 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.95 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.927 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.33 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.934 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.83 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.941 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.26 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.947 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.13 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.953 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.0 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.963 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.13 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.972 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 4.47 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_ST |
| 00:21:28.985 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.32 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.991 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.99 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:28.998 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.25 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.005 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.24 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.015 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.3 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.021 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.44 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.029 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.28 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.041 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.16 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.050 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.65 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 40 |
| 00:21:29.061 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.28 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.069 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.05 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.075 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.99 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.083 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.32 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.090 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.97 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.096 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.26 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.107 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.23 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 82 |
| 00:21:29.146 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 34.76 | Code=ESS_CATEGORY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.159 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.84 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.170 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.94 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.181 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 5.31 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.190 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.61 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.6 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.206 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.04 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:29.218 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.28 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management |
| 00:21:29.403 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 154.63 | MenuID=Model Code Master, CnntCode=0104001, UserID=jaeuk.shin |
| 00:21:29.465 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.68 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0080 |
| 00:21:37.447 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 4.28 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81 |
| 00:21:37.457 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.11 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.464 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.2 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.469 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.4 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.478 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.81 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.486 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.68 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.493 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.18 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.500 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.99 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:37.520 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.85 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:45.847 | find | GSCM.SCM.Master.WSL | SCP0080_GET_GROUP_CODE_MANAGEMENT | 4526 | 488315.77 | p_division_id=81, p_operation_id=A3000,A7000,A8000,A8200,A8210,A9000,F5300,F6000,F6200,F7000,F7100,F7200,F7300,P5000,P5500,P9500,PL500, p_model_id=, p_nickname=, p_check_fcst=N, p_check_production=N, p_check_active=N, p_check_bom=N, p_user_id=jaeuk.shin, debug_mode=F |
| 00:29:46.666 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 49.45 | p_menu_id=SCP0080, p_log_type=FIND, p_log_cnt=4526, p_db_time=488.665, p_ui_time=0.575, p_user_id=jaeuk.shin |
| 00:29:52.088 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.24 | MenuID=Model Code Master, CnntCode=0104002, UserID=jaeuk.shin |

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
- spd81 / Group Code Management - 81: 행 4526 · 컬럼 46(보임 35) · 헤더 2단 · 고정 컬럼 10
- spd40 / Group Code Management - 40: 행 0 · 컬럼 35(보임 34) · 헤더 2단 · 고정 컬럼 6
- spdEtc / Group Code Management: 행 0 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 5

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

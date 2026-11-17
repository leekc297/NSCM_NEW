# AS-IS 실측 요약 — SCP0080

- 실행: 2026-11-12 22:41:04.805 ~ 2026-11-12 22:41:56.614 · 계정 jaeuk.shin · 상태 OK
- 화면: Model Code Master (GSCM.SCP.Master.UIL.SCP0080_GroupCodeManagement)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:41:06.903 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 138 | 1760.09 | Code=OperationForPlanDivisionId1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:41:06.939 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.55 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:41:07.402 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0080 |
| 22:41:07.427 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.47 | USER_ID= |
| 22:41:08.035 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 435.23 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81 |
| 22:41:08.518 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 450.02 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.743 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 212.38 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.767 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 5.85 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.776 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.62 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.786 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.43 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.796 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.49 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.804 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.55 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.826 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.32 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.842 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 6.06 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_UC |
| 22:41:08.856 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.31 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.09 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.877 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.34 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.14 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.898 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.5 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.908 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.58 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.916 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.44 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.928 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.77 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.940 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 5.07 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_HM |
| 22:41:08.952 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.27 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.959 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.44 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.967 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.91 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.974 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.81 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.984 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.41 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.990 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.33 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:08.997 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.74 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.011 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.75 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.020 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 4.78 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81_ST |
| 22:41:09.031 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.37 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.038 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.07 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.046 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.54 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.053 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.53 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.063 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.24 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.071 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.61 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.42 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.091 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.5 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.102 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.79 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 40 |
| 22:41:09.115 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.35 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.124 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.74 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.134 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.02 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.144 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.79 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.153 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.2 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.162 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.24 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.174 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 34 | 4.8 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 82 |
| 22:41:09.297 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 114.22 | Code=ESS_CATEGORY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.308 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.41 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.316 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.86 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.327 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.43 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.346 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.07 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.359 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.43 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.373 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.94 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:09.395 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.2 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management |
| 22:41:11.736 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2184.51 | MenuID=Model Code Master, CnntCode=0104001, UserID=jaeuk.shin |
| 22:41:12.061 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0080 |
| 22:41:16.678 | load | GSCM.SCP.Analysis.WSL | SCP0012_GET_PSI | 0 | 900021.82 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_operation_group=P, p_From_Site=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, p_item_id=, p_electype=, p_program_id=None, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_user_id=None, p_cell_type_gr= |
| 22:41:23.245 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 44 | 5.08 | p_program_id=SCP0080, p_user_id=jaeuk.shin, p_sheet_name=Group Code Management - 81 |
| 22:41:23.266 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.33 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.279 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.6 | Code=ALL_V_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.292 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.14 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.300 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.73 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.313 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.14 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.322 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.66 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.333 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.25 | Code=ALL_Y_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:41:23.359 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.87 | Code=SEQ_NUMBER, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

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

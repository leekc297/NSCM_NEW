# AS-IS 실측 요약 — SCP0106

- 실행: 2026-11-12 20:29:09.097 ~ 2026-11-12 20:29:54.281 · 계정 jaeuk.shin · 상태 OK
- 화면: Loss Plan (GSCM.SCP.Master.UIL.SCP0106_CAPA_Loss_Plan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:29:09.402 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.86 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:29:09.413 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 4.85 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:29:09.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.12 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:29:09.429 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.17 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:29:09.773 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.34 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0106 |
| 20:29:09.800 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.79 | USER_ID= |
| 20:29:10.104 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1873 | 179.34 | Code=CapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:29:10.371 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 58 | 17.56 | p_from_yyyymm=202611, p_program_id=SCP0106, p_sheet_name=CURRENT |
| 20:29:10.963 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 579.37 | p_program_id=SCP0106, p_user_id=jaeuk.shin, p_sheet_name=CURRENT_ELTR |
| 20:29:10.991 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 4.36 | p_program_id=SCP0106, p_user_id=jaeuk.shin, p_sheet_name=CURRENT_ELTR |
| 20:29:14.236 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3108.81 | MenuID=Loss Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 20:29:14.664 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0106 |
| 20:29:22.973 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 58 | 13.88 | p_from_yyyymm=202611, p_program_id=SCP0106, p_sheet_name=CURRENT |
| 20:29:22.984 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 3.92 | p_program_id=SCP0106, p_user_id=jaeuk.shin, p_sheet_name=CURRENT_ELTR |
| 20:29:23.003 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 30 | 4.37 | p_program_id=SCP0106, p_user_id=jaeuk.shin, p_sheet_name=CURRENT_ELTR |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Status | cboProgressStatus |  |
| Plan Month | cboVersion |  |
| Site | clbSite |  |
| Building | clbFactory |  |
| Status | cboSheetType |  |
| Line | clbLine |  |
| Model | txtItem |  |
| layoutControlItem10 | btnItemId |  |
| lciDivisionType | rgrpDivisionType |  |
| Version | cboVersionSeq |  |
| PlanType | txtPlanType |  |
| Plant | clbPlant |  |
| Line Type | clbElectrodeType |  |
| Operation | clbOperation |  |
| lciShowRate | chkShowRate |  |
| layoutControlItem1 | btnColumn |  |

## 그리드

- spdMain / CURRENT_ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / CUTOFF_MODEL_ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / 1ST_CUTOFF_LINE_ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / 2ND_CUTOFF_LINE_ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / CURRENT_ELTR: 행 0 · 컬럼 89(보임 88) · 헤더 3단 · 고정 컬럼 31
- spdMain / CUTOFF_MODEL_ELTR: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / 1ST_CUTOFF_LINE_ELTR: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / 2ND_CUTOFF_LINE_ELTR: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

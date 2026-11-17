# AS-IS 실측 요약 — SCP0104

- 실행: 2026-11-12 20:25:44.886 ~ 2026-11-12 20:27:47.523 · 계정 jaeuk.shin · 상태 OK
- 화면: Line Assign (GSCM.SCP.Master.UIL.SCP0104_CAPA_Line_Assign)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:25:45.229 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.29 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:25:45.790 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 556.27 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:25:45.799 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 4.22 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:25:46.461 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 67 | 658.02 | Code=CapaOperationByLine, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:25:46.469 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 3.89 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:08.026 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 36365 | 21552.64 | Code=CapaNickname, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:39.055 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 622 | 30708.68 | Code=CapaDummyCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:39.323 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 262.13 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:39.403 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 20:26:39.428 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.52 | USER_ID= |
| 20:26:39.560 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 305 | 18.03 | Code=DummyCapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:39.724 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 8 | 137.12 | Code=CapaOperationByLineEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:39.734 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.86 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:45.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.07 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:26:46.485 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 893.21 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 20:26:46.860 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 363.31 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:26:46.891 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 20.78 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:26:46.947 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 19.84 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:26:46.967 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 3.91 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=SOP_ELTR |
| 20:26:49.925 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2928.85 | MenuID=Line Assign, CnntCode=0104001, UserID=jaeuk.shin |
| 20:26:50.252 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 20:26:58.558 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 9.9 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 20:26:58.581 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 19.66 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:26:58.607 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 19.02 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:26:58.647 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 20.27 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:27:14.980 | find | GSCM.SCP.Master.WSL | SCP0100_GET_SITE | 38 | 355776.01 | p_site_tpye=FROM_SITE, p_division_id=, p_bucket=MONTHLY |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Plan Month | cboVersion |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| Operation | clbOperation |  |
| Model | txtItem |  |
| Line Type | clbElectrodeType |  |
| Building | clbFactory |  |
| layoutControlItem10 | btnItemId |  |
| Line | clbLine |  |
| Version | cboVersionSeq |  |
| PlanType | txtPlanType |  |
| lciDivisionType | rgrpDivisionType |  |
| Valid | cboValid |  |
| layoutControlItem1 | btnColumn |  |

## 그리드

- spdAssign / ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdAssign / ELTR: 행 0 · 컬럼 53(보임 50) · 헤더 3단 · 고정 컬럼 24
- spdSOP / SOP_ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 1단 · 고정 컬럼 0
- spdSOP / SOP_ELTR: 행 0 · 컬럼 21(보임 20) · 헤더 1단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0107

- 실행: 2026-11-12 20:30:10.328 ~ 2026-11-12 20:30:59.463 · 계정 jaeuk.shin · 상태 OK
- 화면: TEEP Report (GSCM.SCP.Report.UIL.SCP0107_CAPA_TEEP_Report)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:30:10.691 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.03 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:30:10.704 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 5.27 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:30:10.713 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.29 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:30:10.719 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.11 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:30:11.059 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0107 |
| 20:30:11.085 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.01 | USER_ID= |
| 20:30:11.392 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1873 | 177.91 | Code=CapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:30:11.471 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.24 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:30:11.660 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 30 | 17.93 | p_from_yyyymm=202610, p_program_id=SCP0107, p_sheet_name=ELTR |
| 20:30:12.203 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 531.95 | p_program_id=SCP0107, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:30:12.253 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.48 | p_program_id=SCP0107, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:30:17.868 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5497.18 | MenuID=TEEP Report, CnntCode=0104001, UserID=jaeuk.shin |
| 20:30:18.748 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0107 |
| 20:30:27.508 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 30 | 19.8 | p_from_yyyymm=202610, p_program_id=SCP0107, p_sheet_name=ELTR |
| 20:30:27.519 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 7.13 | p_program_id=SCP0107, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:30:27.540 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 7.33 | p_program_id=SCP0107, p_user_id=jaeuk.shin, p_sheet_name=ELTR |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Month | cboVersion |  |
| Site | clbSite |  |
| Operation | clbOperation |  |
| Plant | clbPlant |  |
| Line Type | clbElectrodeType |  |
| Div | clbDivision |  |
| Version | cboVersionSeq |  |
| PlanType | txtPlanType |  |
| Line | clbLine |  |
| Building | clbFactory |  |
| lciDivisionType | rgrpDivisionType |  |
| layoutControlItem1 | btnColumn |  |

## 그리드

- spdMain / ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / ELTR: 행 0 · 컬럼 47(보임 46) · 헤더 3단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

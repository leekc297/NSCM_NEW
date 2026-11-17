# AS-IS 실측 요약 — SCP0104

- 실행: 2026-11-17 16:18:14.917 ~ 2026-11-17 16:25:18.806 · 계정 jaeuk.shin · 상태 OK
- 화면: Line Assign (GSCM.SCP.Master.UIL.SCP0104_CAPA_Line_Assign)
- 조회 결과: Total : 275 · DB : 2.36s, UI : 0.052s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:24:49.396 | load | GSCM.BizService.WSL | UP_FX_GetGSCMUserAuthenctication | 1 | 4.02 | UserID=jaeuk.shin |
| 16:24:49.428 | load | GSCM.BizService.WSL | UP_FX_SaveUserConnect | -1 | 5.98 | UserID=jaeuk.shin, CnntCode=0103001, SN=LEE-03, PushKey=, CnntIP=100.113.200.36 |
| 16:24:49.473 | load | GSCM.SystemMgmt.WSL | UP_FX_GetMessageInfoList | 470 | 20.15 | Search=None |
| 16:24:49.546 | load | GSCM.SystemMgmt.WSL | UP_FX_GetTermInfoList | 665 | 12.65 | Search=None |
| 16:24:50.535 | load | GSCM.DataService.WSL | UP_FX_GetFavoriteList | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin |
| 16:24:56.877 | find | GSCM.DataService.WSL | UP_FX_GetGSCMAuthenticationMenuList | 273 | 6334.63 | UserID=jaeuk.shin, GroupID=ADMIN, ProgramId= |
| 16:25:00.614 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 5.06 | Code=MyGroupID, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:25:00.766 | find | GSCM.BizService.WSL | SELECT | 1 | 3.76 | USER_ID=jaeuk.shin |
| 16:25:00.782 | find | GSCM.BizService.WSL | DECLARE @v_time  NVARCHAR(10); | 0 | 5.01 | USER_ID=jaeuk.shin |
| 16:25:02.463 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.5 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:02.481 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 7.42 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:02.496 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.49 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:02.508 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 67 | 5.67 | Code=CapaOperationByLine, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:02.520 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.32 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:03.280 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 36365 | 750.08 | Code=CapaNickname, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:04.000 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 622 | 20.12 | Code=CapaDummyCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:04.021 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.84 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:04.964 | find | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.41 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 16:25:05.004 | find | GSCM.BizService.WSL | SELECT * | 874 | 19.71 | USER_ID= |
| 16:25:05.365 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 305 | 26.49 | Code=DummyCapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:05.404 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 8 | 6.19 | Code=CapaOperationByLineEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:05.415 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.95 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:18.396 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 5.15 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:25:18.630 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 12.44 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 16:25:18.673 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 25.55 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:25:18.715 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 24.74 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:25:18.806 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 25.37 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |

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
- spdAssign / ELTR: 행 275 · 컬럼 54(보임 50) · 헤더 3단 · 고정 컬럼 25
- spdSOP / SOP_ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 1단 · 고정 컬럼 0
- spdSOP / SOP_ELTR: 행 0 · 컬럼 21(보임 20) · 헤더 1단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(10528)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

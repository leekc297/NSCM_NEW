# AS-IS 실측 요약 — SCP0105

- 실행: 2026-11-12 20:28:03.305 ~ 2026-11-12 20:28:53.299 · 계정 jaeuk.shin · 상태 OK
- 화면: Speed Plan (GSCM.SCP.Master.UIL.SCP0105_CAPA_Speed_Plan)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:28:03.646 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.76 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:28:03.657 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 5.57 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:28:03.667 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.44 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:28:03.675 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.55 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:28:04.023 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0105 |
| 20:28:04.050 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.29 | USER_ID= |
| 20:28:08.863 | load | GSCM.SCP.Master.WSL | SCP0104_GET_CAPA_LINE_ASSIGN_ELTR | 275 | 70198.32 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,HQ11,MI00,MI02,NA00,NB01,WA00, p_factory_id=E5,E6,E9,EA,EB,EC,ED,EF,EG,EJ,ES,ET,EY,EZ, p_line_id=DUM_MI2_E3_A,DUM_MI2_E3_C,E5DP1,E5DP2,ESD01,ETD02,EZD01,FP_E5M01_A,FP_E5M01_C,FP_E5M02_A,FP_E5M02_C,FP_ |
| 20:28:09.864 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1873 | 5691.68 | Code=CapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:28:09.948 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 3.45 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:28:10.149 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 58 | 10.74 | p_from_yyyymm=202611, p_program_id=SCP0105, p_sheet_name= |
| 20:28:10.308 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 142.64 | p_program_id=SCP0105, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:28:10.345 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 3.47 | p_program_id=SCP0105, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:28:13.655 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3193.88 | MenuID=Speed Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 20:28:13.945 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0105 |
| 20:28:21.928 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 58 | 10.54 | p_from_yyyymm=202611, p_program_id=SCP0105, p_sheet_name= |
| 20:28:21.937 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 4.59 | p_program_id=SCP0105, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 20:28:21.956 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 4.48 | p_program_id=SCP0105, p_user_id=jaeuk.shin, p_sheet_name=ELTR |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Status | cboProgressStatus |  |
| Plan Month | cboVersion |  |
| Site | clbSite |  |
| Operation | clbOperation |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Line | clbLine |  |
| Line Type | clbElectrodeType |  |
| Model | txtItem |  |
| layoutControlItem10 | btnItemId |  |
| lciDivisionType | rgrpDivisionType |  |
| Version | cboVersionSeq |  |
| PlanType | txtPlanType |  |
| layoutControlItem1 | btnColumn |  |

## 그리드

- spdMain / ASSEMBLY: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdMain / ELTR: 행 0 · 컬럼 88(보임 87) · 헤더 3단 · 고정 컬럼 30

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

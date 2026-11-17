# AS-IS 실측 요약 — SCP0104

- 실행: 2026-11-16 16:12:01.200 ~ 2026-11-16 16:13:05.949 · 계정 jaeuk.shin · 상태 OK
- 화면: Line Assign (GSCM.SCP.Master.UIL.SCP0104_CAPA_Line_Assign)
- 조회 결과: Total : 275 · DB : 2.448s, UI : 0.164s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:12:28.472 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 5971.75 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:28.569 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 6.56 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:28.589 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.91 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:28.620 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 67 | 29.72 | Code=CapaOperationByLine, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:28.630 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 5.35 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:29.481 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 36365 | 843.64 | Code=CapaNickname, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:30.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 622 | 162.83 | Code=CapaDummyCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:30.330 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 41.22 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:31.789 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.68 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 16:12:31.829 | load | GSCM.BizService.WSL | SELECT * | 874 | 24.95 | USER_ID= |
| 16:12:32.182 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 305 | 16.66 | Code=DummyCapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:32.220 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 8 | 5.09 | Code=CapaOperationByLineEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:32.220 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.23 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:44.894 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 12.51 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:12:45.685 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 16.14 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 16:12:46.461 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 62.9 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:12:46.561 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 27.48 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:12:46.664 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 27.81 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:12:46.727 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 5.31 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=SOP_ELTR |
| 16:12:47.064 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 95.35 | MenuID=Line Assign, CnntCode=0104001, UserID=jaeuk.shin |
| 16:12:47.249 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 24.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 16:12:56.873 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 16.57 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 16:12:56.908 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 26.85 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:12:56.942 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 26.23 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:12:57.008 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 25.44 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 16:12:59.112 | find | GSCM.SCP.Master.WSL | SCP0104_GET_CAPA_LINE_ASSIGN_ELTR | 275 | 2063.87 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,HQ11,MI00,MI02,NA00,NB01,WA00, p_factory_id=E5,E6,E9,EA,EB,EC,ED,EF,EG,EJ,ES,ET,EY,EZ, p_line_id=DUM_MI2_E3_A,DUM_MI2_E3_C,E5DP1,E5DP2,ESD01,ETD02,EZD01,FP_E5M01_A,FP_E5M01_C,FP_E5M02_A,FP_E5M02_C,FP_ |
| 16:12:59.398 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.3 | p_menu_id=SCP0104, p_log_type=FIND, p_log_cnt=275, p_db_time=2.448, p_ui_time=0.164, p_user_id=jaeuk.shin |

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

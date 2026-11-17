# AS-IS 실측 요약 — SCP0104

- 실행: 2026-11-14 02:39:33.918 ~ 2026-11-14 02:40:15.998 · 계정 jaeuk.shin · 상태 OK
- 화면: Line Assign (GSCM.SCP.Master.UIL.SCP0104_CAPA_Line_Assign)
- 조회 결과: Total : 275 · DB : 4.292s, UI : 0.122s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 02:39:50.280 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.04 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:50.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 10.78 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:50.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.5 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:50.312 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 67 | 5.68 | Code=CapaOperationByLine, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:50.327 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.23 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:51.191 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 36365 | 858.73 | Code=CapaNickname, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:51.768 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 622 | 222.5 | Code=CapaDummyCode, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:51.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 38.28 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:52.293 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 02:39:52.327 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.04 | USER_ID= |
| 02:39:52.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 305 | 19.33 | Code=DummyCapaLineMasterEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:52.580 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 8 | 6.86 | Code=CapaOperationByLineEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:52.585 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 4.24 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:56.655 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 125 | 3.89 | Code=OperationElectrodeType, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 02:39:56.772 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 14.65 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 02:39:56.926 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 119.24 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 02:39:56.963 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 27.07 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 02:39:57.021 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 27.07 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 02:39:57.074 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 20 | 6.02 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=SOP_ELTR |
| 02:39:57.295 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 92.48 | MenuID=Line Assign, CnntCode=0104001, UserID=jaeuk.shin |
| 02:39:57.376 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0104 |
| 02:40:05.730 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 15.29 | p_from_yyyymm=202611, p_program_id=SCP0104, p_sheet_name= |
| 02:40:05.762 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 27.09 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 02:40:05.793 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 25.68 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 02:40:05.824 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 25.29 | p_program_id=SCP0104, p_user_id=jaeuk.shin, p_sheet_name=ELTR |
| 02:40:09.922 | find | GSCM.SCP.Master.WSL | SCP0104_GET_CAPA_LINE_ASSIGN_ELTR | 275 | 4054.72 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,HQ11,MI00,MI02,NA00,NB01,WA00, p_factory_id=E5,E6,E9,EA,EB,EC,ED,EF,EG,EJ,ES,ET,EY,EZ, p_line_id=DUM_MI2_E3_A,DUM_MI2_E3_C,E5DP1,E5DP2,ESD01,ETD02,EZD01,FP_E5M01_A,FP_E5M01_C,FP_E5M02_A,FP_E5M02_C,FP_ |
| 02:40:10.071 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.6 | p_menu_id=SCP0104, p_log_type=FIND, p_log_cnt=275, p_db_time=4.292, p_ui_time=0.122, p_user_id=jaeuk.shin |

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

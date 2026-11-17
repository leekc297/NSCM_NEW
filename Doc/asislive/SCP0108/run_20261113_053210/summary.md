# AS-IS 실측 요약 — SCP0108

- 실행: 2026-11-13 05:32:10.572 ~ 2026-11-13 05:32:33.420 · 계정 jaeuk.shin · 상태 OK
- 화면: LOB Report (GSCM.SCP.Report.UIL.SCP0108_CAPA_LOB_Report)
- 조회 결과: Total : 214 · DB : 1.775s, UI : 0.757s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:32:10.862 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.57 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:10.918 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 51.17 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:10.927 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.3 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:11.787 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 10506 | 856.31 | Code=CapaLineMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:12.051 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 5.75 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:32:12.129 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 05:32:12.151 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.1 | USER_ID= |
| 05:32:12.924 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 17.48 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:12.943 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.84 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:12.965 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.56 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:12.997 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.49 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:13.012 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.81 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:13.033 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.76 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:13.172 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 69.12 | MenuID=LOB Report, CnntCode=0104001, UserID=jaeuk.shin |
| 05:32:13.214 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 05:32:20.789 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.9 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:20.804 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.6 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:20.825 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.77 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:20.862 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.01 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:20.877 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.71 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:20.896 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.93 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:20.924 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 12.38 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:20.939 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.47 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:20.957 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.49 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:21.051 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.03 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:21.066 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.94 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:21.086 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.73 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:24.606 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.52 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:32:24.623 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.75 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:24.645 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.35 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:32:26.273 | find | GSCM.SCP.Master.WSL | SCP0108_GET_CAPA_LOB_CURRENT | 214 | 1611.37 | p_version=202610, p_version_seq=1, p_division_id=40, p_site_id=A001,A002, p_plant_id=HQ06,HQ10,NJ01, p_factory_id=M1,M2,M4,M5,M6,M7,M8,M9,MC, p_line_id=M1C02,M1C03,M1C04,M2C06,M2C07,M2C08,M2C09,M2C10,M4T01,M4T03,M5C06,M5C08,M5C09,M5C10,M6L16,M6L17,M6L21,M6L26,M6L27,M6L28,M6L29,M6L30,M6L31,M6L32,M6L3 |
| 05:32:27.056 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.6 | p_menu_id=SCP0108, p_log_type=FIND, p_log_cnt=214, p_db_time=1.775, p_ui_time=0.757, p_user_id=jaeuk.shin |
| 05:32:32.554 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.42 | MenuID=LOB Report, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Plan Month | cboVersion |  |
| Operation | clbOperation |  |
| Site | clbSite |  |
| Line Type | clbElectrodeType |  |
| Building | clbFactory |  |
| Basic Nickname | txtItem |  |
| layoutControlItem10 | btnItemId |  |
| Status | cboProgressStatus |  |
| Version | cboVersionSeq |  |
| Plant | clbPlant |  |
| PlanType | txtPlanType |  |
| lciDivisionType | rgrpDivisionType |  |
| Line | clbLine |  |
| Bottleneck | cboBottleneck |  |
| layoutControlItem1 | btnColumn |  |

## 그리드

- spdMain / CURRENT: 행 214 · 컬럼 44(보임 43) · 헤더 3단 · 고정 컬럼 15
- spdMain / CUTOFF: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

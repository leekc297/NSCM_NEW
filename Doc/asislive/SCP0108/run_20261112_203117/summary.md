# AS-IS 실측 요약 — SCP0108

- 실행: 2026-11-12 20:31:17.673 ~ 2026-11-12 20:32:01.845 · 계정 jaeuk.shin · 상태 OK
- 화면: LOB Report (GSCM.SCP.Report.UIL.SCP0108_CAPA_LOB_Report)
- 조회 결과: Total : 318 · DB : 12.964s, UI : 1.838s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:31:18.027 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.06 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:31:18.042 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 5.74 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:31:18.051 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.34 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:31:25.139 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 10506 | 7083.0 | Code=CapaLineMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:31:25.402 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.93 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:31:25.802 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 20:31:25.829 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.74 | USER_ID= |
| 20:31:26.723 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 15.48 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 20:31:26.999 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 263.97 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 20:31:27.028 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 14.01 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 20:31:27.059 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.48 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 20:31:27.076 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.19 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 20:31:27.100 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 16.14 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 20:31:30.365 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3117.77 | MenuID=LOB Report, CnntCode=0104001, UserID=jaeuk.shin |
| 20:31:30.906 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 6.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 20:31:39.751 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 14.45 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 20:31:39.766 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.9 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 20:31:39.786 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 11.55 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 20:31:52.600 | find | GSCM.SCP.Master.WSL | SCP0108_GET_CAPA_LOB_CURRENT | 318 | 12789.87 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,MI00,MI02,NA00,NB01,WA00, p_factory_id=A2,A3,A4,A5,A6,A7,A8,A9,AA,AC,AH,AI, p_line_id=A2A10,A2A13,A2A14,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A05,A4A06,A4A07,A5A01,A5A03,A6A04,A6A05, |
| 20:31:54.904 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 434.17 | p_menu_id=SCP0108, p_log_type=FIND, p_log_cnt=318, p_db_time=12.964, p_ui_time=1.838, p_user_id=jaeuk.shin |
| 20:32:00.590 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.56 | MenuID=LOB Report, CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / CURRENT: 행 318 · 컬럼 44(보임 43) · 헤더 3단 · 고정 컬럼 15
- spdMain / CUTOFF: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

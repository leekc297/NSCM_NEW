# AS-IS 실측 요약 — SCP0108

- 실행: 2026-11-14 23:46:36.126 ~ 2026-11-14 23:47:02.174 · 계정 jaeuk.shin · 상태 OK
- 화면: LOB Report (GSCM.SCP.Report.UIL.SCP0108_CAPA_LOB_Report)
- 조회 결과: Total : 318 · DB : 3.054s, UI : 1.846s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:46:36.563 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.89 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:36.622 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 53.85 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:36.634 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.19 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:37.959 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 10506 | 1321.21 | Code=CapaLineMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:38.285 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 41.09 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:46:38.688 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 23:46:38.716 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.82 | USER_ID= |
| 23:46:39.476 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 15.05 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 23:46:39.524 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 35.81 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 23:46:39.556 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.11 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 23:46:39.591 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 12.73 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 23:46:39.608 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 14.78 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 23:46:39.638 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 14.96 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 23:46:39.886 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 93.64 | MenuID=LOB Report, CnntCode=0104001, UserID=jaeuk.shin |
| 23:46:39.957 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 23:46:49.598 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 12.97 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 23:46:49.614 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.01 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 23:46:49.643 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 14.77 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 23:46:52.530 | find | GSCM.SCP.Master.WSL | SCP0108_GET_CAPA_LOB_CURRENT | 318 | 2852.67 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,MI00,MI02,NA00,NB01,WA00, p_factory_id=A2,A3,A4,A5,A6,A7,A8,A9,AA,AC,AH,AI, p_line_id=A2A10,A2A13,A2A14,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A05,A4A06,A4A07,A5A01,A5A03,A6A04,A6A05, |
| 23:46:54.425 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 16.24 | p_menu_id=SCP0108, p_log_type=FIND, p_log_cnt=318, p_db_time=3.054, p_ui_time=1.846, p_user_id=jaeuk.shin |
| 23:47:01.428 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.16 | MenuID=LOB Report, CnntCode=0104002, UserID=jaeuk.shin |

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

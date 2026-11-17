# AS-IS 실측 요약 — SCP0108

- 실행: 2026-11-13 05:43:06.620 ~ 2026-11-13 05:43:28.902 · 계정 jaeuk.shin · 상태 OK
- 화면: LOB Report (GSCM.SCP.Report.UIL.SCP0108_CAPA_LOB_Report)
- 조회 결과: Total : 318 · DB : 2.666s, UI : 1.812s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:43:06.966 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 26.91 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:06.981 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 6.63 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:06.992 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 4.74 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:07.767 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 10506 | 769.97 | Code=CapaLineMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:08.078 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.86 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:43:08.156 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 05:43:08.180 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.07 | USER_ID= |
| 05:43:08.804 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 14.59 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:43:08.824 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.24 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:43:08.850 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.78 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:43:08.882 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 14.55 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:43:08.902 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.02 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:43:08.930 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.58 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:43:09.014 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.17 | MenuID=LOB Report, CnntCode=0104001, UserID=jaeuk.shin |
| 05:43:09.062 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 05:43:17.957 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 14.13 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 05:43:17.976 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.66 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:43:18.005 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 12.74 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 05:43:20.510 | find | GSCM.SCP.Master.WSL | SCP0108_GET_CAPA_LOB_CURRENT | 318 | 2488.41 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,MI00,MI02,NA00,NB01,WA00, p_factory_id=A2,A3,A4,A5,A6,A7,A8,A9,AA,AC,AH,AI, p_line_id=A2A10,A2A13,A2A14,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A05,A4A06,A4A07,A5A01,A5A03,A6A04,A6A05, |
| 05:43:22.401 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 45.9 | p_menu_id=SCP0108, p_log_type=FIND, p_log_cnt=318, p_db_time=2.666, p_ui_time=1.812, p_user_id=jaeuk.shin |
| 05:43:28.215 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.95 | MenuID=LOB Report, CnntCode=0104002, UserID=jaeuk.shin |

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

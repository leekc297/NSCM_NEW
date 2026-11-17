# AS-IS 실측 요약 — SCP0108

- 실행: 2026-11-14 17:59:53.242 ~ 2026-11-14 18:00:16.782 · 계정 jaeuk.shin · 상태 OK
- 화면: LOB Report (GSCM.SCP.Report.UIL.SCP0108_CAPA_LOB_Report)
- 조회 결과: Total : 318 · DB : 2.137s, UI : 1.809s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 17:59:53.777 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.23 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:59:53.793 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 232 | 5.74 | Code=CapaVersion, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:59:53.806 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 4 | 3.25 | Code=CapaProgressStatus, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:59:54.559 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 10506 | 758.9 | Code=CapaLineMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:59:55.009 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 25 | 4.56 | Code=YearFromThisYear, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 17:59:55.319 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.27 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 17:59:55.351 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.6 | USER_ID= |
| 17:59:56.087 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.61 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 17:59:56.119 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.34 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 17:59:56.154 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.16 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 17:59:56.189 | load | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 13.02 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 17:59:56.209 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 14.85 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 17:59:56.230 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.11 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 17:59:56.396 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.37 | MenuID=LOB Report, CnntCode=0104001, UserID=jaeuk.shin |
| 17:59:56.454 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.81 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0108 |
| 18:00:06.302 | find | GSCM.SCP.Master.WSL | SCP0104_GET_SPREAD_TITLE | 29 | 35.09 | p_from_yyyymm=202611, p_program_id=SCP0108, p_sheet_name=MAIN |
| 18:00:06.319 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.07 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 18:00:06.352 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 15.47 | p_program_id=SCP0108, p_user_id=jaeuk.shin, p_sheet_name=CURRENT |
| 18:00:08.269 | find | GSCM.SCP.Master.WSL | SCP0108_GET_CAPA_LOB_CURRENT | 318 | 1871.3 | p_version=202610, p_version_seq=1, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,MI00,MI02,NA00,NB01,WA00, p_factory_id=A2,A3,A4,A5,A6,A7,A8,A9,AA,AC,AH,AI, p_line_id=A2A10,A2A13,A2A14,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A05,A4A06,A4A07,A5A01,A5A03,A6A04,A6A05, |
| 18:00:10.238 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 110.12 | p_menu_id=SCP0108, p_log_type=FIND, p_log_cnt=318, p_db_time=2.137, p_ui_time=1.809, p_user_id=jaeuk.shin |
| 18:00:16.024 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.11 | MenuID=LOB Report, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(31556)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

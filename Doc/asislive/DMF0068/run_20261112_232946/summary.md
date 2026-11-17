# AS-IS 실측 요약 — DMF0068

- 실행: 2026-11-12 23:29:46.432 ~ 2026-11-12 23:30:23.503 · 계정 jaeuk.shin · 상태 OK
- 화면: Demand Manager  (GSCM.DM.Plan.UIL.DMF0068_DemandManager40)
- 조회 결과:  · DB : 11.864s, UI : 0.081s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": "DMF0068_VersionPopup", "opener": "btnSPVer_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:29:46.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.75 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:29:46.864 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0068 |
| 23:29:46.889 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.74 | USER_ID= |
| 23:29:47.036 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 156 | 24.82 | p_program_id=DMF0068, p_user_id=jaeuk.shin, p_sheet_name=ContributeSalesList |
| 23:29:47.230 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 111.99 | MenuID=Demand Manager , CnntCode=0104001, UserID=jaeuk.shin |
| 23:29:47.304 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0068 |
| 23:29:56.532 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.79 | Code=MULTITIMEZONECODE, Param1=AS054, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:29:56.627 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.14 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:29:56.641 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.1 | p_lookup_type=MDF_TYPE |
| 23:29:56.729 | load | GSCM.DM.Master.WSL | DMF0068_GET_CONT_VIEW_VERSIONPOPUP | 30 | 69.18 | p_start_yyyymmdd=20260812, p_end_yyyymmdd=20270212, p_division_id=40, p_version_type=REPORT_SP_W, p_description= |
| 23:30:03.964 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 156 | 6.6 | p_program_id=DMF0068, p_user_id=jaeuk.shin, p_sheet_name=ContributeSalesList |
| 23:30:15.958 | find | GSCM.DM.Master.WSL | DMF0068_GET_ORDERLIST | 72 | 11852.99 | p_division_id=40, p_version_no=R_S_20261028_V003, p_fromdt=202501, p_todt=202712 |
| 23:30:16.053 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.6 | p_menu_id=DMF0068, p_log_type=FIND, p_log_cnt=, p_db_time=11.864, p_ui_time=0.081, p_user_id=jaeuk.shin |
| 23:30:22.853 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.12 | MenuID=Demand Manager , CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Version | txtVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Period | drpPeriodMonth |  |

## 그리드

- spdMain / ContributeSalesList: 행 72 · 컬럼 158(보임 48) · 헤더 2단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

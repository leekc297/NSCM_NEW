# AS-IS 실측 요약 — SCP0126

- 실행: 2026-11-12 20:42:02.923 ~ 2026-11-12 20:42:20.431 · 계정 jaeuk.shin · 상태 OK
- 화면: OPT CAPA (GSCM.SCP.Master.UIL.SCP0126_CAPA)
- 조회 결과: Total : 1,448 · DB : 1.657s, UI : 0.011s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:42:03.300 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.2 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:42:03.660 | load | GSCM.SCP.Master.WSL | SCP0126_GET_CAPA_SEARCH_INFO | 63 | 354.69 |  |
| 20:42:03.720 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 48.71 | p_user_id= |
| 20:42:03.783 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0126 |
| 20:42:03.807 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.61 | USER_ID= |
| 20:42:04.105 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.86 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=No Work |
| 20:42:04.122 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.66 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=Daily Capa |
| 20:42:04.140 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.76 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=SOP/EOP |
| 20:42:04.156 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 3.88 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=Ramp-up(From/To) |
| 20:42:04.178 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 6.96 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=Ramp-up(Interval) |
| 20:42:04.197 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.55 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=Utilization Rate |
| 20:42:04.211 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 4.85 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=Yield(Elec.) |
| 20:42:04.303 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 71.1 | MenuID=OPT CAPA, CnntCode=0104001, UserID=jaeuk.shin |
| 20:42:04.372 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.73 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0126 |
| 20:42:12.570 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.7 | p_program_id=SCP0126, p_user_id=jaeuk.shin, p_sheet_name=No Work |
| 20:42:14.206 | find | GSCM.SCP.Master.WSL | SCP0126_GET_NO_WORK | 1448 | 1621.3 | p_division_id=81, p_plan_gr_id=, p_from_yyyymm=202611, p_to_yyyymm=202711, p_plant_id=, p_line_id=, p_nick_name=, p_item_id= |
| 20:42:14.258 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.03 | p_menu_id=SCP0126, p_log_type=FIND, p_log_cnt=1448, p_db_time=1.657, p_ui_time=0.011, p_user_id=jaeuk.shin |
| 20:42:19.537 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.89 | MenuID=OPT CAPA, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Group | cboPlanGroup |  |
| Div | cboDivision |  |
| Plant | clbPlant |  |
| Line | clbLine |  |
| Period | mrpPeriod |  |
| Nick Name | txtNickName |  |
| Model | txtModel |  |
| Excel upload | btnExcelUpload |  |
| Excel Form | btnExcelForm |  |
| Batch Save | btnBatchSave |  |
| Bucket | cboBucketType |  |

## 그리드

- spdMain / No Work: 행 1448 · 컬럼 19(보임 18) · 헤더 1단 · 고정 컬럼 0
- spdMain / Daily Capa: 행 0 · 컬럼 19(보임 18) · 헤더 1단 · 고정 컬럼 0
- spdMain / SOP/EOP: 행 0 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdMain / Ramp-up(From/To): 행 0 · 컬럼 18(보임 17) · 헤더 1단 · 고정 컬럼 0
- spdMain / Ramp-up(Interval): 행 0 · 컬럼 24(보임 23) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

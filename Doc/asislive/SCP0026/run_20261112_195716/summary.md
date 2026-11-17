# AS-IS 실측 요약 — SCP0026

- 실행: 2026-11-12 19:57:16.895 ~ 2026-11-12 19:57:34.280 · 계정 jaeuk.shin · 상태 OK
- 화면: Demand Grouping (GSCM.SCP.Master.UIL.SCP0026_DemandGrouping)
- 조회 결과: Total : 2,575 · DB : 0.932s, UI : 0.072s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:57:17.267 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.92 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:57:17.292 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0026 |
| 19:57:17.314 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.17 | USER_ID= |
| 19:57:17.379 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.33 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:57:17.625 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 231.52 | p_program_id=SCP0026, p_user_id=jaeuk.shin, p_sheet_name=Demand Grouping |
| 19:57:19.255 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1610.93 | MenuID=Demand Grouping, CnntCode=0104001, UserID=jaeuk.shin |
| 19:57:19.549 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0026 |
| 19:57:27.214 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.47 | p_program_id=SCP0026, p_user_id=jaeuk.shin, p_sheet_name=Demand Grouping |
| 19:57:28.122 | find | GSCM.SCP.Master.WSL | SCP0026_GET_DEMAND_GROUPING | 2575 | 895.87 | p_division_id=81, p_operation_group=P, p_item_id= |
| 19:57:28.460 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 228.72 | p_menu_id=SCP0026, p_log_type=FIND, p_log_cnt=2575, p_db_time=0.932, p_ui_time=0.072, p_user_id=jaeuk.shin |
| 19:57:33.557 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.44 | MenuID=Demand Grouping, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Model | txtItemId |  |
| layoutControlItem4 | btnItemId |  |

## 그리드

- spdMain / Demand Grouping: 행 2575 · 컬럼 16(보임 12) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

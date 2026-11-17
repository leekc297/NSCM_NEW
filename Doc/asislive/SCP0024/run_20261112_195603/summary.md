# AS-IS 실측 요약 — SCP0024

- 실행: 2026-11-12 19:56:03.920 ~ 2026-11-12 19:56:50.918 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Fix (GSCM.SCP.Analysis.UIL.SCP0024_ProductionPlanFix)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:56:04.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.56 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:04.299 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 64 | 6.76 | Code=PlantSiteProdPlan1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:04.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 6.94 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:04.323 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 228 | 9.24 | Code=LineProdPlanLine1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:04.360 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1812 | 32.69 | Code=LineByOperationAddOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:04.380 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.76 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:56:04.425 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.3 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0024 |
| 19:56:04.448 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.95 | USER_ID= |
| 19:56:04.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 6.17 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:56:04.691 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.58 | p_from_date=, p_offset_day=363, p_timezone=AS054 |
| 19:56:04.701 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.41 |  |
| 19:56:04.717 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 4.47 | p_division_id=81 |
| 19:56:04.740 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 17.0 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271110 |
| 19:56:04.928 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 182.41 | p_program_id=SCP0024, p_user_id=jaeuk.shin, p_sheet_name=Model |
| 19:56:07.847 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2805.84 | MenuID=Production Plan Fix, CnntCode=0104001, UserID=jaeuk.shin |
| 19:56:08.092 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.27 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0024 |
| 19:56:16.014 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 14.0 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20271110 |
| 19:56:16.025 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 3.86 | p_program_id=SCP0024, p_user_id=jaeuk.shin, p_sheet_name=Model |
| 19:56:44.930 | find | GSCM.SCP.Analysis.WSL | SCP0024_GET_PRODUCTION_PLAN_FIX | 282 | 28780.92 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=, p_item_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20271110, p_electrode_type=, debug_mode=F |
| 19:56:45.579 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 314.1 | p_menu_id=SCP0024, p_log_type=FIND, p_log_cnt=282, p_db_time=28.821, p_ui_time=0.298, p_user_id=jaeuk.shin |
| 19:56:50.230 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.02 | MenuID=Production Plan Fix, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Plant Site | clbPlantSite |  |
| Bucket | cboBucketType |  |
| Line | clbLine |  |
| Material | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Electrode | cboElectrode |  |
| layoutControlItem8 | chkSum |  |
| Unfix | btnUnfix |  |
| W26 | btnW26 |  |
| W52 | btnW52 |  |
| W84 | btnWLast |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Model: 행 282 · 컬럼 453(보임 328) · 헤더 3단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

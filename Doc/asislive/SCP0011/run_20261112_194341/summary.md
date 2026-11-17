# AS-IS 실측 요약 — SCP0011

- 실행: 2026-11-12 19:43:41.177 ~ 2026-11-12 19:44:26.155 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan (GSCM.SCP.Analysis.UIL.SCP0011_ProductionPlan)
- 조회 결과: Total :  · DB : 13.983s, UI : 0.09s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:43:41.547 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 9.21 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:41.750 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 64 | 199.77 | Code=PlantSiteProdPlan1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:41.937 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 182.27 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:42.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 130.71 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:42.215 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 132.49 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:53.682 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 19414 | 11459.09 | Code=LookupCommon1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:54.373 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0011 |
| 19:43:54.403 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.48 | USER_ID= |
| 19:43:54.696 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.2 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:54.820 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.27 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:43:54.962 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.88 |  |
| 19:43:55.310 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 304.37 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 19:43:55.368 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 20.02 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:43:55.433 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 47.55 | p_program_id=SCP0011, p_user_id=jaeuk.shin, p_sheet_name=Model |
| 19:43:55.704 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 15.57 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:43:55.717 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.91 | p_program_id=SCP0011, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 19:43:56.558 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 461.16 | MenuID=Production Plan, CnntCode=0104001, UserID=jaeuk.shin |
| 19:43:56.739 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0011 |
| 19:44:03.381 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHIPMENT_PLAN_FG | 0 | 320787.34 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_biz_type=P, p_project_code=, p_item_id=, p_electype=, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_fromsite=, p_team_id=, p_tosite=, p_bucket=WEEKLY, p_to_period=20270822, p_chk_all=N, p_program_id=SCP0009, p_sheet_n |
| 19:44:05.155 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.43 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:44:05.172 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 7.21 | p_program_id=SCP0011, p_user_id=jaeuk.shin, p_sheet_name=Model |
| 19:44:05.371 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 14.54 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:44:05.382 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.64 | p_program_id=SCP0011, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 19:44:19.521 | find | GSCM.SCP.Analysis.WSL | SCP0011_GET_PRODUCTION_PLAN_MODEL | 0 | 13974.67 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_model_id=, p_item_id=, p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_program_id=SCP0011, p_sheet_name=Model, p_user_id=jaeuk.shin, p_electrode_type=None, p_nick_name=, p_bucket=WEE |
| 19:44:19.755 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 131.51 | p_menu_id=SCP0011, p_log_type=FIND, p_log_cnt=, p_db_time=13.983, p_ui_time=0.09, p_user_id=jaeuk.shin |
| 19:44:25.313 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.3 | MenuID=Production Plan, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Material | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| layoutControlItem10 | btnMeasure |  |
| Plan type* | cboPlanType | Y |
| Plan date* | cboPlanDate | Y |
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Seq* | cboPlanSeq | Y |
| Plant Site | clbPlantSite |  |
| layoutControlItem8 | chkSum |  |
| Calculate | btnCal |  |
| Electrode | cboElectrode |  |
| All | chkAll |  |
| Period* | dCalendar | Y |
| Model | txtModelId |  |
| Nick Name | txtNickName |  |
| Bucket | cboBucketType |  |

## 그리드

- spdMain / Model: 행 0 · 컬럼 459(보임 61) · 헤더 3단 · 고정 컬럼 20
- spdLine / Line: 행 0 · 컬럼 459(보임 63) · 헤더 3단 · 고정 컬럼 20

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0010

- 실행: 2026-11-12 23:53:49.185 ~ 2026-11-13 00:01:11.649 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan SEMI (GSCM.SCP.Analysis.UIL.SCP0010_Shipment_Plan_SEMI)
- 조회 결과: Total : 63 · DB : 420.977s, UI : 0.612s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:53:49.508 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.22 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:49.544 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2662 | 30.98 | Code=AllPlantSiteDescription, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:49.574 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 5.25 | Code=ShipmentPlanSEMIToStie1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:49.585 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 42 | 6.51 | Code=ToSiteShipmentPlanSEMI1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:49.783 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 194.13 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:49.926 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 138.32 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:50.080 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 139.18 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:53:50.136 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0010 |
| 23:53:50.159 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.9 | USER_ID= |
| 23:53:50.333 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.16 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:53:50.342 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.31 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:53:50.444 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.02 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 23:53:50.453 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.84 |  |
| 23:53:50.469 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.73 | p_division_id=81 |
| 23:53:50.498 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 14.38 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 23:53:50.542 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 34.9 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 23:53:50.819 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 94.81 | MenuID=Shipment Plan SEMI, CnntCode=0104001, UserID=jaeuk.shin |
| 23:53:50.914 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 10 | 27.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0010 |
| 23:53:51.679 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.81 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:53:51.777 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.34 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 23:53:51.875 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.68 | p_division_id=82 |
| 23:53:51.915 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.09 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 23:53:51.927 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 3.97 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 23:54:01.669 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.08 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 23:54:01.688 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.31 | p_program_id=SCP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 00:01:02.325 | find | GSCM.SCP.Analysis.WSL | SCP0010_GET_SHIPMENT_PLAN_SEMI | 63 | 420321.86 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=82, p_operation_group=P, p_item_id=, p_electype=, p_plan_start_yyyymmdd=20260824, p_plan_type=FN, p_seq=1, p_fromsite=, p_tosite=, p_program_id=SCP0010, p_sheet_name=ELECTRODE, p_user_id=jaeuk.shin, debug_mode=F |
| 00:01:03.531 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.31 | p_menu_id=SCP0010, p_log_type=FIND, p_log_cnt=63, p_db_time=420.977, p_ui_time=0.612, p_user_id=jaeuk.shin |
| 00:01:10.780 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.06 | MenuID=Shipment Plan SEMI, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperGroup | Y |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Bucket | cboBucketType |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| Model | txtItemId |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutControlItem2 | chkSum |  |
| Electrode | clbElecType |  |
| layoutControlItem3 | btnMeasure |  |
| New | btnNew |  |
| To Site | clbToSite |  |
| From Site | clbFromSite |  |
| lbchkAll | chkAll |  |
| W26 | btnW26 |  |
| W52 | btnW52 |  |
| W84 | btnWLast |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Shipment Plan SEMI: 행 64 · 컬럼 468(보임 62) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

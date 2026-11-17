# AS-IS 실측 요약 — SCP0017

- 실행: 2026-11-13 00:12:23.630 ~ 2026-11-13 00:15:53.155 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Waterfall (GSCM.SCP.Analysis.UIL.SCP0017_WaterfallProductionPlan)
- 조회 결과: Total : 531 · DB : 186.075s, UI : 1.508s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "clbVersion", "check": "0"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:12:23.922 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.21 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:23.960 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 64 | 32.49 | Code=PlantSiteProdPlan1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:23.971 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 5.58 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:23.980 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.45 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:23.987 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.25 | Code=OperationGroupEE, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:24.135 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 196 | 144.04 | Code=WaterfallVer21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:24.270 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 228 | 130.56 | Code=LineProdPlanLine1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:24.308 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1812 | 32.86 | Code=LineByOperationAddOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:24.333 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.71 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:12:24.429 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 55.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0017 |
| 00:12:24.466 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.26 | USER_ID= |
| 00:12:24.734 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 4 | 3.36 | Code=BucketISO, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:12:25.119 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 13.8 | p_start_yyyymmdd=20260101, p_end_yyyymmdd=20261231 |
| 00:12:25.164 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 27.36 | p_program_id=SCP0017, p_user_id=jaeuk.shin, p_sheet_name=MODEL |
| 00:12:25.521 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.5 | MenuID=Production Plan Waterfall, CnntCode=0104001, UserID=jaeuk.shin |
| 00:12:25.833 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0017 |
| 00:12:38.713 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 440 | 12.77 | p_start_yyyymmdd=20260101, p_end_yyyymmdd=20261231 |
| 00:12:38.728 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 7.23 | p_program_id=SCP0017, p_user_id=jaeuk.shin, p_sheet_name=MODEL |
| 00:15:44.368 | find | GSCM.SCP.Analysis.WSL | SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL | 531 | 185473.17 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_model_id=, p_item_id=, p_from_yyyymmdd=20260101, p_to_yyyymmdd=20261231, p_version_no=PP_W_20260817, p_program_id=SCP0017, p_sheet_name=MODEL, p_user_id=jaeuk.shin, p_electrode_type=, debug_mode=F, p_nick_name=, p_gap=N, p_line_id= |
| 00:15:46.199 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.16 | p_menu_id=SCP0017, p_log_type=FIND, p_log_cnt=531, p_db_time=186.075, p_ui_time=1.508, p_user_id=jaeuk.shin |
| 00:15:51.800 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.82 | MenuID=Production Plan Waterfall, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Plant Site | clbPlantSite |  |
| Version* | clbVersion | Y |
| Nick Name | txtNickName |  |
| Period* | dCalendar | Y |
| Bucket | cboBucketType |  |
| Electrode | cboElectrode |  |
| Line | clbLine |  |
| Model | txtModelId |  |
| Material | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| layoutControlItem14 | btnMeasure |  |
| layoutControlItem4 | btnColumn |  |
| layoutControlItem8 | chkSum |  |
| layoutControlItem8 | chkALL |  |
| layoutControlItem8 | chkGap |  |
| UOM | clbUOM |  |

## 그리드

- spdMain / MODEL: 행 531 · 컬럼 462(보임 322) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

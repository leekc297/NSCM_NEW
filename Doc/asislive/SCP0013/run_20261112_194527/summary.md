# AS-IS 실측 요약 — SCP0013

- 실행: 2026-11-12 19:45:27.226 ~ 2026-11-12 19:46:13.873 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Line (GSCM.SCP.Analysis.UIL.SCP0013_ProductionPlanLine)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:45:27.647 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.3 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:27.657 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.46 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:45:27.665 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 4.0 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:27.676 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 64 | 7.16 | Code=PlantSiteProdPlan1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:27.686 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 5.76 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:28.187 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 228 | 496.98 | Code=LineProdPlanLine1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:28.225 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1812 | 33.36 | Code=LineByOperationAddOSP1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:28.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 182.82 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:28.561 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 131.35 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:28.708 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 141.31 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:28.941 | load | GSCM.SCP.Analysis.WSL | SCP0013_GET_EXTRA_SPEC | 24 | 218.78 | p_division_id=40 |
| 19:45:29.317 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0013 |
| 19:45:29.346 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.65 | USER_ID= |
| 19:45:29.551 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.15 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:29.627 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.18 |  |
| 19:45:29.642 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.8 | p_from_date=20260824, p_offset_day=363, p_timezone=AS054 |
| 19:45:29.652 | load | GSCM.SCP.Analysis.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.88 | p_division_id=81 |
| 19:45:29.682 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 14.34 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:45:29.855 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 162.03 | p_program_id=SCP0013, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 19:45:30.084 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.12 | p_program_id=SCP0013, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 19:45:31.561 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1354.31 | MenuID=Production Plan Line, CnntCode=0104001, UserID=jaeuk.shin |
| 19:45:31.868 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0013 |
| 19:45:41.179 | find | GSCM.SCP.Analysis.WSL | SCP0013_GET_PLAN_EDIT_INFO | 0 | 833.92 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=, p_item_id=, p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, debug_mode=F |
| 19:45:42.051 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 776.71 | Code=SCPPlanPeriod, Param1=20260824, Param2=81, Param3=WEEKLY, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:45:42.143 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 14.22 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:45:42.163 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 5.45 | p_program_id=SCP0013, p_user_id=jaeuk.shin, p_sheet_name=Line |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan type* | cboPlanType | Y |
| Plan date* | cboPlanDate | Y |
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| layoutControlItem4 | btnItemId |  |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Electrode | cboElectrode |  |
| NEW | btnNew |  |
| Nick Name | txtNickName |  |
| layoutControlItem8 | chkSum |  |
| Cell Type Gr | cboCellTypeGr |  |
| Seq* | cboPlanSeq | Y |
| Load% | btnLoad |  |
| layoutControlItem8 | chkLineAssign |  |
| Plant Site | clbPlantSite |  |
| Line | clbLine |  |
| W26 | btnW26 |  |
| W52 | btnW52 |  |
| W84 | btnWLast |  |
| lbChkAll | chkAll |  |
| Period* | dCalendar | Y |
| Model | txtModel |  |
| Material | txtItemId |  |
| Bucket | cboBucketType |  |
| Extra Spec | clbExtraSpec |  |
| layoutControlItem14 | btnMeasure |  |

## 그리드

- spdMain / Line: 행 0 · 컬럼 467(보임 62) · 헤더 3단 · 고정 컬럼 27

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

# AS-IS 실측 요약 — SCP0012

- 실행: 2026-11-12 19:44:26.317 ~ 2026-11-12 19:45:08.228 · 계정 jaeuk.shin · 상태 OK
- 화면: PSI (GSCM.SCP.Analysis.UIL.SCP0012_PSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:44:26.748 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.78 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:26.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 132.28 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:27.001 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 63 | 88.78 | Code=FromSite_PSI1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:27.015 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 6.18 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:27.199 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 177.47 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:27.349 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 139.98 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:27.364 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 4.03 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:44:27.451 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0012 |
| 19:44:27.477 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.33 | USER_ID= |
| 19:44:27.600 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.14 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:44:27.616 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.59 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:44:27.674 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.11 |  |
| 19:44:27.691 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.63 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 19:44:27.713 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 15.37 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:44:27.725 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.79 | p_program_id=SCP0012, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 19:44:28.432 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 579.88 | MenuID=PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 19:44:28.562 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0012 |
| 19:44:36.796 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.14 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:44:36.808 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.62 | p_program_id=SCP0012, p_user_id=jaeuk.shin, p_sheet_name=PSI |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan date* | cboPlanDate | Y |
| Operation Group | cboOperGroup |  |
| Material | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| From Site | clbFromSite |  |
| Div* | cboDivision | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| Electrode | clbElecType |  |
| Bucket | cboBucketType |  |
| Cell Type Gr | cboCellTypeGr |  |
| layoutControlItem1 | chkSum |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / PSI: 행 0 · 컬럼 459(보임 322) · 헤더 3단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

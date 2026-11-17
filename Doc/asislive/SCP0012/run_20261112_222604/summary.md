# AS-IS 실측 요약 — SCP0012

- 실행: 2026-11-12 22:26:04.193 ~ 2026-11-12 22:26:51.273 · 계정 jaeuk.shin · 상태 OK
- 화면: PSI (GSCM.SCP.Analysis.UIL.SCP0012_PSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:26:04.558 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.63 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:04.695 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 132.44 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:04.752 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 63 | 49.67 | Code=FromSite_PSI1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:04.762 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 6.5 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:04.950 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 184.14 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:05.093 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 137.0 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:05.163 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 60.77 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:26:05.479 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.48 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0012 |
| 22:26:05.507 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.87 | USER_ID= |
| 22:26:05.751 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.68 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:26:05.768 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.6 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:26:05.845 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.32 |  |
| 22:26:05.892 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 12.31 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 22:26:05.942 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 17.36 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:26:05.982 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 28.02 | p_program_id=SCP0012, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 22:26:06.895 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 702.58 | MenuID=PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 22:26:07.016 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.6 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0012 |
| 22:26:16.350 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 52.82 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:26:16.409 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 45.93 | p_program_id=SCP0012, p_user_id=jaeuk.shin, p_sheet_name=PSI |

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

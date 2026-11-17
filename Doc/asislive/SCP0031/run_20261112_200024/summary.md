# AS-IS 실측 요약 — SCP0031

- 실행: 2026-11-12 20:00:24.695 ~ 2026-11-12 20:01:07.463 · 계정 jaeuk.shin · 상태 OK
- 화면: Global PSI (GSCM.SCP.Analysis.UIL.SCP0031_GlobalPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:00:25.068 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.31 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:00:25.265 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 186.38 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:00:25.407 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 132.9 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:00:25.557 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 135.6 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:00:25.891 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0031 |
| 20:00:25.921 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.64 | USER_ID= |
| 20:00:26.101 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.58 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:00:26.143 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 29.12 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:00:26.276 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 7.35 | p_division_id=81, p_plan_cycle=, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 20:00:26.285 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.85 |  |
| 20:00:26.321 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.7 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 20:00:26.336 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.58 | p_program_id=SCP0031, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |
| 20:00:27.273 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 720.19 | MenuID=Global PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 20:00:27.437 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0031 |
| 20:00:36.048 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 450.11 | Code=SCPPlanPeriod, Param1=20260824, Param2=81, Param3=DAILY, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:00:36.148 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 17.39 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 20:00:36.159 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.82 | p_program_id=SCP0031, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Material | txtItemId |  |
| layoutControlItem3 | btnMeasure |  |
| layoutControlItem4 | btnItem_Id |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| layoutControlItem2 | chkSum |  |
| Bucket | cboBucketType |  |
| Nick Name | txtNickName |  |
| To Site | clbToSite |  |
| From Site | clbFromSite |  |
| layoutControlItem5 | chkAll |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Global PSI: 행 0 · 컬럼 458(보임 330) · 헤더 3단 · 고정 컬럼 16

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

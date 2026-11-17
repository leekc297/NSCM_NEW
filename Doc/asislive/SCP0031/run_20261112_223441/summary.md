# AS-IS 실측 요약 — SCP0031

- 실행: 2026-11-12 22:34:41.044 ~ 2026-11-12 22:35:27.077 · 계정 jaeuk.shin · 상태 OK
- 화면: Global PSI (GSCM.SCP.Analysis.UIL.SCP0031_GlobalPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:34:41.368 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.29 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:34:41.557 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 183.5 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:34:41.692 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 130.58 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:34:41.835 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 135.53 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:34:41.880 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0031 |
| 22:34:41.909 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.03 | USER_ID= |
| 22:34:42.250 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 240.18 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:34:42.339 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 76.59 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:34:42.444 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.0 | p_division_id=81, p_plan_cycle=, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 22:34:42.471 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.76 |  |
| 22:34:42.500 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.6 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:34:42.702 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 196.15 | p_program_id=SCP0031, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |
| 22:34:43.253 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 393.83 | MenuID=Global PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 22:34:43.361 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.51 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0031 |
| 22:34:52.835 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 290.44 | Code=SCPPlanPeriod, Param1=20260824, Param2=81, Param3=DAILY, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:34:52.949 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.19 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 22:34:52.959 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.54 | p_program_id=SCP0031, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |

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

# AS-IS 실측 요약 — SCP0031

- 실행: 2026-11-13 00:15:53.217 ~ 2026-11-13 00:18:35.082 · 계정 jaeuk.shin · 상태 OK
- 화면: Global PSI (GSCM.SCP.Analysis.UIL.SCP0031_GlobalPSI)
- 조회 결과: Total :  · DB : 145.586s, UI : 0.127s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:15:53.566 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.91 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:15:53.754 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 182.88 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:15:53.896 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 136.31 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:15:54.034 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 130.47 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:15:54.113 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 27.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0031 |
| 00:15:54.137 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.62 | USER_ID= |
| 00:15:54.299 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 42.72 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 00:15:54.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 78.36 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 00:15:54.544 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 7.22 | p_division_id=81, p_plan_cycle=, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 00:15:54.553 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.42 |  |
| 00:15:54.583 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.2 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 00:15:54.619 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 28.49 | p_program_id=SCP0031, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |
| 00:15:54.830 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 65.78 | MenuID=Global PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 00:15:54.924 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0031 |
| 00:16:03.122 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 5.18 | Code=SCPPlanPeriod, Param1=20260824, Param2=81, Param3=DAILY, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:16:03.220 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.01 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 00:16:03.232 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.85 | p_program_id=SCP0031, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |
| 00:18:28.943 | find | GSCM.SCP.Analysis.WSL | SCP0031_GET_GLOBAL_PSI | 0 | 145576.06 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_item_id=, p_nick_name=, p_from_site=, p_to_site=, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_program_id=SCP0031, p_sheet_name=Global PSI, p_bucket=DAILY, p_chk_all=N, p_user_id=jaeuk.shin, debug_mode=F |
| 00:18:29.083 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.17 | p_menu_id=SCP0031, p_log_type=FIND, p_log_cnt=, p_db_time=145.586, p_ui_time=0.127, p_user_id=jaeuk.shin |
| 00:18:33.979 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.17 | MenuID=Global PSI, CnntCode=0104002, UserID=jaeuk.shin |

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

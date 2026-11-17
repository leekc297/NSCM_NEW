# AS-IS 실측 요약 — SCP0038

- 실행: 2026-11-12 20:03:07.508 ~ 2026-11-12 20:03:58.615 · 계정 jaeuk.shin · 상태 OK
- 화면: Global PSI(Mobility & IT) (GSCM.SCP.Analysis.UIL.SCP0038_GlobalPSI_small)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:03:07.840 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.08 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:08.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 217.73 | Code=FromSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:09.010 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 940.55 | Code=ToSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:09.247 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 220.0 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:09.401 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 149.61 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:09.566 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 149.1 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:09.888 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0038 |
| 20:03:09.915 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.32 | USER_ID= |
| 20:03:10.085 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.4 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:03:10.746 | load | GSCM.SCP.Analysis.WSL | SCP0038_GET_CELLTYPE_EM0101 | 19 | 651.2 |  |
| 20:03:10.933 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.04 | p_division_id=40, p_plan_cycle=, p_from_date=20261019, p_offset_month=12, p_timezone=AS054 |
| 20:03:10.940 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.03 |  |
| 20:03:10.971 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.21 | p_start_yyyymmdd=20261019, p_end_yyyymmdd=20271017 |
| 20:03:11.011 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 29.9 | p_program_id=SCP0038, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |
| 20:03:11.023 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.54 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:03:11.591 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 367.23 | MenuID=Global PSI(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 20:03:11.672 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0038 |
| 20:03:30.558 | find | GSCM.SCP.Analysis.WSL | SCP0031_GET_GLOBAL_PSI | 0 | 174254.57 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_item_id=, p_nick_name=, p_from_site=, p_to_site=, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_program_id=SCP0031, p_sheet_name=Global PSI, p_bucket=DAILY, p_chk_all=N, p_user_id=jaeuk.shin, debug_mode=F |
| 20:03:57.920 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.71 | MenuID=Global PSI(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| layoutControlItem3 | btnMeasure |  |
| layoutControlItem4 | btnItem_Id |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| layoutControlItem2 | chkSum |  |
| Bucket | cboBucketType |  |
| To Site | clbToSite |  |
| Nick Name | txtNickName |  |
| From Site | clbFromSite |  |
| Period* | dCalendar | Y |
| Material* | txtItemId | Y |
| Operation Group | cboOperationGroup |  |
| Cell Type | cboCellTypeGr |  |

## 그리드

- spdMain / Global PSI: 행 0 · 컬럼 456(보임 330) · 헤더 3단 · 고정 컬럼 13

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 20:03:19.945 [GSCM] Material 값은 필수 입력입니다 → default_button(id=1)

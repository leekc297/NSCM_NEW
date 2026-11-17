# AS-IS 실측 요약 — SCP0038

- 실행: 2026-11-12 22:36:56.776 ~ 2026-11-12 22:38:16.796 · 계정 jaeuk.shin · 상태 OK
- 화면: Global PSI(Mobility & IT) (GSCM.SCP.Analysis.UIL.SCP0038_GlobalPSI_small)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:36:57.151 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.17 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:05.795 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 8624.52 | Code=FromSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:05.844 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 37.95 | Code=ToSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:06.093 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 192.63 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:06.254 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 139.0 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:06.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 145.95 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:07.153 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0038 |
| 22:37:07.185 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.22 | USER_ID= |
| 22:37:07.417 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.47 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:37:13.987 | load | GSCM.SCP.Analysis.WSL | SCP0038_GET_CELLTYPE_EM0101 | 19 | 6562.42 |  |
| 22:37:14.292 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.89 | p_division_id=40, p_plan_cycle=, p_from_date=20261019, p_offset_month=12, p_timezone=AS054 |
| 22:37:14.300 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.34 |  |
| 22:37:14.336 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 17.56 | p_start_yyyymmdd=20261019, p_end_yyyymmdd=20271017 |
| 22:37:15.553 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 1203.34 | p_program_id=SCP0038, p_user_id=jaeuk.shin, p_sheet_name=Global PSI |
| 22:37:15.578 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.84 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:37:20.549 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4609.02 | MenuID=Global PSI(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 22:37:21.788 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0038 |
| 22:37:39.460 | find | GSCM.SCP.Master.WSL | SCP0037_GET_OPERATION_LT | 328 | 95268.5 | p_division_id=81, p_scm_site_id=HQ07-E,HQ11-E,MI00-E,MI02-E,NA00-E,NB01-E,WA00-E, p_item_id=, p_scm_valid_yn=None, p_lt_operation=SLITTING |
| 22:38:02.434 | find | GSCM.SCP.Analysis.WSL | SCP0031_GET_GLOBAL_PSI | 0 | 189321.2 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_item_id=, p_nick_name=, p_from_site=, p_to_site=, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_program_id=SCP0031, p_sheet_name=Global PSI, p_bucket=DAILY, p_chk_all=N, p_user_id=jaeuk.shin, debug_mode=F |
| 22:38:15.919 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.33 | MenuID=Global PSI(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 22:37:32.128 [GSCM] Material 값은 필수 입력입니다 → default_button(id=1)

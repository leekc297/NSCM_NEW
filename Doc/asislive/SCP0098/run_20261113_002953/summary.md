# AS-IS 실측 요약 — SCP0098

- 실행: 2026-11-13 00:29:53.551 ~ 2026-11-13 00:31:16.029 · 계정 jaeuk.shin · 상태 OK
- 화면: CAPA (Mobility IT) (GSCM.SCP.Master.UIL.SCP0098_CAPAReprotSmall)
- 조회 결과: Total : 1,973 · DB : 58.543s, UI : 5.609s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:29:54.014 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.11 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:29:54.023 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.68 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:54.031 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 3.71 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:29:54.092 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.69 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0098 |
| 00:29:54.118 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.14 | USER_ID= |
| 00:29:54.230 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.67 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:29:54.238 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 4.96 | Code=PlantByDivisionOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:54.374 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 126.77 | Code=DATE_WEEKLY, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:54.502 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 966 | 119.01 | Code=LineByOperationAddOSP, Param1=81, Param2=, Param3=, Param4=, Param5=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, Param6=, TimeZon |
| 00:29:54.678 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 966 | 151.77 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, TimeZone=AS054 |
| 00:29:54.858 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.5 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:54.907 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 39.23 | p_from_date=, p_offset_day=363, p_timezone=AS054 |
| 00:29:54.922 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 3.03 | p_division_id=81 |
| 00:29:54.947 | load | GSCM.SCM.Master.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 475 | 13.53 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20271130 |
| 00:29:54.990 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 29.97 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 00:29:55.146 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.57 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 00:29:55.155 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.37 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:29:55.162 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 29 | 4.74 | Code=PlantByDivisionOperation, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:55.299 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 128.74 | Code=DATE_WEEKLY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:29:55.418 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 438 | 107.88 | Code=LineByOperationAddOSP, Param1=40, Param2=, Param3=, Param4=, Param5=AZ00-A,AZ00-E,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ05_40-W,HQ06-A,HQ06-E,HQ10-A,HQ10-E,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02149300_40-A,KR022651 |
| 00:29:55.538 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 435 | 103.21 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=AZ00-A,AZ00-E,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ05_40-W,HQ06-A,HQ06-E,HQ10-A,HQ10-E,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02149300_40-A,KR02265100_40_ |
| 00:29:55.702 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 3.33 | p_division_id=40 |
| 00:29:55.935 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 186.01 | MenuID=CAPA (Mobility IT), CnntCode=0104001, UserID=jaeuk.shin |
| 00:29:56.065 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0098 |
| 00:30:04.402 | find | GSCM.SCM.Master.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 475 | 16.59 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20271130 |
| 00:30:04.421 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.86 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 00:31:02.529 | find | GSCM.SCM.Master.WSL | SCP0098_GET_CAPA_MobilityIT | 1973 | 57899.64 | p_today_yyyymmdd=20261113, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20271130, p_division_id=40, p_plant_id=ALL, p_line_id=, p_operation_id=, p_model_id=, p_item_id=, p_nick_name=, p_bucket=DAILY, p_user_id=jaeuk.shin, debug_mode=F |
| 00:31:08.788 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.7 | p_menu_id=SCP0098, p_log_type=FIND, p_log_cnt=1973, p_db_time=58.543, p_ui_time=5.609, p_user_id=jaeuk.shin |
| 00:31:14.584 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.12 | MenuID=CAPA (Mobility IT), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div * | cboDivision | Y |
| Plant Site | clbPlantSite |  |
| Period* | dCalendar | Y |
| layoutControlItem14 | btnMeasure |  |
| Material | txtItemId |  |
| Line | clbLine |  |
| layoutControlItem4 | btnItemId |  |
| Nick Name | txtNickName |  |
| Bucket | cboBucketType |  |
| layoutControlItem1 | chkDetail |  |
| Copy Data | btnCopyData |  |
| Category | cboCategory |  |
| Day Type | cboDayWeek |  |
| Input | btnInput |  |
| Input Value | txtInpuValue |  |

## 그리드

- spdMain / CAPA_SMALL: 행 1973 · 컬럼 495(보임 325) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

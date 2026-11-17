# AS-IS 실측 요약 — SCP0098

- 실행: 2026-11-12 20:20:05.869 ~ 2026-11-12 20:20:53.392 · 계정 jaeuk.shin · 상태 OK
- 화면: CAPA (Mobility IT) (GSCM.SCP.Master.UIL.SCP0098_CAPAReprotSmall)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:20:06.240 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.46 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:20:06.252 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.55 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:20:06.259 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 3.53 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:20:06.625 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0098 |
| 20:20:06.658 | load | GSCM.BizService.WSL | SELECT * | 874 | 23.03 | USER_ID= |
| 20:20:06.874 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 27.72 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:20:06.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 7.91 | Code=PlantByDivisionOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:20:11.160 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4252.44 | Code=DATE_WEEKLY, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:20:11.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 966 | 123.98 | Code=LineByOperationAddOSP, Param1=81, Param2=, Param3=, Param4=, Param5=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, Param6=, TimeZon |
| 20:20:11.416 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 966 | 109.55 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, TimeZone=AS054 |
| 20:20:11.591 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.48 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:20:11.610 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.16 | p_from_date=, p_offset_day=363, p_timezone=AS054 |
| 20:20:11.914 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 297.56 | p_division_id=81 |
| 20:20:11.946 | load | GSCM.SCM.Master.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 475 | 12.78 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20271130 |
| 20:20:11.966 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.43 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 20:20:12.148 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.18 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 20:20:12.156 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.39 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:20:12.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 29 | 5.35 | Code=PlantByDivisionOperation, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:20:12.312 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 130.16 | Code=DATE_WEEKLY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:20:12.423 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 438 | 107.61 | Code=LineByOperationAddOSP, Param1=40, Param2=, Param3=, Param4=, Param5=AZ00-A,AZ00-E,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ05_40-W,HQ06-A,HQ06-E,HQ10-A,HQ10-E,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02149300_40-A,KR022651 |
| 20:20:12.537 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 435 | 103.16 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=AZ00-A,AZ00-E,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ05_40-W,HQ06-A,HQ06-E,HQ10-A,HQ10-E,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02149300_40-A,KR02265100_40_ |
| 20:20:12.597 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.9 | p_division_id=40 |
| 20:20:13.350 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 603.12 | MenuID=CAPA (Mobility IT), CnntCode=0104001, UserID=jaeuk.shin |
| 20:20:13.447 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0098 |
| 20:20:21.554 | find | GSCM.SCM.Master.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 475 | 14.02 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20271130 |
| 20:20:21.564 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.39 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |

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

- spdMain / CAPA_SMALL: 행 0 · 컬럼 494(보임 326) · 헤더 3단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

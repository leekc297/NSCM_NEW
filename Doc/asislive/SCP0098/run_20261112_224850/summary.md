# AS-IS 실측 요약 — SCP0098

- 실행: 2026-11-12 22:48:50.675 ~ 2026-11-12 22:49:35.712 · 계정 jaeuk.shin · 상태 OK
- 화면: CAPA (Mobility IT) (GSCM.SCP.Master.UIL.SCP0098_CAPAReprotSmall)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:48:51.024 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.68 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:48:51.033 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.46 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:51.040 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 3.49 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:48:51.103 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0098 |
| 22:48:51.125 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.88 | USER_ID= |
| 22:48:51.227 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.51 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:48:51.238 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 6.15 | Code=PlantByDivisionOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:51.381 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 128.07 | Code=DATE_WEEKLY, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:51.507 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 966 | 117.6 | Code=LineByOperationAddOSP, Param1=81, Param2=, Param3=, Param4=, Param5=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, Param6=, TimeZon |
| 22:48:51.627 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 966 | 112.0 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, TimeZone=AS054 |
| 22:48:51.750 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.0 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:51.764 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.43 | p_from_date=, p_offset_day=363, p_timezone=AS054 |
| 22:48:51.772 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 3.11 | p_division_id=81 |
| 22:48:51.789 | load | GSCM.SCM.Master.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 475 | 12.07 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20271130 |
| 22:48:51.801 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.48 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 22:48:51.946 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.84 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |
| 22:48:51.956 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.47 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:48:51.964 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 29 | 5.21 | Code=PlantByDivisionOperation, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:52.101 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 126.44 | Code=DATE_WEEKLY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:48:52.258 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 438 | 149.33 | Code=LineByOperationAddOSP, Param1=40, Param2=, Param3=, Param4=, Param5=AZ00-A,AZ00-E,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ05_40-W,HQ06-A,HQ06-E,HQ10-A,HQ10-E,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02149300_40-A,KR022651 |
| 22:48:52.371 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 435 | 102.38 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=AZ00-A,AZ00-E,CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ05_40-W,HQ06-A,HQ06-E,HQ10-A,HQ10-E,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02149300_40-A,KR02265100_40_ |
| 22:48:52.444 | load | GSCM.SCM.Master.WSL | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 1 | 2.86 | p_division_id=40 |
| 22:48:52.666 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 177.95 | MenuID=CAPA (Mobility IT), CnntCode=0104001, UserID=jaeuk.shin |
| 22:48:52.746 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.52 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0098 |
| 22:49:01.696 | find | GSCM.SCM.Master.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 475 | 14.56 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20271130 |
| 22:49:01.711 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.22 | p_program_id=SCP0098, p_user_id=jaeuk.shin, p_sheet_name=CAPA_SMALL |

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

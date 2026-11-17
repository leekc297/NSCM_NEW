# AS-IS 실측 요약 — SSP0008

- 실행: 2026-11-12 22:58:03.519 ~ 2026-11-12 22:59:08.634 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Line(SSP) (GSCM.SSP.Plan.UIL.SSP0008_ProductionPlanLine)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:58:03.886 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 4.33 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:58:03.897 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.4 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:03.976 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0008 |
| 22:58:03.998 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.47 | USER_ID= |
| 22:58:04.137 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.35 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:58:04.150 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.67 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:04.877 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 719.13 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:05.022 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 131.89 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:05.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 132.3 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:05.275 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 96.76 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 22:58:05.334 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.09 |  |
| 22:58:05.356 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.06 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 22:58:05.384 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.66 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 22:58:05.833 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 438.87 | p_program_id=SSP0008, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 22:58:08.169 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2173.96 | MenuID=Production Plan Line(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 22:58:08.624 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0008 |
| 22:58:18.297 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.58 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:58:18.322 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 6.45 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:18.442 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 99.7 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 22:58:18.591 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.6 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 677.0 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.318 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.67 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.357 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 26.11 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.376 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.59 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 22:58:19.413 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.19 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.61 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.486 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.74 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:58:19.595 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 99.05 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 22:58:23.073 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.18 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:58:23.082 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.72 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:23.183 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 93.89 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 22:58:23.283 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 5.63 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:23.973 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 666.83 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:24.108 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 127.78 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:24.243 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.53 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:24.359 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 98.76 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 22:58:28.195 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.36 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:58:28.207 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.74 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:28.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 100.28 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 22:58:28.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.39 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 676.09 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.114 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.69 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.153 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 27.05 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.172 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.88 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 22:58:29.205 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.93 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.240 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.17 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.76 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:58:29.391 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 102.1 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 22:58:34.566 | find | GSCM.SSP.Plan.WSL | SSP0008_GET_PLAN_EDIT_INFO | 0 | 9.34 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=-,A1A02,A1A03,A1A04,A1A05,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A02,A4A03,A4A04,A4A05,A4A06,A4A07,A5A01,A5A02,A5A03,A6A04,A6A05,A6A06,A6A07 |
| 22:58:34.582 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.71 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 22:58:34.592 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.96 | p_program_id=SSP0008, p_user_id=jaeuk.shin, p_sheet_name=Line |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan type* | cboPlanType | Y |
| Plan date* | cboPlanDate | Y |
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Period* | drpPeriod | Y |
| Seq* | cboPlanSeq | Y |
| Plant Site | clbPlantSite |  |
| Bucket | cboBucketType |  |
| Line | clbLine |  |
| Model | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Electrode | clbElectrode |  |
| Nick Name | txtNickName |  |
| layoutControlItem8 | chkSum |  |
| layoutControlItem14 | btnMeasure |  |

## 그리드

- spdMain / Line: 행 0 · 컬럼 93(보임 19) · 헤더 3단 · 고정 컬럼 23

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
